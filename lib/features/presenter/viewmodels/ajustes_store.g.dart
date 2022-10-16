// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ajustes_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AjustesStore on _AjustesStoreBase, Store {
  final _$selectedItemAtom = Atom(name: '_AjustesStoreBase.selectedItem');

  @override
  int get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(int value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  final _$quantityListAtom = Atom(name: '_AjustesStoreBase.quantityList');

  @override
  List<int> get quantityList {
    _$quantityListAtom.reportRead();
    return super.quantityList;
  }

  @override
  set quantityList(List<int> value) {
    _$quantityListAtom.reportWrite(value, super.quantityList, () {
      super.quantityList = value;
    });
  }

  final _$cEletricoAtualAtom = Atom(name: '_AjustesStoreBase.cEletricoAtual');

  @override
  TextEditingController get cEletricoAtual {
    _$cEletricoAtualAtom.reportRead();
    return super.cEletricoAtual;
  }

  @override
  set cEletricoAtual(TextEditingController value) {
    _$cEletricoAtualAtom.reportWrite(value, super.cEletricoAtual, () {
      super.cEletricoAtual = value;
    });
  }

  final _$cEletricoDesejadoAtom =
      Atom(name: '_AjustesStoreBase.cEletricoDesejado');

  @override
  TextEditingController get cEletricoDesejado {
    _$cEletricoDesejadoAtom.reportRead();
    return super.cEletricoDesejado;
  }

  @override
  set cEletricoDesejado(TextEditingController value) {
    _$cEletricoDesejadoAtom.reportWrite(value, super.cEletricoDesejado, () {
      super.cEletricoDesejado = value;
    });
  }

  final _$volumeAtualAtom = Atom(name: '_AjustesStoreBase.volumeAtual');

  @override
  TextEditingController get volumeAtual {
    _$volumeAtualAtom.reportRead();
    return super.volumeAtual;
  }

  @override
  set volumeAtual(TextEditingController value) {
    _$volumeAtualAtom.reportWrite(value, super.volumeAtual, () {
      super.volumeAtual = value;
    });
  }

  final _$volumeDesejadoAtom = Atom(name: '_AjustesStoreBase.volumeDesejado');

  @override
  TextEditingController get volumeDesejado {
    _$volumeDesejadoAtom.reportRead();
    return super.volumeDesejado;
  }

  @override
  set volumeDesejado(TextEditingController value) {
    _$volumeDesejadoAtom.reportWrite(value, super.volumeDesejado, () {
      super.volumeDesejado = value;
    });
  }

  final _$pHAtom = Atom(name: '_AjustesStoreBase.pH');

  @override
  TextEditingController get pH {
    _$pHAtom.reportRead();
    return super.pH;
  }

  @override
  set pH(TextEditingController value) {
    _$pHAtom.reportWrite(value, super.pH, () {
      super.pH = value;
    });
  }

  final _$reservatorioAtom = Atom(name: '_AjustesStoreBase.reservatorio');

  @override
  TextEditingController get reservatorio {
    _$reservatorioAtom.reportRead();
    return super.reservatorio;
  }

  @override
  set reservatorio(TextEditingController value) {
    _$reservatorioAtom.reportWrite(value, super.reservatorio, () {
      super.reservatorio = value;
    });
  }

  final _$selectedReservatorioAtom =
      Atom(name: '_AjustesStoreBase.selectedReservatorio');

  @override
  Reservatorio get selectedReservatorio {
    _$selectedReservatorioAtom.reportRead();
    return super.selectedReservatorio;
  }

  @override
  set selectedReservatorio(Reservatorio value) {
    _$selectedReservatorioAtom.reportWrite(value, super.selectedReservatorio,
        () {
      super.selectedReservatorio = value;
    });
  }

  final _$reservatorioListAtom =
      Atom(name: '_AjustesStoreBase.reservatorioList');

  @override
  List<Reservatorio> get reservatorioList {
    _$reservatorioListAtom.reportRead();
    return super.reservatorioList;
  }

  @override
  set reservatorioList(List<Reservatorio> value) {
    _$reservatorioListAtom.reportWrite(value, super.reservatorioList, () {
      super.reservatorioList = value;
    });
  }

  final _$buscarReservatoriosAsyncAction =
      AsyncAction('_AjustesStoreBase.buscarReservatorios');

  @override
  Future buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  final _$_AjustesStoreBaseActionController =
      ActionController(name: '_AjustesStoreBase');

  @override
  dynamic newValueItem(int newValue) {
    final _$actionInfo = _$_AjustesStoreBaseActionController.startAction(
        name: '_AjustesStoreBase.newValueItem');
    try {
      return super.newValueItem(newValue);
    } finally {
      _$_AjustesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearAll() {
    final _$actionInfo = _$_AjustesStoreBaseActionController.startAction(
        name: '_AjustesStoreBase.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$_AjustesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectReservatorio(Reservatorio reservatorio) {
    final _$actionInfo = _$_AjustesStoreBaseActionController.startAction(
        name: '_AjustesStoreBase.selectReservatorio');
    try {
      return super.selectReservatorio(reservatorio);
    } finally {
      _$_AjustesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedItem: ${selectedItem},
quantityList: ${quantityList},
cEletricoAtual: ${cEletricoAtual},
cEletricoDesejado: ${cEletricoDesejado},
volumeAtual: ${volumeAtual},
volumeDesejado: ${volumeDesejado},
pH: ${pH},
reservatorio: ${reservatorio},
selectedReservatorio: ${selectedReservatorio},
reservatorioList: ${reservatorioList}
    ''';
  }
}
