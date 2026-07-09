import 'dart:async';
import 'dart:developer' as developer;

import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_signals_store.dart';

class HomeAdaptiveRefreshCoordinator {
  static const Duration _debounceDuration = Duration(milliseconds: 350);

  Timer? _debounceTimer;
  bool _isRefreshing = false;
  bool _refreshQueued = false;

  void onSequenceSignalsChanged(
    InstantSequenceSignalsSnapshot previous,
    InstantSequenceSignalsSnapshot next,
  ) {
    if (previous == next) return;
    _scheduleRefresh('sequenceSignalsChanged');
  }

  Future<void> refreshInstantAfterDomainMutation(String reason) async {
    _scheduleRefresh(reason);
  }

  Future<void> refreshInstantAfterHomeDashboardLoaded(String reason) async {
    _scheduleRefresh(reason);
  }

  void _scheduleRefresh(String reason) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      unawaited(_refresh(reason));
    });
  }

  Future<void> _refresh(String reason) async {
    if (_isRefreshing) {
      _refreshQueued = true;
      return;
    }

    _isRefreshing = true;
    try {
      final getIt = GetIt.I;
      if (!getIt.isRegistered<HomeStore>()) return;

      final homeStore = getIt<HomeStore>();
      if (!homeStore.isInstantMode) return;

      homeStore.prepareInstantRefresh();
      await homeStore.carregarHome();
      if (!homeStore.isInstantMode) return;

      await homeStore.loadInstantAdaptiveInterface();
    } catch (e, stackTrace) {
      developer.log(
        'Erro ao atualizar INSTANT após evento de sequência: $reason',
        name: 'HOME_ADAPTIVE_REFRESH_COORDINATOR',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isRefreshing = false;
      if (_refreshQueued) {
        _refreshQueued = false;
        _scheduleRefresh('$reason:queued');
      }
    }
  }
}
