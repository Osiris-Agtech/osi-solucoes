import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/reservatorio/reservatorio_repository.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'reservatorios_store.g.dart';

class ReservatoriosStore = _ReservatoriosStoreBase with _$ReservatoriosStore;

abstract class _ReservatoriosStoreBase with Store {
  ReservatorioRepository reservatorioRepository =
      GetIt.I<ReservatorioRepository>();
  AuthController authController = GetIt.I<AuthController>();
// ------------------------ NOVO RESERVATÓRIO ----------------------------------

  SolucaoNutritiva solucaoTest = SolucaoNutritiva(
    id: 1,
    nome: "Furlani",
    c_eletrica: "1.8",
    created_at: DateTime.now(),
    reservatorios: [],
  );

  @observable
  bool isSolucaoListLoading = false;

  @observable
  bool isReservatorioListLoading = false;

  @observable
  bool isNovoReservatorioLoading = false;

  @observable
  List<SolucaoNutritiva> solucaoList = [];

  @observable
  List<Reservatorio> reservatorioList = [];

  @observable
  Reservatorio novoReservatorio = Reservatorio();

  @observable
  SolucaoNutritiva solucaoNutritiva = SolucaoNutritiva();

  @observable
  bool isSolucaoNutritivaValid = false;

  @observable
  TextEditingController novoReservatorioName = TextEditingController();

  @observable
  TextEditingController novoReservatorioVolume = TextEditingController();

  @observable
  int dotIndicator = 1;

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 2) {
      dotIndicator = value;
      print(dotIndicator);
    }
  }

  @action
  setSolucaoNutritiva(SolucaoNutritiva solucao) {
    solucaoNutritiva = solucao;
    isSolucaoNutritivaValid = true;
  }

  @action
  buscarReservatorios() async {
    isReservatorioListLoading = true;

    var reservatorios = await reservatorioRepository
        .buscarReservatorios(authController.usuario.selected_conta!.conta!.id!);

    reservatorios.fold(
      (err) {
        print("FALHOU");
      },
      (data) async {
        reservatorioList = List.from(data);
        reservatorioList.add(data[0]);
        reservatorioList.add(data[0]);
        reservatorioList.add(data[0]);
        reservatorioList.add(data[0]);
        reservatorioList.add(data[0]);
        reservatorioList = List.from(reservatorioList);
      },
    );

    isReservatorioListLoading = false;
  }

  @action
  buscarSolucoes() async {
    isSolucaoListLoading = true;

    var solucoes = await reservatorioRepository
        .buscarSolucoes(authController.usuario.selected_conta!.conta!.id!);

    solucoes.fold(
      (err) {
        print("FALHOU");
      },
      (data) async {
        solucaoList = List.from(data);
      },
    );

    isSolucaoListLoading = false;
  }

  @action
  registrarReservatorio() async {
    isNovoReservatorioLoading = true;

    novoReservatorio = Reservatorio(
      nome: novoReservatorioName.text,
      volume: novoReservatorioVolume.text,
      solucao: solucaoNutritiva,
      conta: authController.usuario.selected_conta?.conta,
    );

    var registrarReservatorio =
        await reservatorioRepository.registrarReservatorio(novoReservatorio);

    registrarReservatorio.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        buscarReservatorios();
        limparNovoReservatorio();
        Get.close(1);
      },
    );

    isNovoReservatorioLoading = false;
  }

  @action
  limparNovoReservatorio() {
    isSolucaoNutritivaValid = false;
    novoReservatorio = Reservatorio();
    solucaoNutritiva = SolucaoNutritiva();
    novoReservatorioName.clear();
    novoReservatorioVolume.clear();
  }
}
