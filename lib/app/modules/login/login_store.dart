import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';

import 'package:osi_solucoes/app/modules/login/repositories/login_repository.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final LoginRepository loginRepository = Modular.get();
  @observable
  TextEditingController email = TextEditingController();

  @observable
  TextEditingController senha = TextEditingController();

  @observable
  bool isObscure = true;

  @action
  toggleObscure() {
    isObscure = !isObscure;
  }

  @action
  vertificaLogin(String email) async {
    try {
      // var response = await loginRepository.buscaUser(email);
      return "loginValido".i18n();
    } catch (e) {
      return "loginInvalido".i18n();
    }
  }

  @action
  testaUser(String email) async {
    try {
      var response = await loginRepository.buscaUser(email);
      return response;
    } catch (e) {
      return e;
    }
  }
}
