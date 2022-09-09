// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SetorStore on _SetorStoreBase, Store {
  final _$areaSelecionadaAtom = Atom(name: '_SetorStoreBase.areaSelecionada');

  @override
  Area get areaSelecionada {
    _$areaSelecionadaAtom.reportRead();
    return super.areaSelecionada;
  }

  @override
  set areaSelecionada(Area value) {
    _$areaSelecionadaAtom.reportWrite(value, super.areaSelecionada, () {
      super.areaSelecionada = value;
    });
  }

  final _$setorListAtom = Atom(name: '_SetorStoreBase.setorList');

  @override
  List<Setor> get setorList {
    _$setorListAtom.reportRead();
    return super.setorList;
  }

  @override
  set setorList(List<Setor> value) {
    _$setorListAtom.reportWrite(value, super.setorList, () {
      super.setorList = value;
    });
  }

  final _$buscarSetoresAsyncAction =
      AsyncAction('_SetorStoreBase.buscarSetores');

  @override
  Future buscarSetores() {
    return _$buscarSetoresAsyncAction.run(() => super.buscarSetores());
  }

  final _$_SetorStoreBaseActionController =
      ActionController(name: '_SetorStoreBase');

  @override
  dynamic setAreaSelecionada(Area estufa) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setAreaSelecionada');
    try {
      return super.setAreaSelecionada(estufa);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
areaSelecionada: ${areaSelecionada},
setorList: ${setorList}
    ''';
  }
}
