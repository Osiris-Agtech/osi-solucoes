// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modulos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ModulosStore on _ModulosStoreBase, Store {
  final _$pageviewControllerAtom =
      Atom(name: '_ModulosStoreBase.pageviewController');

  @override
  int get pageviewController {
    _$pageviewControllerAtom.reportRead();
    return super.pageviewController;
  }

  @override
  set pageviewController(int value) {
    _$pageviewControllerAtom.reportWrite(value, super.pageviewController, () {
      super.pageviewController = value;
    });
  }

  final _$_ModulosStoreBaseActionController =
      ActionController(name: '_ModulosStoreBase');

  @override
  dynamic setPageViewController(int id) {
    final _$actionInfo = _$_ModulosStoreBaseActionController.startAction(
        name: '_ModulosStoreBase.setPageViewController');
    try {
      return super.setPageViewController(id);
    } finally {
      _$_ModulosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageviewController: ${pageviewController}
    ''';
  }
}
