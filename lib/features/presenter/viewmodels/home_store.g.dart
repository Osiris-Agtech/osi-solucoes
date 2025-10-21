// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$isNotifiedAtom =
      Atom(name: 'HomeStoreBase.isNotified', context: context);

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

  late final _$isCollapsedAtom =
      Atom(name: 'HomeStoreBase.isCollapsed', context: context);

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

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  bool toggleNotified() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.toggleNotified');
    try {
      return super.toggleNotified();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsCollaped() {
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
isNotified: ${isNotified},
isCollapsed: ${isCollapsed}
    ''';
  }
}
