import 'package:flutter/material.dart';
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
  bool isNovaAreaLoading = false;

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

  // @observable
  // Fase novoLoteFase = Fase();

  @observable
  TextEditingController novoLoteDescricao = TextEditingController();

  @action
  selecionarNovoLoteArea(Area area) => novoLoteArea = area;

  @action
  selecionarNovoLoteSetor(Setor setor) => novoLoteSetor = setor;

  @action
  setNovoLoteCultura(int index) => novoLoteCultura = culturaList[index];

  @action
  selecionarNovoLoteReservatorio() =>
      novoLoteReservatorio = reservatorioDetalhes;

  @observable
  List<Reservatorio> reservatorioList = [];

  @observable
  Reservatorio reservatorioDetalhes = Reservatorio();

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoNutritivaList = [];

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

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
    Lote novoLote = Lote(
      nome: novoLoteName.text,
      setor: novoLoteSetor,
      cultura: novoLoteCultura,
      reservatorio: novoLoteReservatorio,
    );

    var lote = await loteRepository.registrarLote(novoLote);

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        print("Deu bom!");
      },
    );
  }

  // ##################### END CADASTRAR LOTE ######################
}
