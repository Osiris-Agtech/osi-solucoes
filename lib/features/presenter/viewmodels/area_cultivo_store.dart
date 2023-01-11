import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/area/area_repository.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:search_cep/search_cep.dart';

import '../../../core/utils/toast.dart';
import '../models/area/area_model.dart';
import '../models/localizacao/localizacao_model.dart';

part 'area_cultivo_store.g.dart';

class AreaCultivoStore = _AreaCultivoStoreBase with _$AreaCultivoStore;

abstract class _AreaCultivoStoreBase with Store {
  @observable
  bool isAreaLoading = false;

  @observable
  String dropDownValue = "Nome";

  @action
  setDropDown(String value) => dropDownValue = value;

  @observable
  String order = "asc";

  @action
  changeOrder() => order == "asc" ? order = "desc" : order = "asc";

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

  @observable
  List<Area> areaList = [];

  @action
  buscarArea() async {
    isAreaLoading = true;
    AreaRepository areaRepository = GetIt.I<AreaRepository>();
    AuthController authController = GetIt.I<AuthController>();

    var areaListResult = await areaRepository.buscarArea(
      authController.usuario.selected_conta!.conta!.id!,
      dropDownValue,
      order,
      data1,
      data2,
    );

    areaListResult.fold(
      (err) {
        //toastError(message: err.message);
      },
      (data) async {
        areaList = List.from(data);
      },
    );
    isAreaLoading = false;
  }

  @observable
  String searchAreaText = '';

  @action
  setSearchAreaText(String value) => searchAreaText = value;

  @computed
  List<Area> get searchArea {
    List<Area> result = areaList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchAreaText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  //####################### START CADASTRAR AREA DE CULTIVO ##########################

  @observable
  bool isNovaAreaLoading = false;

  @observable
  bool showTextFormField = false;

  @observable
  bool isEditing = false;

  @observable
  int dotIndicator = 1;

  @observable
  List<Localizacao> localizacaoList = [];

  @observable
  Area novaArea = Area();

  @observable
  String? responseCEP;

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
  setIsEditing(bool value) => isEditing = value;

  @action
  setAreaEditing(Area area) {
    novaAreaName = TextEditingController(text: area.nome);
    novaAreaDescricao = TextEditingController(text: area.descricao);
    localizacaoSelecionada = area.localizacao!;
    novaArea = area;
    setIsEditing(true);
    return;
  }

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
  buscarLocalizacoes() async {
    AreaRepository areaRepository = GetIt.I<AreaRepository>();
    AuthController authController = GetIt.I<AuthController>();

    var localizaoListResult = await areaRepository
        .buscarLocalizacoes(authController.usuario.selected_conta!.conta!.id!);

    localizaoListResult.fold(
      (err) {
        //toastError(message: err.message);
      },
      (data) async {
        localizacaoList = List.from(data);
      },
    );
  }

  @action
  registrarArea() async {
    AuthController authController = GetIt.I<AuthController>();
    AreaRepository areaRepository = GetIt.I<AreaRepository>();
    isNovaAreaLoading = true;

    novaArea = Area(
      nome: novaAreaName.text,
      descricao: novaAreaDescricao.text,
      tipo: 'hidroponia',
      conta: authController.usuario.selected_conta!.conta,
      localizacao: localizacaoSelecionada,
    );

    var registrarArea = await areaRepository.registrarArea(novaArea);

    registrarArea.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        buscarArea();
        limparTudo();
        Get.close(1);
      },
    );

    isNovaAreaLoading = false;
  }

  @action
  alterarArea() async {
    AuthController authController = GetIt.I<AuthController>();
    AreaRepository areaRepository = GetIt.I<AreaRepository>();
    SetorStore setorStore = GetIt.I<SetorStore>();

    isNovaAreaLoading = true;

    novaArea.nome = novaAreaName.text;
    novaArea.descricao = novaAreaDescricao.text;
    novaArea.tipo = 'hidroponia';
    novaArea.conta = authController.usuario.selected_conta!.conta;
    novaArea.localizacao = localizacaoSelecionada;

    var alterarArea = await areaRepository.alterarArea(novaArea);

    alterarArea.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarArea();
        limparTudo();
        Get.close(2);
        setorStore.setAreaSelecionada(data);
        Get.toNamed(Routes.setorPage);
      },
    );

    isNovaAreaLoading = false;
  }

  @action
  setLocalizacaoSelecionada(int index) =>
      localizacaoSelecionada = localizacaoList[index];

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

  @action
  Future<String> buscaCEP() async {
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
        cep: cep.text.replaceAll(".", '').replaceAll("-", ""));
    if (infoCepJSON.isRight()) {
      Right(infoCepJSON).value.map(
            (r) => {
              endereco.text = r.logradouro ?? '',
              complemento.text = r.complemento ?? '',
              bairro.text = r.bairro ?? '',
              cidade.text = r.localidade ?? '',
              estado.text = r.uf ?? '',
              pais.text = "Brasil",
            },
          );
      return "Sucess";
    } else {
      // logradouro.clear();
      // complemento.clear();
      // bairro.clear();
      // cidade.clear();
      // estado.clear();
      return "Error";
    }
  }

  //####################### END CADASTRAR AREA DE CULTIVO ##########################

  @action
  limparTudo() {
    novaAreaName.clear();
    novaAreaDescricao.clear();
    limparLocalizacao();
    localizacaoList.clear();
    localizacaoSelecionada = Localizacao();
  }
}
