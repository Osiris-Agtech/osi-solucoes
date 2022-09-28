import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'lote_store.g.dart';

class LoteStore = _LoteStoreBase with _$LoteStore;

abstract class _LoteStoreBase with Store {
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
  bool isDetalhesLoteLoading = false;

  @observable
  Lote loteSelecionado = Lote();

  @action
  selecionarLote(Lote lote) => loteSelecionado = lote;

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

  // ##################### END DETALHES LOTE ########################

  // #################### START CADASTRAR LOTE ######################

  @observable
  bool showTextFormField = false;

  @observable
  bool isNovaAreaLoading = false;

  @observable
  int dotIndicator = 1;

  @observable
  List<Cultura> culturaList = [];

  @observable
  Setor novoLoteSetor = Setor();

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
  setDotIndicator(int value) {
    if (value >= 0 && value <= 4) {
      dotIndicator = value;
    }
  }

  @action
  buscarCulturas() async {
    AuthController authController = GetIt.I<AuthController>();
    LoteRepository loteRepository = GetIt.I<LoteRepository>();

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

  // ##################### END CADASTRAR LOTE ######################
}
