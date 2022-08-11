// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_cultivo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AreaCultivoStore on _AreaCultivoStoreBase, Store {
  final _$dropDownValueAtom = Atom(name: '_AreaCultivoStoreBase.dropDownValue');

  @override
  String get dropDownValue {
    _$dropDownValueAtom.reportRead();
    return super.dropDownValue;
  }

  @override
  set dropDownValue(String value) {
    _$dropDownValueAtom.reportWrite(value, super.dropDownValue, () {
      super.dropDownValue = value;
    });
  }

  final _$data2Atom = Atom(name: '_AreaCultivoStoreBase.data2');

  @override
  DateTime get data2 {
    _$data2Atom.reportRead();
    return super.data2;
  }

  @override
  set data2(DateTime value) {
    _$data2Atom.reportWrite(value, super.data2, () {
      super.data2 = value;
    });
  }

  final _$data1Atom = Atom(name: '_AreaCultivoStoreBase.data1');

  @override
  DateTime get data1 {
    _$data1Atom.reportRead();
    return super.data1;
  }

  @override
  set data1(DateTime value) {
    _$data1Atom.reportWrite(value, super.data1, () {
      super.data1 = value;
    });
  }

  final _$valueAtom = Atom(name: '_AreaCultivoStoreBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$isNovaAreaLoadingAtom =
      Atom(name: '_AreaCultivoStoreBase.isNovaAreaLoading');

  @override
  bool get isNovaAreaLoading {
    _$isNovaAreaLoadingAtom.reportRead();
    return super.isNovaAreaLoading;
  }

  @override
  set isNovaAreaLoading(bool value) {
    _$isNovaAreaLoadingAtom.reportWrite(value, super.isNovaAreaLoading, () {
      super.isNovaAreaLoading = value;
    });
  }

  final _$novaAreaNameAtom = Atom(name: '_AreaCultivoStoreBase.novaAreaName');

  @override
  TextEditingController get novaAreaName {
    _$novaAreaNameAtom.reportRead();
    return super.novaAreaName;
  }

  @override
  set novaAreaName(TextEditingController value) {
    _$novaAreaNameAtom.reportWrite(value, super.novaAreaName, () {
      super.novaAreaName = value;
    });
  }

  final _$novaAreaDescricaoAtom =
      Atom(name: '_AreaCultivoStoreBase.novaAreaDescricao');

  @override
  TextEditingController get novaAreaDescricao {
    _$novaAreaDescricaoAtom.reportRead();
    return super.novaAreaDescricao;
  }

  @override
  set novaAreaDescricao(TextEditingController value) {
    _$novaAreaDescricaoAtom.reportWrite(value, super.novaAreaDescricao, () {
      super.novaAreaDescricao = value;
    });
  }

  final _$dotIndicatorAtom = Atom(name: '_AreaCultivoStoreBase.dotIndicator');

  @override
  int get dotIndicator {
    _$dotIndicatorAtom.reportRead();
    return super.dotIndicator;
  }

  @override
  set dotIndicator(int value) {
    _$dotIndicatorAtom.reportWrite(value, super.dotIndicator, () {
      super.dotIndicator = value;
    });
  }

  final _$_AreaCultivoStoreBaseActionController =
      ActionController(name: '_AreaCultivoStoreBase');

  @override
  dynamic setDropDown(String value) {
    final _$actionInfo = _$_AreaCultivoStoreBaseActionController.startAction(
        name: '_AreaCultivoStoreBase.setDropDown');
    try {
      return super.setDropDown(value);
    } finally {
      _$_AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setData2(DateTime value) {
    final _$actionInfo = _$_AreaCultivoStoreBaseActionController.startAction(
        name: '_AreaCultivoStoreBase.setData2');
    try {
      return super.setData2(value);
    } finally {
      _$_AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setData1(DateTime value) {
    final _$actionInfo = _$_AreaCultivoStoreBaseActionController.startAction(
        name: '_AreaCultivoStoreBase.setData1');
    try {
      return super.setData1(value);
    } finally {
      _$_AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_AreaCultivoStoreBaseActionController.startAction(
        name: '_AreaCultivoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_AreaCultivoStoreBaseActionController.startAction(
        name: '_AreaCultivoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dropDownValue: ${dropDownValue},
data2: ${data2},
data1: ${data1},
value: ${value},
isNovaAreaLoading: ${isNovaAreaLoading},
novaAreaName: ${novaAreaName},
novaAreaDescricao: ${novaAreaDescricao},
dotIndicator: ${dotIndicator}
    ''';
  }
}
