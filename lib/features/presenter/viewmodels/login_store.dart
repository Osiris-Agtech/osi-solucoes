// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/services/local_storage.dart';
import '../../data/repositories/login/login_repository.dart';
import '../models/usuario/usuario_model.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  // late LoginRepository loginRepository = Modular.get();
  // late AppController appController = Modular.get();
  final LoginRepository loginRepository = GetIt.I<LoginRepository>();
  final AuthController authController = GetIt.I<AuthController>();

  @observable
  TextEditingController email = TextEditingController();

  @observable
  TextEditingController senha = TextEditingController();

  @observable
  List<Usuario> userList = [];

  @observable
  bool isObscure = true;

  @action
  void toggleObscure() {
    isObscure = !isObscure;
  }

  @action
  String setEmailController(String value) => email.text = value;

  @action
  String setSenhaController(String value) => senha.text = value;

  @action
  void clearFields() {
    email.clear();
    senha.clear();
  }

  @action
  Future<String> login() async {
    bool isValidLogin = false;
    bool isMultipleAccount = false;

    var users = await loginRepository.login(email.text, senha.text, email.text);
    print(users);

    users.fold(
      (err) {
        isValidLogin = false;
      }, // ifLeft callback
      (data) async {
        userList = List.from(data);
        isValidLogin = true;

        authController.setUser(data[0]);

        if (userList[0].contas!.length > 1) {
          isMultipleAccount = true;
        } else {
          authController.usuario.selected_conta = userList[0].contas![0];
        }

        await LocalStorage().storageUser(data[0]);
      },
    ); // ifRight callback

    if (!isValidLogin) {
      return "loginInvalido".i18n();
    }
    if (isMultipleAccount) return "multiple";

    return "loginValido".i18n();
  }

  String? validateEmail(String? value) {
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

  String? validateSenha(String? value) {
    if (value!.isEmpty) {
      return "erroValidacaoSenhaVazio".i18n();
    } else if (value.length < 6) {
      return "ErroValidacaoSenhaInvalido".i18n();
    }
    return null;
  }
}
