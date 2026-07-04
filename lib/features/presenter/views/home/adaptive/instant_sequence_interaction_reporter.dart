import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/home_adaptive_refresh_coordinator.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_signals_store.dart';

class InstantSequenceInteractionReporter {
  bool reportLotWithProtocolCreated() {
    return _report(InstantSequenceEventType.lotWithProtocolCreated);
  }

  bool reportGeneratedAgendaActivitiesChecked() {
    return _report(InstantSequenceEventType.generatedAgendaActivitiesChecked);
  }

  bool reportNutritionalAdjustmentExecuted() {
    return _report(InstantSequenceEventType.nutritionalAdjustmentExecuted);
  }

  bool reportAutomaticAdjustmentRecordChecked() {
    return _report(InstantSequenceEventType.automaticAdjustmentRecordChecked);
  }

  bool reportAgendaActivitiesCompleted() {
    return _report(InstantSequenceEventType.agendaActivitiesCompleted);
  }

  bool reportFinalHomeStateChecked() {
    return _report(InstantSequenceEventType.finalHomeStateChecked);
  }

  bool _report(InstantSequenceEventType eventType) {
    final getIt = GetIt.I;
    if (!getIt.isRegistered<InstantSequenceSignalsStore>() ||
        !getIt.isRegistered<HomeAdaptiveRefreshCoordinator>()) {
      return false;
    }

    final store = getIt<InstantSequenceSignalsStore>();
    store.syncScope(_resolveScopeKey(getIt));
    final previous = store.snapshot;
    final changed = store.report(eventType);
    if (!changed) return false;

    getIt<HomeAdaptiveRefreshCoordinator>().onSequenceSignalsChanged(
      previous,
      store.snapshot,
    );
    return true;
  }

  String _resolveScopeKey(GetIt getIt) {
    if (!getIt.isRegistered<HomeStore>()) return 'unknown';

    final homeStore = getIt<HomeStore>();
    final userId = homeStore.authController.usuario.id?.toString() ?? 'unknown';
    final accountId = homeStore.authController.usuario.selected_conta?.conta?.id
            ?.toString() ??
        'unknown';
    final sessionId = homeStore.currentSessionId ?? 'unknown';
    final adaptiveMode = homeStore.adaptiveMode;
    return '$userId|$accountId|$sessionId|$adaptiveMode';
  }
}
