// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:search_cep/search_cep.dart';

import '../../data/repositories/cadastro/cadastro_repository.dart';

part 'cadastro_store.g.dart';

class CadastroStore = _CadastroStoreBase with _$CadastroStore;

abstract class _CadastroStoreBase with Store {
  // late CadastroRepository repository = Modular.get<CadastroRepository>();
  // late AppController appController = Modular.get();
  CadastroRepository repository = GetIt.I<CadastroRepository>();
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
  gerarCodigo() {
    var rng = Random();
    codigoGerado = "";
    for (var i = 0; i < 4; i++) {
      codigoGerado += rng.nextInt(9).toString();
    }
    return codigoGerado;
  }

  @action
  enviarCodigoEmail() async {
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
  verificaCodigo() {
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
  toggleObscure() {
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
  verificaEmail() async {
    String strReturn = "";
    var response = await repository.verificaUser(email.text);

    response.fold(
      (l) => strReturn = l.message,
      (r) => strReturn = "E-mail ja cadastrado.",
    );
    return strReturn;
  }

  @action
  cadastraUser() async {
    late var usuario;
    try {
      usuario = await repository.cadastraConta(
        nome: nome.text,
        sobrenome: sobrenome.text,
        email: email.text,
        senha: senha.text,
        endereco: logradouro.text,
        bairro: bairro.text,
        cidade: cidade.text,
        telefone: telefone.text,
        imagem: "",
        cep: cep.text,
        estado: estado.text,
        pais: pais.text,
        complemento: complemento.text,
        imagemConta: "",
        cnpjConta: cnpjConta.text,
      );
    } catch (e) {
      return "cadastroInvalido".i18n();
    }
    authController.setUser(usuario);
    return "sucesso";
  }
}
