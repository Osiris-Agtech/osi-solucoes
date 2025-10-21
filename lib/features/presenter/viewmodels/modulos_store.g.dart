// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modulos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ModulosStore on ModulosStoreBase, Store {
  late final _$pageviewControllerAtom =
      Atom(name: 'ModulosStoreBase.pageviewController', context: context);

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

  late final _$ModulosStoreBaseActionController =
      ActionController(name: 'ModulosStoreBase', context: context);

  @override
  void setPageViewController(int id) {
    final _$actionInfo = _$ModulosStoreBaseActionController.startAction(
        name: 'ModulosStoreBase.setPageViewController');
    try {
      return super.setPageViewController(id);
    } finally {
      _$ModulosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageviewController: ${pageviewController}
    ''';
  }
}
