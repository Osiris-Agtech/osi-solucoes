import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_next_activity.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_operational_context_helpers.dart';
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
  final Map<String, dynamic> cultivationState;
  final Map<String, dynamic> teamState;
  final Map<String, dynamic> infoCardsState;

  const OperationalContext({
    required this.generatedAt,
    required this.dashboardState,
    required this.agendaState,
    required this.fieldNotebookState,
    required this.productionState,
    required this.alertState,
    required this.testSequenceSignals,
    required this.reservoirState,
    required this.cultivationState,
    required this.teamState,
    required this.infoCardsState,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': InstantOperationalContextHelpers.utcIso(generatedAt),
        'dashboardState': dashboardState.toJson(),
        'agendaState': agendaState.toJson(),
        'fieldNotebookState': fieldNotebookState.toJson(),
        'productionState': productionState.toJson(),
        'cultivationState': cultivationState,
        'teamState': teamState,
        'alertState': alertState.toJson(),
        'testSequenceSignals': testSequenceSignals.toJson(),
        'reservoirState': reservoirState.toJson(),
        'infoCardsState': infoCardsState,
      };
}

class DashboardOperationalState {
  final bool hasActiveLots;
  final int activeLotsCount;
  final int finishedLotsCount;
  final bool hasProtocolLinkedToLatestLot;
  final bool hasUpcomingHarvests;
  final Map<String, dynamic> extra;

  const DashboardOperationalState({
    required this.hasActiveLots,
    required this.activeLotsCount,
    required this.finishedLotsCount,
    required this.hasProtocolLinkedToLatestLot,
    required this.hasUpcomingHarvests,
    this.extra = const {},
  });

  Map<String, dynamic> toJson() => {
        ...extra,
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
  final Map<String, dynamic> extra;

  const AgendaOperationalState({
    required this.pendingActivitiesTodayCount,
    required this.overdueActivitiesCount,
    required this.hasGeneratedActivities,
    required this.completedActivitiesTodayCount,
    required this.nextActivity,
    this.lastInteractionType,
    this.lastActivityTitle,
    this.lastActivityDescription,
    this.extra = const {},
  });

  Map<String, dynamic> toJson() => {
        ...extra,
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
  final Map<String, dynamic> extra;

  const ReservoirOperationalState({
    required this.hasReservoirs,
    required this.totalCount,
    this.lowLevelCount = 0,
    this.criticalLevelCount = 0,
    this.currentLevel = 'unknown',
    this.extra = const {},
  });

  Map<String, dynamic> toJson() => {
        ...extra,
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
  final Map<String, dynamic> extra;

  const FieldNotebookOperationalState({
    required this.hasRecentNutritionAdjustmentRecord,
    this.hasRecentFieldNotes = false,
    this.uncheckedNotesCount = 0,
    this.latestRecordType,
    this.extra = const {},
  });

  Map<String, dynamic> toJson() => {
        ...extra,
        'hasRecentNutritionAdjustmentRecord':
            hasRecentNutritionAdjustmentRecord,
        'hasRecentFieldNotes': hasRecentFieldNotes,
        'uncheckedNotesCount': uncheckedNotesCount,
        if (latestRecordType != null) 'latestRecordType': latestRecordType,
      };
}

class ProductionOperationalState {
  final bool hasProductionData;
  final int harvestedPlantsLast30d;
  final int producedPackagesLast30d;
  final Map<String, dynamic> extra;

  const ProductionOperationalState({
    required this.hasProductionData,
    required this.harvestedPlantsLast30d,
    required this.producedPackagesLast30d,
    this.extra = const {},
  });

  Map<String, dynamic> toJson() => {
        ...extra,
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
  final List<Map<String, dynamic>> items;

  const AlertOperationalState({
    required this.hasCriticalAlerts,
    required this.criticalCount,
    this.highestSeverity,
    required this.types,
    this.items = const [],
  });

  Map<String, dynamic> toJson() => {
        'hasCriticalAlerts': hasCriticalAlerts,
        'criticalCount': criticalCount,
        if (highestSeverity != null) 'highestSeverity': highestSeverity,
        'types': types,
        'items': items,
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
        if (changedAt != null)
          'changedAt': InstantOperationalContextHelpers.utcIso(changedAt!),
      };
}
