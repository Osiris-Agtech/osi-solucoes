import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/app/models/usuario_model.dart';
import 'package:osi_solucoes/app/modules/cadastro/repositories/cadastro_repository.dart';
import 'package:search_cep/search_cep.dart';

part 'cadastro_store.g.dart';

class CadastroStore = _CadastroStoreBase with _$CadastroStore;

abstract class _CadastroStoreBase with Store {
  final repository = Modular.get<CadastroRepository>();
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
  verificaCodigo() {
    code = primeiroDigito.text +
        segundoDigito.text +
        terceiroDigito.text +
        quartoDigito.text;
    if (codigoGerado == code) {
      return true;
    }
    return false;
    // return true;
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
      Right(infoCepJSON).value.map((r) => {
            logradouro.text = r.logradouro!,
            complemento.text = r.complemento!,
            bairro.text = r.bairro!,
            cidade.text = r.localidade!,
            estado.text = r.uf!,
            pais.text = "Brasil",
          });
      responseCEP = "sucess";
      return "Sucess";
    } else {
      responseCEP = "Erro";
      logradouro.clear();
      complemento.clear();
      bairro.clear();
      cidade.clear();
      estado.clear();
      return "Error";
    }
  }

  @action
  verificaEmail() async {
    try {
      String response = await repository.verificaUser(email.text);

      return "sucesso";
    } catch (e) {
      return "E-mail ja cadastrado.";
    }
  }

  @action
  cadastraUser() async {
    try {
      Usuario user = Usuario(
        nome: nome.text,
        sobrenome: sobrenome.text,
        logradouro: logradouro.text,
        complemento: complemento.text,
        bairro: bairro.text,
        cidade: cidade.text,
        estado: estado.text,
        pais: pais.text,
      );

      String res = await repository.cadastraUser(user);

      return "sucesso";
    } catch (e) {
      return "cadastroInvalido".i18n();
    }
  }
}
