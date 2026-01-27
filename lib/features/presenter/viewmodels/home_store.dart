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

  final AdaptiveInterfaceService _adaptiveService = AdaptiveInterfaceService();

  @action
  Future<void> loadAdaptiveInterface() async {
    print('🏠 [HOME_STORE] Carregando interface adaptativa...');
    isLoadingShortcuts = true;
    try {
      final result = await _adaptiveService.getAdaptiveInterface();
      
      result.fold(
        (failure) {
          // Em caso de erro, usa atalhos padrão
          print('❌ [HOME_STORE] Erro ao carregar: ${failure.message}');
          recommendedShortcuts = _getDefaultShortcuts();
          adaptiveDashboard = null;
          dashboardConfidence = 0.0;
          print('   └─ Usando ${recommendedShortcuts.length} atalhos padrão');
        },
        (response) {
          recommendedShortcuts = response.shortcuts;
          adaptiveDashboard = response.dashboard;
          dashboardConfidence = response.dashboardConfidence;
          
          print('✅ [HOME_STORE] Interface adaptativa atualizada:');
          print('   └─ Dashboard recomendado: ${adaptiveDashboard ?? 'null'}');
          print('   └─ Confiança do dashboard: ${(dashboardConfidence * 100).toStringAsFixed(1)}%');
          print('   └─ Atalhos recomendados: ${recommendedShortcuts.length}');
          
          if (adaptiveDashboard != null && dashboardConfidence > 0.5) {
            print('   └─ ✅ Dashboard será aplicado automaticamente');
          } else {
            print('   └─ ⚠️ Dashboard não será aplicado (confiança baixa ou null)');
          }
        },
      );
    } catch (e, stackTrace) {
      // Fallback para atalhos padrão
      print('❌ [HOME_STORE] Exceção ao carregar interface: $e');
      print('   StackTrace: $stackTrace');
      recommendedShortcuts = _getDefaultShortcuts();
    } finally {
      isLoadingShortcuts = false;
      print('🏠 [HOME_STORE] Carregamento finalizado');
    }
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

      final result = await homeDashboardRepository!.buscarHomeDashboard(contaId);
      
      result.fold(
        (failure) {
          hasError = true;
          errorMessage = failure.message;
        },
        (data) {
          dashboard = data;
          hasError = false;
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
