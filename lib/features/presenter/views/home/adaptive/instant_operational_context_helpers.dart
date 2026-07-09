import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_info_context_model.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_next_activity.dart';

class InstantOperationalContextHelpers {
  static const int _listLimit = 5;
  static const int _shortTextLimit = 120;
  static const int _descriptionLimit = 180;

  static Map<String, dynamic> dashboardState(HomeDashboard? dashboard) {
    final resumo = dashboard?.resumo;
    return {
      'totalLots': resumo?.totalLotes ?? 0,
      'completionRate': resumo?.taxaConclusao ?? 0,
      'lotsByStatus': (resumo?.lotesPorStatus ?? [])
          .take(_listLimit)
          .map((item) => _withoutNulls({
                'status': _clean(item.status),
                'count': item.quantidade,
                'color': _clean(item.cor),
              }))
          .toList(),
      'speciesInProgress': (resumo?.especiesEmAndamento ?? [])
          .take(_listLimit)
          .map((item) => _clean(item.nome))
          .whereType<String>()
          .toList(),
    };
  }

  static Map<String, dynamic> agendaState(
    HomeDashboard? dashboard,
    NextActivity? nextActivity,
  ) {
    final tarefas = dashboard?.tarefas;
    return {
      'pendingActivitiesWeekCount': tarefas?.pendentesSemana ?? 0,
      'dueBuckets': _withoutNulls({
        'today': tarefas?.porVencimento?.hoje ?? tarefas?.pendentesHoje ?? 0,
        'thisWeek':
            tarefas?.porVencimento?.estaSemana ?? tarefas?.pendentesSemana ?? 0,
        'nextWeek': tarefas?.porVencimento?.proximaSemana ?? 0,
      }),
      'priorityBuckets': _withoutNulls({
        'high': tarefas?.porPrioridade?.alta ?? 0,
        'medium': tarefas?.porPrioridade?.media ?? 0,
        'low': tarefas?.porPrioridade?.baixa ?? 0,
      }),
      'latestTasks': (tarefas?.ultimasTarefas ?? [])
          .take(_listLimit)
          .map((task) => _withoutNulls({
                'id': task.id,
                'title': _clean(task.titulo),
                'status': task.vencida == true ? 'overdue' : 'pending',
                'dueLabel': _clean(task.data),
                'lotName': _clean(task.loteNome),
                'overdue': task.vencida ?? false,
              }))
          .toList(),
      if (nextActivity != null) 'nextActivity': nextActivity.toJson(),
    };
  }

  static NextActivity? nextActivity(HomeDashboard? dashboard) {
    final infoTask = dashboard?.infoContext?.todayCultivation?.nextTasks
            ?.where((task) => _clean(task.title) != null)
            .firstOrNull ??
        dashboard?.infoContext?.dayProgress?.nextTask;
    if (infoTask != null) {
      return NextActivity(
        id: infoTask.id,
        title: _clean(infoTask.title),
        description: _clean(infoTask.description, _descriptionLimit),
        type: _inferActivityType(infoTask.title),
        status: infoTask.overdue == true ? 'overdue' : 'pending',
        dueLabel: _clean(infoTask.date),
        lotId: infoTask.lotId,
        lotName: _clean(infoTask.lotName),
        overdue: infoTask.overdue ?? false,
      );
    }

    final task = dashboard?.tarefas?.ultimasTarefas
        ?.where((item) => _clean(item.titulo) != null)
        .firstOrNull;
    if (task == null) return null;

    return NextActivity(
      id: task.id,
      title: _clean(task.titulo),
      type: _inferActivityType(task.titulo),
      status: task.vencida == true ? 'overdue' : 'pending',
      dueLabel: _clean(task.data),
      lotName: _clean(task.loteNome),
      overdue: task.vencida ?? false,
    );
  }

  static Map<String, dynamic> productionState(HomeDashboard? dashboard) {
    final producao = dashboard?.producao;
    final monthly = producao?.producaoMensal ?? [];
    return {
      'upcomingHarvestLots': producao?.lotesComColheitaProxima ??
          dashboard?.resumo?.lotesComColheitaProxima ??
          0,
      if (_clean(producao?.periodoInicio) != null)
        'periodStart': utcIsoOrNull(producao?.periodoInicio),
      if (utcIsoOrNull(producao?.periodoFim) != null)
        'periodEnd': utcIsoOrNull(producao?.periodoFim),
      'monthlyProduction': monthly
          .take(_listLimit)
          .map((item) => _withoutNulls({
                'label': _clean(item.mes),
                'harvestedPlants': _count(item.quantidade),
                'producedPackages': 0,
                'month': _clean(item.mes),
                'quantity': _count(item.quantidade),
              }))
          .toList(),
      if (producao?.taxasMedia != null)
        'averageRates': _withoutNulls({
          'plants': producao?.taxasMedia?.taxaGlobal,
          'packages': producao?.taxasMedia?.taxaEmbalagem,
          'germination': producao?.taxasMedia?.taxaGerminacao,
          'transplant': producao?.taxasMedia?.taxaTransplantio,
          'packaging': producao?.taxasMedia?.taxaEmbalagem,
          'global': producao?.taxasMedia?.taxaGlobal,
        }),
      if (producao?.comparativoPeriodo != null)
        'periodComparison': _withoutNulls({
          'harvestedPlantsDelta': producao?.comparativoPeriodo?.plantasColhidas,
          'producedPackagesDelta': 0,
          'harvestedPlants': producao?.comparativoPeriodo?.plantasColhidas,
          'percentageVariation':
              producao?.comparativoPeriodo?.variacaoPercentual,
        }),
      if (producao?.culturaMaisProducao != null)
        'topCulture': _clean(producao?.culturaMaisProducao?.nome),
      if (producao?.culturaMaisProducao != null)
        'topCultureDetails': _withoutNulls({
          'name': _clean(producao?.culturaMaisProducao?.nome),
          'quantity': producao?.culturaMaisProducao?.quantidade,
          'percentageOfTotal': producao?.culturaMaisProducao?.percentualDoTotal,
        }),
    };
  }

  static Map<String, dynamic> cultivationState(HomeDashboard? dashboard) {
    final cultures = dashboard?.culturas ?? [];
    final dominant = cultures.isEmpty
        ? null
        : cultures.reduce(
            (a, b) => (a.quantidade ?? 0) >= (b.quantidade ?? 0) ? a : b);
    return {
      'cultures': cultures
          .take(_listLimit)
          .map((culture) => _withoutNulls({
                'name': _clean(culture.nome),
                'quantity': culture.quantidade,
                'color': _clean(culture.cor),
              }))
          .toList(),
      if (dominant != null) 'dominantCulture': _clean(dominant.nome),
      if (dominant != null)
        'dominantCultureDetails': _withoutNulls({
          'name': _clean(dominant.nome),
          'quantity': dominant.quantidade,
          'color': _clean(dominant.cor),
        }),
      'speciesInProgress': (dashboard?.resumo?.especiesEmAndamento ?? [])
          .take(_listLimit)
          .map((item) => _clean(item.nome))
          .whereType<String>()
          .toList(),
    };
  }

  static Map<String, dynamic> teamState(HomeDashboard? dashboard) {
    final equipe = dashboard?.equipe;
    return _withoutNulls({
      'activeMembers': equipe?.membrosAtivos ?? 0,
      'averageCompletionRate': equipe?.taxaConclusaoMedia ?? 0,
      'onTimeActivities': equipe?.atividadesNoPrazo ?? 0,
      'overdueActivities': equipe?.atividadesVencidas ?? 0,
    });
  }

  static List<Map<String, dynamic>> alertItems(List<HomeAlertaCritico> alerts) {
    return alerts
        .take(_listLimit)
        .map((alert) => _withoutNulls({
              'type': _clean(alert.tipo),
              'message': _clean(alert.mensagem, _descriptionLimit),
              'lotId': alert.loteId,
              'lotName': _clean(alert.loteNome),
              'severity': _clean(alert.gravidade),
              'date': utcIsoOrNull(alert.data),
            }))
        .toList();
  }

  static Map<String, dynamic> reservoirState(HomeDashboard? dashboard) {
    final report = dashboard?.infoContext?.reservoirReport;
    return {
      'totalCount': report?.totalReservoirs ?? 0,
      'totalVolume': report?.totalVolume ?? 0,
      'withSolutionCount': report?.reservoirsWithSolution ?? 0,
      'withoutSolutionCount': report?.reservoirsWithoutSolution ?? 0,
      'activeLotsLinked': report?.activeLotsLinked ?? 0,
      'highlightedReservoirs': (report?.highlightedReservoirs ?? [])
          .take(_listLimit)
          .map((reservoir) => _withoutNulls({
                'id': reservoir.id,
                'name': _clean(reservoir.name),
                'volume': reservoir.volume,
                'solutionName': _clean(reservoir.solutionName),
                'electricalConductivity': reservoir.electricalConductivity,
                'linkedLotsCount': reservoir.linkedLotsCount,
              }))
          .toList(),
    };
  }

  static Map<String, dynamic> fieldNotebookState(HomeDashboard? dashboard) {
    final summary = dashboard?.infoContext?.fieldNotesSummary;
    final notes = summary?.latestNotes ?? [];
    final latest =
        notes.where((note) => _clean(note.title) != null).firstOrNull;
    return {
      'totalRecentNotes': summary?.totalRecentNotes ?? 0,
      if (latest != null) 'latestRecordType': _inferRecordType(latest),
      'latestNotes': notes
          .take(_listLimit)
          .map((note) => _withoutNulls({
                'id': note.id,
                'title': _clean(note.title),
                'description': _clean(note.description, _descriptionLimit),
                'lotId': note.lotId,
                'lotName': _clean(note.lotName),
                'createdAt': utcIsoOrNull(note.createdAt),
              }))
          .toList(),
      'sowingNotePresent': notes.any(_isSowingNote),
    };
  }

  static String utcIso(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final milliseconds = utc.millisecond.toString().padLeft(3, '0');
    final year = utc.year.toString().padLeft(4, '0');
    final month = utc.month.toString().padLeft(2, '0');
    final day = utc.day.toString().padLeft(2, '0');
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');
    final second = utc.second.toString().padLeft(2, '0');

    return '$year-$month-${day}T$hour:$minute:$second.${milliseconds}Z';
  }

  static String? utcIsoOrNull(String? value) {
    final text = _clean(value);
    if (text == null) return null;

    final parsed = DateTime.tryParse(text);
    if (parsed == null) return null;

    return utcIso(parsed);
  }

  static String? cleanText(String? value, [int limit = _shortTextLimit]) {
    return _clean(value, limit);
  }

  static String? _inferActivityType(String? title) {
    final normalized = _normalize(title);
    if (normalized.contains('ajuste') || normalized.contains('nutri')) {
      return 'nutritional_adjustment';
    }
    if (normalized.contains('seme')) return 'protocol_activity';
    if (normalized.contains('colhe')) return 'harvest';
    if (normalized.contains('irriga')) return 'irrigation';
    if (normalized.contains('inspec') || normalized.contains('verific')) {
      return 'inspection';
    }
    if (normalized.contains('tarefa') || normalized.contains('agenda')) {
      return 'inspection';
    }
    return normalized.isEmpty ? null : 'inspection';
  }

  static String? _inferRecordType(HomeFieldNoteInfo note) {
    if (_isSowingNote(note)) return 'sowing';
    final normalized =
        _normalize('${note.title ?? ''} ${note.description ?? ''}');
    if (normalized.contains('ajuste') || normalized.contains('nutri')) {
      return 'nutritional_adjustment';
    }
    if (normalized.contains('colhe')) return 'harvest';
    return normalized.isEmpty ? null : 'field_note';
  }

  static bool _isSowingNote(HomeFieldNoteInfo note) {
    return _normalize('${note.title ?? ''} ${note.description ?? ''}')
        .contains('seme');
  }

  static String _normalize(String? value) {
    return (value ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  static String? _clean(String? value, [int limit = _shortTextLimit]) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    if (text.length <= limit) return text;
    return text.substring(0, limit);
  }

  static Map<String, dynamic> _withoutNulls(Map<String, dynamic> map) {
    return Map.fromEntries(map.entries.where((entry) => entry.value != null));
  }

  static int? _count(num? value) {
    if (value == null || value < 0) return null;
    return value.round();
  }
}
