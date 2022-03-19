import 'package:mobx/mobx.dart';

part 'setores_store.g.dart';

class SetoresStore = _SetoresStoreBase with _$SetoresStore;
abstract class _SetoresStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}