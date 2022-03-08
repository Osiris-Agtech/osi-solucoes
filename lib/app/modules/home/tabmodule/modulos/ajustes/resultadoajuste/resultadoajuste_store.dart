import 'package:mobx/mobx.dart';

part 'resultadoajuste_store.g.dart';

class ResultadoajusteStore = _ResultadoajusteStoreBase with _$ResultadoajusteStore;
abstract class _ResultadoajusteStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}