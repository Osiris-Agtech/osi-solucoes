import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/services/user_action_trace.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_info_cards_state_mapper.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_next_activity.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_operational_context_dtos.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_operational_context_helpers.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_signals_store.dart';

class InstantOperationalContextMapper {
  /// Maps store state to OperationalContext.
  /// Uses GetIt to resolve stores.
  static OperationalContext map() {
    final homeStore = GetIt.I<HomeStore>();
    final loteStore = GetIt.I<LoteStore>();
    final cadernoCampoStore = GetIt.I<CadernoCampoStore>();
    final sequenceSignals = _mapSequenceSignals(homeStore);

    final dashboard = homeStore.dashboard;
    final resumo = dashboard?.resumo;
    final tarefas = dashboard?.tarefas;
    final producao = dashboard?.producao;
    final alerts = dashboard?.alertasCritico ?? [];
    final criticalAgendaAlerts = alerts.where(_isCriticalAgendaAlert).toList();
    final infoContext = dashboard?.infoContext;

    // Dashboard state
    final activeLots = resumo?.lotesAtivos ?? 0;
    final finishedLots = resumo?.lotesFinalizados ?? 0;
    final selectedLotProtocolId = _isActiveLot(loteStore.loteSelecionado)
        ? _protocolId(loteStore.loteSelecionado)
        : null;
    final dashboardActiveLotProtocolIds = resumo?.activeLotProtocolIds
            ?.where((id) => id > 0)
            .map((id) => id.toString())
            .toSet()
            .toList() ??
        [];
    final fallbackActiveLotProtocolIds = loteStore.loteList
        .where(_isActiveLot)
        .map(_protocolId)
        .whereType<String>()
        .toSet()
        .toList();
    final activeLotProtocolIds = {
      ...dashboardActiveLotProtocolIds,
      ...fallbackActiveLotProtocolIds,
    }.toList();
    final hasSelectedLotProtocol = selectedLotProtocolId != null;
    final hasDashboardActiveLotProtocolEvidence =
        resumo?.hasActiveLotWithProtocol == true ||
            (resumo?.lotesAtivosComProtocolo ?? 0) > 0 ||
            dashboardActiveLotProtocolIds.isNotEmpty;
    final hasActiveLotProtocolEvidence =
        hasDashboardActiveLotProtocolEvidence ||
            fallbackActiveLotProtocolIds.isNotEmpty ||
            sequenceSignals.lotWithProtocolCreated;
    final hasUpcomingHarvests = (resumo?.lotesComColheitaProxima ?? 0) > 0;

    // Agenda state
    final pendingToday =
        tarefas?.pendentesHoje ?? tarefas?.porVencimento?.hoje ?? 0;
    final overdue = tarefas?.atrasadas ?? 0;
    final hasGeneratedActivities = (tarefas?.pendentesHoje ?? 0) > 0 ||
        (tarefas?.porVencimento?.hoje ?? 0) > 0;
    final completedActivitiesToday =
        infoContext?.dayProgress?.completedTasksToday ?? 0;
    final nextActivity =
        InstantOperationalContextHelpers.nextActivity(dashboard) ??
            const NextActivity();
    final hasProtocolTasks = nextActivity.type == 'protocol_activity';

    // Info context derived state
    final reservoirReport = infoContext?.reservoirReport;
    final totalReservoirs = reservoirReport?.totalReservoirs ?? 0;
    final fieldNotesSummary = infoContext?.fieldNotesSummary;
    final totalRecentNotes = fieldNotesSummary?.totalRecentNotes ?? 0;
    // Start with simple values - no persistence yet

    // Field notebook state
    final hasRecentNutritionAdjustment =
        cadernoCampoStore.loteSelecionado.lotes_atividades?.any(
              (a) => (a.atividade?.nome ?? '').toLowerCase().contains('ajuste'),
            ) ??
            false;

    final experimentActive = homeStore.isInstantMode;

    final fieldNotebookExtra =
        InstantOperationalContextHelpers.fieldNotebookState(dashboard);
    final latestRecordType = fieldNotebookExtra['latestRecordType'] as String?;

    // Production state
    final totalPlants = producao?.totalPlantasColhidas ?? 0;
    final totalPackages = producao?.totalEmbalagensProduzidas ?? 0;
    final hasProduction = totalPlants > 0 || totalPackages > 0;

    // Alert state
    final hasCriticalAlerts = criticalAgendaAlerts.isNotEmpty;
    final criticalCount = criticalAgendaAlerts.length;
    String? highestSeverity;
    final types = <String>{};
    if (criticalAgendaAlerts.isNotEmpty) {
      const severityOrder = [
        'critico',
        'critical',
        'alto',
        'high',
        'medio',
        'medium',
        'baixo',
        'low',
      ];
      var highestIndex = -1;
      for (final alert in criticalAgendaAlerts) {
        final grav = (alert.gravidade ?? '').toLowerCase();
        final idx = severityOrder.indexOf(grav);
        if (idx >= 0 && (highestIndex < 0 || idx < highestIndex)) {
          highestIndex = idx;
          highestSeverity = alert.gravidade;
        }
        if (alert.tipo != null) {
          types.add(alert.tipo!);
        }
      }
    }

    // Consume user action trace
    final trace = GetIt.I<UserActionTrace>();
    final recentActions = trace.consume();

    // Derive last agenda interaction from trace, if any
    String? lastInteractionType;
    for (final action in recentActions) {
      if (action['entityType'] == 'agenda_activity') {
        lastInteractionType = action['action'] as String?;
        break;
      }
    }

    return OperationalContext(
      generatedAt: DateTime.now(),
      dashboardState: DashboardOperationalState(
        hasActiveLots: activeLots > 0,
        activeLotsCount: activeLots,
        finishedLotsCount: finishedLots,
        hasProtocolLinkedToLatestLot: hasSelectedLotProtocol,
        hasProtocolLinkedToActiveLot: hasActiveLotProtocolEvidence,
        selectedLotProtocolId: selectedLotProtocolId,
        activeLotProtocolIds: activeLotProtocolIds,
        hasUpcomingHarvests: hasUpcomingHarvests,
        extra: InstantOperationalContextHelpers.dashboardState(dashboard),
      ),
      agendaState: AgendaOperationalState(
        pendingActivitiesTodayCount: pendingToday,
        overdueActivitiesCount: overdue,
        hasGeneratedActivities: hasGeneratedActivities,
        completedActivitiesTodayCount: completedActivitiesToday,
        nextActivity: nextActivity,
        lastInteractionType: lastInteractionType,
        extra: InstantOperationalContextHelpers.agendaState(
          dashboard,
          nextActivity,
        ),
        hasProtocolTasks: hasProtocolTasks,
      ),
      fieldNotebookState: FieldNotebookOperationalState(
        hasRecentNutritionAdjustmentRecord: hasRecentNutritionAdjustment,
        hasRecentFieldNotes: totalRecentNotes > 0,
        uncheckedNotesCount: 0,
        latestRecordType: latestRecordType,
        extra: fieldNotebookExtra,
      ),
      productionState: ProductionOperationalState(
        hasProductionData: hasProduction,
        harvestedPlantsLast30d: totalPlants,
        producedPackagesLast30d: totalPackages,
        extra: InstantOperationalContextHelpers.productionState(dashboard),
      ),
      cultivationState:
          InstantOperationalContextHelpers.cultivationState(dashboard),
      teamState: InstantOperationalContextHelpers.teamState(dashboard),
      alertState: AlertOperationalState(
        hasCriticalAlerts: hasCriticalAlerts,
        criticalCount: criticalCount,
        highestSeverity: highestSeverity,
        types: types.toList()..sort(),
        items:
            InstantOperationalContextHelpers.alertItems(criticalAgendaAlerts),
      ),
      testSequenceSignals: TestSequenceSignals(
        lotWithProtocolCreated: sequenceSignals.lotWithProtocolCreated,
        generatedAgendaActivitiesChecked:
            sequenceSignals.generatedAgendaActivitiesChecked,
        adjustmentRecorded: sequenceSignals.adjustmentRecorded,
        agendaActivitiesCompleted: sequenceSignals.agendaActivitiesCompleted,
        finalHomeStateChecked: sequenceSignals.finalHomeStateChecked,
        lastRelevantEvent: sequenceSignals.lastRelevantEvent,
        changedAt: sequenceSignals.changedAt,
        experimentActive: experimentActive,
      ),
      reservoirState: ReservoirOperationalState(
        hasReservoirs: totalReservoirs > 0,
        totalCount: totalReservoirs,
        lowLevelCount: 0,
        criticalLevelCount: 0,
        currentLevel: 'unknown',
        extra: InstantOperationalContextHelpers.reservoirState(dashboard),
      ),
      infoCardsState: InstantInfoCardsStateMapper.map(infoContext),
      recentUserActions: recentActions,
    );
  }

  static TestSequenceSignals _mapSequenceSignals(HomeStore homeStore) {
    final getIt = GetIt.I;
    if (!getIt.isRegistered<InstantSequenceSignalsStore>()) {
      return const TestSequenceSignals.empty();
    }

    final store = getIt<InstantSequenceSignalsStore>();
    store.syncScope(_resolveScopeKey(homeStore));

    return TestSequenceSignals.fromSnapshot(
      store.snapshot,
    );
  }

  static String _resolveScopeKey(HomeStore homeStore) {
    final userId = homeStore.authController.usuario.id?.toString() ?? 'unknown';
    final accountId = homeStore.authController.usuario.selected_conta?.conta?.id
            ?.toString() ??
        'unknown';
    final sessionId = homeStore.currentSessionId ?? 'unknown';
    final adaptiveMode = homeStore.adaptiveMode;
    return '$userId|$accountId|$sessionId|$adaptiveMode';
  }

  static bool _isActiveLot(Lote lote) {
    return lote.ativo != false && lote.deleted_at == null;
  }

  static String? _protocolId(Lote lote) {
    final id = lote.protocolo?.id;
    if (id == null || id <= 0) return null;

    return id.toString();
  }

  static bool _isCriticalAgendaAlert(HomeAlertaCritico alert) {
    return _normalizeAlertType(alert.tipo) != 'colheita_proxima';
  }

  static String _normalizeAlertType(String? type) {
    if (type == null) return '';

    return type
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
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[\s-]+'), '_');
  }
}
