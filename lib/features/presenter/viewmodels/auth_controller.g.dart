// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthController on _AuthControllerBase, Store {
  final _$usuarioAtom = Atom(name: '_AuthControllerBase.usuario');

  @override
  Usuario get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(Usuario value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  final _$isDevelopAtom = Atom(name: '_AuthControllerBase.isDevelop');

  @override
  bool get isDevelop {
    _$isDevelopAtom.reportRead();
    return super.isDevelop;
  }

  @override
  set isDevelop(bool value) {
    _$isDevelopAtom.reportWrite(value, super.isDevelop, () {
      super.isDevelop = value;
    });
  }

  final _$developCountAtom = Atom(name: '_AuthControllerBase.developCount');

  @override
  int get developCount {
    _$developCountAtom.reportRead();
    return super.developCount;
  }

  @override
  set developCount(int value) {
    _$developCountAtom.reportWrite(value, super.developCount, () {
      super.developCount = value;
    });
  }

  final _$_AuthControllerBaseActionController =
      ActionController(name: '_AuthControllerBase');

  @override
  dynamic setUser(Usuario user) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsDevelop() {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setIsDevelop');
    try {
      return super.setIsDevelop();
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
usuario: ${usuario},
isDevelop: ${isDevelop},
developCount: ${developCount}
    ''';
  }
}
