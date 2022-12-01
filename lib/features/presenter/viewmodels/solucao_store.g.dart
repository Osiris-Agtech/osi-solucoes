// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SolucaoStore on _SolucaoStoreBase, Store {
  Computed<List<SolucaoNutritiva>>? _$searchSolucaoComputed;

  @override
  List<SolucaoNutritiva> get searchSolucao => (_$searchSolucaoComputed ??=
          Computed<List<SolucaoNutritiva>>(() => super.searchSolucao,
              name: '_SolucaoStoreBase.searchSolucao'))
      .value;

  final _$valueAtom = Atom(name: '_SolucaoStoreBase.value');

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

  final _$isSolucaoListLoadingAtom =
      Atom(name: '_SolucaoStoreBase.isSolucaoListLoading');

  @override
  bool get isSolucaoListLoading {
    _$isSolucaoListLoadingAtom.reportRead();
    return super.isSolucaoListLoading;
  }

  @override
  set isSolucaoListLoading(bool value) {
    _$isSolucaoListLoadingAtom.reportWrite(value, super.isSolucaoListLoading,
        () {
      super.isSolucaoListLoading = value;
    });
  }

  final _$solucaoListAtom = Atom(name: '_SolucaoStoreBase.solucaoList');

  @override
  List<SolucaoNutritiva> get solucaoList {
    _$solucaoListAtom.reportRead();
    return super.solucaoList;
  }

  @override
  set solucaoList(List<SolucaoNutritiva> value) {
    _$solucaoListAtom.reportWrite(value, super.solucaoList, () {
      super.solucaoList = value;
    });
  }

  final _$searchSolucaoTextAtom =
      Atom(name: '_SolucaoStoreBase.searchSolucaoText');

  @override
  String get searchSolucaoText {
    _$searchSolucaoTextAtom.reportRead();
    return super.searchSolucaoText;
  }

  @override
  set searchSolucaoText(String value) {
    _$searchSolucaoTextAtom.reportWrite(value, super.searchSolucaoText, () {
      super.searchSolucaoText = value;
    });
  }

  final _$buscarSolucoesAsyncAction =
      AsyncAction('_SolucaoStoreBase.buscarSolucoes');

  @override
  Future buscarSolucoes() {
    return _$buscarSolucoesAsyncAction.run(() => super.buscarSolucoes());
  }

  final _$_SolucaoStoreBaseActionController =
      ActionController(name: '_SolucaoStoreBase');

  @override
  void increment() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setsearchSolucaoText(String value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setsearchSolucaoText');
    try {
      return super.setsearchSolucaoText(value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
isSolucaoListLoading: ${isSolucaoListLoading},
solucaoList: ${solucaoList},
searchSolucaoText: ${searchSolucaoText},
searchSolucao: ${searchSolucao}
    ''';
  }
}
