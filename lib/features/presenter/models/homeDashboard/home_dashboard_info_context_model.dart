// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'home_dashboard_info_context_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeInfoContext {
  @JsonKey(required: false, disallowNullValue: false)
  HomeTodayCultivationInfo? todayCultivation;

  @JsonKey(required: false, disallowNullValue: false)
  HomeReservoirReportInfo? reservoirReport;

  @JsonKey(required: false, disallowNullValue: false)
  HomeDayProgressInfo? dayProgress;

  @JsonKey(required: false, disallowNullValue: false)
  HomeFieldNotesSummaryInfo? fieldNotesSummary;

  HomeInfoContext({
    this.todayCultivation,
    this.reservoirReport,
    this.dayProgress,
    this.fieldNotesSummary,
  });

  factory HomeInfoContext.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoContextFromJson(json);

  Map<String, dynamic> toJson() => _$HomeInfoContextToJson(this);
}

@JsonSerializable()
class HomeTodayCultivationInfo {
  @JsonKey(required: false, disallowNullValue: false)
  int? tasksToday;

  @JsonKey(required: false, disallowNullValue: false)
  int? overdueTasks;

  @JsonKey(required: false, disallowNullValue: false)
  int? activeLots;

  @JsonKey(required: false, disallowNullValue: false)
  int? upcomingHarvests;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeInfoAlert>? alerts;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeInfoTask>? nextTasks;

  HomeTodayCultivationInfo({
    this.tasksToday,
    this.overdueTasks,
    this.activeLots,
    this.upcomingHarvests,
    this.alerts,
    this.nextTasks,
  });

  factory HomeTodayCultivationInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeTodayCultivationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTodayCultivationInfoToJson(this);
}

@JsonSerializable()
class HomeInfoAlert {
  @JsonKey(required: false, disallowNullValue: false)
  String? type;

  @JsonKey(required: false, disallowNullValue: false)
  String? message;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotId;

  @JsonKey(required: false, disallowNullValue: false)
  String? lotName;

  @JsonKey(required: false, disallowNullValue: false)
  String? severity;

  @JsonKey(required: false, disallowNullValue: false)
  String? date;

  HomeInfoAlert({
    this.type,
    this.message,
    this.lotId,
    this.lotName,
    this.severity,
    this.date,
  });

  factory HomeInfoAlert.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoAlertFromJson(json);

  Map<String, dynamic> toJson() => _$HomeInfoAlertToJson(this);
}

@JsonSerializable()
class HomeInfoTask {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? title;

  @JsonKey(required: false, disallowNullValue: false)
  String? description;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotId;

  @JsonKey(required: false, disallowNullValue: false)
  String? lotName;

  @JsonKey(required: false, disallowNullValue: false)
  String? date;

  @JsonKey(required: false, disallowNullValue: false)
  bool? overdue;

  HomeInfoTask({
    this.id,
    this.title,
    this.description,
    this.lotId,
    this.lotName,
    this.date,
    this.overdue,
  });

  factory HomeInfoTask.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoTaskFromJson(json);

  Map<String, dynamic> toJson() => _$HomeInfoTaskToJson(this);
}

@JsonSerializable()
class HomeReservoirReportInfo {
  @JsonKey(required: false, disallowNullValue: false)
  int? totalReservoirs;

  @JsonKey(required: false, disallowNullValue: false)
  double? totalVolume;

  @JsonKey(required: false, disallowNullValue: false)
  int? reservoirsWithSolution;

  @JsonKey(required: false, disallowNullValue: false)
  int? reservoirsWithoutSolution;

  @JsonKey(required: false, disallowNullValue: false)
  int? activeLotsLinked;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeHighlightedReservoir>? highlightedReservoirs;

  HomeReservoirReportInfo({
    this.totalReservoirs,
    this.totalVolume,
    this.reservoirsWithSolution,
    this.reservoirsWithoutSolution,
    this.activeLotsLinked,
    this.highlightedReservoirs,
  });

  factory HomeReservoirReportInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeReservoirReportInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeReservoirReportInfoToJson(this);
}

@JsonSerializable()
class HomeHighlightedReservoir {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? name;

  @JsonKey(required: false, disallowNullValue: false)
  double? volume;

  @JsonKey(required: false, disallowNullValue: false)
  String? solutionName;

  @JsonKey(required: false, disallowNullValue: false)
  double? electricalConductivity;

  @JsonKey(required: false, disallowNullValue: false)
  int? linkedLotsCount;

  HomeHighlightedReservoir({
    this.id,
    this.name,
    this.volume,
    this.solutionName,
    this.electricalConductivity,
    this.linkedLotsCount,
  });

  factory HomeHighlightedReservoir.fromJson(Map<String, dynamic> json) =>
      _$HomeHighlightedReservoirFromJson(json);

  Map<String, dynamic> toJson() => _$HomeHighlightedReservoirToJson(this);
}

@JsonSerializable()
class HomeDayProgressInfo {
  @JsonKey(required: false, disallowNullValue: false)
  int? totalTasksToday;

  @JsonKey(required: false, disallowNullValue: false)
  int? completedTasksToday;

  @JsonKey(required: false, disallowNullValue: false)
  int? pendingTasksToday;

  @JsonKey(required: false, disallowNullValue: false)
  int? overdueTasks;

  @JsonKey(required: false, disallowNullValue: false)
  String? completionLabel;

  @JsonKey(required: false, disallowNullValue: false)
  HomeInfoTask? nextTask;

  HomeDayProgressInfo({
    this.totalTasksToday,
    this.completedTasksToday,
    this.pendingTasksToday,
    this.overdueTasks,
    this.completionLabel,
    this.nextTask,
  });

  factory HomeDayProgressInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeDayProgressInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDayProgressInfoToJson(this);
}

@JsonSerializable()
class HomeFieldNotesSummaryInfo {
  @JsonKey(required: false, disallowNullValue: false)
  int? totalRecentNotes;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeFieldNoteInfo>? latestNotes;

  HomeFieldNotesSummaryInfo({
    this.totalRecentNotes,
    this.latestNotes,
  });

  factory HomeFieldNotesSummaryInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeFieldNotesSummaryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFieldNotesSummaryInfoToJson(this);
}

@JsonSerializable()
class HomeFieldNoteInfo {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? title;

  @JsonKey(required: false, disallowNullValue: false)
  String? description;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotId;

  @JsonKey(required: false, disallowNullValue: false)
  String? lotName;

  @JsonKey(required: false, disallowNullValue: false)
  String? userName;

  @JsonKey(required: false, disallowNullValue: false)
  String? createdAt;

  HomeFieldNoteInfo({
    this.id,
    this.title,
    this.description,
    this.lotId,
    this.lotName,
    this.userName,
    this.createdAt,
  });

  factory HomeFieldNoteInfo.fromJson(Map<String, dynamic> json) =>
      _$HomeFieldNoteInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFieldNoteInfoToJson(this);
}
