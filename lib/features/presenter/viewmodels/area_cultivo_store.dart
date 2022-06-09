import 'package:mobx/mobx.dart';

part 'area_cultivo_store.g.dart';

class AreaCultivoStore = _AreaCultivoStoreBase with _$AreaCultivoStore;

abstract class _AreaCultivoStoreBase with Store {
  @observable
  String dropDownValue = "Nome";

  @action
  setDropDown(String value) => dropDownValue = value;

  @observable
  DateTime data2 = DateTime.now();

  @action
  setData2(DateTime value) => data2 = value;

  @observable
  DateTime data1 = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);

  @action
  setData1(DateTime value) => data1 = value;

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
