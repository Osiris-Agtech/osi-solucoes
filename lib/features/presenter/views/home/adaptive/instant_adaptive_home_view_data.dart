class InstantAdaptiveHomeViewData {
  final NextStepViewData? nextStep;
  final AdaptiveFocusBannerViewData? focusBanner;
  final List<SectionAdaptationViewData> sectionAdaptations;
  final List<AdaptiveRecommendedActionViewData> recommendedActions;
  final List<ActivityFeedItemViewData> activityFeedItems;
  final InfoRecommendationViewData? infoRecommendation;
  final OperationalOnboardingViewData? operationalOnboarding;
  final String? reasonSummary;
  final bool fallbackUsed;

  const InstantAdaptiveHomeViewData({
    this.nextStep,
    this.focusBanner,
    this.sectionAdaptations = const [],
    this.recommendedActions = const [],
    this.activityFeedItems = const [],
    this.infoRecommendation,
    this.operationalOnboarding,
    this.reasonSummary,
    this.fallbackUsed = false,
  });

  bool get isEmpty =>
      nextStep == null &&
      focusBanner == null &&
      sectionAdaptations.isEmpty &&
      recommendedActions.isEmpty &&
      activityFeedItems.isEmpty &&
      infoRecommendation == null &&
      operationalOnboarding == null;
}

class NextStepViewData {
  final String title;
  final String description;
  final String ctaLabel;
  final String targetRoute;
  final String? resourceId;
  final String? infoExplanation;
  final bool isProminent;

  const NextStepViewData({
    required this.title,
    required this.description,
    required this.ctaLabel,
    required this.targetRoute,
    this.resourceId,
    this.infoExplanation,
    this.isProminent = false,
  });
}

class ContextualOnboardingViewData {
  final String title;
  final String message;
  final String ctaLabel;
  final String targetRoute;
  final String illustrationHint;

  const ContextualOnboardingViewData({
    required this.title,
    required this.message,
    required this.ctaLabel,
    required this.targetRoute,
    required this.illustrationHint,
  });
}

class OperationalOnboardingViewData {
  final String title;
  final String message;
  final List<String> steps;
  final String ctaLabel;
  final String targetRoute;
  final String? reason;
  final num? priority;

  const OperationalOnboardingViewData({
    required this.title,
    required this.message,
    required this.steps,
    required this.ctaLabel,
    required this.targetRoute,
    this.reason,
    this.priority,
  });
}

class AdaptiveFocusBannerViewData {
  final String message;
  final String? targetRoute;
  final String? ctaLabel;

  const AdaptiveFocusBannerViewData({
    required this.message,
    this.targetRoute,
    this.ctaLabel,
  });
}

class SectionAdaptationViewData {
  final String sectionId;
  final String highlightType;
  final String? reason;
  final String? label;

  const SectionAdaptationViewData({
    required this.sectionId,
    required this.highlightType,
    this.reason,
    this.label,
  });

  bool get hasHighlight => highlightType != 'none';
}

class AdaptiveRecommendedActionViewData {
  final String label;
  final String description;
  final String targetRoute;
  final String? resourceId;
  final double confidence;
  final String? reason;

  const AdaptiveRecommendedActionViewData({
    required this.label,
    required this.description,
    required this.targetRoute,
    this.resourceId,
    required this.confidence,
    this.reason,
  });
}

class ActivityFeedItemViewData {
  final String title;
  final String subtitle;
  final String? targetRoute;
  final DateTime timestamp;

  const ActivityFeedItemViewData({
    required this.title,
    required this.subtitle,
    this.targetRoute,
    required this.timestamp,
  });
}

class InfoRecommendationViewData {
  final String type; // today_cultivation, reservoir_report, day_progress, field_notes_summary, basic_tip
  final String source; // operational_context, user_preference, etc.
  final String priority; // high, medium, low
  final String title; // Display title for the info card
  final String reason; // Why this was recommended
  final String? ctaRoute; // Route to navigate to if user taps CTA
  final String category; // geral, agenda, lote, protocolo, solucao, reservatorio, caderno_campo, cultivo

  const InfoRecommendationViewData({
    required this.type,
    required this.source,
    required this.priority,
    required this.title,
    required this.reason,
    this.ctaRoute,
    required this.category,
  });
}
