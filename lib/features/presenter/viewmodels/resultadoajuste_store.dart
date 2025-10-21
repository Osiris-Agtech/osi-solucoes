import 'package:mobx/mobx.dart';

part 'resultadoajuste_store.g.dart';

class ResultadoajusteStore = ResultadoajusteStoreBase
    with _$ResultadoajusteStore;

abstract class ResultadoajusteStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  int fatorConcentracao = 300;
}
