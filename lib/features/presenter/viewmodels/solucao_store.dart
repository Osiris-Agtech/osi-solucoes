import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/solucoes/solucoes_repository.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'solucao_store.g.dart';

class SolucaoStore = _SolucaoStoreBase with _$SolucaoStore;

abstract class _SolucaoStoreBase with Store {
  @observable
  int value = 0;

  @observable
  bool isSolucaoListLoading = false;

  @observable
  List<SolucaoNutritiva> solucaoList = [];

  @observable
  String searchSolucaoText = '';

  @action
  void increment() {
    value++;
  }

  @action
  setsearchSolucaoText(String value) => searchSolucaoText = value;

  @action
  buscarSolucoes() async {
    AuthController authController = GetIt.I<AuthController>();
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();
    isSolucaoListLoading = true;

    var solucoes = await solucaoRepository
        .buscarSolucoes(authController.usuario.selected_conta!.conta!.id!);

    solucoes.fold(
      (err) {
        solucaoList = ObservableList.of([]);
        toastError(message: err.message);
      },
      (data) async {
        solucaoList = ObservableList.of(data);
      },
    );

    isSolucaoListLoading = false;
  }

  @computed
  List<SolucaoNutritiva> get searchSolucao {
    List<SolucaoNutritiva> result = solucaoList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchSolucaoText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }
}
