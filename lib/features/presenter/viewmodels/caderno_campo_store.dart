import 'package:mobx/mobx.dart';

part 'caderno_campo_store.g.dart';

class CadernoCampoStore = _CadernoCampoStoreBase with _$CadernoCampoStore;

abstract class _CadernoCampoStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
