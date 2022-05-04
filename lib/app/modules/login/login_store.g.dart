// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$emailAtom = Atom(name: '_LoginStoreBase.email');

  @override
  TextEditingController get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(TextEditingController value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$senhaAtom = Atom(name: '_LoginStoreBase.senha');

  @override
  TextEditingController get senha {
    _$senhaAtom.reportRead();
    return super.senha;
  }

  @override
  set senha(TextEditingController value) {
    _$senhaAtom.reportWrite(value, super.senha, () {
      super.senha = value;
    });
  }

  final _$isObscureAtom = Atom(name: '_LoginStoreBase.isObscure');

  @override
  bool get isObscure {
    _$isObscureAtom.reportRead();
    return super.isObscure;
  }

  @override
  set isObscure(bool value) {
    _$isObscureAtom.reportWrite(value, super.isObscure, () {
      super.isObscure = value;
    });
  }

  final _$vertificaLoginAsyncAction =
      AsyncAction('_LoginStoreBase.vertificaLogin');

  @override
  Future vertificaLogin() {
    return _$vertificaLoginAsyncAction.run(() => super.vertificaLogin());
  }

  final _$testaUserAsyncAction = AsyncAction('_LoginStoreBase.testaUser');

  @override
  Future testaUser(String email) {
    return _$testaUserAsyncAction.run(() => super.testaUser(email));
  }

  final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase');

  @override
  dynamic toggleObscure() {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.toggleObscure');
    try {
      return super.toggleObscure();
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
senha: ${senha},
isObscure: ${isObscure}
    ''';
  }
}
