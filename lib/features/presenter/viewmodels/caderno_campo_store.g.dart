// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caderno_campo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadernoCampoStore on _CadernoCampoStoreBase, Store {
  final _$valueAtom = Atom(name: '_CadernoCampoStoreBase.value');

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

  final _$loteListAtom = Atom(name: '_CadernoCampoStoreBase.loteList');

  @override
  List<Lote> get loteList {
    _$loteListAtom.reportRead();
    return super.loteList;
  }

  @override
  set loteList(List<Lote> value) {
    _$loteListAtom.reportWrite(value, super.loteList, () {
      super.loteList = value;
    });
  }

  final _$isLoteListLoadingAtom =
      Atom(name: '_CadernoCampoStoreBase.isLoteListLoading');

  @override
  bool get isLoteListLoading {
    _$isLoteListLoadingAtom.reportRead();
    return super.isLoteListLoading;
  }

  @override
  set isLoteListLoading(bool value) {
    _$isLoteListLoadingAtom.reportWrite(value, super.isLoteListLoading, () {
      super.isLoteListLoading = value;
    });
  }

  final _$setorSelecionadoAtom =
      Atom(name: '_CadernoCampoStoreBase.setorSelecionado');

  @override
  Setor get setorSelecionado {
    _$setorSelecionadoAtom.reportRead();
    return super.setorSelecionado;
  }

  @override
  set setorSelecionado(Setor value) {
    _$setorSelecionadoAtom.reportWrite(value, super.setorSelecionado, () {
      super.setorSelecionado = value;
    });
  }

  final _$buscarLotesByContaAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarLotesByConta');

  @override
  Future buscarLotesByConta() {
    return _$buscarLotesByContaAsyncAction
        .run(() => super.buscarLotesByConta());
  }

  final _$_CadernoCampoStoreBaseActionController =
      ActionController(name: '_CadernoCampoStoreBase');

  @override
  void increment() {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
loteList: ${loteList},
isLoteListLoading: ${isLoteListLoading},
setorSelecionado: ${setorSelecionado}
    ''';
  }
}
