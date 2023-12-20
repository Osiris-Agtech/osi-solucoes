// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgendaStore on _AgendaStoreBase, Store {
  final _$showEditPageAtom = Atom(name: '_AgendaStoreBase.showEditPage');

  @override
  bool get showEditPage {
    _$showEditPageAtom.reportRead();
    return super.showEditPage;
  }

  @override
  set showEditPage(bool value) {
    _$showEditPageAtom.reportWrite(value, super.showEditPage, () {
      super.showEditPage = value;
    });
  }

  final _$isAcoesListLoadingAtom =
      Atom(name: '_AgendaStoreBase.isAcoesListLoading');

  @override
  bool get isAcoesListLoading {
    _$isAcoesListLoadingAtom.reportRead();
    return super.isAcoesListLoading;
  }

  @override
  set isAcoesListLoading(bool value) {
    _$isAcoesListLoadingAtom.reportWrite(value, super.isAcoesListLoading, () {
      super.isAcoesListLoading = value;
    });
  }

  final _$acoesListAtom = Atom(name: '_AgendaStoreBase.acoesList');

  @override
  List<Acao> get acoesList {
    _$acoesListAtom.reportRead();
    return super.acoesList;
  }

  @override
  set acoesList(List<Acao> value) {
    _$acoesListAtom.reportWrite(value, super.acoesList, () {
      super.acoesList = value;
    });
  }

  final _$buscarAcoesAsyncAction = AsyncAction('_AgendaStoreBase.buscarAcoes');

  @override
  Future buscarAcoes() {
    return _$buscarAcoesAsyncAction.run(() => super.buscarAcoes());
  }

  final _$_AgendaStoreBaseActionController =
      ActionController(name: '_AgendaStoreBase');

  @override
  dynamic setShowEditPage(bool value) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.setShowEditPage');
    try {
      return super.setShowEditPage(value);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showEditPage: ${showEditPage},
isAcoesListLoading: ${isAcoesListLoading},
acoesList: ${acoesList}
    ''';
  }
}
