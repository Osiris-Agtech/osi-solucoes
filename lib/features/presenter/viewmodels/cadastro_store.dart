// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:search_cep/search_cep.dart';

import '../../../core/services/local_storage.dart';
import '../../data/repositories/cadastro/cadastro_repository.dart';
import '../../data/repositories/login/login_repository.dart';

part 'cadastro_store.g.dart';

class CadastroStore = CadastroStoreBase with _$CadastroStore;

abstract class CadastroStoreBase with Store {
  // late CadastroRepository repository = Modular.get<CadastroRepository>();
  // late AppController appController = Modular.get();
  CadastroRepository repository = GetIt.I<CadastroRepository>();
  LoginRepository loginRepository = GetIt.I<LoginRepository>();
  AuthController authController = GetIt.I<AuthController>();

  @observable
  TextEditingController nome = TextEditingController();
  @observable
  TextEditingController sobrenome = TextEditingController();
  @observable
  TextEditingController cep = TextEditingController();
  @observable
  TextEditingController logradouro = TextEditingController();
  @observable
  TextEditingController complemento = TextEditingController();
  @observable
  TextEditingController bairro = TextEditingController();
  @observable
  TextEditingController cidade = TextEditingController();
  @observable
  TextEditingController estado = TextEditingController();
  @observable
  TextEditingController pais = TextEditingController();
  @observable
  TextEditingController telefone = TextEditingController();
  @observable
  TextEditingController cnpjConta = TextEditingController();
  @observable
  TextEditingController email = TextEditingController();
  @observable
  TextEditingController senha = TextEditingController();

  @observable
  String? responseCEP;

  @observable
  bool isObscure = false;

  @observable
  TextEditingController primeiroDigito = TextEditingController();

  @observable
  TextEditingController segundoDigito = TextEditingController();

  @observable
  TextEditingController terceiroDigito = TextEditingController();

  @observable
  TextEditingController quartoDigito = TextEditingController();

  @observable
  String? code;

  @observable
  String codigoGerado = "";

  @action
  String gerarCodigo() {
    var rng = Random();
    codigoGerado = "";
    for (var i = 0; i < 4; i++) {
      codigoGerado += rng.nextInt(9).toString();
    }
    return codigoGerado;
  }

  @action
  Future<String> enviarCodigoEmail() async {
    String strReturn = "";
    var response =
        await repository.enviarEmail(codigoGerado, email.text, nome.text);

    response.fold(
      (l) => strReturn = l.message,
      (r) => strReturn = "sucesso",
    );
    return strReturn;
  }

  @action
  bool verificaCodigo() {
    code = primeiroDigito.text +
        segundoDigito.text +
        terceiroDigito.text +
        quartoDigito.text;
    if (codigoGerado == code) {
      return true;
    }
    return false;
  }

  @action
  void toggleObscure() {
    isObscure = !isObscure;
  }

  @action
  Future<String> buscaCEP() async {
    responseCEP = "waiting";
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
        cep: cep.text.replaceAll(".", '').replaceAll("-", ""));
    if (infoCepJSON.isRight()) {
      Right(infoCepJSON).value.map(
            (r) => {
              logradouro.text = r.logradouro ?? '',
              complemento.text = r.complemento ?? '',
              bairro.text = r.bairro ?? '',
              cidade.text = r.localidade ?? '',
              estado.text = r.uf ?? '',
              pais.text = "Brasil",
            },
          );
      responseCEP = "sucess";
      return "Sucess";
    } else {
      responseCEP = "Erro";
      // logradouro.clear();
      // complemento.clear();
      // bairro.clear();
      // cidade.clear();
      // estado.clear();
      return "Error";
    }
  }

  @action
  Future<String> verificaEmail() async {
    String strReturn = "";
    var response = await repository.verificaUser(email.text);

    response.fold(
      (l) => strReturn = l.message,
      (r) => strReturn = "E-mail ja cadastrado.",
    );
    return strReturn;
  }

  @action
  Future<String> cadastraUser() async {
    var usuario = await repository.cadastraConta(
      nome: nome.text,
      sobrenome: sobrenome.text,
      email: email.text,
      senha: senha.text,
      endereco: logradouro.text,
      bairro: bairro.text,
      cidade: cidade.text,
      telefone: telefone.text,
      cep: cep.text,
      estado: estado.text,
      pais: pais.text,
      complemento: complemento.text,
      imagemConta: "",
      cnpjConta: cnpjConta.text,
    );

    return usuario.fold(
      (l) async => "cadastroInvalido".i18n(),
      (r) async {
        final authenticationResult = await loginRepository.login(
          email: email.text.trim(),
          senha: senha.text,
        );

        return authenticationResult.fold(
          (l) async => l.message,
          (authentication) async {
            final authenticatedUser = authentication.usuario;
            final token = authentication.token;

            if (authenticatedUser == null || token == null || token.isEmpty) {
              return "loginInvalido".i18n();
            }

            if (authenticatedUser.contas != null &&
                authenticatedUser.contas!.isNotEmpty) {
              authenticatedUser.selected_conta = authenticatedUser.contas![0];
            }

            final localStorage = LocalStorage();
            await localStorage.storageToken(token);
            final storedToken = await localStorage.getToken();

            if (storedToken == null || storedToken.isEmpty) {
              return "loginInvalido".i18n();
            }

            await localStorage.storageUser(authenticatedUser);
            authController.setUser(authenticatedUser);
            return "sucesso";
          },
        );
      },
    );
  }
}
