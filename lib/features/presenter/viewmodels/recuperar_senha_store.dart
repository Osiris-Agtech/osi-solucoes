import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:sigma_hort_gestao_producao/core/utils/toast.dart';
import 'package:sigma_hort_gestao_producao/features/data/repositories/recuperarSenha/recuperar_senha_repository.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/usuario/usuario_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/routes/routes.dart';

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
  Usuario? usuarioEncontrado;

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
  verificarEmail() async {
    isLoading = true;
    RecuperarSenhaRepository recuperarSenhaRepository =
        GetIt.I<RecuperarSenhaRepository>();

    var buscarUsuario =
        await recuperarSenhaRepository.buscarUsuario(email.text);

    buscarUsuario.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        usuarioEncontrado = data;
        bool codigoEnviado = await enviarCodigo();
        if (codigoEnviado) {
          Get.toNamed(Routes.codigoSeguranca);
        }
      },
    );

    isLoading = false;
  }

  @action
  gerarCodigo() async {
    String token1, token2, token3, token4;
    var rng = Random();
    token1 = rng.nextInt(9).toString();
    token2 = rng.nextInt(9).toString();
    token3 = rng.nextInt(9).toString();
    token4 = rng.nextInt(9).toString();
    codigoGerado = token1 + token2 + token3 + token4;
    return;
  }

  @action
  Future<bool> enviarCodigo() async {
    bool codigoEnviado = false;
    await gerarCodigo();

    RecuperarSenhaRepository recuperarSenhaRepository =
        GetIt.I<RecuperarSenhaRepository>();

    var sendEmail =
        await recuperarSenhaRepository.enviarCodigo(email.text, codigoGerado);

    sendEmail.fold(
      (err) {
        toastError(message: err.message);
        codigoEnviado = false;
      },
      (data) async {
        toastSuccess(message: "Código enviado");
        codigoEnviado = true;
      },
    );

    return codigoEnviado;
  }

  @action
  validarCodigo() {
    String codigoDigitado =
        codigo1.text + codigo2.text + codigo3.text + codigo4.text;

    if (codigoDigitado == codigoGerado) {
      Get.toNamed(Routes.novaSenha);
    } else {
      toastError(message: "Código não corresponde ao enviado no e-mail");
    }
  }

  @action
  alterarSenha() async {
    if (usuarioEncontrado == null) {
      toastError(message: "Erro ao encontrar usuário");
      return;
    }

    isLoading = true;

    RecuperarSenhaRepository recuperarSenhaRepository =
        GetIt.I<RecuperarSenhaRepository>();

    var alterarSenha = await recuperarSenhaRepository.alterarSenha(
        usuarioEncontrado!.id!, novaSenha.text);

    alterarSenha.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        Get.close(3);
        toastSuccess(message: "Senha alterada com sucesso");
        clearEmailPage();
        clearCodigoPage();
        clearNovaSenhaPage();
      },
    );

    isLoading = false;
  }
}
