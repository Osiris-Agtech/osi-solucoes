import 'package:mobx/mobx.dart';

part 'modulos_store.g.dart';

class ModulosStore = _ModulosStoreBase with _$ModulosStore;

abstract class _ModulosStoreBase with Store {
  @observable
  int pageviewController = 0;

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
