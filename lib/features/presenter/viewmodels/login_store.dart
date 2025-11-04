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

  /// Verifica se o texto informado é um email válido
  bool _isValidEmail(String text) {
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
    );
    return emailRegex.hasMatch(text);
  }

  @action
  Future<String> login() async {
    // Login por email ou código de acesso (campo email aceita ambos)
    final loginIdentifier = email.text.trim();
    final password = senha.text;

    if (loginIdentifier.isEmpty || password.isEmpty) {
      return "loginInvalido".i18n();
    }

    // Identifica se é email ou código de acesso
    final isEmail = _isValidEmail(loginIdentifier);
    
    // Chama o repositório que delega para o datasource
    final usersResult = await loginRepository.login(
      email: isEmail ? loginIdentifier : null,
      codigo: isEmail ? null : loginIdentifier,
      senha: password,
    );

    // Trata erros
    if (usersResult.isLeft()) {
      return usersResult.fold(
        (error) => error.message,
        (_) => "",
      );
    }

    // Extrai a lista de usuários do Right
    final data = usersResult.fold(
      (_) => null,
      (users) => users,
    );

    if (data == null) {
      return "loginInvalido".i18n();
    }

    // A API já retorna a lista de usuários corretamente validada
    userList = List.from([data]);

    // Define o usuário principal no auth controller
    authController.setUser(data);

    // Se o usuário tem múltiplas contas, retorna "multiple" para mostrar a página de seleção
    final hasMultipleAccounts = data.contas != null && data.contas!.length > 1;

    if (hasMultipleAccounts) {
      return "multiple";
    }

    // Se tem apenas uma conta, seleciona automaticamente e salva
    if (data.contas != null && data.contas!.isNotEmpty) {
      authController.usuario.selected_conta = data.contas![0];
    }

    await LocalStorage().storageUser(data);

    return "sucesso";
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "erroValidacaoEmailVazio".i18n();
    }
    // Não valida formato pois pode ser email OU código de acesso
    // A validação do formato é feita internamente no método login()
    return null;
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
