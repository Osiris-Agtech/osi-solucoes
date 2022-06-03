// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on HomeStoreBase, Store {
  final _$appControllerAtom = Atom(name: 'HomeStoreBase.appController');

  @override
  AppController get appController {
    _$appControllerAtom.reportRead();
    return super.appController;
  }

  @override
  set appController(AppController value) {
    _$appControllerAtom.reportWrite(value, super.appController, () {
      super.appController = value;
    });
  }

  final _$isNotifiedAtom = Atom(name: 'HomeStoreBase.isNotified');

  @override
  bool get isNotified {
    _$isNotifiedAtom.reportRead();
    return super.isNotified;
  }

  @override
  set isNotified(bool value) {
    _$isNotifiedAtom.reportWrite(value, super.isNotified, () {
      super.isNotified = value;
    });
  }

  final _$isCollapsedAtom = Atom(name: 'HomeStoreBase.isCollapsed');

  @override
  bool get isCollapsed {
    _$isCollapsedAtom.reportRead();
    return super.isCollapsed;
  }

  @override
  set isCollapsed(bool value) {
    _$isCollapsedAtom.reportWrite(value, super.isCollapsed, () {
      super.isCollapsed = value;
    });
  }

  final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase');

  @override
  dynamic toggleNotified() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.toggleNotified');
    try {
      return super.toggleNotified();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsCollaped() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setIsCollaped');
    try {
      return super.setIsCollaped();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appController: ${appController},
isNotified: ${isNotified},
isCollapsed: ${isCollapsed}
    ''';
  }
}
