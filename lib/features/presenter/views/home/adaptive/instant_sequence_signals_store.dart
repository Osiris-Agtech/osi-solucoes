enum InstantSequenceEventType {
  lotWithProtocolCreated,
  generatedAgendaActivitiesChecked,
  nutritionalAdjustmentExecuted,
  automaticAdjustmentRecordChecked,
  agendaActivitiesCompleted,
  finalHomeStateChecked,
}

extension InstantSequenceEventTypeName on InstantSequenceEventType {
  String get payloadName => switch (this) {
        InstantSequenceEventType.lotWithProtocolCreated =>
          'lotWithProtocolCreated',
        InstantSequenceEventType.generatedAgendaActivitiesChecked =>
          'generatedAgendaActivitiesChecked',
        InstantSequenceEventType.nutritionalAdjustmentExecuted =>
          'nutritionalAdjustmentExecuted',
        InstantSequenceEventType.automaticAdjustmentRecordChecked =>
          'automaticAdjustmentRecordChecked',
        InstantSequenceEventType.agendaActivitiesCompleted =>
          'agendaActivitiesCompleted',
        InstantSequenceEventType.finalHomeStateChecked =>
          'finalHomeStateChecked',
      };
}

class InstantSequenceSignalsSnapshot {
  final bool lotWithProtocolCreated;
  final bool generatedAgendaActivitiesChecked;
  final bool nutritionalAdjustmentExecuted;
  final bool automaticAdjustmentRecordChecked;
  final bool agendaActivitiesCompleted;
  final bool finalHomeStateChecked;
  final InstantSequenceEventType? lastRelevantEvent;
  final DateTime? changedAt;

  const InstantSequenceSignalsSnapshot({
    required this.lotWithProtocolCreated,
    required this.generatedAgendaActivitiesChecked,
    required this.nutritionalAdjustmentExecuted,
    required this.automaticAdjustmentRecordChecked,
    required this.agendaActivitiesCompleted,
    required this.finalHomeStateChecked,
    required this.lastRelevantEvent,
    required this.changedAt,
  });

  const InstantSequenceSignalsSnapshot.empty()
      : lotWithProtocolCreated = false,
        generatedAgendaActivitiesChecked = false,
        nutritionalAdjustmentExecuted = false,
        automaticAdjustmentRecordChecked = false,
        agendaActivitiesCompleted = false,
        finalHomeStateChecked = false,
        lastRelevantEvent = null,
        changedAt = null;

  InstantSequenceSignalsSnapshot mark(
    InstantSequenceEventType eventType,
    DateTime changedAt,
  ) {
    return switch (eventType) {
      InstantSequenceEventType.lotWithProtocolCreated => copyWith(
          lotWithProtocolCreated: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
      InstantSequenceEventType.generatedAgendaActivitiesChecked => copyWith(
          generatedAgendaActivitiesChecked: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
      InstantSequenceEventType.nutritionalAdjustmentExecuted => copyWith(
          nutritionalAdjustmentExecuted: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
      InstantSequenceEventType.automaticAdjustmentRecordChecked => copyWith(
          automaticAdjustmentRecordChecked: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
      InstantSequenceEventType.agendaActivitiesCompleted => copyWith(
          agendaActivitiesCompleted: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
      InstantSequenceEventType.finalHomeStateChecked => copyWith(
          finalHomeStateChecked: true,
          lastRelevantEvent: eventType,
          changedAt: changedAt,
        ),
    };
  }

  InstantSequenceSignalsSnapshot copyWith({
    bool? lotWithProtocolCreated,
    bool? generatedAgendaActivitiesChecked,
    bool? nutritionalAdjustmentExecuted,
    bool? automaticAdjustmentRecordChecked,
    bool? agendaActivitiesCompleted,
    bool? finalHomeStateChecked,
    InstantSequenceEventType? lastRelevantEvent,
    DateTime? changedAt,
  }) {
    return InstantSequenceSignalsSnapshot(
      lotWithProtocolCreated:
          lotWithProtocolCreated ?? this.lotWithProtocolCreated,
      generatedAgendaActivitiesChecked: generatedAgendaActivitiesChecked ??
          this.generatedAgendaActivitiesChecked,
      nutritionalAdjustmentExecuted:
          nutritionalAdjustmentExecuted ?? this.nutritionalAdjustmentExecuted,
      automaticAdjustmentRecordChecked: automaticAdjustmentRecordChecked ??
          this.automaticAdjustmentRecordChecked,
      agendaActivitiesCompleted:
          agendaActivitiesCompleted ?? this.agendaActivitiesCompleted,
      finalHomeStateChecked:
          finalHomeStateChecked ?? this.finalHomeStateChecked,
      lastRelevantEvent: lastRelevantEvent ?? this.lastRelevantEvent,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  bool get hasAllPreviousSignalsForFinalHomeCheck =>
      lotWithProtocolCreated &&
      generatedAgendaActivitiesChecked &&
      nutritionalAdjustmentExecuted &&
      automaticAdjustmentRecordChecked &&
      agendaActivitiesCompleted;

  Map<String, dynamic> toJson() => {
        'lotWithProtocolCreated': lotWithProtocolCreated,
        'generatedAgendaActivitiesChecked': generatedAgendaActivitiesChecked,
        'nutritionalAdjustmentExecuted': nutritionalAdjustmentExecuted,
        'automaticAdjustmentRecordChecked': automaticAdjustmentRecordChecked,
        'agendaActivitiesCompleted': agendaActivitiesCompleted,
        'finalHomeStateChecked': finalHomeStateChecked,
        if (lastRelevantEvent != null)
          'lastRelevantEvent': lastRelevantEvent!.payloadName,
        if (changedAt != null) 'changedAt': changedAt!.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    return other is InstantSequenceSignalsSnapshot &&
        other.lotWithProtocolCreated == lotWithProtocolCreated &&
        other.generatedAgendaActivitiesChecked ==
            generatedAgendaActivitiesChecked &&
        other.nutritionalAdjustmentExecuted == nutritionalAdjustmentExecuted &&
        other.automaticAdjustmentRecordChecked ==
            automaticAdjustmentRecordChecked &&
        other.agendaActivitiesCompleted == agendaActivitiesCompleted &&
        other.finalHomeStateChecked == finalHomeStateChecked &&
        other.lastRelevantEvent == lastRelevantEvent &&
        other.changedAt == changedAt;
  }

  @override
  int get hashCode => Object.hash(
        lotWithProtocolCreated,
        generatedAgendaActivitiesChecked,
        nutritionalAdjustmentExecuted,
        automaticAdjustmentRecordChecked,
        agendaActivitiesCompleted,
        finalHomeStateChecked,
        lastRelevantEvent,
        changedAt,
      );
}

class InstantSequenceSignalsStore {
  InstantSequenceSignalsSnapshot _snapshot =
      const InstantSequenceSignalsSnapshot.empty();
  String? _scopeKey;

  InstantSequenceSignalsSnapshot get snapshot => _snapshot;

  void syncScope(String scopeKey) {
    if (_scopeKey == scopeKey) return;

    _scopeKey = scopeKey;
    _snapshot = const InstantSequenceSignalsSnapshot.empty();
  }

  bool report(InstantSequenceEventType eventType) {
    if (_isAlreadyMarked(eventType)) return false;

    final nextSnapshot = _snapshot.mark(eventType, DateTime.now().toUtc());
    if (!hasRelevantChange(_snapshot, nextSnapshot)) return false;

    _snapshot = nextSnapshot;
    return true;
  }

  bool hasRelevantChange(
    InstantSequenceSignalsSnapshot previous,
    InstantSequenceSignalsSnapshot next,
  ) {
    return previous != next;
  }

  bool _isAlreadyMarked(InstantSequenceEventType eventType) {
    return switch (eventType) {
      InstantSequenceEventType.lotWithProtocolCreated =>
        _snapshot.lotWithProtocolCreated,
      InstantSequenceEventType.generatedAgendaActivitiesChecked =>
        _snapshot.generatedAgendaActivitiesChecked,
      InstantSequenceEventType.nutritionalAdjustmentExecuted =>
        _snapshot.nutritionalAdjustmentExecuted,
      InstantSequenceEventType.automaticAdjustmentRecordChecked =>
        _snapshot.automaticAdjustmentRecordChecked,
      InstantSequenceEventType.agendaActivitiesCompleted =>
        _snapshot.agendaActivitiesCompleted,
      InstantSequenceEventType.finalHomeStateChecked =>
        _snapshot.finalHomeStateChecked,
    };
  }
}
