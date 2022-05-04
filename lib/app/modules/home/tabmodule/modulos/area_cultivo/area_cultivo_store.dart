import 'package:mobx/mobx.dart';

part 'area_cultivo_store.g.dart';

class AreaCultivoStore = _AreaCultivoStoreBase with _$AreaCultivoStore;

abstract class _AreaCultivoStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
