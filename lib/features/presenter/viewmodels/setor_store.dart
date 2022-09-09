import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

part 'setor_store.g.dart';

class SetorStore = _SetorStoreBase with _$SetorStore;

abstract class _SetorStoreBase with Store {
  @observable
  Area areaSelecionada = Area();

  @observable
  List<Setor> setorList = [];

  @action
  setAreaSelecionada(Area estufa) => areaSelecionada = estufa;

  @action
  buscarSetores() async {
    SetorRepository setorRepository = GetIt.I<SetorRepository>();

    var setores = await setorRepository.buscarSetores(areaSelecionada.id!);

    setores.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        setorList = List.from(data);
      },
    );
    print(setorList);
  }
}
