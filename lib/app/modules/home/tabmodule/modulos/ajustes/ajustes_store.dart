import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'ajustes_store.g.dart';

class AjustesStore = _AjustesStoreBase with _$AjustesStore;

abstract class _AjustesStoreBase with Store {
  @observable
  int selectedItem = 1;

  @observable
  List<int> quantityList = List<int>.generate(50, (int i) => i);

  @action
  newValueItem(int newValue) => selectedItem = newValue;

  @observable
  TextEditingController cEletricoAtual = TextEditingController();
  @observable
  TextEditingController cEletricoDesejado = TextEditingController();
  @observable
  TextEditingController volumeAtual = TextEditingController();
  @observable
  TextEditingController volumeDesejado = TextEditingController();
  @observable
  TextEditingController pH = TextEditingController();
  @observable
  TextEditingController reservatorio = TextEditingController();

  List<String> listaReservatorios = [
    "UFMT",
    "IC-UFMT",
    "Osiris",
  ];
}
