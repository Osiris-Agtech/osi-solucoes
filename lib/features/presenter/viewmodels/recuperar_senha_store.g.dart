// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recuperar_senha_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecuperarSenhaStore on RecuperarSenhaStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'RecuperarSenhaStoreBase.isLoading', context: context);

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

  late final _$mostrarSenhaAtom =
      Atom(name: 'RecuperarSenhaStoreBase.mostrarSenha', context: context);

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

  late final _$mostrarConfirmarSenhaAtom = Atom(
      name: 'RecuperarSenhaStoreBase.mostrarConfirmarSenha', context: context);

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

  late final _$usuarioEncontradoAtom =
      Atom(name: 'RecuperarSenhaStoreBase.usuarioEncontrado', context: context);

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

  late final _$emailAtom =
      Atom(name: 'RecuperarSenhaStoreBase.email', context: context);

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

  late final _$codigoGeradoAtom =
      Atom(name: 'RecuperarSenhaStoreBase.codigoGerado', context: context);

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

  late final _$codigo1Atom =
      Atom(name: 'RecuperarSenhaStoreBase.codigo1', context: context);

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

  late final _$codigo2Atom =
      Atom(name: 'RecuperarSenhaStoreBase.codigo2', context: context);

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

  late final _$codigo3Atom =
      Atom(name: 'RecuperarSenhaStoreBase.codigo3', context: context);

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

  late final _$codigo4Atom =
      Atom(name: 'RecuperarSenhaStoreBase.codigo4', context: context);

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

  late final _$novaSenhaAtom =
      Atom(name: 'RecuperarSenhaStoreBase.novaSenha', context: context);

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

  late final _$confirmarNovaSenhaAtom = Atom(
      name: 'RecuperarSenhaStoreBase.confirmarNovaSenha', context: context);

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

  late final _$verificarEmailAsyncAction =
      AsyncAction('RecuperarSenhaStoreBase.verificarEmail', context: context);

  @override
  Future<void> verificarEmail() {
    return _$verificarEmailAsyncAction.run(() => super.verificarEmail());
  }

  late final _$gerarCodigoAsyncAction =
      AsyncAction('RecuperarSenhaStoreBase.gerarCodigo', context: context);

  @override
  Future<void> gerarCodigo() {
    return _$gerarCodigoAsyncAction.run(() => super.gerarCodigo());
  }

  late final _$enviarCodigoAsyncAction =
      AsyncAction('RecuperarSenhaStoreBase.enviarCodigo', context: context);

  @override
  Future<bool> enviarCodigo() {
    return _$enviarCodigoAsyncAction.run(() => super.enviarCodigo());
  }

  late final _$alterarSenhaAsyncAction =
      AsyncAction('RecuperarSenhaStoreBase.alterarSenha', context: context);

  @override
  Future<void> alterarSenha() {
    return _$alterarSenhaAsyncAction.run(() => super.alterarSenha());
  }

  late final _$RecuperarSenhaStoreBaseActionController =
      ActionController(name: 'RecuperarSenhaStoreBase', context: context);

  @override
  void switchMostrarSenha() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.switchMostrarSenha');
    try {
      return super.switchMostrarSenha();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchMostrarConfirmarSenha() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.switchMostrarConfirmarSenha');
    try {
      return super.switchMostrarConfirmarSenha();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearEmailPage() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.clearEmailPage');
    try {
      return super.clearEmailPage();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCodigoPage() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.clearCodigoPage');
    try {
      return super.clearCodigoPage();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNovaSenhaPage() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.clearNovaSenhaPage');
    try {
      return super.clearNovaSenhaPage();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarCodigo() {
    final _$actionInfo = _$RecuperarSenhaStoreBaseActionController.startAction(
        name: 'RecuperarSenhaStoreBase.validarCodigo');
    try {
      return super.validarCodigo();
    } finally {
      _$RecuperarSenhaStoreBaseActionController.endAction(_$actionInfo);
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
