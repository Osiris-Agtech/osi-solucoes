import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

part 'modulos_store.g.dart';

class ModulosStore = _ModulosStoreBase with _$ModulosStore;

abstract class _ModulosStoreBase with Store {
  ReservatoriosStore reservatoriosStore = GetIt.I<ReservatoriosStore>();

  @observable
  int pageviewController = 2;

  @action
  setPageViewController(int id) {
    pageviewController = id;
    if (id == 1) {
      reservatoriosStore.buscarReservatorios();
    }
  }
}
