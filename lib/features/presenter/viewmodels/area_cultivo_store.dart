import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/area/area_repository.dart';

import '../../../core/utils/toast.dart';
import '../models/localizacao/localizacao_model.dart';

part 'area_cultivo_store.g.dart';

class AreaCultivoStore = _AreaCultivoStoreBase with _$AreaCultivoStore;

abstract class _AreaCultivoStoreBase with Store {
  @observable
  String dropDownValue = "Nome";

  @action
  setDropDown(String value) => dropDownValue = value;

  @observable
  DateTime data2 = DateTime.now();

  @action
  setData2(DateTime value) => data2 = value;

  @observable
  DateTime data1 = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);

  @action
  setData1(DateTime value) => data1 = value;

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  //####################### CADASTRAR AREA DE CULTIVO ##########################

  @observable
  bool isNovaAreaLoading = false;

  @observable
  bool showTextFormField = false;

  @observable
  int dotIndicator = 1;

  @observable
  List<Localizacao> localizacaoList = [];

  @observable
  Localizacao localizacaoSelecionada = Localizacao();

  @observable
  TextEditingController novaAreaName = TextEditingController();

  @observable
  TextEditingController novaAreaDescricao = TextEditingController();

  @observable
  TextEditingController cep = TextEditingController();

  @observable
  TextEditingController endereco = TextEditingController();

  @observable
  TextEditingController bairro = TextEditingController();

  @observable
  TextEditingController cidade = TextEditingController();

  @observable
  TextEditingController numero = TextEditingController();

  @observable
  TextEditingController complemento = TextEditingController();

  @observable
  TextEditingController pais = TextEditingController();

  @observable
  TextEditingController estado = TextEditingController();

  @action
  cadastrarNovaLocalizacao(BuildContext context) async {
    AreaRepository areaRepository = GetIt.I<AreaRepository>();

    Localizacao localizacao = Localizacao(
        cep: cep.text,
        endereco: endereco.text,
        bairro: bairro.text,
        cidade: cidade.text,
        pais: pais.text,
        estado: estado.text,
        complemento: complemento.text);

    var localizaoResult =
        await areaRepository.cadastrarLocalizacao(localizacao);

    localizaoResult.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        localizacaoList.add(data);
        localizacaoSelecionada = data;
        localizacaoList = List.from(localizacaoList);

        Navigator.pop(context);
        limparLocalizacao();
      },
    );
  }

  @action
  limparLocalizacao() {
    cep.clear();
    endereco.clear();
    bairro.clear();
    cidade.clear();
    numero.clear();
    pais.clear();
    complemento.clear();
  }

  @action
  limparTudo() {
    novaAreaName.clear();
    novaAreaDescricao.clear();
    limparLocalizacao();
    localizacaoList.clear();
    localizacaoSelecionada = Localizacao();
  }

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 1) {
      dotIndicator = value;
    }
  }

  @action
  setShowTextFormField(bool value) {
    showTextFormField = value;
  }

  @action
  alterarNome(String name) {
    novaAreaName = TextEditingController(text: name);
  }
}
