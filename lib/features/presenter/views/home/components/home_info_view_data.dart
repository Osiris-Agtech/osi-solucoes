enum HomeInfoType {
  todayCultivation,
  reservoirReport,
  dayProgress,
  fieldNotesSummary,
  basicTip,
}

enum HomeInfoMetricTone { neutral, positive, warning, danger }

enum HomeInfoItemTone { neutral, warning, danger }

class HomeInfoViewData {
  final HomeInfoType type;
  final String title;
  final String? subtitle;
  final List<HomeInfoMetric> metrics;
  final List<HomeInfoListItem> items;
  final String? ctaLabel;
  final String? ctaRoute;
  final String? sourceCategory;
  final String? tipText;

  const HomeInfoViewData({
    required this.type,
    required this.title,
    this.subtitle,
    this.metrics = const [],
    this.items = const [],
    this.ctaLabel,
    this.ctaRoute,
    this.sourceCategory,
    this.tipText,
  });

  bool get isEmpty =>
      metrics.isEmpty && items.isEmpty && tipText == null;
}

class HomeInfoMetric {
  final String label;
  final String value;
  final HomeInfoMetricTone tone;

  const HomeInfoMetric({
    required this.label,
    required this.value,
    this.tone = HomeInfoMetricTone.neutral,
  });
}

class HomeInfoListItem {
  final String title;
  final String? subtitle;
  final String? lotName;
  final String? date;
  final String? userName;
  final HomeInfoItemTone tone;

  const HomeInfoListItem({
    required this.title,
    this.subtitle,
    this.lotName,
    this.date,
    this.userName,
    this.tone = HomeInfoItemTone.neutral,
  });
}
