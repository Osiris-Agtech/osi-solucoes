import 'package:flutter/material.dart';

enum HomePanelTone { neutral, primary, success, warning, danger }

enum HomeAdaptationMode { static, instant, gradual }

enum HomeAdaptationSource { adaptive, system, fallback, insufficientData }

enum HomeAdaptationStrength { none, weak, moderate, strong }

enum HomeAdaptationFocus { tarefas, lotes, producao, saude }

class HomeAdaptationViewData {
  final HomeAdaptationMode mode;
  final double confidence;
  final HomeAdaptationStrength strength;
  final HomeAdaptationSource source;
  final String? reason;
  final bool isTemporary;
  final HomeAdaptationFocus? highlightedFocus;
  final String? label;

  const HomeAdaptationViewData({
    required this.mode,
    required this.confidence,
    required this.strength,
    required this.source,
    required this.reason,
    required this.isTemporary,
    required this.highlightedFocus,
    required this.label,
  });

  static const none = HomeAdaptationViewData(
    mode: HomeAdaptationMode.gradual,
    confidence: 0,
    strength: HomeAdaptationStrength.none,
    source: HomeAdaptationSource.system,
    reason: null,
    isTemporary: false,
    highlightedFocus: null,
    label: null,
  );

  bool get hasHighlight =>
      highlightedFocus != null && strength != HomeAdaptationStrength.none;
}

class HomePanelViewData {
  final HomeHeaderViewData header;
  final TodayCultivationViewData today;
  final List<RecommendedActionViewData> actions;
  final ProductionSummaryViewData production;
  final List<HomeModuleShortcutViewData> modules;
  final bool hasDashboardSupport;
  final HomeAdaptationViewData adaptation;

  const HomePanelViewData({
    required this.header,
    required this.today,
    required this.actions,
    required this.production,
    required this.modules,
    required this.hasDashboardSupport,
    required this.adaptation,
  });

  bool get isEmpty =>
      today.isEmpty && production.isEmpty && actions.isEmpty && modules.isEmpty;
}

class HomeHeaderViewData {
  final String greeting;
  final String accountContext;
  final String roleLabel;
  final bool canOpenTasks;
  final bool canSwitchAccount;

  const HomeHeaderViewData({
    required this.greeting,
    required this.accountContext,
    required this.roleLabel,
    required this.canOpenTasks,
    required this.canSwitchAccount,
  });
}

class TodayCultivationViewData {
  final int tasksToday;
  final int overdueTasks;
  final int activeLots;
  final int upcomingHarvests;
  final List<HomePanelListItemViewData> tasks;
  final List<HomePanelListItemViewData> criticalAlerts;
  final HomeAdaptationViewData adaptation;
  final HomeAdaptationFocus? highlightedMetric;

  const TodayCultivationViewData({
    required this.tasksToday,
    required this.overdueTasks,
    required this.activeLots,
    required this.upcomingHarvests,
    required this.tasks,
    required this.criticalAlerts,
    required this.adaptation,
    required this.highlightedMetric,
  });

  bool get isEmpty =>
      tasksToday == 0 &&
      overdueTasks == 0 &&
      activeLots == 0 &&
      upcomingHarvests == 0 &&
      tasks.isEmpty &&
      criticalAlerts.isEmpty;
}

class HomePanelListItemViewData {
  final String title;
  final String description;
  final HomePanelTone tone;
  final IconData icon;

  const HomePanelListItemViewData({
    required this.title,
    required this.description,
    required this.tone,
    required this.icon,
  });
}

class RecommendedActionViewData {
  final String label;
  final String description;
  final String route;
  final String iconAsset;
  final Color color;
  final bool isAdaptive;
  final double confidence;
  final String? resourceId;
  final String? resourceType;
  final String? resourceName;

  const RecommendedActionViewData({
    required this.label,
    required this.description,
    required this.route,
    required this.iconAsset,
    required this.color,
    required this.isAdaptive,
    required this.confidence,
    this.resourceId,
    this.resourceType,
    this.resourceName,
  });
}

class ProductionSummaryViewData {
  final String metricLabel;
  final String metricValue;
  final String trendLabel;
  final String periodLabel;
  final String? reportRoute;
  final HomeAdaptationViewData adaptation;

  const ProductionSummaryViewData({
    required this.metricLabel,
    required this.metricValue,
    required this.trendLabel,
    required this.periodLabel,
    required this.reportRoute,
    required this.adaptation,
  });

  bool get isEmpty => metricValue == '0' && trendLabel.isEmpty;
}

class HomeModuleShortcutViewData {
  final String label;
  final String description;
  final String iconAsset;
  final Color color;
  final String? route;

  const HomeModuleShortcutViewData({
    required this.label,
    required this.description,
    required this.iconAsset,
    required this.color,
    this.route,
  });
}
