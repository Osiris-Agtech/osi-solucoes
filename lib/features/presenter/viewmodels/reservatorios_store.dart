import 'package:mobx/mobx.dart';

part 'reservatorios_store.g.dart';

class ReservatoriosStore = _ReservatoriosStoreBase with _$ReservatoriosStore;
abstract class _ReservatoriosStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}