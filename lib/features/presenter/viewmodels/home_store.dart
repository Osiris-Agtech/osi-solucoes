import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/homeDashboard/home_dashboard_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/core/services/adaptive_interface_service.dart';
import 'package:osi_solucoes/features/presenter/models/shortcut/shortcut_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  AuthController authController = GetIt.I<AuthController>();
  IHomeDashboardRepository? homeDashboardRepository;

  HomeStoreBase({this.homeDashboardRepository});

  @observable
  bool isNotified = false;

  @action
  bool toggleNotified() => isNotified = !isNotified;

  @observable
  bool isCollapsed = true;

  @action
  bool setIsCollaped() => isCollapsed = !isCollapsed;

  // Dashboard state
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  HomeDashboard? dashboard;

  // Novos observables para interface adaptativa
  @observable
  List<ShortcutModel> recommendedShortcuts = [];

  @observable
  bool isLoadingShortcuts = false;

  @observable
  String? adaptiveDashboard;

  @observable
  double dashboardConfidence = 0.0;

  String adaptiveDashboardSource = 'system';

  String adaptiveSource = 'system';

  String adaptiveVisualPriority = 'none';

  String? adaptiveReason;

  bool get hasAdaptiveDashboardRecommendation =>
      adaptiveSource == 'adaptive' &&
      (adaptiveDashboard != null || adaptiveCardType != null);

  // Navegação do dashboard (um card por vez)
  @observable
  int currentCardIndex = 0;

  @observable
  List<String> cardOrder = [];

  final AdaptiveInterfaceService _adaptiveService = AdaptiveInterfaceService();

  @action
  void nextCard() {
    if (cardOrder.isEmpty) return;
    currentCardIndex = (currentCardIndex + 1) % cardOrder.length;
  }

  @action
  void previousCard() {
    if (cardOrder.isEmpty) return;
    currentCardIndex =
        (currentCardIndex - 1 + cardOrder.length) % cardOrder.length;
  }

  @action
  void goToCard(int index) {
    if (index >= 0 && index < cardOrder.length) {
      currentCardIndex = index;
    }
  }

  // Novos campos para suportar cardType direto da API
  @observable
  String? adaptiveCardType;

  // Modo de adaptação ativo (para métricas de eficácia)
  @observable
  String adaptiveMode = 'GRADUAL';

  // Session ID (para métricas de sessão INSTANT)
  @observable
  String? currentSessionId;

  /// Inicializa a ordem dos cards com o recomendado em primeiro
  void initializeCardOrder() {
    const allCards = ['lotes', 'tarefas', 'producao', 'saude'];
    cardOrder = List.from(allCards);
    currentCardIndex = 0;
    print('📊 [HOME_STORE] Ordem estrutural padrão dos cards: $cardOrder');
  }

  /// Busca a configuração adaptativa do usuário no Firestore
  /// Retorna um mapa com mode e sessionId, ou null se não houver config
  Future<Map<String, dynamic>?> _fetchUserAdaptiveConfig() async {
    try {
      // Verifica se Firebase está inicializado
      Firebase.app();
      final userId = _getUserId();
      if (userId == null) {
        print('⚠️ [HOME_STORE] UserId não disponível para buscar config');
        return null;
      }

      final doc = await FirebaseFirestore.instance
          .collection('userAdaptiveConfig')
          .doc(userId)
          .get();

      if (!doc.exists || doc.data() == null) {
        print(
            '📊 [HOME_STORE] Nenhuma config adaptativa encontrada para user $userId');
        return null;
      }

      final data = doc.data()!;

      // Verifica se a configuração expirou
      if (data['expiresAt'] != null) {
        final expiresAt = data['expiresAt'] as Timestamp?;
        if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
          print('📊 [HOME_STORE] Config expirada para user $userId');
          return null;
        }
      }

      final config = {
        'mode': data['mode'] as String?,
        'sessionId': data['sessionId'] as String?,
      };

      print(
          '📊 [HOME_STORE] Config adaptativa encontrada: mode=${config['mode']}, sessionId=${config['sessionId'] != null ? '***' : 'null'}');
      return config;
    } catch (e) {
      print('⚠️ [HOME_STORE] Erro ao buscar config adaptativa: $e');
      return null;
    }
  }

  /// Helper para obter userId do AuthController
  String? _getUserId() {
    try {
      return (authController.usuario.id).toString();
    } catch (e) {
      return null;
    }
  }

  @action
  Future<void> loadAdaptiveInterface() async {
    print('🏠 [HOME_STORE] Carregando interface adaptativa...');
    isLoadingShortcuts = true;
    try {
      // PASSO 1: Buscar configuração do usuário no Firestore
      // Isso garante que teremos mode e sessionId para modo INSTANT
      final userConfig = await _fetchUserAdaptiveConfig();
      final mode = userConfig?['mode'];
      final sessionId = userConfig?['sessionId'];

      // Atualiza o sessionId no store para uso em métricas
      if (sessionId != null) {
        currentSessionId = sessionId;
      }

      print(
          '🏠 [HOME_STORE] Config carregada: mode=$mode, sessionId=${sessionId != null ? 'presente' : 'null'}');

      // PASSO 2: Chamar a API com mode e sessionId (se disponíveis)
      final result = await _adaptiveService.getAdaptiveInterface(
        mode: mode,
        sessionId: sessionId,
      );

      result.fold(
        (failure) {
          // Em caso de erro, usa atalhos padrão
          print('❌ [HOME_STORE] Erro ao carregar: ${failure.message}');
          recommendedShortcuts = _getDefaultShortcuts();
          adaptiveDashboard = null;
          adaptiveCardType = null;
          adaptiveDashboardSource = 'system';
          adaptiveSource = 'fallback';
          adaptiveVisualPriority = 'none';
          adaptiveReason = null;
          dashboardConfidence = 0.0;
          print(' └─ Usando ${recommendedShortcuts.length} atalhos padrão');
        },
        (response) {
          // Garante que sempre haverá pelo menos 4 atalhos
          recommendedShortcuts = _ensureMinimumShortcuts(response.shortcuts);
          adaptiveDashboard = response.dashboard;
          adaptiveCardType = response.cardType; // Novo campo da API
          adaptiveDashboardSource = response.source;
          adaptiveSource = response.source;
          adaptiveVisualPriority = response.visualPriority;
          adaptiveReason = response.reason;
          dashboardConfidence = response.dashboardConfidence;
          adaptiveMode = response.mode; // Mode para métricas

          print('✅ [HOME_STORE] Interface adaptativa atualizada:');
          print(' └─ Dashboard recomendado: ${adaptiveDashboard ?? 'null'}');
          print(' └─ Card Type (novo): ${adaptiveCardType ?? 'null'}');
          print(
              ' └─ Confiança do dashboard: ${(dashboardConfidence * 100).toStringAsFixed(1)}%');
          print(' └─ Atalhos recomendados: ${response.shortcuts.length}');
          print(
              ' └─ Atalhos finais (completados): ${recommendedShortcuts.length}');
          print(' └─ Mode: $adaptiveMode');
          print(' └─ Session ID: ${currentSessionId ?? 'null'}');

          final hasRecommendation =
              (adaptiveCardType != null || adaptiveDashboard != null) &&
                  adaptiveSource == 'adaptive';

          if (hasRecommendation) {
            print(' └─ ✅ Dashboard será aplicado automaticamente');
          } else {
            print(
                ' └─ ⚠️ Dashboard não será aplicado (confiança baixa ou sem recomendação)');
          }
        },
      );

      // Inicializa a ordem dos cards após carregar interface adaptativa
      initializeCardOrder();
    } catch (e, stackTrace) {
      // Fallback para atalhos padrão
      print('❌ [HOME_STORE] Exceção ao carregar interface: $e');
      print('   StackTrace: $stackTrace');
          recommendedShortcuts = _getDefaultShortcuts();
          adaptiveDashboardSource = 'system';
          adaptiveSource = 'fallback';
          adaptiveVisualPriority = 'none';
          adaptiveReason = null;
      // Garante que a ordem dos cards seja inicializada mesmo em caso de erro
      initializeCardOrder();
    } finally {
      isLoadingShortcuts = false;
      print('🏠 [HOME_STORE] Carregamento finalizado');
    }
  }

  /// Garante que a lista tenha pelo menos 4 atalhos, completando com padrões se necessário
  List<ShortcutModel> _ensureMinimumShortcuts(List<ShortcutModel> shortcuts) {
    const int minShortcuts = 4;

    // Se já tem 4 ou mais, retorna como está
    if (shortcuts.length >= minShortcuts) {
      return shortcuts;
    }

    // Obtém as rotas já presentes para evitar duplicatas
    final existingRoutes = shortcuts.map((s) => s.route).toSet();

    // Obtém os atalhos padrão
    final defaultShortcuts = _getDefaultShortcuts();

    // Cria uma cópia da lista de atalhos recomendados
    final result = List<ShortcutModel>.from(shortcuts);

    // Completa com atalhos padrão que não estão na lista
    for (final defaultShortcut in defaultShortcuts) {
      if (result.length >= minShortcuts) break;

      // Adiciona apenas se a rota não estiver presente
      if (!existingRoutes.contains(defaultShortcut.route)) {
        result.add(defaultShortcut);
        existingRoutes.add(defaultShortcut.route);
      }
    }

    // Se ainda não tiver 4, completa com os primeiros padrões disponíveis
    if (result.length < minShortcuts) {
      for (final defaultShortcut in defaultShortcuts) {
        if (result.length >= minShortcuts) break;
        if (!existingRoutes.contains(defaultShortcut.route)) {
          result.add(defaultShortcut);
          existingRoutes.add(defaultShortcut.route);
        }
      }
    }

    return result;
  }

  List<ShortcutModel> _getDefaultShortcuts() {
    return [
      ShortcutModel(
        route: Routes.gerenciarEquipePage,
        title: 'Gerenciar Equipe',
        icon: 'assets/icons/gerenciar_icon.svg',
        colorHex: '#6366F1',
        confidence: 0.5,
      ),
      ShortcutModel(
        route: Routes.historicoPage,
        title: 'Histórico',
        icon: 'assets/icons/relatorio_icon.svg',
        colorHex: '#8B5CF6',
        confidence: 0.5,
      ),
      ShortcutModel(
        route: Routes.agendaPage,
        title: 'Agenda',
        icon: 'assets/icons/inventario_icon.svg',
        colorHex: '#06B6D4',
        confidence: 0.5,
      ),
      ShortcutModel(
        route: Routes.protocoloPage,
        title: 'Protocolos',
        icon: 'assets/icons/relatorio_icon.svg',
        colorHex: '#10B981',
        confidence: 0.5,
      ),
    ];
  }

  @action
  Future<void> carregarHome() async {
    if (homeDashboardRepository == null) return;

    isLoading = true;
    hasError = false;
    errorMessage = '';

    try {
      final contaId = authController.usuario?.contas?.firstOrNull?.conta?.id;
      if (contaId == null) {
        hasError = true;
        errorMessage = 'Conta não encontrada';
        isLoading = false;
        return;
      }

      final result =
          await homeDashboardRepository!.buscarHomeDashboard(contaId);

      result.fold(
        (failure) {
          hasError = true;
          errorMessage = failure.message;
        },
        (data) {
          dashboard = data;
          hasError = false;
          // Inicializa a ordem dos cards quando o dashboard é carregado
          if (cardOrder.isEmpty) {
            initializeCardOrder();
          }
        },
      );
    } catch (e) {
      hasError = true;
      errorMessage = 'Erro ao carregar dashboard: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }
}
