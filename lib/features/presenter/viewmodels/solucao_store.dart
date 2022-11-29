import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'solucao_store.g.dart';

class SolucaoStore = _SolucaoStoreBase with _$SolucaoStore;

abstract class _SolucaoStoreBase with Store {
  @observable
  int value = 0;

  @observable
  bool isReceitaListLoading = false;

  @observable
  List<SolucaoNutritiva> receitaList = [];

  @action
  void increment() {
    value++;
  }
}
