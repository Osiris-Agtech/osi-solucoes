import 'package:osi_solucoes/core/utils/atividade_descricao_codec.dart';
import 'package:osi_solucoes/core/utils/date_only_display_formatter.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_info_context_model.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'home_info_view_data.dart';
import 'home_info_data_source.dart';

class HomeInfoMapper {
  static HomeInfoViewData resolve({
    required HomeInfoContext? infoContext,
    required InfoRecommendationViewData? infoRecommendation,
    required String adaptiveMode,
  }) {
    // INSTANT mode: follow recommendation
    if (adaptiveMode == 'INSTANT' && infoRecommendation != null) {
      final result =
          _resolveFromRecommendation(infoContext, infoRecommendation);
      if (result != null) return result;

      // Fallback chain
      final fallback = _resolveFallback(infoContext);
      if (fallback != null) return fallback;
    }

    // STATIC mode or no recommendation/fallback
    return _basicTip(infoRecommendation?.category);
  }

  static HomeInfoViewData? _resolveFromRecommendation(
    HomeInfoContext? infoContext,
    InfoRecommendationViewData recommendation,
  ) {
    switch (recommendation.type) {
      case 'today_cultivation':
        final today = infoContext?.todayCultivation;
        if (today == null) return null;
        if ((today.tasksToday ?? 0) == 0 &&
            (today.overdueTasks ?? 0) == 0 &&
            (today.activeLots ?? 0) == 0 &&
            (today.alerts == null || today.alerts!.isEmpty) &&
            (today.nextTasks == null || today.nextTasks!.isEmpty)) {
          return null;
        }
        return _mapTodayCultivation(today, infoContext?.dayProgress, recommendation);

      case 'reservoir_report':
        final reservoir = infoContext?.reservoirReport;
        if (reservoir == null) return null;
        if ((reservoir.totalReservoirs ?? 0) == 0) return null;
        return _mapReservoirReport(reservoir, recommendation);

      case 'day_progress':
        // Redirect: day_progress data is injected as completion chip
        // inside today_cultivation card instead of rendering a separate card.
        final today = infoContext?.todayCultivation;
        final progress = infoContext?.dayProgress;
        if (today != null &&
            ((today.tasksToday ?? 0) > 0 ||
                (today.overdueTasks ?? 0) > 0 ||
                (today.activeLots ?? 0) > 0 ||
                (today.nextTasks != null && today.nextTasks!.isNotEmpty) ||
                (today.alerts != null && today.alerts!.isNotEmpty))) {
          return _mapTodayCultivation(today, progress, recommendation);
        }
        // Fallback: build minimal todayCultivation from dayProgress alone
        if (progress != null && (progress.totalTasksToday ?? 0) > 0) {
          final minimalToday = HomeTodayCultivationInfo(
            tasksToday: progress.totalTasksToday,
            overdueTasks: progress.overdueTasks,
          );
          return _mapTodayCultivation(minimalToday, progress, recommendation);
        }
        return null;

      case 'field_notes_summary':
        final notes = infoContext?.fieldNotesSummary;
        if (notes == null) return null;
        if ((notes.totalRecentNotes ?? 0) == 0) return null;
        return _mapFieldNotesSummary(notes, recommendation);

      case 'basic_tip':
        return _basicTip(recommendation.category);

      default:
        return null;
    }
  }

  static HomeInfoViewData? _resolveFallback(HomeInfoContext? infoContext) {
    if (infoContext == null) return null;

    // Try today_cultivation first (now includes completion progress)
    final today = infoContext.todayCultivation;
    if (today != null &&
        ((today.tasksToday ?? 0) > 0 ||
            (today.overdueTasks ?? 0) > 0 ||
            (today.activeLots ?? 0) > 0 ||
            (today.nextTasks != null && today.nextTasks!.isNotEmpty) ||
            (today.alerts != null && today.alerts!.isNotEmpty))) {
      return _mapTodayCultivation(today, infoContext.dayProgress, null);
    }

    // Try reservoir_report
    final reservoir = infoContext.reservoirReport;
    if (reservoir != null && (reservoir.totalReservoirs ?? 0) > 0) {
      return _mapReservoirReport(reservoir, null);
    }

    // Try field_notes_summary
    final notes = infoContext.fieldNotesSummary;
    if (notes != null && (notes.totalRecentNotes ?? 0) > 0) {
      return _mapFieldNotesSummary(notes, null);
    }

    return null;
  }

  static HomeInfoViewData _mapTodayCultivation(
    HomeTodayCultivationInfo today,
    HomeDayProgressInfo? progress,
    InfoRecommendationViewData? rec,
  ) {
    final metrics = <HomeInfoMetric>[
      // Completion chip injected from dayProgress data (if available)
      if (progress != null &&
          (progress.totalTasksToday ?? 0) > 0 &&
          (progress.completedTasksToday ?? 0) >= 0)
        HomeInfoMetric(
          label: 'Concluídas',
          value:
              '${progress.completedTasksToday ?? 0}/${progress.totalTasksToday ?? 0}',
          tone: _completionTone(
              progress.completedTasksToday ?? 0, progress.totalTasksToday ?? 0),
        ),
      if ((today.tasksToday ?? 0) > 0)
        HomeInfoMetric(
          label: 'Tarefas hoje',
          value: '${today.tasksToday}',
          tone: HomeInfoMetricTone.positive,
        ),
      if ((today.overdueTasks ?? 0) > 0)
        HomeInfoMetric(
          label: 'Atrasadas',
          value: '${today.overdueTasks}',
          tone: HomeInfoMetricTone.danger,
        ),
      if ((today.activeLots ?? 0) > 0)
        HomeInfoMetric(
          label: 'Lotes ativos',
          value: '${today.activeLots}',
          tone: HomeInfoMetricTone.neutral,
        ),
      if ((today.upcomingHarvests ?? 0) > 0)
        HomeInfoMetric(
          label: 'Colheitas próximas',
          value: '${today.upcomingHarvests}',
          tone: HomeInfoMetricTone.warning,
        ),
    ];

    final items = <HomeInfoListItem>[];
    if (today.nextTasks != null) {
      for (final task in today.nextTasks!.take(2)) {
        items.add(HomeInfoListItem(
          title: task.title ?? 'Tarefa',
          subtitle: task.description,
          lotName: task.lotName,
          date: DateOnlyDisplayFormatter.formatShortBrazilian(task.date),
          tone: task.overdue == true
              ? HomeInfoItemTone.danger
              : HomeInfoItemTone.neutral,
        ));
      }
    }
    if (today.alerts != null && items.length < 2) {
      for (final alert in today.alerts!.take(2 - items.length)) {
        items.add(HomeInfoListItem(
          title: alert.message ?? 'Alerta',
          lotName: alert.lotName,
          date: DateOnlyDisplayFormatter.formatShortBrazilian(alert.date),
          tone: _alertTone(alert.severity),
        ));
      }
    }

    return HomeInfoViewData(
      type: HomeInfoType.todayCultivation,
      title: rec?.title ?? 'Hoje no cultivo',
      subtitle: 'Atividades criadas pelo protocolo para acompanhar na agenda.',
      metrics: metrics,
      items: items,
    );
  }

  static HomeInfoViewData _mapReservoirReport(
    HomeReservoirReportInfo reservoir,
    InfoRecommendationViewData? rec,
  ) {
    final metrics = <HomeInfoMetric>[
      HomeInfoMetric(
        label: 'Reservatórios',
        value: '${reservoir.totalReservoirs ?? 0}',
        tone: HomeInfoMetricTone.neutral,
      ),
      if ((reservoir.reservoirsWithSolution ?? 0) > 0)
        HomeInfoMetric(
          label: 'Com solução',
          value: '${reservoir.reservoirsWithSolution}',
          tone: HomeInfoMetricTone.positive,
        ),
      if ((reservoir.reservoirsWithoutSolution ?? 0) > 0)
        HomeInfoMetric(
          label: 'Sem solução',
          value: '${reservoir.reservoirsWithoutSolution}',
          tone: HomeInfoMetricTone.warning,
        ),
      if ((reservoir.activeLotsLinked ?? 0) > 0)
        HomeInfoMetric(
          label: 'Lotes vinculados',
          value: '${reservoir.activeLotsLinked}',
          tone: HomeInfoMetricTone.neutral,
        ),
    ];

    final items = <HomeInfoListItem>[];
    if (reservoir.highlightedReservoirs != null) {
      for (final r in reservoir.highlightedReservoirs!.take(2)) {
        items.add(HomeInfoListItem(
          title: r.name ?? 'Reservatório',
          subtitle: r.solutionName != null
              ? '${r.solutionName}${r.electricalConductivity != null ? ' — ${r.electricalConductivity} mS/cm' : ''}'
              : null,
          lotName:
              r.linkedLotsCount != null ? '${r.linkedLotsCount} lote(s)' : null,
        ));
      }
    }

    return HomeInfoViewData(
      type: HomeInfoType.reservoirReport,
      title: rec?.title ?? 'Reservatórios',
      subtitle:
          'Volume total: ${reservoir.totalVolume?.toStringAsFixed(1) ?? '—'} L',
      metrics: metrics,
      items: items,
      ctaLabel: 'Ver reservatórios',
      ctaRoute: rec?.ctaRoute ?? '/reservatoriosPage',
    );
  }

  static HomeInfoViewData _mapFieldNotesSummary(
    HomeFieldNotesSummaryInfo notes,
    InfoRecommendationViewData? rec,
  ) {
    final items = <HomeInfoListItem>[];
    if (notes.latestNotes != null) {
      for (final note in notes.latestNotes!.take(2)) {
        items.add(HomeInfoListItem(
          title: note.title ?? 'Anotação',
          subtitle: normalizeAtividadeDescricao(note.description),
          lotName: note.lotName,
          date: note.createdAt,
          userName: note.userName,
        ));
      }
    }

    return HomeInfoViewData(
      type: HomeInfoType.fieldNotesSummary,
      title: rec?.title ?? 'Caderno de Campo',
      subtitle: '${notes.totalRecentNotes ?? 0} anotação(ões) recente(s)',
      metrics: [],
      items: items,
      ctaLabel: 'Ver caderno de campo',
      ctaRoute: rec?.ctaRoute ?? '/cadernoCampoPage',
    );
  }

  static HomeInfoViewData _basicTip(String? category) {
    final tip = HomeBasicTipSource.getRandomTip(category);
    return HomeInfoViewData(
      type: HomeInfoType.basicTip,
      title: 'Dica ${_categoryLabel(category)}',
      tipText: tip,
      sourceCategory: category ?? 'geral',
    );
  }

  static String _categoryLabel(String? category) {
    switch (category) {
      case 'agenda':
        return 'de agenda';
      case 'lote':
        return 'de cultivo';
      case 'protocolo':
        return 'de protocolo';
      case 'solucao':
        return 'de solução';
      case 'reservatorio':
        return 'de reservatório';
      case 'caderno_campo':
        return 'de campo';
      case 'cultivo':
        return 'de cultivo';
      default:
        return 'do dia';
    }
  }

  static HomeInfoItemTone _alertTone(String? severity) {
    final value = severity?.toLowerCase().trim() ?? '';
    if (value.contains('crit') ||
        value.contains('alta') ||
        value.contains('erro')) {
      return HomeInfoItemTone.danger;
    }
    if (value.contains('media') ||
        value.contains('média') ||
        value.contains('aten')) {
      return HomeInfoItemTone.warning;
    }
    return HomeInfoItemTone.neutral;
  }

  static HomeInfoMetricTone _completionTone(int completed, int total) {
    if (total == 0) return HomeInfoMetricTone.neutral;
    final ratio = completed / total;
    if (ratio >= 0.8) return HomeInfoMetricTone.positive;
    if (ratio > 0) return HomeInfoMetricTone.warning;
    return HomeInfoMetricTone.neutral;
  }
}
