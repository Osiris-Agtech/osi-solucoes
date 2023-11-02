// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocolo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProtocoloStore on _ProtocoloStoreBase, Store {
  final _$dotIndicatorAtom = Atom(name: '_ProtocoloStoreBase.dotIndicator');

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

  final _$_ProtocoloStoreBaseActionController =
      ActionController(name: '_ProtocoloStoreBase');

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_ProtocoloStoreBaseActionController.startAction(
        name: '_ProtocoloStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dotIndicator: ${dotIndicator}
    ''';
  }
}
