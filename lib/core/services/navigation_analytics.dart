import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:get_it/get_it.dart';

class NavigationAnalytics {
  static FirebaseAnalytics? _analytics;

  /// Obtém instância do Firebase Analytics de forma lazy
  static FirebaseAnalytics? get _analyticsInstance {
    try {
      // Verifica se Firebase está inicializado
      Firebase.app();
      _analytics ??= FirebaseAnalytics.instance;
      return _analytics;
    } catch (e) {
      // Firebase não inicializado, retorna null
      return null;
    }
  }

  /// Registra uma navegação no Firebase Analytics
  static Future<void> logNavigation(
    String screenName, {
    String? resourceId,
    String? resourceType,
    String? resourceName,
  }) async {
    try {
      final analytics = _analyticsInstance;
      if (analytics == null) {
        // Firebase não inicializado, apenas retorna sem erro
        print('📊 [ANALYTICS] Firebase não disponível, navegação não registrada: $screenName');
        return;
      }

      final now = DateTime.now();
      final usuario = GetIt.I<AuthController>().usuario;
      final userId = (usuario?.id)?.toString() ?? 'anonymous';

      print('📊 [ANALYTICS] Registrando navegação:');
      print('   └─ Tela: $screenName');
      print('   └─ Hora: ${now.hour}h');
      print('   └─ Dia da semana: ${now.weekday}');
      print('   └─ User ID: $userId');
      if (resourceId != null) {
        print('   └─ Recurso: $resourceType #$resourceId${resourceName != null ? ' ($resourceName)' : ''}');
      }

      final parameters = {
        'screen_name': screenName,
        'hour': now.hour,
        'day_of_week': now.weekday,
        'user_id': userId,
        'timestamp': now.toIso8601String(),
      };

      // Adicionar parâmetros de recurso se disponíveis
      if (resourceId != null) {
        parameters['resource_id'] = resourceId;
      }
      if (resourceType != null) {
        parameters['resource_type'] = resourceType;
      }
      if (resourceName != null) {
        parameters['resource_name'] = resourceName;
      }

      await analytics.logEvent(
        name: 'navigation_click',
        parameters: parameters,
      );
      
      print('   └─ ✅ Navegação registrada no Firebase Analytics');
    } catch (e) {
      // Log erro mas não quebra o app
      print('❌ [ANALYTICS] Erro ao logar navegação: $e');
    }
  }

  /// Registra clique em atalho inteligente
  static Future<void> logShortcutClick(String route, double confidence) async {
    try {
      final analytics = _analyticsInstance;
      if (analytics == null) {
        print('📊 [ANALYTICS] Firebase não disponível, clique em atalho não registrado');
        return;
      }

      print('📊 [ANALYTICS] Registrando clique em atalho inteligente:');
      print('   └─ Rota: $route');
      print('   └─ Confiança: ${(confidence * 100).toStringAsFixed(1)}%');

      await analytics.logEvent(
        name: 'smart_shortcut_click',
        parameters: {
          'route': route,
          'confidence': confidence,
        },
      );
      
      print('   └─ ✅ Clique registrado no Firebase Analytics');
    } catch (e) {
      print('❌ [ANALYTICS] Erro ao logar clique em atalho: $e');
    }
  }

  /// Define o usuário atual no Analytics
  static Future<void> setUserId(String userId) async {
    try {
      final analytics = _analyticsInstance;
      if (analytics == null) {
        // Firebase não inicializado, apenas retorna sem erro
        return;
      }

      await analytics.setUserId(id: userId);
    } catch (e) {
      print('Erro ao definir userId: $e');
    }
  }
}
