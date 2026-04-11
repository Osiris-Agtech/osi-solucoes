import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/services/navigation_resource_args.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

class NavigationAnalytics {
  static FirebaseAnalytics? _analytics;
  static String? _currentSessionId;

  static void onGetRouting(Routing? routing) {
    if (routing == null) {
      return;
    }
    if (routing.isDialog == true || routing.isBottomSheet == true) {
      return;
    }
    if (routing.current.isEmpty) {
      return;
    }
    final args = routing.args;
    NavigationResourceArgs? resource;
    if (args is NavigationResourceArgs) {
      resource = args;
    }
    
    // Registra navegação no Firebase Analytics (sempre, para todos os modos)
    logNavigation(
      routing.current,
      resourceId: resource?.resourceId,
      resourceType: resource?.resourceType,
      resourceName: resource?.resourceName,
    );
    
    // Registra no Firestore APENAS se houver sessão ativa (modo INSTANT)
    // GRADUAL e STATIC não salvam navegações no Firestore
    if (_currentSessionId != null) {
      _logToFirestore(
        routing.current,
        resourceId: resource?.resourceId,
        resourceType: resource?.resourceType,
        resourceName: resource?.resourceName,
      );
    }
  }

  static FirebaseAnalytics? get _analyticsInstance {
    try {
      Firebase.app();
      _analytics ??= FirebaseAnalytics.instance;
      return _analytics;
    } catch (e) {
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
        print(
            '📊 [ANALYTICS] Firebase não disponível, navegação não registrada: $screenName');
        return;
      }

      final now = DateTime.now();
      final usuario = GetIt.I<AuthController>().usuario;
      final userId = (usuario?.id)?.toString() ?? 'anonymous';

      print('📊 [ANALYTICS] Registrando navegação:');
      print(' └─ Tela: $screenName');
      print(' └─ Hora: ${now.hour}h');
      print(' └─ Dia da semana: ${now.weekday}');
      print(' └─ User ID: $userId');
      if (resourceId != null) {
        print(
            ' └─ Recurso: $resourceType #$resourceId${resourceName != null ? ' ($resourceName)' : ''}');
      }

      final parameters = {
        'screen_name': screenName,
        'hour': now.hour,
        'day_of_week': now.weekday,
        'user_id': userId,
        'timestamp': now.toIso8601String(),
      };

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

      print(' └─ ✅ Navegação registrada no Firebase Analytics');

      // Registra no Firestore APENAS se houver sessão ativa (modo INSTANT)
      if (_currentSessionId != null) {
        await _logToFirestore(
          screenName,
          resourceId: resourceId,
          resourceType: resourceType,
          resourceName: resourceName,
        );
      } else {
        print('   └─ ℹ️ Sem sessão ativa (GRADUAL/STATIC), não salvo no Firestore');
      }
    } catch (e) {
      print('❌ [ANALYTICS] Erro ao logar navegação: $e');
    }
  }

  /// Registra clique em atalho inteligente
  static Future<void> logShortcutClick(String route, double confidence) async {
    try {
      final analytics = _analyticsInstance;
      if (analytics == null) {
        print(
            '📊 [ANALYTICS] Firebase não disponível, clique em atalho não registrado');
        return;
      }

      print('📊 [ANALYTICS] Registrando clique em atalho inteligente:');
      print(' └─ Rota: $route');
      print(' └─ Confiança: ${(confidence * 100).toStringAsFixed(1)}%');

      await analytics.logEvent(
        name: 'smart_shortcut_click',
        parameters: {
          'route': route,
          'confidence': confidence,
        },
      );

      print(' └─ ✅ Clique registrado no Firebase Analytics');
    } catch (e) {
      print('❌ [ANALYTICS] Erro ao logar clique em atalho: $e');
    }
  }

  /// Define o usuário atual no Analytics
  static Future<void> setUserId(String userId) async {
    try {
      final analytics = _analyticsInstance;
      if (analytics == null) {
        return;
      }

      await analytics.setUserId(id: userId);
    } catch (e) {
      print('Erro ao definir userId: $e');
    }
  }

  static Future<void> startTestSession(String sessionId) async {
    try {
      Firebase.app();
      _currentSessionId = sessionId;

      final usuario = GetIt.I<AuthController>().usuario;
      final userId = (usuario?.id)?.toString() ?? 'anonymous';

      await FirebaseFirestore.instance
          .collection('sessionNavigations')
          .doc(sessionId)
          .set({
        'sessionId': sessionId,
        'userId': userId,
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      print('📊 [ANALYTICS] Sessão de teste iniciada: $sessionId');
    } catch (e) {
      print('📊 [ANALYTICS] Firebase não disponível, sessão não iniciada: $e');
    }
  }

  static Future<void> endTestSession() async {
    if (_currentSessionId == null) {
      print('📊 [ANALYTICS] Nenhuma sessão ativa para finalizar');
      return;
    }

    try {
      Firebase.app();

      await FirebaseFirestore.instance
          .collection('sessionNavigations')
          .doc(_currentSessionId)
          .update({
        'status': 'completed',
        'endedAt': FieldValue.serverTimestamp(),
      });

      print('📊 [ANALYTICS] Sessão de teste finalizada: $_currentSessionId');
      _currentSessionId = null;
    } catch (e) {
      print('📊 [ANALYTICS] Erro ao finalizar sessão: $e');
      _currentSessionId = null;
    }
  }

  static Future<void> _logToFirestore(
    String screenName, {
    String? resourceId,
    String? resourceType,
    String? resourceName,
  }) async {
    if (_currentSessionId == null) {
      print('   └─ ℹ️ Sem sessão ativa, navegação NÃO salva no Firestore: $screenName');
      return;
    }

    try {
      Firebase.app();
      final now = DateTime.now();

      await FirebaseFirestore.instance
          .collection('sessionNavigations')
          .doc(_currentSessionId)
          .collection('navigations')
          .add({
        'screen': screenName,
        'hour': now.hour,
        'dayOfWeek': now.weekday,
        'timestamp': FieldValue.serverTimestamp(),
        if (resourceId != null) 'resourceId': resourceId,
        if (resourceType != null) 'resourceType': resourceType,
        if (resourceName != null) 'resourceName': resourceName,
      });

      print('📊 [ANALYTICS] Navegação salva no Firestore (sessão INSTANT): $screenName');
    } catch (e) {
      print('📊 [ANALYTICS] Erro ao salvar navegação no Firestore: $e');
    }
  }
}
