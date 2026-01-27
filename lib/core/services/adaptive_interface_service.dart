import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/shortcut/shortcut_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
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
  Future<Either<Failure, AdaptiveInterfaceResponse>>
      getAdaptiveInterface() async {
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
        ));
      }

      final now = DateTime.now();
      final currentHour = now.hour;
      final userId = _getUserId();

      print('📡 [ADAPTIVE] Chamando Cloud Function...');
      print('   └─ Hora atual: $currentHour');
      print('   └─ User ID: $userId');

      // Chama a Cloud Function
      final callable = functions.httpsCallable('getAdaptiveInterface');
      final startTime = DateTime.now();
      final result = await callable.call({
        'hour': currentHour,
        'userId': userId,
      });
      final duration = DateTime.now().difference(startTime);

      print(
          '✅ [ADAPTIVE] Cloud Function respondeu em ${duration.inMilliseconds}ms');

      final data = result.data as Map<String, dynamic>;

      print('📦 [ADAPTIVE] Dados recebidos:');
      print('   └─ Dashboard: ${data['dashboard'] ?? 'null'}');
      print('   └─ Confidence: ${data['confidence'] ?? 0.0}');
      print(
          '   └─ Shortcuts: ${(data['shortcuts'] as List?)?.length ?? 0} itens');

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
              final confidence =
                  (item['prob'] as num? ?? item['confidence'] as num? ?? 0.5)
                      .toDouble();
              final resourceId = item['resourceId'] as String?;
              final resourceType = item['resourceType'] as String?;
              final resourceName = item['resourceName'] as String?;

              print(
                  '   └─ Atalho: $route (confiança: ${(confidence * 100).toStringAsFixed(1)}%)');
              if (resourceId != null && resourceName != null) {
                print(
                    '      └─ Recurso: $resourceType #$resourceId - "$resourceName"');
              }

              return _createShortcutFromRoute(
                route,
                confidence,
                resourceId: resourceId,
                resourceType: resourceType,
                resourceName: resourceName,
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
          dashboard: data['dashboard'] as String?,
          dashboardConfidence: ((data['confidence'] as num?) ?? 0).toDouble(),
          shortcuts: _getDefaultShortcuts(),
        ));
      }

      print('✅ [ADAPTIVE] Interface adaptativa carregada:');
      print(
          '   └─ Dashboard: ${data['dashboard'] ?? 'null'} (confiança: ${((data['confidence'] as num?) ?? 0) * 100}%)');
      print('   └─ Atalhos: ${shortcuts.length} recomendados');
      for (var s in shortcuts) {
        if (s.resourceName != null) {
          print(
              '      • ${s.displayTitle} (${s.route}) - ${(s.confidence * 100).toStringAsFixed(1)}%');
        } else {
          print(
              '      • ${s.title} (${s.route}) - ${(s.confidence * 100).toStringAsFixed(1)}%');
        }
      }

      return Right(AdaptiveInterfaceResponse(
        dashboard: data['dashboard'] as String?,
        dashboardConfidence: ((data['confidence'] as num?) ?? 0).toDouble(),
        shortcuts: shortcuts,
      ));
    } catch (e, stackTrace) {
      // Em caso de erro, retorna atalhos padrão
      print('❌ [ADAPTIVE] Erro ao buscar interface adaptativa: $e');
      print('   StackTrace: $stackTrace');
      return Right(AdaptiveInterfaceResponse(
        dashboard: null,
        dashboardConfidence: 0.0,
        shortcuts: _getDefaultShortcuts(),
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
    );
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
      print('   └─ AuthController.usuario: ${authController.usuario}');
      print('   └─ AuthController.usuario?.id: ${authController.usuario.id}');
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
}

/// Resposta da Cloud Function
class AdaptiveInterfaceResponse {
  final String? dashboard;
  final double dashboardConfidence;
  final List<ShortcutModel> shortcuts;

  AdaptiveInterfaceResponse({
    this.dashboard,
    required this.dashboardConfidence,
    required this.shortcuts,
  });
}

/// Erro customizado
class AdaptiveInterfaceError implements Failure {
  @override
  final String message;
  AdaptiveInterfaceError({required this.message});
}
