import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/shortcut/shortcut_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/core/services/metrics_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_mapper.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';

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
          source: 'fallback',
          visualPriority: 'none',
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

      final data = _normalizeCallableData(result.data);

      print('📦 [ADAPTIVE] Dados recebidos:');
      print(' └─ Dashboard: ${data['dashboard'] ?? 'null'}');
      print(' └─ Confidence: ${data['confidence'] ?? 0.0}');
      print(' └─ Shortcuts: ${_asList(data['shortcuts']).length} itens');
      print(' └─ Mode: ${data['mode'] ?? 'GRADUAL'}');

      // Extrai informações do dashboard (suporta campos novos e legados)
      final dashboardName = _asString(data['dashboard']);
      final dashboardId = _asString(data['dashboardId']);
      final cardType = _asString(data['cardType']);
      final confidence = _asConfidence(data['confidence']);
      final responseMode = _asString(data['mode']) ?? 'GRADUAL';
      final dashboardSource = _resolveDashboardSource(
        data,
        confidence: confidence,
        dashboardName: dashboardName,
        cardType: cardType,
      );
      final source = _normalizeSource(
        _asString(data['source']),
        fallback: dashboardSource,
      );
      final visualPriority = _normalizeVisualPriority(
        _asString(data['visualPriority']),
        fallback: data.containsKey('visualPriority') ? 'none' : '',
      );
      final reason = _normalizeReason(_asString(data['reason']));

      print('📊 [ADAPTIVE] Dashboard recebido:');
      print(' └─ displayName: ${dashboardName ?? 'null'}');
      print(' └─ dashboardId: ${dashboardId ?? 'null'}');
      print(' └─ cardType: ${cardType ?? 'null'}');
      print(' └─ confidence: ${(confidence * 100).toStringAsFixed(1)}%');

      // Parse dos atalhos
      final shortcutsList = _asList(data['shortcuts']);
      print('🔄 [ADAPTIVE] Processando ${shortcutsList.length} atalhos...');

      final shortcuts = shortcutsList
          .map((item) {
            if (item is String) {
              // Se retornar apenas string (route), cria modelo básico
              return _createShortcutFromRoute(item, 0.5);
            } else if (item is Map) {
              // Se retornar objeto completo
              final route = _asString(item['route']) ??
                  _asString(item['predicted_target_screen']) ??
                  '';
              final itemConfidence = _asConfidence(
                item['prob'] ?? item['confidence'],
                fallback: 0.5,
              );
              final resourceId = _asString(item['resourceId']);
              final resourceType = _asString(item['resourceType']);
              final resourceName = _asString(item['resourceName']);
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
          source: source,
          visualPriority: visualPriority,
          reason: reason,
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
        source: source,
        visualPriority: visualPriority,
        reason: reason,
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
        source: 'fallback',
        visualPriority: 'none',
      ));
    }
  }

  /// Busca interface adaptativa ENRIQUECIDA para modo INSTANT.
  /// Envia operationalContext e clientCapabilities para a Cloud Function.
  Future<Either<Failure, AdaptiveInterfaceResponse>> getInstantAdaptiveInterface({
    required String mode,
    required String sessionId,
    required Map<String, dynamic> operationalContext,
    required Map<String, dynamic> clientCapabilities,
  }) async {
    print(
        '🔵 [ADAPTIVE-INSTANT] Iniciando busca de interface adaptativa enriquecida...');

    try {
      final functions = _functionsInstance;
      if (functions == null) {
        return Right(AdaptiveInterfaceResponse(
          dashboard: null,
          dashboardConfidence: 0.0,
          shortcuts: _getDefaultShortcuts(),
          mode: mode,
          source: 'fallback',
          visualPriority: 'none',
          instantViewData:
              const InstantAdaptiveHomeViewData(fallbackUsed: true),
        ));
      }

      final now = DateTime.now();
      final currentHour = now.hour;
      final userId = _getUserId();

      final callable = functions.httpsCallable('getAdaptiveInterface');
      final result = await callable.call({
        'hour': currentHour,
        'userId': userId,
        'mode': mode,
        'sessionId': sessionId,
        'operationalContext': operationalContext,
        'clientCapabilities': clientCapabilities,
      });

      final data = _normalizeCallableData(result.data);

      // Parse base response (reuse existing parsing logic)
      final dashboardName = _asString(data['dashboard']);
      final dashboardId = _asString(data['dashboardId']);
      final cardType = _asString(data['cardType']);
      final confidence = _asConfidence(data['confidence']);
      final responseMode = _asString(data['mode']) ?? mode;
      final source = _normalizeSource(
        _asString(data['source']),
        fallback: 'adaptive',
      );
      final visualPriority = _normalizeVisualPriority(
        _asString(data['visualPriority']),
        fallback: 'none',
      );
      final reason = _normalizeReason(_asString(data['reason']));

      // Parse shortcuts (using shared helper)
      final shortcuts = _parseShortcuts(data);

      // Parse instant view data
      final instantViewData = InstantAdaptiveHomeMapper.parse(
        Map<String, dynamic>.from(data),
      );

      return Right(AdaptiveInterfaceResponse(
        dashboard: dashboardName,
        dashboardId: dashboardId,
        cardType: cardType,
        dashboardConfidence: confidence,
        shortcuts: shortcuts,
        mode: responseMode,
        source: source,
        visualPriority: visualPriority,
        reason: reason,
        instantViewData: instantViewData,
      ));
    } catch (e, stackTrace) {
      print('❌ [ADAPTIVE-INSTANT] Erro: $e');
      print(' StackTrace: $stackTrace');
      return Right(AdaptiveInterfaceResponse(
        dashboard: null,
        dashboardConfidence: 0.0,
        shortcuts: _getDefaultShortcuts(),
        mode: mode,
        source: 'fallback',
        visualPriority: 'none',
        instantViewData:
            const InstantAdaptiveHomeViewData(fallbackUsed: true),
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
    Map<String, Object?> data, {
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

  Map<String, Object?> _normalizeCallableData(Object? value) {
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }

    return const <String, Object?>{};
  }

  List<Object?> _asList(Object? value) {
    if (value is List) return value.cast<Object?>();
    return const <Object?>[];
  }

  String? _asString(Object? value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final stringValue = value.toString().trim();
    return stringValue.isEmpty || stringValue == 'null' ? null : stringValue;
  }

  double _asDouble(Object? value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  double _asConfidence(Object? value, {double fallback = 0}) {
    final confidence = _asDouble(value, fallback: fallback);
    if (confidence < 0) return 0;
    if (confidence > 1) return 1;
    return confidence;
  }

  String _normalizeSource(String? value, {required String fallback}) {
    final rawSource = value?.toLowerCase().trim();
    if (rawSource == 'adaptive' ||
        rawSource == 'system' ||
        rawSource == 'fallback' ||
        rawSource == 'insufficient_data') {
      return rawSource!;
    }

    return fallback;
  }

  String _normalizeVisualPriority(String? value, {String fallback = 'none'}) {
    final rawPriority = value?.toLowerCase().trim();
    if (rawPriority == 'none' ||
        rawPriority == 'weak' ||
        rawPriority == 'moderate' ||
        rawPriority == 'strong') {
      return rawPriority!;
    }

    return fallback;
  }

  String? _normalizeReason(String? value) {
    final reason = value?.trim();
    if (reason == null || reason.isEmpty) return null;
    return reason.length > 80 ? reason.substring(0, 80) : reason;
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

  /// Parseia atalhos do mapa de dados retornado pela Cloud Function.
  /// Retorna atalhos padrão se a lista estiver vazia ou não houver atalhos válidos.
  List<ShortcutModel> _parseShortcuts(Map<String, Object?> data) {
    final shortcutsList = _asList(data['shortcuts']);

    if (shortcutsList.isEmpty) {
      return _getDefaultShortcuts();
    }

    final shortcuts = shortcutsList
        .map((item) {
          if (item is String) {
            return _createShortcutFromRoute(item, 0.5);
          } else if (item is Map) {
            final route = _asString(item['route']) ??
                _asString(item['predicted_target_screen']) ??
                '';
            final itemConfidence = _asConfidence(
              item['prob'] ?? item['confidence'],
              fallback: 0.5,
            );
            final resourceId = _asString(item['resourceId']);
            final resourceType = _asString(item['resourceType']);
            final resourceName = _asString(item['resourceName']);
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

    if (shortcuts.isEmpty) {
      return _getDefaultShortcuts();
    }
    return shortcuts;
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

  final String source;

  final String visualPriority;

  final String? reason;

  /// Dados enriquecidos para modo INSTANT.
  final InstantAdaptiveHomeViewData? instantViewData;

  AdaptiveInterfaceResponse({
    this.dashboard,
    this.dashboardId,
    this.cardType,
    this.dashboardSource = 'system',
    required this.dashboardConfidence,
    required this.shortcuts,
    this.mode = 'GRADUAL',
    this.source = 'system',
    this.visualPriority = 'none',
    this.reason,
    this.instantViewData,
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
