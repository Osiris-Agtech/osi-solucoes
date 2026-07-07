enum InstantSequenceEventType {
  lotWithProtocolCreated,
  generatedAgendaActivitiesChecked,
  adjustmentRecorded,
  agendaActivitiesCompleted,
  finalHomeStateChecked,
}

extension InstantSequenceEventTypeName on InstantSequenceEventType {
  String get payloadName => switch (this) {
        InstantSequenceEventType.lotWithProtocolCreated =>
          'lotWithProtocolCreated',
        InstantSequenceEventType.generatedAgendaActivitiesChecked =>
          'generatedAgendaActivitiesChecked',
        InstantSequenceEventType.adjustmentRecorded => 'adjustmentRecorded',
        InstantSequenceEventType.agendaActivitiesCompleted =>
          'agendaActivitiesCompleted',
        InstantSequenceEventType.finalHomeStateChecked =>
          'finalHomeStateChecked',
      };
}

class InstantSequenceSignalsSnapshot {
  final bool lotWithProtocolCreated;
  final bool generatedAgendaActivitiesChecked;
  final bool adjustmentRecorded;
  final bool agendaActivitiesCompleted;
  final bool finalHomeStateChecked;
  final InstantSequenceEventType? lastRelevantEvent;
  final DateTime? changedAt;

  const InstantSequenceSignalsSnapshot({
    required this.lotWithProtocolCreated,
    required this.generatedAgendaActivitiesChecked,
    required this.adjustmentRecorded,
    required this.agendaActivitiesCompleted,
    required this.finalHomeStateChecked,
    required this.lastRelevantEvent,
    required this.changedAt,
  });

  const InstantSequenceSignalsSnapshot.empty()
      : lotWithProtocolCreated = false,
        generatedAgendaActivitiesChecked = false,
        adjustmentRecorded = false,
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
      InstantSequenceEventType.adjustmentRecorded => copyWith(
          adjustmentRecorded: true,
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
    bool? adjustmentRecorded,
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
      adjustmentRecorded: adjustmentRecorded ?? this.adjustmentRecorded,
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
      adjustmentRecorded &&
      agendaActivitiesCompleted;

  Map<String, dynamic> toJson() => {
        'lotWithProtocolCreated': lotWithProtocolCreated,
        'generatedAgendaActivitiesChecked': generatedAgendaActivitiesChecked,
        'adjustmentRecorded': adjustmentRecorded,
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
        other.adjustmentRecorded == adjustmentRecorded &&
        other.agendaActivitiesCompleted == agendaActivitiesCompleted &&
        other.finalHomeStateChecked == finalHomeStateChecked &&
        other.lastRelevantEvent == lastRelevantEvent &&
        other.changedAt == changedAt;
  }

  @override
  int get hashCode => Object.hash(
        lotWithProtocolCreated,
        generatedAgendaActivitiesChecked,
        adjustmentRecorded,
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
      InstantSequenceEventType.adjustmentRecorded =>
        _snapshot.adjustmentRecorded,
      InstantSequenceEventType.agendaActivitiesCompleted =>
        _snapshot.agendaActivitiesCompleted,
      InstantSequenceEventType.finalHomeStateChecked =>
        _snapshot.finalHomeStateChecked,
    };
  }
}
