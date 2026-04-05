import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

part 'setor_store.g.dart';

class SetorStore = SetorStoreBase with _$SetorStore;

abstract class SetorStoreBase with Store {
  SetorRepository setorRepository = GetIt.I<SetorRepository>();
  AuthController authController = GetIt.I<AuthController>();

  // #################### START LISTAGEM SETOR #######################

  @observable
  String searchSetorText = '';

  @observable
  String dropDownValue = "Nome";

  @observable
  String order = "asc";

  @observable
  bool isSetorListLoading = false;

  @observable
  Area areaSelecionada = Area();

  @observable
  List<Setor> setorList = [];

  @action
  String changeOrder() => order == "asc" ? order = "desc" : order = "asc";

  @observable
  DateTime data1 = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);

  @observable
  DateTime data2 = DateTime.now();

  @action
  DateTime setData1(DateTime value) => data1 = value;

  @action
  DateTime setData2(DateTime value) => data2 = value;

  @action
  Area setAreaSelecionada(Area estufa) => areaSelecionada = estufa;

  @action
  String setDropDown(String value) => dropDownValue = value;

  @action
  String setSearchSetorText(String value) => searchSetorText = value;

  @action
  Future<void> buscarSetores() async {
    isSetorListLoading = true;

    SetorRepository setorRepository = GetIt.I<SetorRepository>();

    var setores = await setorRepository.buscarSetores(
      areaSelecionada.id!,
      dropDownValue,
      order,
      data1,
      data2,
    );

    setores.fold(
      (err) {
        //toastError(message: err.message);
        setorList = [];
      },
      (data) async {
        setorList = List.from(data);
      },
    );

    isSetorListLoading = false;
  }

  @computed
  List<Setor> get searchSetor {
    List<Setor> result = setorList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchSetorText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  // #################### END LISTAGEM SETOR #######################

  // #################### START CADASTRO SETOR #######################

  @observable
  bool isEditing = false;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  List<Reservatorio> reservatorioList = [];

  @observable
  TextEditingController novoSetorName = TextEditingController(text: '');

  @observable
  TextEditingController novoSetorDescription = TextEditingController();

  @observable
  Reservatorio novoSetorReservatorio = Reservatorio();

  @observable
  bool showTextFormField = false;

  @observable
  bool isNovoSetorLoading = false;

  @observable
  int dotIndicator = 1;

  @observable
  Setor novoSetor = Setor();

  @action
  bool setIsEditing(bool value) => isEditing = value;

  @action
  bool setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  void setSetorEditing(Setor setor) {
    novoSetorName = TextEditingController(text: setor.nome);
    novoSetorDescription = TextEditingController(text: setor.descricao);
    novoSetorReservatorio = setor.reservatorio ?? Reservatorio();
    areaSelecionada = setor.area!;
    novoSetor = setor;
    setIsEditing(true);
    return;
  }

  @action
  void setDotIndicator(int value) {
    if (value >= 0 && value <= 1) {
      dotIndicator = value;
    }
  }

  @action
  void setShowTextFormField(bool value) {
    showTextFormField = value;
  }

  @action
  Future<void> buscarReservatorios() async {
    var reservatorios = await setorRepository
        .buscarReservatorios(authController.usuario.selected_conta!.conta!.id!);

    reservatorios.fold(
      (err) {
        reservatorioList = List.from([]);
      },
      (data) async {
        reservatorioList = List.from(data);
      },
    );
  }

  @action
  void limparTudo() {
    reservatorioList.clear();
    novoSetorName.clear();
    novoSetorDescription.clear();
    novoSetorReservatorio = Reservatorio();
  }

  @action
  void alterarNome(String name) {
    novoSetorName = TextEditingController(text: name);
  }

  @action
  Reservatorio setReservatorioSelecionada(Reservatorio reservatorio) =>
      novoSetorReservatorio = reservatorio;

  @action
  bool validarCadastro() {
    bool validate = novoSetorName.text.isNotEmpty;

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  Future<void> registrarSetor() async {
    SetorRepository setorRepository = GetIt.I<SetorRepository>();
    AreaCultivoStore areaCultivoStore = GetIt.I<AreaCultivoStore>();

    isNovoSetorLoading = true;

    novoSetor = Setor(
      nome: novoSetorName.text,
      descricao: novoSetorDescription.text,
      reservatorio: novoSetorReservatorio,
      area: areaSelecionada,
    );

    var registrarSetor = await setorRepository.cadastrarSetor(novoSetor);

    registrarSetor.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        buscarSetores();
        areaCultivoStore.buscarArea();
        limparTudo();
        Get.close(1);
      },
    );

    isNovoSetorLoading = false;
  }

  @action
  Future<void> alterarSetor() async {
    SetorRepository setorRepository = GetIt.I<SetorRepository>();
    LoteStore loteStore = GetIt.I<LoteStore>();
    isNovoSetorLoading = true;

    novoSetor.nome = novoSetorName.text;
    novoSetor.descricao = novoSetorDescription.text;
    novoSetor.reservatorio = novoSetorReservatorio;
    novoSetor.area = areaSelecionada;

    var alterarSetor = await setorRepository.alterarSetor(novoSetor);

    alterarSetor.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarSetores();
        limparTudo();
        Get.close(2);
        loteStore.setSetorSelecionado(data);
        Get.toNamed(Routes.lotePage);
      },
    );

    isNovoSetorLoading = false;
  }
  // #################### END CADASTRO SETOR #######################
}
