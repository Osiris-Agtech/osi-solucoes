// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recuperar_senha_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RecuperarSenhaStore on _RecuperarSenhaStoreBase, Store {
  final _$isLoadingAtom = Atom(name: '_RecuperarSenhaStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$mostrarSenhaAtom =
      Atom(name: '_RecuperarSenhaStoreBase.mostrarSenha');

  @override
  bool get mostrarSenha {
    _$mostrarSenhaAtom.reportRead();
    return super.mostrarSenha;
  }

  @override
  set mostrarSenha(bool value) {
    _$mostrarSenhaAtom.reportWrite(value, super.mostrarSenha, () {
      super.mostrarSenha = value;
    });
  }

  final _$mostrarConfirmarSenhaAtom =
      Atom(name: '_RecuperarSenhaStoreBase.mostrarConfirmarSenha');

  @override
  bool get mostrarConfirmarSenha {
    _$mostrarConfirmarSenhaAtom.reportRead();
    return super.mostrarConfirmarSenha;
  }

  @override
  set mostrarConfirmarSenha(bool value) {
    _$mostrarConfirmarSenhaAtom.reportWrite(value, super.mostrarConfirmarSenha,
        () {
      super.mostrarConfirmarSenha = value;
    });
  }

  final _$usuarioEncontradoAtom =
      Atom(name: '_RecuperarSenhaStoreBase.usuarioEncontrado');

  @override
  Usuario? get usuarioEncontrado {
    _$usuarioEncontradoAtom.reportRead();
    return super.usuarioEncontrado;
  }

  @override
  set usuarioEncontrado(Usuario? value) {
    _$usuarioEncontradoAtom.reportWrite(value, super.usuarioEncontrado, () {
      super.usuarioEncontrado = value;
    });
  }

  final _$emailAtom = Atom(name: '_RecuperarSenhaStoreBase.email');

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

  final _$codigoGeradoAtom =
      Atom(name: '_RecuperarSenhaStoreBase.codigoGerado');

  @override
  String get codigoGerado {
    _$codigoGeradoAtom.reportRead();
    return super.codigoGerado;
  }

  @override
  set codigoGerado(String value) {
    _$codigoGeradoAtom.reportWrite(value, super.codigoGerado, () {
      super.codigoGerado = value;
    });
  }

  final _$codigo1Atom = Atom(name: '_RecuperarSenhaStoreBase.codigo1');

  @override
  TextEditingController get codigo1 {
    _$codigo1Atom.reportRead();
    return super.codigo1;
  }

  @override
  set codigo1(TextEditingController value) {
    _$codigo1Atom.reportWrite(value, super.codigo1, () {
      super.codigo1 = value;
    });
  }

  final _$codigo2Atom = Atom(name: '_RecuperarSenhaStoreBase.codigo2');

  @override
  TextEditingController get codigo2 {
    _$codigo2Atom.reportRead();
    return super.codigo2;
  }

  @override
  set codigo2(TextEditingController value) {
    _$codigo2Atom.reportWrite(value, super.codigo2, () {
      super.codigo2 = value;
    });
  }

  final _$codigo3Atom = Atom(name: '_RecuperarSenhaStoreBase.codigo3');

  @override
  TextEditingController get codigo3 {
    _$codigo3Atom.reportRead();
    return super.codigo3;
  }

  @override
  set codigo3(TextEditingController value) {
    _$codigo3Atom.reportWrite(value, super.codigo3, () {
      super.codigo3 = value;
    });
  }

  final _$codigo4Atom = Atom(name: '_RecuperarSenhaStoreBase.codigo4');

  @override
  TextEditingController get codigo4 {
    _$codigo4Atom.reportRead();
    return super.codigo4;
  }

  @override
  set codigo4(TextEditingController value) {
    _$codigo4Atom.reportWrite(value, super.codigo4, () {
      super.codigo4 = value;
    });
  }

  final _$novaSenhaAtom = Atom(name: '_RecuperarSenhaStoreBase.novaSenha');

  @override
  TextEditingController get novaSenha {
    _$novaSenhaAtom.reportRead();
    return super.novaSenha;
  }

  @override
  set novaSenha(TextEditingController value) {
    _$novaSenhaAtom.reportWrite(value, super.novaSenha, () {
      super.novaSenha = value;
    });
  }

  final _$confirmarNovaSenhaAtom =
      Atom(name: '_RecuperarSenhaStoreBase.confirmarNovaSenha');

  @override
  TextEditingController get confirmarNovaSenha {
    _$confirmarNovaSenhaAtom.reportRead();
    return super.confirmarNovaSenha;
  }

  @override
  set confirmarNovaSenha(TextEditingController value) {
    _$confirmarNovaSenhaAtom.reportWrite(value, super.confirmarNovaSenha, () {
      super.confirmarNovaSenha = value;
    });
  }

  final _$verificarEmailAsyncAction =
      AsyncAction('_RecuperarSenhaStoreBase.verificarEmail');

  @override
  Future verificarEmail() {
    return _$verificarEmailAsyncAction.run(() => super.verificarEmail());
  }

  final _$gerarCodigoAsyncAction =
      AsyncAction('_RecuperarSenhaStoreBase.gerarCodigo');

  @override
  Future gerarCodigo() {
    return _$gerarCodigoAsyncAction.run(() => super.gerarCodigo());
  }

  final _$enviarCodigoAsyncAction =
      AsyncAction('_RecuperarSenhaStoreBase.enviarCodigo');

  @override
  Future<bool> enviarCodigo() {
    return _$enviarCodigoAsyncAction.run(() => super.enviarCodigo());
  }

  final _$alterarSenhaAsyncAction =
      AsyncAction('_RecuperarSenhaStoreBase.alterarSenha');

  @override
  Future alterarSenha() {
    return _$alterarSenhaAsyncAction.run(() => super.alterarSenha());
  }

  final _$_RecuperarSenhaStoreBaseActionController =
      ActionController(name: '_RecuperarSenhaStoreBase');

  @override
  dynamic switchMostrarSenha() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.switchMostrarSenha');
    try {
      return super.switchMostrarSenha();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic switchMostrarConfirmarSenha() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.switchMostrarConfirmarSenha');
    try {
      return super.switchMostrarConfirmarSenha();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearEmailPage() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.clearEmailPage');
    try {
      return super.clearEmailPage();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearCodigoPage() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.clearCodigoPage');
    try {
      return super.clearCodigoPage();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearNovaSenhaPage() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.clearNovaSenhaPage');
    try {
      return super.clearNovaSenhaPage();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic validarCodigo() {
    final _$actionInfo = _$_RecuperarSenhaStoreBaseActionController.startAction(
        name: '_RecuperarSenhaStoreBase.validarCodigo');
    try {
      return super.validarCodigo();
    } finally {
      _$_RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
mostrarSenha: ${mostrarSenha},
mostrarConfirmarSenha: ${mostrarConfirmarSenha},
usuarioEncontrado: ${usuarioEncontrado},
email: ${email},
codigoGerado: ${codigoGerado},
codigo1: ${codigo1},
codigo2: ${codigo2},
codigo3: ${codigo3},
codigo4: ${codigo4},
novaSenha: ${novaSenha},
confirmarNovaSenha: ${confirmarNovaSenha}
    ''';
  }
}
