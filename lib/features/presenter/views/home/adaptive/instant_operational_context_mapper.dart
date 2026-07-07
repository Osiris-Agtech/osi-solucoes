import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_signals_store.dart';

class OperationalContext {
  final DateTime generatedAt;
  final DashboardOperationalState dashboardState;
  final AgendaOperationalState agendaState;
  final FieldNotebookOperationalState fieldNotebookState;
  final ProductionOperationalState productionState;
  final AlertOperationalState alertState;
  final TestSequenceSignals testSequenceSignals;
  final ReservoirOperationalState reservoirState;
  final InfoContextOperationalState infoContextState;

  const OperationalContext({
    required this.generatedAt,
    required this.dashboardState,
    required this.agendaState,
    required this.fieldNotebookState,
    required this.productionState,
    required this.alertState,
    required this.testSequenceSignals,
    required this.reservoirState,
    required this.infoContextState,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt.toIso8601String(),
        'dashboardState': dashboardState.toJson(),
        'agendaState': agendaState.toJson(),
        'fieldNotebookState': fieldNotebookState.toJson(),
        'productionState': productionState.toJson(),
        'alertState': alertState.toJson(),
        'testSequenceSignals': testSequenceSignals.toJson(),
        'reservoirState': reservoirState.toJson(),
        'infoContextState': infoContextState.toJson(),
      };
}

class NextActivity {
  final String? type;
  final String? status;
  final String? dueLabel;

  const NextActivity({this.type, this.status, this.dueLabel});

  Map<String, dynamic> toJson() => {
        'type': type,
        'status': status,
        'dueLabel': dueLabel,
      };
}

class DashboardOperationalState {
  final bool hasActiveLots;
  final int activeLotsCount;
  final int finishedLotsCount;
  final bool hasProtocolLinkedToLatestLot;
  final bool hasUpcomingHarvests;

  const DashboardOperationalState({
    required this.hasActiveLots,
    required this.activeLotsCount,
    required this.finishedLotsCount,
    required this.hasProtocolLinkedToLatestLot,
    required this.hasUpcomingHarvests,
  });

  Map<String, dynamic> toJson() => {
        'hasActiveLots': hasActiveLots,
        'activeLotsCount': activeLotsCount,
        'finishedLotsCount': finishedLotsCount,
        'hasProtocolLinkedToLatestLot': hasProtocolLinkedToLatestLot,
        'hasUpcomingHarvests': hasUpcomingHarvests,
      };
}

class AgendaOperationalState {
  final int pendingActivitiesTodayCount;
  final int overdueActivitiesCount;
  final bool hasGeneratedActivities;
  final int completedActivitiesTodayCount;
  final NextActivity nextActivity;
  final String? lastInteractionType;
  final String? lastActivityTitle;
  final String? lastActivityDescription;

  const AgendaOperationalState({
    required this.pendingActivitiesTodayCount,
    required this.overdueActivitiesCount,
    required this.hasGeneratedActivities,
    required this.completedActivitiesTodayCount,
    required this.nextActivity,
    this.lastInteractionType,
    this.lastActivityTitle,
    this.lastActivityDescription,
  });

  Map<String, dynamic> toJson() => {
        'pendingActivitiesTodayCount': pendingActivitiesTodayCount,
        'overdueActivitiesCount': overdueActivitiesCount,
        'hasGeneratedActivities': hasGeneratedActivities,
        'completedActivitiesTodayCount': completedActivitiesTodayCount,
        'nextActivity': nextActivity.toJson(),
        if (lastInteractionType != null)
          'lastInteractionType': lastInteractionType,
        if (lastActivityTitle != null) 'lastActivityTitle': lastActivityTitle,
        if (lastActivityDescription != null)
          'lastActivityDescription': lastActivityDescription,
      };
}

class ReservoirOperationalState {
  final bool hasReservoirs;
  final int totalCount;
  final int lowLevelCount;
  final int criticalLevelCount;
  final String currentLevel;

  const ReservoirOperationalState({
    required this.hasReservoirs,
    required this.totalCount,
    this.lowLevelCount = 0,
    this.criticalLevelCount = 0,
    this.currentLevel = 'unknown',
  });

  Map<String, dynamic> toJson() => {
        'hasReservoirs': hasReservoirs,
        'totalCount': totalCount,
        'lowLevelCount': lowLevelCount,
        'criticalLevelCount': criticalLevelCount,
        'currentLevel': currentLevel,
      };
}

class FieldNotebookOperationalState {
  final bool hasRecentNutritionAdjustmentRecord;
  final bool hasRecentFieldNotes;
  final int uncheckedNotesCount;
  final String? latestRecordType;

  const FieldNotebookOperationalState({
    required this.hasRecentNutritionAdjustmentRecord,
    this.hasRecentFieldNotes = false,
    this.uncheckedNotesCount = 0,
    this.latestRecordType,
  });

  Map<String, dynamic> toJson() => {
        'hasRecentNutritionAdjustmentRecord':
            hasRecentNutritionAdjustmentRecord,
        'hasRecentFieldNotes': hasRecentFieldNotes,
        'uncheckedNotesCount': uncheckedNotesCount,
        if (latestRecordType != null) 'latestRecordType': latestRecordType,
      };
}

class InfoContextOperationalState {
  final String? lastShownType;
  final String? lastShownCategory;
  final int dismissedTodayCount;
  final bool hasSeenInfoToday;

  const InfoContextOperationalState({
    this.lastShownType,
    this.lastShownCategory,
    this.dismissedTodayCount = 0,
    this.hasSeenInfoToday = false,
  });

  Map<String, dynamic> toJson() => {
        if (lastShownType != null) 'lastShownType': lastShownType,
        if (lastShownCategory != null) 'lastShownCategory': lastShownCategory,
        'dismissedTodayCount': dismissedTodayCount,
        'hasSeenInfoToday': hasSeenInfoToday,
      };
}

class ProductionOperationalState {
  final bool hasProductionData;
  final int harvestedPlantsLast30d;
  final int producedPackagesLast30d;

  const ProductionOperationalState({
    required this.hasProductionData,
    required this.harvestedPlantsLast30d,
    required this.producedPackagesLast30d,
  });

  Map<String, dynamic> toJson() => {
        'hasProductionData': hasProductionData,
        'harvestedPlantsLast30d': harvestedPlantsLast30d,
        'producedPackagesLast30d': producedPackagesLast30d,
      };
}

class AlertOperationalState {
  final bool hasCriticalAlerts;
  final int criticalCount;
  final String? highestSeverity;
  final List<String> types;

  const AlertOperationalState({
    required this.hasCriticalAlerts,
    required this.criticalCount,
    this.highestSeverity,
    required this.types,
  });

  Map<String, dynamic> toJson() => {
        'hasCriticalAlerts': hasCriticalAlerts,
        'criticalCount': criticalCount,
        if (highestSeverity != null) 'highestSeverity': highestSeverity,
        'types': types,
      };
}

class TestSequenceSignals {
  final bool lotWithProtocolCreated;
  final bool generatedAgendaActivitiesChecked;
  final bool adjustmentRecorded;
  final bool agendaActivitiesCompleted;
  final bool finalHomeStateChecked;
  final InstantSequenceEventType? lastRelevantEvent;
  final DateTime? changedAt;

  const TestSequenceSignals({
    required this.lotWithProtocolCreated,
    required this.generatedAgendaActivitiesChecked,
    required this.adjustmentRecorded,
    required this.agendaActivitiesCompleted,
    required this.finalHomeStateChecked,
    this.lastRelevantEvent,
    this.changedAt,
  });

  factory TestSequenceSignals.fromSnapshot(
    InstantSequenceSignalsSnapshot snapshot,
  ) {
    return TestSequenceSignals(
      lotWithProtocolCreated: snapshot.lotWithProtocolCreated,
      generatedAgendaActivitiesChecked:
          snapshot.generatedAgendaActivitiesChecked,
      adjustmentRecorded: snapshot.adjustmentRecorded,
      agendaActivitiesCompleted: snapshot.agendaActivitiesCompleted,
      finalHomeStateChecked: snapshot.finalHomeStateChecked,
      lastRelevantEvent: snapshot.lastRelevantEvent,
      changedAt: snapshot.changedAt,
    );
  }

  const TestSequenceSignals.empty()
      : lotWithProtocolCreated = false,
        generatedAgendaActivitiesChecked = false,
        adjustmentRecorded = false,
        agendaActivitiesCompleted = false,
        finalHomeStateChecked = false,
        lastRelevantEvent = null,
        changedAt = null;

  Map<String, dynamic> toJson() => {
        'lotWithProtocolCreated': lotWithProtocolCreated,
        'generatedActivitiesSeen': generatedAgendaActivitiesChecked,
        'adjustmentRecorded': adjustmentRecorded,
        'agendaActivitiesCompleted': agendaActivitiesCompleted,
        'finalHomeChecked': finalHomeStateChecked,
        if (lastRelevantEvent != null)
          'lastRelevantEvent': lastRelevantEvent!.payloadName,
        if (changedAt != null) 'changedAt': changedAt!.toIso8601String(),
      };
}

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
    final hasProtocol = loteStore.loteSelecionado.protocolo != null;
    final hasUpcomingHarvests = (resumo?.lotesComColheitaProxima ?? 0) > 0;

    // Agenda state
    final pendingToday =
        tarefas?.pendentesHoje ?? tarefas?.porVencimento?.hoje ?? 0;
    final overdue = tarefas?.atrasadas ?? 0;
    final hasGeneratedActivities = (tarefas?.pendentesHoje ?? 0) > 0 ||
        (tarefas?.porVencimento?.hoje ?? 0) > 0;
    const completedActivitiesToday = 0;

    // Infer nextActivity from first pending task
    String? nextActivityType;
    String? nextActivityStatus;
    String? nextActivityDueLabel;
    final latestTasks = tarefas?.ultimasTarefas ?? [];
    if (latestTasks.isNotEmpty) {
      final firstTask = latestTasks.first;
      final title = (firstTask.titulo ?? '').toLowerCase();
      if (title.contains('ajuste') || title.contains('nutri')) {
        nextActivityType = 'nutritional_adjustment';
      } else if (title.contains('agenda') || title.contains('tarefa')) {
        nextActivityType = 'task_review';
      }
      nextActivityStatus = firstTask.vencida == true ? 'overdue' : 'pending';
      nextActivityDueLabel = firstTask.data;
    }

    // Info context derived state
    final reservoirReport = infoContext?.reservoirReport;
    final totalReservoirs = reservoirReport?.totalReservoirs ?? 0;
    final fieldNotesSummary = infoContext?.fieldNotesSummary;
    final totalRecentNotes = fieldNotesSummary?.totalRecentNotes ?? 0;
    // Start with simple values - no persistence yet
    const String? lastShownType = null;
    const String? lastShownCategory = null;

    // Field notebook state
    final hasRecentNutritionAdjustment =
        cadernoCampoStore.loteSelecionado.lotes_atividades?.any(
              (a) => (a.atividade?.nome ?? '').toLowerCase().contains('ajuste'),
            ) ??
            false;

    const String? latestRecordType = null;

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

    // Consume pending activity context from HomeStore
    final pendingInteractionType = homeStore.pendingActivityInteractionType;
    final pendingTitle = homeStore.pendingActivityTitle;
    final pendingDescription = homeStore.pendingActivityDescription;
    homeStore.consumePendingActivityContext();

    return OperationalContext(
      generatedAt: DateTime.now(),
      dashboardState: DashboardOperationalState(
        hasActiveLots: activeLots > 0,
        activeLotsCount: activeLots,
        finishedLotsCount: finishedLots,
        hasProtocolLinkedToLatestLot: hasProtocol,
        hasUpcomingHarvests: hasUpcomingHarvests,
      ),
      agendaState: AgendaOperationalState(
        pendingActivitiesTodayCount: pendingToday,
        overdueActivitiesCount: overdue,
        hasGeneratedActivities: hasGeneratedActivities,
        completedActivitiesTodayCount: completedActivitiesToday,
        nextActivity: NextActivity(
          type: nextActivityType,
          status: nextActivityStatus,
          dueLabel: nextActivityDueLabel,
        ),
        lastInteractionType: pendingInteractionType,
        lastActivityTitle: pendingTitle,
        lastActivityDescription: pendingDescription,
      ),
      fieldNotebookState: FieldNotebookOperationalState(
        hasRecentNutritionAdjustmentRecord: hasRecentNutritionAdjustment,
        hasRecentFieldNotes: totalRecentNotes > 0,
        uncheckedNotesCount: 0,
        latestRecordType: latestRecordType,
      ),
      productionState: ProductionOperationalState(
        hasProductionData: hasProduction,
        harvestedPlantsLast30d: totalPlants,
        producedPackagesLast30d: totalPackages,
      ),
      alertState: AlertOperationalState(
        hasCriticalAlerts: hasCriticalAlerts,
        criticalCount: criticalCount,
        highestSeverity: highestSeverity,
        types: types.toList()..sort(),
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
      ),
      reservoirState: ReservoirOperationalState(
        hasReservoirs: totalReservoirs > 0,
        totalCount: totalReservoirs,
        lowLevelCount: 0,
        criticalLevelCount: 0,
        currentLevel: 'unknown',
      ),
      infoContextState: InfoContextOperationalState(
        lastShownType: lastShownType,
        lastShownCategory: lastShownCategory,
        dismissedTodayCount: 0,
        hasSeenInfoToday: false,
      ),
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
