class ClientCapabilities {
  final List<String> supportedComponents;
  final List<String> supportedInfoTypes;
  final bool supportsInfoIconExplanation;
  final bool supportsHighlightFrame;
  final int maxShortcuts;
  final int maxSectionAdaptations;
  final List<String> forbiddenComponents;

  const ClientCapabilities({
    required this.supportedComponents,
    required this.supportedInfoTypes,
    required this.supportsInfoIconExplanation,
    required this.supportsHighlightFrame,
    required this.maxShortcuts,
    required this.maxSectionAdaptations,
    required this.forbiddenComponents,
  });

  Map<String, dynamic> toJson() => {
        'supportedComponents': supportedComponents,
        'supportedInfoTypes': supportedInfoTypes,
        'maxShortcuts': maxShortcuts,
        'maxSectionAdaptations': maxSectionAdaptations,
      };
}

class ClientCapabilitiesMapper {
  static ClientCapabilities map() {
    return const ClientCapabilities(
      supportedComponents: [
        'NextStepCard',
        'AdaptiveFocusBanner',
        'AdaptiveReasonChip',
        'AdaptiveRecommendedActionTile',
        'AdaptiveHighlightFrame',
        'ActivityFeedCard',
        'OperationalOnboardingCard',
        'HomeInfoCard',
      ],
      supportedInfoTypes: [
        'today_cultivation',
        'reservoir_report',
        'day_progress',
        'field_notes_summary',
        'basic_tip',
      ],
      supportsInfoIconExplanation: true,
      supportsHighlightFrame: true,
      maxShortcuts: 4,
      maxSectionAdaptations: 4,
      forbiddenComponents: [
        'WorkflowProgressBar',
        'TestProgressBar',
        'ProgressStepper',
        'ProgressBar',
        'Stepper',
        'Checklist',
      ],
    );
  }
}
