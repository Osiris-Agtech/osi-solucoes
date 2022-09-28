import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'setor_store.g.dart';

class SetorStore = _SetorStoreBase with _$SetorStore;

abstract class _SetorStoreBase with Store {
  SetorRepository setorRepository = GetIt.I<SetorRepository>();
  AuthController authController = GetIt.I<AuthController>();

  // #################### START LISTAGEM SETOR #######################

  @observable
  bool isSetorListLoading = false;

  @observable
  Area areaSelecionada = Area();

  @observable
  List<Setor> setorList = [];

  @action
  setAreaSelecionada(Area estufa) => areaSelecionada = estufa;

  @action
  buscarSetores() async {
    isSetorListLoading = true;

    SetorRepository setorRepository = GetIt.I<SetorRepository>();

    var setores = await setorRepository.buscarSetores(areaSelecionada.id!);

    setores.fold(
      (err) {
        toastError(message: err.message);
        setorList = [];
      },
      (data) async {
        setorList = List.from(data);
      },
    );

    isSetorListLoading = false;
  }
  // #################### END LISTAGEM SETOR #######################

  // #################### START CADASTRO SETOR #######################

  @observable
  List<Reservatorio> reservatorioList = [];

  @observable
  Reservatorio? selectedReservatorio;

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
  selectReservatorio(Reservatorio reservatorio) {
    selectedReservatorio = reservatorio;
  }

  @action
  buscarReservatorios() async {
    var reservatorios = await setorRepository
        .buscarReservatorios(authController.usuario.selected_conta!.conta!.id!);

    reservatorios.fold(
      (err) {
        reservatorioList = List.from([]);
        toastError(message: err.message);
      },
      (data) async {
        reservatorioList = List.from(data);
      },
    );
  }

    @action
  registrarSetor() async {
    AuthController authController = GetIt.I<AuthController>();
    SetorRepository setorRepository = GetIt.I<SetorRepository>();
    isNovoSetorLoading = true;

    Setor novoSetor = Setor(
      nome: novoSetorName.text,
      descricao: novoSetorDescription.text,
      reservatorio: selectedReservatorio,
      area: area,
    );

    var registrarSetor = await setorRepository.cadastrarSetor(novoSetor);

    registrarSetor.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        buscarSetores();
        limparTudo();
        Get.close(1);
      },
    );

    isNovoSetorLoading = false;
  }

  @action
  limparTudo() {
    reservatorioList.clear();
    novoSetorName.clear();
    novoSetorDescription.clear();
    novoSetorReservatorio = Reservatorio();
  }

  // #################### END CADASTRO SETOR #######################

}
