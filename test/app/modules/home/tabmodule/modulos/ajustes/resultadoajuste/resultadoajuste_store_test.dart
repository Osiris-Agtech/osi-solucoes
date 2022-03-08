import 'package:flutter_test/flutter_test.dart';
import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/ajustes/resultadoajuste/resultadoajuste_store.dart';
 
void main() {
  late ResultadoajusteStore store;

  setUpAll(() {
    store = ResultadoajusteStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}