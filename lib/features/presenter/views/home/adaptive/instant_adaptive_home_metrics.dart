/// Helper de métricas para o Instant Adaptive Home.
///
/// Centraliza o tracking de eventos da [InstantAdaptiveHomeView] com
/// deduplicação de eventos "shown" por sessão. Os métodos delegam as
/// chamadas reais de Firebase Analytics ao [MetricsTrackingService].
///
/// Uso típico:
/// ```dart
/// InstantAdaptiveHomeMetrics.trackAdaptationApplied(
///   mode: mode,
///   sessionId: sessionId,
///   renderedComponents: ['next_step', 'focus_banner'],
///   usedFallback: false,
/// );
/// ```
library;

import 'package:osi_solucoes/core/services/metrics_tracking_service.dart';

class InstantAdaptiveHomeMetrics {
  /// Controla quais eventos "shown" já foram disparados nesta sessão.
  /// A chave é um identificador único por tipo de evento (ex: `next_step_<id>`).
  static final Set<String> _shownComponents = {};

  /// Reseta o cache de eventos mostrados para uma nova sessão.
  static void resetSession() {
    _shownComponents.clear();
  }

  /// Track: instant_adaptation_applied
  ///
  /// Dispara uma vez por adaptação. Sempre que o algoritmo decide quais
  /// componentes renderizar para o usuário.
  static Future<void> trackAdaptationApplied({
    required String mode,
    required String sessionId,
    required List<String> renderedComponents,
    required bool usedFallback,
  }) async {
    await MetricsTrackingService.instance.trackInstantAdaptationApplied(
      mode: mode,
      sessionId: sessionId,
      renderedComponents: renderedComponents,
      usedFallback: usedFallback,
    );
  }

  /// Track: next_step_shown (apenas uma vez por nextStepId por sessão)
  static void trackNextStepShown(
      String nextStepId, String mode, String sessionId) {
    if (_shownComponents.contains('next_step_$nextStepId')) return;
    _shownComponents.add('next_step_$nextStepId');

    MetricsTrackingService.instance.trackNextStepShown(
      nextStepId: nextStepId,
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: next_step_clicked
  static void trackNextStepClicked(
      String targetRoute, String mode, String sessionId) {
    MetricsTrackingService.instance.trackNextStepClicked(
      targetRoute: targetRoute,
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: section_highlight_shown (uma vez por sectionId por sessão)
  static void trackSectionHighlightShown(
      String sectionId, String mode, String sessionId) {
    if (_shownComponents.contains('highlight_$sectionId')) return;
    _shownComponents.add('highlight_$sectionId');

    MetricsTrackingService.instance.trackSectionHighlightShown(
      sectionId: sectionId,
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: section_highlight_clicked
  static void trackSectionHighlightClicked(
      String sectionId, String mode, String sessionId) {
    MetricsTrackingService.instance.trackSectionHighlightClicked(
      sectionId: sectionId,
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: info_icon_opened
  static void trackInfoIconOpened(
      String componentId, String mode, String sessionId) {
    MetricsTrackingService.instance.trackInfoIconOpened(
      componentId: componentId,
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: contextual_onboarding_shown (uma vez por sessão)
  static void trackOnboardingShown(String mode, String sessionId) {
    if (_shownComponents.contains('onboarding_shown')) return;
    _shownComponents.add('onboarding_shown');

    MetricsTrackingService.instance.trackContextualOnboardingShown(
      mode: mode,
      sessionId: sessionId,
    );
  }

  /// Track: contextual_onboarding_clicked
  static void trackOnboardingClicked(
      String targetRoute, String mode, String sessionId) {
    MetricsTrackingService.instance.trackContextualOnboardingClicked(
      targetRoute: targetRoute,
      mode: mode,
      sessionId: sessionId,
    );
  }
}
