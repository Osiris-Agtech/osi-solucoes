import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osi_solucoes/app/modules/home/home_store.dart';

void main() {
  late HomeStore store;

  setUpAll(() {
    store = HomeStore();
  });

  group("Teste das funções do Home", () {
    test("\nNotified inicia falso", () {
      expect(store.isNotified, equals(false));
    });
    test(
        "\nQuando a função toggleNotified executar, Notified deve alternar de estado",
        () {
      store.toggleNotified();
      expect(store.isNotified, equals(true));
      store.toggleNotified();
      expect(store.isNotified, equals(false));
    });
    test("\nCollapsed inicia true", () {
      expect(store.isCollapsed, equals(true));
    });
    test(
        "\nQuando a função setIsCollapsed executar, Collapsed deve alternar de estado",
        () {
      store.setIsCollaped();
      expect(store.isCollapsed, equals(false));
      store.setIsCollaped();
      expect(store.isCollapsed, equals(true));
    });
  });
}
