import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../models/area/area_model.dart';

part 'lote_store.g.dart';

class LoteStore = _LoteStoreBase with _$LoteStore;

abstract class _LoteStoreBase with Store {
  LoteRepository loteRepository = GetIt.I<LoteRepository>();
  AuthController authController = GetIt.I<AuthController>();

  @observable
  bool isLoteListLoading = false;

  @observable
  Setor setorSelecionado = Setor();

  @observable
  List<Lote> loteList = [];

  @action
  setSetorSelecionado(Setor setor) => setorSelecionado = setor;

  @action
  buscarLotes() async {
    isLoteListLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lotes = await loteRepository.buscarLotes(setorSelecionado.id!);

    lotes.fold(
      (err) {
        toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  // #################### START DETALHES LOTE #######################

  @observable
  List<Area> areaList = [];

  @observable
  bool isAreaLoading = false;

  @observable
  bool isDetalhesLoteLoading = false;

  @observable
  Lote loteSelecionado = Lote();

  @observable
  Area areaSelecionada = Area();

  @observable
  Setor setorSelecionadoMigrar = Setor();

  @action
  selecionarSetorMigrar(Setor setor) => setorSelecionadoMigrar = setor;

  @action
  selecionarLote(Lote lote) => loteSelecionado = lote;

  @action
  selecionarArea(Area area) => areaSelecionada = area;

  @action
  buscarDetalhesLote() async {
    isDetalhesLoteLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lote = await loteRepository.buscarDetalhesLote(loteSelecionado.id!);

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        loteSelecionado = data;
      },
    );

    isDetalhesLoteLoading = false;
  }

  @action
  buscarAreasList() async {
    isAreaLoading = true;

    var areaListResult = await loteRepository
        .buscarAreasList(authController.usuario.selected_conta!.conta!.id!);

    areaListResult.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        areaList = List.from(data);
      },
    );
    isAreaLoading = false;
  }

  // ##################### END DETALHES LOTE ########################

  // #################### START CADASTRAR LOTE ######################

  @observable
  bool showTextFormField = false;

  @observable
  bool isVisible = false;

  @observable
  bool isNovaAreaLoading = false;

  @observable
  bool isNovoLoteLoading = false;

  @observable
  bool showReservatorioDetalhes = false;

  @observable
  int dotIndicator = 1;

  @observable
  List<Cultura> culturaList = [];

  @observable
  Setor novoLoteSetor = Setor();

  @observable
  Area novoLoteArea = Area();

  @observable
  TextEditingController novoLoteName = TextEditingController();

  @observable
  Cultura novoLoteCultura = Cultura();

  @observable
  Reservatorio novoLoteReservatorio = Reservatorio();

  @observable
  DateTime registroData = DateTime.now();

  @observable
  DateTime? semeaduraData;

  @observable
  DateTime? transplantioData;

  @observable
  DateTime? colheitaData;

  // @observable
  // Fase novoLoteFase = Fase();

  @observable
  TextEditingController novoLoteDescricao = TextEditingController();

  @observable
  List<Reservatorio> reservatorioList = [];

  @observable
  Reservatorio reservatorioDetalhes = Reservatorio();

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoNutritivaList = [];

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

  @action
  selecionarNovoLoteArea(Area area) => novoLoteArea = area;

  @action
  selecionarNovoLoteSetor(Setor setor) => novoLoteSetor = setor;

  @action
  setNovoLoteCultura(int index) => novoLoteCultura = culturaList[index];

  @action
  selecionarNovoLoteReservatorio() =>
      novoLoteReservatorio = reservatorioDetalhes;

  @action
  setRegistroData(DateTime dateTime) => registroData = dateTime;

  @action
  setSemeaduraData(DateTime dateTime) => semeaduraData = dateTime;

  @action
  setTransplantioData(DateTime dateTime) => transplantioData = dateTime;

  @action
  setColheitaData(DateTime dateTime) => colheitaData = dateTime;

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 4) {
      dotIndicator = value;
    }
  }

  @action
  buscarCulturas() async {
    var culturas = await loteRepository
        .buscarCulturas(authController.usuario.selected_conta!.conta!.id!);

    culturas.fold(
      (err) {
        toastError(message: err.message);
        culturaList = [];
      },
      (data) async {
        culturaList = List.from(data);
      },
    );
  }

  @action
  buscarReservatorios() async {
    var reservatorios = await loteRepository
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
  setShowReservatorioDetalhes(bool value) => showReservatorioDetalhes = value;

  @action
  setReservatorioDetalhes(Reservatorio reservatorio) {
    reservatorioDetalhes = reservatorio;
    showReservatorioDetalhes = true;
  }

  @action
  buscarReservatorioDetalhes() async {
    var reservatorios = await loteRepository
        .buscarReservatorioDetalhes(reservatorioDetalhes.id!);

    reservatorios.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        reservatorioDetalhes = data;
        solucaoNutritivaList = [];
        solucaoConcentradaList = [];
        reservatorioDetalhes.solucao?.solucoes_fertilizantes_concentradas
            ?.forEach(
          (element) {
            if (element.concentrada == null) {
              solucaoNutritivaList.add(element);
            } else {
              solucaoConcentradaList.add(element);
            }
          },
        );
      },
    );

    solucaoNutritivaList = List.from(solucaoNutritivaList);
    solucaoConcentradaList = List.from(solucaoConcentradaList);
  }

  @action
  registrarLote() async {
    isNovoLoteLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    if (validarRegistro()) {
      Lote novoLote = Lote(
        nome: novoLoteName.text,
        setor: novoLoteSetor,
        cultura: novoLoteCultura,
        reservatorio: novoLoteReservatorio,
        registro_data: registroData,
        semeadura_data: semeaduraData,
        transplantio_data: transplantioData,
        colheita_data: colheitaData,
      );

      var lote = await loteRepository.registrarLote(novoLote);

      lote.fold(
        (err) {
          toastError(message: err.message);
        },
        (data) async {
          limparTudo();
          Get.close(1);
          if (setorSelecionado.id != null) {
            buscarLotes();
          }
        },
      );
    }

    isNovoLoteLoading = false;
  }

  @action
  validarRegistro() {
    bool isValid = novoLoteName.text.isNotEmpty &&
        novoLoteSetor.id != null &&
        novoLoteCultura.id != null &&
        novoLoteReservatorio.id != null;

    if (isValid) {
      return true;
    }

    toastError(message: "Preencha todos os campos obrigatórios");
    return false;
  }

  limparTudo() {
    showTextFormField = false;
    isVisible = false;
    showReservatorioDetalhes = false;
    culturaList = [];
    novoLoteSetor = Setor();
    novoLoteArea = Area();
    novoLoteName = TextEditingController();
    novoLoteCultura = Cultura();
    novoLoteReservatorio = Reservatorio();
    novoLoteDescricao = TextEditingController();
    reservatorioList = [];
    reservatorioDetalhes = Reservatorio();
    solucaoNutritivaList = [];
    solucaoConcentradaList = [];
    registroData = DateTime.now();
    semeaduraData = null;
    transplantioData = null;
    colheitaData = null;
  }

  // ##################### END CADASTRAR LOTE ######################
}
