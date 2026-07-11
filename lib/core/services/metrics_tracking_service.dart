import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

class MetricsTrackingService {
  static final MetricsTrackingService _instance = MetricsTrackingService._internal();
  factory MetricsTrackingService() => _instance;
  MetricsTrackingService._internal();

  static MetricsTrackingService get instance => _instance;

  FirebaseAnalytics? _analytics;
  bool _firstProductiveNavTracked = false;
  DateTime? _sessionStartTimestamp;
  Map<String, dynamic>? _experimentConfig;

  FirebaseAnalytics? get _analyticsInstance {
    try {
      Firebase.app();
      _analytics ??= FirebaseAnalytics.instance;
      return _analytics;
    } catch (e) {
      return null;
    }
  }

  String? _getUserId() {
    try {
      final authController = GetIt.I<AuthController>();
      return (authController.usuario.id)?.toString();
    } catch (e) {
      return null;
    }
  }

  Future<void> _ensureExperimentConfig() async {
    if (_experimentConfig != null) return;
    try {
      final userId = _getUserId();
      if (userId == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('userAdaptiveConfig')
          .doc(userId)
          .get();
      if (doc.exists) _experimentConfig = doc.data();
    } catch (_) {
      // Silent — experiment data is optional for metrics
    }
  }

  /// Fire-and-forget write to the instantMetrics Firestore collection.
  Future<void> _writeInstantMetric({
    required String event,
    required Map<String, dynamic> extra,
  }) async {
    try {
      await _ensureExperimentConfig();
      final userId = _getUserId() ?? 'anonymous';
      final data = <String, dynamic>{
        'event': event,
        'userId': userId,
        'experimentId': _experimentConfig?['experimentId'],
        'testGroup': _experimentConfig?['testGroup'],
        'participantId': _experimentConfig?['participantId'],
        'period': _experimentConfig?['period'],
        ...extra,
        'createdAt': FieldValue.serverTimestamp(),
      };
      data.removeWhere((key, value) => value == null);
      await FirebaseFirestore.instance
          .collection('instantMetrics')
          .add(data);
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar métrica instantânea: $e');
    }
  }

  /// M1: Registra que shortcuts foram exibidos ao usuário
  Future<void> trackShortcutsShown({
    required List<String> shortcutRoutes,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    final userId = _getUserId();

    try {
      await analytics.logEvent(
        name: 'shortcuts_shown',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          'shortcut_routes': shortcutRoutes.join(','),
          'shortcuts_count': shortcutRoutes.length,
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] shortcuts_shown: ${shortcutRoutes.length} atalhos em modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar shortcuts_shown: $e');
    }
  }

  /// M1: Registra que usuário clicou em um shortcut recomendado
  Future<void> trackShortcutClicked({
    required String route,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    final userId = _getUserId();

    try {
      await analytics.logEvent(
        name: 'shortcut_clicked',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          'route': route,
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] shortcut_clicked: $route em modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar shortcut_clicked: $e');
    }

    await _writeInstantMetric(
      event: 'shortcut_clicked',
      extra: {
        'route': route,
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }

  /// M2: Registra que dashboard foi exibido na home
  Future<void> trackDashboardShown({
    required String? dashboardId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    final userId = _getUserId();

    try {
      await analytics.logEvent(
        name: 'dashboard_shown',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          'dashboard_id': dashboardId ?? 'null',
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] dashboard_shown: $dashboardId em modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar dashboard_shown: $e');
    }
  }

  /// M2: Registra que usuário trocou o dashboard na home
  Future<void> trackDashboardChanged({
    required String? fromDashboardId,
    required String? toDashboardId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    final userId = _getUserId();

    try {
      await analytics.logEvent(
        name: 'dashboard_changed',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          'from_dashboard': fromDashboardId ?? 'null',
          'to_dashboard': toDashboardId ?? 'null',
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] dashboard_changed: $fromDashboardId → $toDashboardId em modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar dashboard_changed: $e');
    }
  }

  /// M3: Regenta início de sessão na home
  Future<void> trackSessionStart({
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    _sessionStartTimestamp = DateTime.now();
    _firstProductiveNavTracked = false;

    final userId = _getUserId();

    try {
      await analytics.logEvent(
        name: 'adaptive_session_start',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] adaptive_session_start: modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar adaptive_session_start: $e');
    }

    await _writeInstantMetric(
      event: 'session_start',
      extra: {
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }

  /// M3: Registra primeira navegação produtiva (time-to-task proxy)
  Future<void> trackFirstProductiveNavigation({
    required String screen,
    required String mode,
    String? sessionId,
  }) async {
    if (_firstProductiveNavTracked) return;
    _firstProductiveNavTracked = true;

    final analytics = _analyticsInstance;
    if (analytics == null) return;

    final userId = _getUserId();
    final timeToTask = _sessionStartTimestamp != null
        ? DateTime.now().difference(_sessionStartTimestamp!).inMilliseconds
        : -1;

    try {
      await analytics.logEvent(
        name: 'first_productive_navigation',
        parameters: {
          'user_id': userId ?? 'anonymous',
          'mode': mode,
          'screen': screen,
          'time_to_task_ms': timeToTask,
          if (sessionId != null) 'session_id': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] first_productive_navigation: $screen (${timeToTask}ms) em modo $mode');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar first_productive_navigation: $e');
    }
  }

  /// Reseta estado de tracking (útil quando sessão termina ou usuário troca)
  void resetTrackingState() {
    _firstProductiveNavTracked = false;
    _sessionStartTimestamp = null;
    _experimentConfig = null;
  }

  /// M4: Instant adaptation applied
  Future<void> trackInstantAdaptationApplied({
    required String mode,
    required String sessionId,
    required List<String> renderedComponents,
    required bool usedFallback,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'instant_adaptation_applied',
        parameters: {
          'mode': mode,
          'session_id': sessionId,
          'rendered_components': renderedComponents.join(','),
          'component_count': renderedComponents.length,
          'used_fallback': usedFallback.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 [METRICS] instant_adaptation_applied: ${renderedComponents.length} componentes');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar instant_adaptation_applied: $e');
    }

    await _writeInstantMetric(
      event: 'adaptation_applied',
      extra: {
        'mode': mode,
        'sessionId': sessionId,
        'components': renderedComponents,
        'componentCount': renderedComponents.length,
        'usedFallback': usedFallback,
      },
    );
  }

  /// M4: Next step shown
  Future<void> trackNextStepShown({
    required String nextStepId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'next_step_shown',
        parameters: {
          'next_step_id': nextStepId,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar next_step_shown: $e');
    }

    await _writeInstantMetric(
      event: 'next_step_shown',
      extra: {
        'nextStepId': nextStepId,
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }

  /// M4: Next step clicked
  Future<void> trackNextStepClicked({
    required String targetRoute,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'next_step_clicked',
        parameters: {
          'target_route': targetRoute,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar next_step_clicked: $e');
    }

    await _writeInstantMetric(
      event: 'next_step_clicked',
      extra: {
        'targetRoute': targetRoute,
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }

  /// M4: Section highlight shown
  Future<void> trackSectionHighlightShown({
    required String sectionId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'section_highlight_shown',
        parameters: {
          'section_id': sectionId,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar section_highlight_shown: $e');
    }
  }

  /// M4: Section highlight clicked
  Future<void> trackSectionHighlightClicked({
    required String sectionId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'section_highlight_clicked',
        parameters: {
          'section_id': sectionId,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar section_highlight_clicked: $e');
    }
  }

  /// M4: Info icon opened
  Future<void> trackInfoIconOpened({
    required String componentId,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'info_icon_opened',
        parameters: {
          'component_id': componentId,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar info_icon_opened: $e');
    }
  }

  /// M4: Contextual onboarding shown
  Future<void> trackContextualOnboardingShown({
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'contextual_onboarding_shown',
        parameters: {
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar contextual_onboarding_shown: $e');
    }
  }

  /// M4: Contextual onboarding clicked
  Future<void> trackContextualOnboardingClicked({
    required String targetRoute,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'contextual_onboarding_clicked',
        parameters: {
          'target_route': targetRoute,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar contextual_onboarding_clicked: $e');
    }
  }

  /// Info Card: shown
  Future<void> trackInfoCardShown({
    required String infoType,
    required String source,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'info_card_shown',
        parameters: {
          'info_type': infoType,
          'source': source,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
      print(
          '📊 [METRICS] info_card_shown: $infoType (source: $source, mode: $mode)');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar info_card_shown: $e');
    }

    await _writeInstantMetric(
      event: 'info_card_shown',
      extra: {
        'infoType': infoType,
        'source': source,
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }

  /// Info Card: clicked
  Future<void> trackInfoCardClicked({
    required String infoType,
    required String targetRoute,
    required String mode,
    String? sessionId,
  }) async {
    final analytics = _analyticsInstance;
    if (analytics == null) return;

    try {
      await analytics.logEvent(
        name: 'info_card_clicked',
        parameters: {
          'info_type': infoType,
          'target_route': targetRoute,
          'mode': mode,
          if (sessionId != null) 'session_id': sessionId,
        },
      );
      print(
          '📊 [METRICS] info_card_clicked: $infoType → $targetRoute (mode: $mode)');
    } catch (e) {
      print('❌ [METRICS] Erro ao registrar info_card_clicked: $e');
    }

    await _writeInstantMetric(
      event: 'info_card_clicked',
      extra: {
        'infoType': infoType,
        'targetRoute': targetRoute,
        'mode': mode,
        'sessionId': sessionId,
      },
    );
  }
}
