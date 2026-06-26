import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/shortcut/shortcut_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/core/services/metrics_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';

class AdaptiveInterfaceService {
  FirebaseFunctions? _functions;

  /// Obtém instância do Firebase Functions de forma lazy
  FirebaseFunctions? get _functionsInstance {
    try {
      // Verifica se Firebase está inicializado
      Firebase.app();
      _functions ??= FirebaseFunctions.instance;
      return _functions;
    } catch (e) {
      // Firebase não inicializado, retorna null
      return null;
    }
  }

  /// Busca interface adaptativa (Dashboard + Atalhos) do Cloud Function
  ///
  /// Parâmetros opcionais:
  /// - [mode]: Modo de adaptação ('STATIC', 'INSTANT', 'GRADUAL')
  /// - [sessionId]: ID da sessão (obrigatório para modo INSTANT)
  Future<Either<Failure, AdaptiveInterfaceResponse>> getAdaptiveInterface({
    String? mode,
    String? sessionId,
  }) async {
    print('🔵 [ADAPTIVE] Iniciando busca de interface adaptativa...');

    try {
      // Verifica se Firebase está disponível
      final functions = _functionsInstance;
      if (functions == null) {
        print('⚠️ [ADAPTIVE] Firebase não inicializado, usando atalhos padrão');
        return Right(AdaptiveInterfaceResponse(
          dashboard: null,
          dashboardConfidence: 0.0,
          shortcuts: _getDefaultShortcuts(),
          mode: 'GRADUAL',
        ));
      }

      final now = DateTime.now();
      final currentHour = now.hour;
      final userId = _getUserId();

      print('📡 [ADAPTIVE] Chamando Cloud Function...');
      print(' └─ Hora atual: $currentHour');
      print(' └─ User ID: $userId');
      if (mode != null) print(' └─ Mode: $mode');
      if (sessionId != null) print(' └─ Session ID: $sessionId');

      // Chama a Cloud Function
      final callable = functions.httpsCallable('getAdaptiveInterface');
      final startTime = DateTime.now();
      final result = await callable.call({
        'hour': currentHour,
        'userId': userId,
        if (mode != null) 'mode': mode,
        if (sessionId != null) 'sessionId': sessionId,
      });
      final duration = DateTime.now().difference(startTime);

      print(
          '✅ [ADAPTIVE] Cloud Function respondeu em ${duration.inMilliseconds}ms');

      final data = result.data as Map<String, dynamic>;

      print('📦 [ADAPTIVE] Dados recebidos:');
      print(' └─ Dashboard: ${data['dashboard'] ?? 'null'}');
      print(' └─ Confidence: ${data['confidence'] ?? 0.0}');
      print(
          ' └─ Shortcuts: ${(data['shortcuts'] as List?)?.length ?? 0} itens');
      print(' └─ Mode: ${data['mode'] ?? 'GRADUAL'}');

      // Extrai informações do dashboard (suporta campos novos e legados)
      final dashboardName = data['dashboard'] as String?;
      final dashboardId = data['dashboardId'] as String?;
      final cardType = data['cardType'] as String?;
      final confidence = ((data['confidence'] as num?) ?? 0).toDouble();
      final responseMode = (data['mode'] as String?) ?? 'GRADUAL';
      final dashboardSource = _resolveDashboardSource(
        data,
        confidence: confidence,
        dashboardName: dashboardName,
        cardType: cardType,
      );

      print('📊 [ADAPTIVE] Dashboard recebido:');
      print(' └─ displayName: ${dashboardName ?? 'null'}');
      print(' └─ dashboardId: ${dashboardId ?? 'null'}');
      print(' └─ cardType: ${cardType ?? 'null'}');
      print(' └─ confidence: ${(confidence * 100).toStringAsFixed(1)}%');

      // Parse dos atalhos
      final shortcutsList = data['shortcuts'] as List<dynamic>? ?? [];
      print('🔄 [ADAPTIVE] Processando ${shortcutsList.length} atalhos...');

      final shortcuts = shortcutsList
          .map((item) {
            if (item is String) {
              // Se retornar apenas string (route), cria modelo básico
              return _createShortcutFromRoute(item, 0.5);
            } else if (item is Map) {
              // Se retornar objeto completo
              final route = item['route'] as String? ??
                  item['predicted_target_screen'] as String? ??
                  '';
              final itemConfidence =
                  (item['prob'] as num? ?? item['confidence'] as num? ?? 0.5)
                      .toDouble();
              final resourceId = item['resourceId']?.toString();
              final resourceType = item['resourceType']?.toString();
              final resourceName = item['resourceName']?.toString();
              final source = _resolveShortcutSource(
                item,
                confidence: itemConfidence,
                resourceId: resourceId,
              );

              print(
                  ' └─ Atalho: $route (confiança: ${(itemConfidence * 100).toStringAsFixed(1)}%)');
              if (resourceId != null && resourceName != null) {
                print(
                    ' └─ Recurso: $resourceType #$resourceId - "$resourceName"');
              }

              return _createShortcutFromRoute(
                route,
                itemConfidence,
                resourceId: resourceId,
                resourceType: resourceType,
                resourceName: resourceName,
                source: source,
              );
            }
            return null;
          })
          .whereType<ShortcutModel>()
          .toList();

      // Se não houver atalhos, usa os padrão
      if (shortcuts.isEmpty) {
        print('⚠️ [ADAPTIVE] Nenhum atalho válido, usando padrão');
        return Right(AdaptiveInterfaceResponse(
          dashboard: dashboardName,
          dashboardId: dashboardId,
          cardType: cardType,
          dashboardSource: dashboardSource,
          dashboardConfidence: confidence,
          shortcuts: _getDefaultShortcuts(),
          mode: responseMode,
        ));
      }

      print('✅ [ADAPTIVE] Interface adaptativa carregada:');
      print(
          ' └─ Dashboard: ${dashboardName ?? 'null'} (confiança: ${(confidence * 100).toStringAsFixed(1)}%)');
      if (cardType != null) {
        print(' └─ Card Type (novo): $cardType');
      }
      print(' └─ Mode: $responseMode');
      print(' └─ Atalhos: ${shortcuts.length} recomendados');
      for (var s in shortcuts) {
        if (s.resourceName != null) {
          print(
              ' • ${s.displayTitle} (${s.route}) - ${(s.confidence * 100).toStringAsFixed(1)}%');
        } else {
          print(
              ' • ${s.title} (${s.route}) - ${(s.confidence * 100).toStringAsFixed(1)}%');
        }
      }

      // Metrics tracking: registra exposição de shortcuts e dashboard
      _trackAdaptiveExposure(
        shortcuts: shortcuts,
        dashboardId: dashboardId,
        mode: responseMode,
        sessionId: sessionId,
      );

      return Right(AdaptiveInterfaceResponse(
        dashboard: dashboardName,
        dashboardId: dashboardId,
        cardType: cardType,
        dashboardSource: dashboardSource,
        dashboardConfidence: confidence,
        shortcuts: shortcuts,
        mode: responseMode,
      ));
    } catch (e, stackTrace) {
      // Em caso de erro, retorna atalhos padrão
      print('❌ [ADAPTIVE] Erro ao buscar interface adaptativa: $e');
      print(' StackTrace: $stackTrace');
      return Right(AdaptiveInterfaceResponse(
        dashboard: null,
        dashboardConfidence: 0.0,
        shortcuts: _getDefaultShortcuts(),
        mode: 'GRADUAL',
      ));
    }
  }

  /// Cria um ShortcutModel a partir de uma rota
  ShortcutModel _createShortcutFromRoute(
    String route,
    double confidence, {
    String? resourceId,
    String? resourceType,
    String? resourceName,
    String source = 'system',
  }) {
    final config = _getRouteConfig()[route];

    if (config != null) {
      return ShortcutModel(
        route: route,
        title: config['title']!,
        icon: config['icon']!,
        colorHex: config['colorHex']!,
        confidence: confidence,
        context: confidence > 0.7 ? 'frequente' : null,
        resourceId: resourceId,
        resourceType: resourceType,
        resourceName: resourceName,
        source: source,
      );
    }

    // Fallback para rota desconhecida
    return ShortcutModel(
      route: route,
      title: route.replaceAll('_', ' ').replaceAll('Page', ''),
      icon: 'assets/icons/info_icon.svg',
      colorHex: '#6366F1',
      confidence: confidence,
      resourceId: resourceId,
      resourceType: resourceType,
      resourceName: resourceName,
      source: source,
    );
  }

  String _resolveShortcutSource(
    Map<dynamic, dynamic> item, {
    required double confidence,
    String? resourceId,
  }) {
    final rawSource = item['source']?.toString().toLowerCase() ??
        item['origin']?.toString().toLowerCase();

    if (rawSource == 'system' ||
        rawSource == 'static' ||
        rawSource == 'default') {
      return 'system';
    }

    if (rawSource == 'adaptive' || rawSource == 'smart' || rawSource == 'ml') {
      return 'adaptive';
    }

    if (resourceId != null || confidence > 0.5) {
      return 'adaptive';
    }

    return 'system';
  }

  String _resolveDashboardSource(
    Map<String, dynamic> data, {
    required double confidence,
    String? dashboardName,
    String? cardType,
  }) {
    final rawSource = data['dashboardSource']?.toString().toLowerCase() ??
        data['dashboardOrigin']?.toString().toLowerCase();

    if (rawSource == 'system' ||
        rawSource == 'static' ||
        rawSource == 'default') {
      return 'system';
    }

    if (rawSource == 'adaptive' || rawSource == 'smart' || rawSource == 'ml') {
      return 'adaptive';
    }

    if ((dashboardName != null || cardType != null) && confidence > 0.5) {
      return 'adaptive';
    }

    return 'system';
  }

  /// Configuração de rotas para mapeamento
  Map<String, Map<String, String>> _getRouteConfig() {
    return {
      Routes.gerenciarEquipePage: {
        'title': 'Gerenciar Equipe',
        'icon': 'assets/icons/gerenciar_icon.svg',
        'colorHex': '#6366F1',
      },
      Routes.historicoPage: {
        'title': 'Histórico',
        'icon': 'assets/icons/relatorio_icon.svg',
        'colorHex': '#8B5CF6',
      },
      Routes.agendaPage: {
        'title': 'Agenda',
        'icon': 'assets/icons/inventario_icon.svg',
        'colorHex': '#06B6D4',
      },
      Routes.protocoloPage: {
        'title': 'Protocolos',
        'icon': 'assets/icons/relatorio_icon.svg',
        'colorHex': '#10B981',
      },
      Routes.setorPage: {
        'title': 'Setores',
        'icon': 'assets/icons/cultivo_icon.svg',
        'colorHex': '#059669',
      },
      Routes.reservatoriosPage: {
        'title': 'Reservatórios',
        'icon': 'assets/icons/reservatorio_icon.svg',
        'colorHex': '#2563EB',
      },
      Routes.cadernoCampoPage: {
        'title': 'Caderno de Campo',
        'icon': 'assets/icons/caderno_campo_icon.svg',
        'colorHex': '#DC2626',
      },
      Routes.solucaoPage: {
        'title': 'Soluções Nutritivas',
        'icon': 'assets/icons/solucoes_nutritivas_icon.svg',
        'colorHex': '#EA580C',
      },
      Routes.ajustesPage: {
        'title': 'Ajustes',
        'icon': 'assets/icons/ajustes_icon.svg',
        'colorHex': '#7C3AED',
      },
      Routes.lotePage: {
        'title': 'Lotes',
        'icon': 'assets/icons/cultivo_icon.svg',
        'colorHex': '#059669',
      },
    };
  }

  String? _getUserId() {
    try {
      // Tenta pegar o userId do AuthController
      final authController = GetIt.I<AuthController>();
      print(' └─ AuthController.usuario: ${authController.usuario}');
      print(' └─ AuthController.usuario?.id: ${authController.usuario.id}');
      return (authController.usuario.id)?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Retorna atalhos padrão quando não há dados do ML
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

  /// Registra exposição de shortcuts e dashboard para métricas de eficácia.
  /// Fire-and-forget: erros são logados silenciosamente, sem impactar o fluxo.
  void _trackAdaptiveExposure({
    required List<ShortcutModel> shortcuts,
    String? dashboardId,
    String mode = 'GRADUAL',
    String? sessionId,
  }) {
    try {
      final metrics = MetricsTrackingService.instance;

      if (shortcuts.isNotEmpty) {
        metrics.trackShortcutsShown(
          shortcutRoutes: shortcuts.map((s) => s.route).toList(),
          mode: mode,
          sessionId: sessionId,
        );
      }

      if (dashboardId != null) {
        metrics.trackDashboardShown(
          dashboardId: dashboardId,
          mode: mode,
          sessionId: sessionId,
        );
      }
    } catch (e) {
      // Silencioso — tracking não pode quebrar o fluxo principal
      print('⚠️ [ADAPTIVE] Erro ao registrar métricas de exposição: $e');
    }
  }
}

/// Resposta da Cloud Function
class AdaptiveInterfaceResponse {
  /// Nome legível do dashboard (legado)
  final String? dashboard;

  /// ID técnico do dashboard
  final String? dashboardId;

  /// Tipo de card correspondente ao dashboard
  final String? cardType;

  /// Origem da seleção do dashboard: system ou adaptive.
  final String dashboardSource;

  /// Confiança da recomendação (0.0 - 1.0)
  final double dashboardConfidence;

  /// Lista de atalhos recomendados
  final List<ShortcutModel> shortcuts;

  /// Modo de adaptação usado ('STATIC', 'INSTANT', 'GRADUAL')
  final String mode;

  AdaptiveInterfaceResponse({
    this.dashboard,
    this.dashboardId,
    this.cardType,
    this.dashboardSource = 'system',
    required this.dashboardConfidence,
    required this.shortcuts,
    this.mode = 'GRADUAL',
  });

  /// Obtém o tipo de card preferencialmente do novo campo cardType,
  /// fazendo fallback para o mapeamento por nome
  String? get effectiveCardType {
    // Prioridade 1: novo campo cardType
    if (cardType != null && cardType!.isNotEmpty) {
      return cardType;
    }
    // Prioridade 2: mapeamento por nome
    return mapDashboardToCardType(dashboard);
  }

  /// Mapeamento estático de nomes de dashboard para tipos de cards
  /// Mantido para backward compatibility
  static const Map<String, String> _dashboardToCardTypeMap = {
    'Lotes em Produção': 'lotes',
    'Tarefas Pendentes': 'tarefas',
    'Produção Total': 'producao',
    'Saúde das Equipes': 'saude',
  };

  /// Mapeia o nome do dashboard para o tipo de card
  static String? mapDashboardToCardType(String? dashboardName) {
    if (dashboardName == null || dashboardName.isEmpty) return null;

    // Matching exato primeiro
    final exactMatch = _dashboardToCardTypeMap[dashboardName];
    if (exactMatch != null) {
      return exactMatch;
    }

    // Log de aviso para dashboards não mapeados
    print('⚠️ [ADAPTIVE] Dashboard não mapeado: "$dashboardName"');
    return null;
  }
}

/// Erro customizado
class AdaptiveInterfaceError implements Failure {
  @override
  final String message;
  AdaptiveInterfaceError({required this.message});
}
