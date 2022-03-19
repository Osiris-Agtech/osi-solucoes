import 'package:mobx/mobx.dart';

part 'modulos_store.g.dart';

class ModulosStore = _ModulosStoreBase with _$ModulosStore;

abstract class _ModulosStoreBase with Store {
  @observable
  int pageviewController = 2;

  @action
  setPageViewController(int id) => pageviewController = id;
}
