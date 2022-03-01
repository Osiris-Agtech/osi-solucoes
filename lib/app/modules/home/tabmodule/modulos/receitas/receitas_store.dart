import 'package:mobx/mobx.dart';

part 'receitas_store.g.dart';

class ReceitasStore = _ReceitasStoreBase with _$ReceitasStore;
abstract class _ReceitasStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}