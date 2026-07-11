import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';

class InstantAdaptiveHomeMapper {
  static InstantAdaptiveHomeViewData parse(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return const InstantAdaptiveHomeViewData(fallbackUsed: true);
    }

    try {
      return InstantAdaptiveHomeViewData(
        nextStep: _parseNextStep(data['nextStepPrediction']),
        focusBanner: _parseFocusBanner(data['focus']),
        sectionAdaptations:
            _parseSectionAdaptations(data['sectionAdaptations']),
        recommendedActions:
            _parseRecommendedActions(data['shortcuts']),
        activityFeedItems: _parseActivityFeed(data['activityFeedItems']),
        infoRecommendation: _parseInfoRecommendation(data['infoRecommendation']),
        operationalOnboarding:
            _parseOperationalOnboarding(data['operationalOnboarding']),
        reasonSummary: _parseReasonSummary(data),
        fallbackUsed: false,
      );
    } catch (_) {
      return const InstantAdaptiveHomeViewData(fallbackUsed: true);
    }
  }

  static NextStepViewData? _parseNextStep(dynamic value) {
    final map = _parseMap(value);
    if (map == null) return null;

    final title = _asString(map['title']);
    final description = _asString(map['description']);
    // API field is actionLabel, mapped to ctaLabel
    final ctaLabel = _asString(map['actionLabel']);
    final targetRoute = _asString(map['targetRoute']);

    if (title == null || description == null || ctaLabel == null) {
      return null;
    }
    if (targetRoute == null || targetRoute.isEmpty) return null;

    return NextStepViewData(
      title: title,
      description: description,
      ctaLabel: ctaLabel,
      targetRoute: targetRoute,
      resourceId: _asString(map['resourceId']),
      infoExplanation: _asString(map['infoExplanation']),
      isProminent: _asBool(map['isProminent']),
    );
  }

  static AdaptiveFocusBannerViewData? _parseFocusBanner(dynamic value) {
    final map = _parseMap(value);
    if (map == null) return null;

    final message = _asString(map['message']);
    if (message == null || message.isEmpty) return null;

    return AdaptiveFocusBannerViewData(
      message: message,
      targetRoute: _asString(map['targetRoute']),
      ctaLabel: _asString(map['ctaLabel']),
    );
  }

  static List<SectionAdaptationViewData> _parseSectionAdaptations(
      dynamic value) {
    final list = _parseList(value);
    if (list.isEmpty) return [];

    const validSectionIds = {
      'recommended_actions',
      'today_cultivation',
      'production_summary',
      'today_tasks',
      'production',
      'modules',
      'health',
      'team',
      'agenda',
    };

    return list
        .map((e) {
          final map = _parseMap(e);
          if (map == null) return null;

          final sectionId = _asString(map['sectionId']);
          // API field is treatment, mapped to highlightType
          final treatment = _asString(map['treatment']);

          if (sectionId == null || !validSectionIds.contains(sectionId)) {
            return null;
          }

          final normalizedType = _normalizeHighlightType(treatment);
          if (normalizedType == null) return null;

          return SectionAdaptationViewData(
            sectionId: sectionId,
            highlightType: normalizedType,
            reason: _asString(map['reason']),
            label: _asString(map['label']),
          );
        })
        .whereType<SectionAdaptationViewData>()
        .toList();
  }

  static List<AdaptiveRecommendedActionViewData> _parseRecommendedActions(
      dynamic value) {
    final list = _parseList(value);
    if (list.isEmpty) return [];

    return list
        .map((e) {
          final map = _parseMap(e);
          if (map == null) return null;

          final label = _asString(map['label']);
          // API shortcuts don't have description; default to empty string
          final description = _asString(map['description']) ?? '';
          // API field is route, mapped to targetRoute
          final targetRoute = _asString(map['route']);

          if (label == null || targetRoute == null || targetRoute.isEmpty) {
            return null;
          }

          return AdaptiveRecommendedActionViewData(
            label: label,
            description: description,
            targetRoute: targetRoute,
            resourceId: _asString(map['resourceId']),
            confidence: _asDouble(map['confidence']),
            reason: _asString(map['reason']),
          );
        })
        .whereType<AdaptiveRecommendedActionViewData>()
        .toList();
  }

  static List<ActivityFeedItemViewData> _parseActivityFeed(dynamic value) {
    final list = _parseList(value);
    if (list.isEmpty) return [];

    return list
        .map((e) {
          final map = _parseMap(e);
          if (map == null) return null;

          final title = _asString(map['title']);
          final subtitle = _asString(map['subtitle']);
          final timestampStr = _asString(map['timestamp']);

          if (title == null || subtitle == null || timestampStr == null) {
            return null;
          }

          final timestamp = DateTime.tryParse(timestampStr);
          if (timestamp == null) return null;

          return ActivityFeedItemViewData(
            title: title,
            subtitle: subtitle,
            targetRoute: _asString(map['targetRoute']),
            timestamp: timestamp,
          );
        })
        .whereType<ActivityFeedItemViewData>()
        .toList();
  }

  static InfoRecommendationViewData? _parseInfoRecommendation(dynamic value) {
    final map = _parseMap(value);
    if (map == null) return null;

    final type = _asString(map['type']);
    final source = _asString(map['source']);
    final priority = _asString(map['priority']);
    final title = _asString(map['title']);
    final reason = _asString(map['reason']);
    final category = _asString(map['category']);

    if (type == null ||
        source == null ||
        priority == null ||
        title == null ||
        reason == null ||
        category == null) {
      return null;
    }

    return InfoRecommendationViewData(
      type: type,
      source: source,
      priority: priority,
      title: title,
      reason: reason,
      ctaRoute: _asString(map['ctaRoute']),
      category: category,
    );
  }

  static OperationalOnboardingViewData? _parseOperationalOnboarding(
      dynamic value) {
    final map = _parseMap(value);
    if (map == null) return null;

    final title = _asTrimmedString(map['title']);
    final message = _asTrimmedString(map['message']);
    final ctaLabel = _asTrimmedString(map['ctaLabel']);
    final targetRoute = _asTrimmedString(map['targetRoute']);

    if (title == null ||
        message == null ||
        ctaLabel == null ||
        targetRoute == null) {
      return null;
    }

    // targetRoute must be an internal route starting with '/'
    if (!targetRoute.startsWith('/')) return null;

    // Parse steps: trim, remove empty, limit to 5 valid items
    final steps = _parseOperationalOnboardingSteps(map['steps']);
    if (steps == null) return null;

    return OperationalOnboardingViewData(
      title: title,
      message: message,
      steps: steps,
      ctaLabel: ctaLabel,
      targetRoute: targetRoute,
      reason: _asTrimmedString(map['reason']),
      priority: _asNum(map['priority']),
    );
  }

  static List<String>? _parseOperationalOnboardingSteps(dynamic value) {
    final list = _parseList(value);
    if (list.isEmpty) return null;

    final steps = list
        .map((e) => e is String ? e.trim() : null)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .take(5)
        .toList();

    if (steps.isEmpty) return null;
    return steps;
  }

  static String? _asString(dynamic value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  static String? _asTrimmedString(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  static num? _asNum(dynamic value) {
    if (value is num) return value;
    return null;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return 0.0;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    return false;
  }

  static List<dynamic> _parseList(dynamic value) {
    if (value is List) return value;
    return [];
  }

  static Map<String, dynamic>? _parseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  static String? _parseReasonSummary(Map<String, dynamic>? data) {
    if (data == null) return null;
    // Prefer reasonDetails.summary, fall back to reason
    final reasonDetails = _parseMap(data['reasonDetails']);
    if (reasonDetails != null) {
      final summary = _asString(reasonDetails['summary']);
      if (summary != null) return summary;
    }
    return _asString(data['reason']);
  }

  static String? _normalizeHighlightType(String? type) {
    // Map API treatment values to internal highlightType values
    switch (type) {
      case 'prominent':
        return 'border';
      case 'highlight':
        return 'background';
      case 'replace':
        return 'badge';
      case 'none':
        return 'none';
      default:
        return null;
    }
  }
}
