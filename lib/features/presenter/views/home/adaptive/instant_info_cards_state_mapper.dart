import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_info_context_model.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_operational_context_helpers.dart';

class InstantInfoCardsStateMapper {
  static const int _listLimit = 5;
  static const int _descriptionLimit = 180;

  static Map<String, dynamic> map(HomeInfoContext? infoContext) {
    return _withoutNulls({
      if (infoContext?.todayCultivation != null)
        'todayCultivation': _todayCultivation(infoContext!.todayCultivation!),
      if (infoContext?.reservoirReport != null)
        'reservoirReport': InstantOperationalContextHelpers.reservoirState(
          HomeDashboard(infoContext: infoContext),
        ),
      if (infoContext?.dayProgress != null)
        'dayProgress': _dayProgress(infoContext!.dayProgress!),
      if (infoContext?.fieldNotesSummary != null)
        'fieldNotesSummary':
            InstantOperationalContextHelpers.fieldNotebookState(
          HomeDashboard(infoContext: infoContext),
        ),
    });
  }

  static Map<String, dynamic> _todayCultivation(HomeTodayCultivationInfo info) {
    return {
      'pendingToday': info.tasksToday ?? 0,
      'overdue': info.overdueTasks ?? 0,
      'tasksToday': info.tasksToday ?? 0,
      'overdueTasks': info.overdueTasks ?? 0,
      'activeLots': info.activeLots ?? 0,
      'upcomingHarvests': info.upcomingHarvests ?? 0,
      'alerts': info.alerts?.length ?? 0,
      'alertItems': (info.alerts ?? [])
          .take(_listLimit)
          .map((alert) => _withoutNulls({
                'type': _clean(alert.type),
                'message': _clean(alert.message, _descriptionLimit),
                'lotId': alert.lotId,
                'lotName': _clean(alert.lotName),
                'severity': _clean(alert.severity),
                'date': InstantOperationalContextHelpers.utcIsoOrNull(
                  alert.date,
                ),
              }))
          .toList(),
      'nextTasks': (info.nextTasks ?? [])
          .take(_listLimit)
          .map((task) => _withoutNulls({
                'id': task.id,
                'title': _clean(task.title),
                'description': _clean(task.description, _descriptionLimit),
                'lotId': task.lotId,
                'lotName': _clean(task.lotName),
                'date': InstantOperationalContextHelpers.utcIsoOrNull(
                  task.date,
                ),
                'overdue': task.overdue ?? false,
              }))
          .toList(),
    };
  }

  static Map<String, dynamic> _dayProgress(HomeDayProgressInfo info) {
    return _withoutNulls({
      'total': info.totalTasksToday ?? 0,
      'completed': info.completedTasksToday ?? 0,
      'pending': info.pendingTasksToday ?? 0,
      'overdue': info.overdueTasks ?? 0,
      'label': _clean(info.completionLabel),
      'totalTasksToday': info.totalTasksToday ?? 0,
      'completedTasksToday': info.completedTasksToday ?? 0,
      'pendingTasksToday': info.pendingTasksToday ?? 0,
      'overdueTasks': info.overdueTasks ?? 0,
      'completionLabel': _clean(info.completionLabel),
      if (info.nextTask != null)
        'nextTask': _withoutNulls({
          'id': info.nextTask?.id,
          'title': _clean(info.nextTask?.title),
          'description': _clean(info.nextTask?.description, _descriptionLimit),
          'lotId': info.nextTask?.lotId,
          'lotName': _clean(info.nextTask?.lotName),
          'date': _clean(info.nextTask?.date),
          'overdue': info.nextTask?.overdue ?? false,
        }),
    });
  }

  static String? _clean(String? value, [int limit = 120]) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    if (text.length <= limit) return text;
    return text.substring(0, limit);
  }

  static Map<String, dynamic> _withoutNulls(Map<String, dynamic> map) {
    return Map.fromEntries(map.entries.where((entry) => entry.value != null));
  }
}
