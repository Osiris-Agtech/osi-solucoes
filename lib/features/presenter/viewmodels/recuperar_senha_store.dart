import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'recuperar_senha_store.g.dart';

class RecuperarSenhaStore = _RecuperarSenhaStoreBase with _$RecuperarSenhaStore;

abstract class _RecuperarSenhaStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool mostrarSenha = false;

  @observable
  bool mostrarConfirmarSenha = false;

  @observable
  TextEditingController email = TextEditingController();

  @observable
  String codigoGerado = '';

  @observable
  TextEditingController codigo1 = TextEditingController();

  @observable
  TextEditingController codigo2 = TextEditingController();

  @observable
  TextEditingController codigo3 = TextEditingController();

  @observable
  TextEditingController codigo4 = TextEditingController();

  @observable
  TextEditingController novaSenha = TextEditingController();

  @observable
  TextEditingController confirmarNovaSenha = TextEditingController();

  @action
  switchMostrarSenha() {
    mostrarSenha = !mostrarSenha;
  }

  @action
  switchMostrarConfirmarSenha() {
    mostrarConfirmarSenha = !mostrarConfirmarSenha;
  }

  @action
  clearEmailPage() {
    email = TextEditingController();
  }

  @action
  clearCodigoPage() {
    codigoGerado = '';
    codigo1 = TextEditingController();
    codigo2 = TextEditingController();
    codigo3 = TextEditingController();
    codigo4 = TextEditingController();
  }

  @action
  clearNovaSenhaPage() {
    novaSenha = TextEditingController();
    confirmarNovaSenha = TextEditingController();
  }

  @action
  verificarEmail() {}

  @action
  gerarCodigo() {}
}
