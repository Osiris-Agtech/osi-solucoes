import 'package:mobx/mobx.dart';

part 'ajustes_store.g.dart';

class AjustesStore = _AjustesStoreBase with _$AjustesStore;
abstract class _AjustesStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}