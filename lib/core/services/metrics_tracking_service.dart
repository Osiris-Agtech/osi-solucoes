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
  }
}
