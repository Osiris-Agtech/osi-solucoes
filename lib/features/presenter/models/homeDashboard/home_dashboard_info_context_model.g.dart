// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_info_context_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfoContext _$HomeInfoContextFromJson(Map<String, dynamic> json) =>
    HomeInfoContext(
      todayCultivation: json['todayCultivation'] == null
          ? null
          : HomeTodayCultivationInfo.fromJson(
              json['todayCultivation'] as Map<String, dynamic>),
      reservoirReport: json['reservoirReport'] == null
          ? null
          : HomeReservoirReportInfo.fromJson(
              json['reservoirReport'] as Map<String, dynamic>),
      dayProgress: json['dayProgress'] == null
          ? null
          : HomeDayProgressInfo.fromJson(
              json['dayProgress'] as Map<String, dynamic>),
      fieldNotesSummary: json['fieldNotesSummary'] == null
          ? null
          : HomeFieldNotesSummaryInfo.fromJson(
              json['fieldNotesSummary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeInfoContextToJson(HomeInfoContext instance) =>
    <String, dynamic>{
      'todayCultivation': instance.todayCultivation?.toJson(),
      'reservoirReport': instance.reservoirReport?.toJson(),
      'dayProgress': instance.dayProgress?.toJson(),
      'fieldNotesSummary': instance.fieldNotesSummary?.toJson(),
    };

HomeTodayCultivationInfo _$HomeTodayCultivationInfoFromJson(
        Map<String, dynamic> json) =>
    HomeTodayCultivationInfo(
      tasksToday: (json['tasksToday'] as num?)?.toInt(),
      overdueTasks: (json['overdueTasks'] as num?)?.toInt(),
      activeLots: (json['activeLots'] as num?)?.toInt(),
      upcomingHarvests: (json['upcomingHarvests'] as num?)?.toInt(),
      alerts: (json['alerts'] as List<dynamic>?)
          ?.map((e) => HomeInfoAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextTasks: (json['nextTasks'] as List<dynamic>?)
          ?.map((e) => HomeInfoTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeTodayCultivationInfoToJson(
        HomeTodayCultivationInfo instance) =>
    <String, dynamic>{
      'tasksToday': instance.tasksToday,
      'overdueTasks': instance.overdueTasks,
      'activeLots': instance.activeLots,
      'upcomingHarvests': instance.upcomingHarvests,
      'alerts': instance.alerts,
      'nextTasks': instance.nextTasks,
    };

HomeInfoAlert _$HomeInfoAlertFromJson(Map<String, dynamic> json) =>
    HomeInfoAlert(
      type: json['type'] as String?,
      message: json['message'] as String?,
      lotId: (json['lotId'] as num?)?.toInt(),
      lotName: json['lotName'] as String?,
      severity: json['severity'] as String?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$HomeInfoAlertToJson(HomeInfoAlert instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'lotId': instance.lotId,
      'lotName': instance.lotName,
      'severity': instance.severity,
      'date': instance.date,
    };

HomeInfoTask _$HomeInfoTaskFromJson(Map<String, dynamic> json) => HomeInfoTask(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      lotId: (json['lotId'] as num?)?.toInt(),
      lotName: json['lotName'] as String?,
      date: json['date'] as String?,
      overdue: json['overdue'] as bool?,
    );

Map<String, dynamic> _$HomeInfoTaskToJson(HomeInfoTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'lotId': instance.lotId,
      'lotName': instance.lotName,
      'date': instance.date,
      'overdue': instance.overdue,
    };

HomeReservoirReportInfo _$HomeReservoirReportInfoFromJson(
        Map<String, dynamic> json) =>
    HomeReservoirReportInfo(
      totalReservoirs: (json['totalReservoirs'] as num?)?.toInt(),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      reservoirsWithSolution: (json['reservoirsWithSolution'] as num?)?.toInt(),
      reservoirsWithoutSolution:
          (json['reservoirsWithoutSolution'] as num?)?.toInt(),
      activeLotsLinked: (json['activeLotsLinked'] as num?)?.toInt(),
      highlightedReservoirs: (json['highlightedReservoirs'] as List<dynamic>?)
          ?.map((e) =>
              HomeHighlightedReservoir.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeReservoirReportInfoToJson(
        HomeReservoirReportInfo instance) =>
    <String, dynamic>{
      'totalReservoirs': instance.totalReservoirs,
      'totalVolume': instance.totalVolume,
      'reservoirsWithSolution': instance.reservoirsWithSolution,
      'reservoirsWithoutSolution': instance.reservoirsWithoutSolution,
      'activeLotsLinked': instance.activeLotsLinked,
      'highlightedReservoirs': instance.highlightedReservoirs,
    };

HomeHighlightedReservoir _$HomeHighlightedReservoirFromJson(
        Map<String, dynamic> json) =>
    HomeHighlightedReservoir(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      volume: (json['volume'] as num?)?.toDouble(),
      solutionName: json['solutionName'] as String?,
      electricalConductivity:
          (json['electricalConductivity'] as num?)?.toDouble(),
      linkedLotsCount: (json['linkedLotsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeHighlightedReservoirToJson(
        HomeHighlightedReservoir instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'volume': instance.volume,
      'solutionName': instance.solutionName,
      'electricalConductivity': instance.electricalConductivity,
      'linkedLotsCount': instance.linkedLotsCount,
    };

HomeDayProgressInfo _$HomeDayProgressInfoFromJson(Map<String, dynamic> json) =>
    HomeDayProgressInfo(
      totalTasksToday: (json['totalTasksToday'] as num?)?.toInt(),
      completedTasksToday: (json['completedTasksToday'] as num?)?.toInt(),
      pendingTasksToday: (json['pendingTasksToday'] as num?)?.toInt(),
      overdueTasks: (json['overdueTasks'] as num?)?.toInt(),
      completionLabel: json['completionLabel'] as String?,
      nextTask: json['nextTask'] == null
          ? null
          : HomeInfoTask.fromJson(json['nextTask'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeDayProgressInfoToJson(
        HomeDayProgressInfo instance) =>
    <String, dynamic>{
      'totalTasksToday': instance.totalTasksToday,
      'completedTasksToday': instance.completedTasksToday,
      'pendingTasksToday': instance.pendingTasksToday,
      'overdueTasks': instance.overdueTasks,
      'completionLabel': instance.completionLabel,
      'nextTask': instance.nextTask,
    };

HomeFieldNotesSummaryInfo _$HomeFieldNotesSummaryInfoFromJson(
        Map<String, dynamic> json) =>
    HomeFieldNotesSummaryInfo(
      totalRecentNotes: (json['totalRecentNotes'] as num?)?.toInt(),
      latestNotes: (json['latestNotes'] as List<dynamic>?)
          ?.map((e) => HomeFieldNoteInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeFieldNotesSummaryInfoToJson(
        HomeFieldNotesSummaryInfo instance) =>
    <String, dynamic>{
      'totalRecentNotes': instance.totalRecentNotes,
      'latestNotes': instance.latestNotes,
    };

HomeFieldNoteInfo _$HomeFieldNoteInfoFromJson(Map<String, dynamic> json) =>
    HomeFieldNoteInfo(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      lotId: (json['lotId'] as num?)?.toInt(),
      lotName: json['lotName'] as String?,
      userName: json['userName'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$HomeFieldNoteInfoToJson(HomeFieldNoteInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'lotId': instance.lotId,
      'lotName': instance.lotName,
      'userName': instance.userName,
      'createdAt': instance.createdAt,
    };
