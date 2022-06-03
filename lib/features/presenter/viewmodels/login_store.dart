// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/app_controller.dart';

import '../../data/repositories/login/login_repository.dart';
import '../models/usuario/usuario_model.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  late LoginRepository loginRepository = Modular.get();
  late AppController appController = Modular.get();

  @observable
  TextEditingController email = TextEditingController();

  @observable
  TextEditingController senha = TextEditingController();

  @observable
  List<Usuario> userList = [];

  @observable
  bool isObscure = true;

  @action
  toggleObscure() {
    isObscure = !isObscure;
  }

  @action
  login() async {
    var users;
    try {
      users = await loginRepository.login(email.text, senha.text, email.text);
    } catch (e) {
      return "loginInvalido".i18n();
    }
    userList = List.from(users);
    if (userList[0].contas!.length > 1) return "multiple";

    appController.setUser(users[0]);
    appController.usuario.selected_conta = userList[0].contas![0];
    return "loginValido".i18n();
  }

  validateEmail(String? value) {
    if (value!.isEmpty) {
      return "erroValidacaoEmailVazio".i18n();
    } else {
      // ## Pode receber tanto e-mail quanto código de acesso
      // String pattern =
      //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      // RegExp regex = RegExp(pattern);
      // if (!regex.hasMatch(value)) {
      //   return "ErroValidacaoEmailInvalido".i18n();
      // } else {
      //   return null;
      // }
      return null;
    }
  }

  validateSenha(String? value) {
    if (value!.isEmpty) {
      return "erroValidacaoSenhaVazio".i18n();
    } else if (value.length < 6) {
      return "ErroValidacaoSenhaInvalido".i18n();
    }
    return null;
  }
}
