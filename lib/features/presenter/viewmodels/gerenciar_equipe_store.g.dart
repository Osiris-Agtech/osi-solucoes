// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerenciar_equipe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GerenciarEquipeStore on _GerenciarEquipeBase, Store {
  final _$valueAtom = Atom(name: '_GerenciarEquipeBase.value');

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
      Atom(name: '_GerenciarEquipeBase.isSolucaoListLoading');

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

  final _$contaListAtom = Atom(name: '_GerenciarEquipeBase.contaList');

  @override
  List<Conta> get contaList {
    _$contaListAtom.reportRead();
    return super.contaList;
  }

  @override
  set contaList(List<Conta> value) {
    _$contaListAtom.reportWrite(value, super.contaList, () {
      super.contaList = value;
    });
  }

  final _$searchSolucaoTextAtom =
      Atom(name: '_GerenciarEquipeBase.searchSolucaoText');

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
      AsyncAction('_GerenciarEquipeBase.buscarSolucoes');

  @override
  Future buscarSolucoes() {
    return _$buscarSolucoesAsyncAction.run(() => super.buscarSolucoes());
  }

  final _$_GerenciarEquipeBaseActionController =
      ActionController(name: '_GerenciarEquipeBase');

  @override
  void increment() {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.increment');
    try {
      return super.increment();
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setsearchSolucaoText(String value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setsearchSolucaoText');
    try {
      return super.setsearchSolucaoText(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
isSolucaoListLoading: ${isSolucaoListLoading},
contaList: ${contaList},
searchSolucaoText: ${searchSolucaoText}
    ''';
  }
}
