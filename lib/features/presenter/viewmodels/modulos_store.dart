import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/ajustes_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';

part 'modulos_store.g.dart';

class ModulosStore = _ModulosStoreBase with _$ModulosStore;

abstract class _ModulosStoreBase with Store {
  AreaCultivoStore areaCultivoStore = GetIt.I<AreaCultivoStore>();
  ReservatoriosStore reservatoriosStore = GetIt.I<ReservatoriosStore>();
  CadernoCampoStore cadernoCampoStore = GetIt.I<CadernoCampoStore>();
  SolucaoStore solucaoStore = GetIt.I<SolucaoStore>();
  AjustesStore ajusteStore = GetIt.I<AjustesStore>();

  @observable
  int pageviewController = 2;

  @action
  setPageViewController(int id) {
    pageviewController = id;
    switch (id) {
      case 0:
        areaCultivoStore.setSearchAreaText('');
        areaCultivoStore.buscarArea();
        break;
      case 1:
        reservatoriosStore.buscarReservatorios();
        break;
      case 2:
        cadernoCampoStore.buscarLotesByConta();
        cadernoCampoStore.buscarAreasList();
        break;
      case 3:
        solucaoStore.buscarSolucoes();
        break;
      case 4:
        ajusteStore.buscarReservatorios();
        break;
      default:
    }

    return;
  }
}
