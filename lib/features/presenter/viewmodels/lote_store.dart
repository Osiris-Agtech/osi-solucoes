import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';

import '../models/area/area_model.dart';

part 'lote_store.g.dart';

class LoteStore = LoteStoreBase with _$LoteStore;

abstract class LoteStoreBase with Store {
  LoteRepository loteRepository = GetIt.I<LoteRepository>();
  AuthController authController = GetIt.I<AuthController>();

  @observable
  bool isLoteListLoading = false;

  @observable
  bool isProtocoloListLoading = false;

  @observable
  String dropDownValue = "Nome";

  @observable
  String searchLoteText = '';

  @observable
  String order = "asc";

  @observable
  Setor setorSelecionado = Setor();

  @observable
  List<Lote> loteList = [];

  @observable
  List<Protocolo> protocoloList = [];

  @observable
  List<Fase> listaFaseDetalhes = [];

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
  String changeOrder() => order == "asc" ? order = "desc" : order = "asc";

  @action
  Setor setSetorSelecionado(Setor setor) => setorSelecionado = setor;

  @action
  String setDropDown(String value) => dropDownValue = value;

  @action
  String setSearchLoteText(String value) => searchLoteText = value;

  @action
  Future<void> buscarLotes() async {
    isLoteListLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lotes = await loteRepository.buscarLotes(
      setorSelecionado.id!,
      dropDownValue,
      order,
      data1,
      data2,
    );

    lotes.fold(
      (err) {
        //toastError(message: err.message);
        loteList = [];
      },
      (data) async {
        loteList = List.from(data);
      },
    );

    isLoteListLoading = false;
  }

  @computed
  List<Lote> get searchLote {
    List<Lote> result = loteList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchLoteText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  // #################### START DETALHES LOTE #######################

  @observable
  List<Area> areaList = [];

  @observable
  bool isAreaLoading = false;

  @observable
  bool isDetalhesLoteLoading = false;

  @observable
  bool isMigrateLoteLoading = false;

  @observable
  Lote loteSelecionado = Lote();

  @observable
  Area areaSelecionada = Area();

  @observable
  Setor setorSelecionadoMigrar = Setor();

  @action
  Setor selecionarSetorMigrar(Setor? setor) =>
      setorSelecionadoMigrar = setor ?? Setor();

  @computed
  bool get validarMigracao {
    if (areaSelecionada.setores!.isEmpty) {
      return false;
    }

    if (setorSelecionadoMigrar.id == null) {
      return false;
    }

    if (loteSelecionado.id == null) {
      return false;
    }

    return true;
  }

  @action
  Future<void> migrarLote(bool migrarReservatorio) async {
    isMigrateLoteLoading = true;

    SetorStore setorStore = GetIt.I<SetorStore>();
    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lote = await loteRepository.migrarLote(
      loteSelecionado.id!,
      setorSelecionadoMigrar.id!,
      migrarReservatorio
          ? setorSelecionadoMigrar.reservatorio!.id
          : loteSelecionado.reservatorio!.id,
    );

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        limparTudo();
        Get.close(4);
        setorStore.buscarSetores();
      },
    );

    isMigrateLoteLoading = false;
  }

  @action
  Lote selecionarLote(Lote lote) => loteSelecionado = lote;

  @action
  Area selecionarArea(Area area) => areaSelecionada = area;

  @observable
  bool isLoadingLotePorId = false;

  /// Busca um lote por ID e prepara o store para navegação direta (ex: atalhos da home).
  /// Retorna true se bem-sucedido, false caso contrário.
  @action
  Future<bool> buscarLotePorId(int id) async {
    isLoadingLotePorId = true;
    try {
      final result = await loteRepository.buscarDetalhesLote(id);
      return result.fold(
        (err) {
          toastError(message: 'Lote não encontrado');
          return false;
        },
        (lote) {
          selecionarLote(lote);
          if (lote.setor?.id != null) {
            setSetorSelecionado(lote.setor!);
          }
          return true;
        },
      );
    } finally {
      isLoadingLotePorId = false;
    }
  }

  @action
  Future<void> buscarDetalhesLote() async {
    isDetalhesLoteLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lote = await loteRepository.buscarDetalhesLote(loteSelecionado.id!);

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        loteSelecionado = data;
        bandeijasSemeadasController = TextEditingController(
          text: (loteSelecionado.bandeijas_semeadas ?? 0).toString(),
        );
        mudasTransplantadasController = TextEditingController(
          text: (loteSelecionado.mudas_transplantadas ?? 0).toString(),
        );
        plantasColhidasController = TextEditingController(
          text: (loteSelecionado.plantas_colhidas ?? 0).toString(),
        );
        embalagensProduzidasController = TextEditingController(
          text: (loteSelecionado.embalagens_produzidas ?? 0).toString(),
        );
        registroData = loteSelecionado.registro_data ?? DateTime.now();
        semeaduraData = loteSelecionado.semeadura_data;
        transplantioData = loteSelecionado.transplantio_data;
        colheitaData = loteSelecionado.colheita_data;
      },
    );

    isDetalhesLoteLoading = false;
  }

  @action
  Future<void> buscarAreasList() async {
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
  bool mostrarErroFormulario = false;

  @observable
  bool showTextFormField = false;

  @observable
  bool isEditing = false;

  @observable
  bool isBandeijasEditing = false;

  @observable
  bool isMudasEditing = false;

  @observable
  bool isPlantasEditing = false;

  @observable
  bool isEmbalagensEditing = false;

  @observable
  bool isVisible = false;

  @observable
  bool isNovaAreaLoading = false;

  @observable
  bool isNovoLoteLoading = false;

  @observable
  bool showReservatorioDetalhes = false;

  @observable
  bool showProtocoloDetalhes = false;

  @observable
  bool isNovaCultura = false;

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
  TextEditingController novaCulturaController = TextEditingController();

  @observable
  TextEditingController bandeijasSemeadasController = TextEditingController();

  @observable
  TextEditingController mudasTransplantadasController = TextEditingController();

  @observable
  TextEditingController plantasColhidasController = TextEditingController();

  @observable
  TextEditingController embalagensProduzidasController =
      TextEditingController();

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
  Protocolo? protocoloDetalhes;

  @observable
  Protocolo? protocoloVinculado;

  @observable
  String searchProtocoloText = '';

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoNutritivaList = [];

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

  @observable
  Lote novoLote = Lote();

  @observable
  bool abrirProtocoloDetalhesAtv = false;

  @observable
  bool isProtocoloValid = false;

  @action
  void toggleAbrirProtocoloDetalhesAtv() {
    abrirProtocoloDetalhesAtv = !abrirProtocoloDetalhesAtv;
  }

  @action
  Area selecionarNovoLoteArea(Area area) => novoLoteArea = area;

  @action
  Setor selecionarNovoLoteSetor(Setor setor) => novoLoteSetor = setor;

  @action
  bool setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  void carregarAreaSetor() {
    SetorStore setorStore = GetIt.I<SetorStore>();

    if (setorStore.areaSelecionada.id != null) {
      int index = areaList
          .indexWhere((element) => element.id == setorStore.areaSelecionada.id);
      if (index != -1) {
        selecionarNovoLoteArea(areaList[index]);

        int indexSetor = (novoLoteArea.setores ?? [])
            .indexWhere((element) => element.id == setorSelecionado.id);
        if (indexSetor != -1) {
          selecionarNovoLoteSetor(novoLoteArea.setores![indexSetor]);
        }
      }
    }
  }

  @action
  Cultura setNovoLoteCultura(int index) => novoLoteCultura = culturaList[index];

  @action
  void selecionarNovoLoteReservatorio() {
    novoLoteReservatorio = reservatorioDetalhes;
    setShowReservatorioDetalhes(false);
  }

  @action
  void selecionarNovoLoteProtocolo() {
    setShowReservatorioDetalhes(false);
  }

  @action
  DateTime setRegistroData(DateTime dateTime) => registroData = dateTime;

  @action
  DateTime setSemeaduraData(DateTime dateTime) => semeaduraData = dateTime;

  @action
  DateTime setTransplantioData(DateTime dateTime) =>
      transplantioData = dateTime;

  @action
  DateTime setColheitaData(DateTime dateTime) => colheitaData = dateTime;

  @action
  bool setIsEditing(bool value) => isEditing = value;

  @action
  void setIsBandeijaEditing(bool value) {
    isBandeijasEditing = value;
    if (!value &&
        bandeijasSemeadasController.text !=
            (loteSelecionado.bandeijas_semeadas ?? 0).toString()) {
      loteSelecionado.bandeijas_semeadas =
          int.parse(bandeijasSemeadasController.text);
      alterarProducaoLote();
    }
  }

  @action
  void setIsMudasEditing(bool value) {
    isMudasEditing = value;
    if (!value &&
        mudasTransplantadasController.text !=
            (loteSelecionado.mudas_transplantadas ?? 0).toString()) {
      loteSelecionado.mudas_transplantadas =
          int.parse(mudasTransplantadasController.text);
      alterarProducaoLote();
    }
  }

  @action
  void setIsPlantasEditing(bool value) {
    isPlantasEditing = value;
    if (!value &&
        plantasColhidasController.text !=
            (loteSelecionado.plantas_colhidas ?? 0).toString()) {
      loteSelecionado.plantas_colhidas =
          int.parse(plantasColhidasController.text);
      alterarProducaoLote();
    }
  }

  @action
  void setIsEmbalagensEditing(bool value) {
    isEmbalagensEditing = value;
    if (!value &&
        embalagensProduzidasController.text !=
            (loteSelecionado.embalagens_produzidas ?? 0).toString()) {
      loteSelecionado.embalagens_produzidas =
          int.parse(embalagensProduzidasController.text);
      alterarProducaoLote();
    }
  }

  @action
  void alterarNome(String name) {
    novoLoteName = TextEditingController(text: name);
  }

  @action
  void setLoteEditing(Lote lote) {
    novoLoteName = TextEditingController(text: lote.nome);
    novoLoteCultura = lote.cultura ?? Cultura();
    novoLoteReservatorio = lote.reservatorio ?? Reservatorio();
    novoLoteSetor = lote.setor ?? Setor();
    semeaduraData = lote.semeadura_data;
    registroData = lote.registro_data ?? DateTime.now();
    transplantioData = lote.transplantio_data;
    colheitaData = lote.colheita_data;

    novoLote = lote;
    setIsEditing(true);
    return;
  }

  @action
  void setDotIndicator(int value) {
    if (value >= 0 && value <= 4) {
      dotIndicator = value;
    }
  }

  @action
  Future<void> buscarCulturas() async {
    var culturas = await loteRepository
        .buscarCulturas(authController.usuario.selected_conta!.conta!.id!);

    culturas.fold(
      (err) {
        toastError(message: err.message);
        culturaList = [];
      },
      (data) async {
        culturaList = List.from(data);
        if (isEditing) {
          novoLoteCultura = culturaList
              .firstWhere((element) => element.id == novoLote.cultura!.id);
        }
      },
    );
  }

  @action
  Future<void> buscarReservatorios() async {
    var reservatorios = await loteRepository
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
  bool setShowReservatorioDetalhes(bool value) =>
      showReservatorioDetalhes = value;

  @action
  bool setShowProtocoloDetalhes(bool value) => showProtocoloDetalhes = value;

  @action
  bool setIsNovaCultura(bool value) => isNovaCultura = value;

  @action
  void setReservatorioDetalhes(Reservatorio reservatorio) {
    reservatorioDetalhes = reservatorio;
    showReservatorioDetalhes = true;
  }

  @action
  void setProtocoloDetalhes(Protocolo protocolo) {
    protocoloDetalhes = protocolo;
    showProtocoloDetalhes = true;
  }

  @action
  void removeProtocoloDetalhes() {
    protocoloDetalhes = null;
  }

  @action
  String setSearchProtocoloText(String value) => searchProtocoloText = value;

  @computed
  List<Protocolo> get searchProtocolo {
    List<Protocolo> result = protocoloList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchProtocoloText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  @action
  void setProtocolo(Protocolo protocolo) {
    protocoloVinculado = protocolo;
    isProtocoloValid = true;
  }

  @action
  void desvincularProtocolo() {
    protocoloVinculado = null;
    isProtocoloValid = false;
  }

  @action
  Future<void> buscarReservatorioDetalhes() async {
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
  void prepararListaDetalhesFase() {
    listaFaseDetalhes.clear();
    if (protocoloDetalhes == null) {
      return;
    } // Limpa a lista antes de adicionar novas fases
    if (protocoloDetalhes!.acao != null) {
      for (var acao in protocoloDetalhes!.acao!) {
        if (acao.fase != null) {
          var fase = listaFaseDetalhes.firstWhere(
            (f) => f.id == acao.fase!.id,
            orElse: () => Fase(),
          );

          if (fase.id == null) {
            acao.fase!.acao = [acao];
            listaFaseDetalhes.add(acao.fase!);
          } else {
            fase.acao?.add(acao);
          }
        }
      }
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);
  }

  @action
  Future<void> registrarLote() async {
    SetorStore setorStore = GetIt.I<SetorStore>();

    isNovoLoteLoading = true;
    novoLote = Lote(
      nome: novoLoteName.text,
      setor: novoLoteSetor,
      cultura: novoLoteCultura,
      reservatorio:
          novoLoteReservatorio.id != null ? novoLoteReservatorio : null,
      registro_data: registroData,
      semeadura_data: semeaduraData,
      transplantio_data: transplantioData,
      colheita_data: colheitaData,
      protocolo: protocoloVinculado,
    );

    var lote = await loteRepository.registrarLote(
      novoLote,
      authController.usuario.selected_conta!.conta!.id!,
    );

    lote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        limparTudo();
        Get.close(1);
        setorStore.buscarSetores();
        GetIt.I<HomeStore>().carregarHome();
        if (setorSelecionado.id != null) {
          buscarLotes();
        }
      },
    );

    isNovoLoteLoading = false;
  }

  @action
  Future<void> registrarCultura() async {
    if (novaCulturaController.text.isNotEmpty) {
      Cultura novaCultura = Cultura(
        nome: novaCulturaController.text,
        privado: true,
      );

      var conta = await loteRepository.registrarCultura(
          novaCultura, authController.usuario.selected_conta!.conta!.id!);

      conta.fold(
        (err) {
          toastError(message: err.message);
        },
        (data) async {
          culturaList = List.from([data, ...culturaList]);
          setIsNovaCultura(false);
        },
      );
    }
  }

  @action
  bool validarRegistro() {
    bool isValid = novoLoteName.text.isNotEmpty &&
        novoLoteSetor.id != null &&
        novoLoteCultura.id != null;

    mostrarErroFormulario = !isValid;

    if (isValid) {
      return true;
    }

    toastError(message: "Preencha todos os campos obrigatórios");
    return false;
  }

  @action
  Future<void> alterarLote() async {
    LoteRepository loteRepository = GetIt.I<LoteRepository>();
    isNovoLoteLoading = true;

    novoLote = loteSelecionado;
    novoLote.nome = novoLoteName.text;
    novoLote.setor = novoLoteSetor;
    novoLote.cultura = novoLoteCultura;
    novoLote.reservatorio = novoLoteReservatorio;
    novoLote.registro_data = registroData;
    novoLote.semeadura_data = semeaduraData;
    novoLote.transplantio_data = transplantioData;
    novoLote.colheita_data = colheitaData;
    novoLote.protocolo = protocoloVinculado;

    var alterarLote = await loteRepository.alterarLote(novoLote);

    alterarLote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarDetalhesLote();
        buscarLotes();
        limparTudo();
        Get.close(1);
      },
    );

    isNovoLoteLoading = false;
  }

  @action
  Future<void> alterarProducaoLote() async {
    LoteRepository loteRepository = GetIt.I<LoteRepository>();
    isNovoLoteLoading = true;

    loteSelecionado.bandeijas_semeadas =
        int.parse(bandeijasSemeadasController.text);
    loteSelecionado.mudas_transplantadas =
        int.parse(mudasTransplantadasController.text);
    loteSelecionado.plantas_colhidas =
        int.parse(plantasColhidasController.text);
    loteSelecionado.embalagens_produzidas =
        int.parse(embalagensProduzidasController.text);

    var alterarLote = await loteRepository.alterarLote(loteSelecionado);

    alterarLote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarDetalhesLote();
      },
    );

    isNovoLoteLoading = false;
  }

  @action
  Future<void> alterarDatasLote() async {
    LoteRepository loteRepository = GetIt.I<LoteRepository>();
    isNovoLoteLoading = true;

    loteSelecionado.registro_data = registroData;
    loteSelecionado.semeadura_data = semeaduraData;
    loteSelecionado.transplantio_data = transplantioData;
    loteSelecionado.colheita_data = colheitaData;

    var alterarLote = await loteRepository.alterarLote(loteSelecionado);

    alterarLote.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarDetalhesLote();
      },
    );

    isNovoLoteLoading = false;
  }

  @computed
  bool get isAlreadySelected {
    return protocoloVinculado?.id != null &&
        protocoloVinculado?.id == protocoloDetalhes?.id;
  }

  void limparTudo() {
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
    protocoloVinculado = null;
    semeaduraData = null;
    transplantioData = null;
    colheitaData = null;
  }

  // ##################### END CADASTRAR LOTE ######################

  // ##################### START FINALIZAR LOTE ######################

  @observable
  TextEditingController searchLotePage = TextEditingController(text: '');

  @observable
  int? plantasColhidas;

  @observable
  int? embalagensProduzidas;

  @observable
  List<LoteSelection> finalizarLotes = [];

  @observable
  List<AgendaSelection> atividadesPendentes = [];

  @observable
  List<Agenda> atividadesDeletadas = [];

  @observable
  bool carregandoFinalizarLotes = false;

  @action
  void listaLotesParaFinalizar() {
    finalizarLotes.clear();
    for (var lote in loteList) {
      finalizarLotes.add(LoteSelection(lote: lote, selected: false));
    }
    finalizarLotes = List.from(finalizarLotes);
  }

  @action
  void setSeachLotePage(String value) {
    searchLotePage = TextEditingController(text: value);
  }

  @action
  void selecionarLoteParaFinalizar(int index) {
    finalizarLotes[index].selected = !finalizarLotes[index].selected;
    finalizarLotes = List.from(finalizarLotes);
  }

  @action
  void selecionarAtividadesParaFinalizar(int index) {
    atividadesPendentes[index].selected = !atividadesPendentes[index].selected;
    atividadesPendentes = List.from(atividadesPendentes);
  }

  @action
  void preencherPlantasColhidas(String value) {
    plantasColhidas = value.isNotEmpty ? int.parse(value) : 0;
  }

  @action
  void preencherEmbalagensProduzidas(String value) {
    embalagensProduzidas = value.isNotEmpty ? int.parse(value) : 0;
  }

  void salvarDetalhesLote(int loteId) {
    var loteSelecionado =
        finalizarLotes.firstWhere((element) => element.lote.id == loteId);

    loteSelecionado.lote.embalagens_produzidas = embalagensProduzidas;
    loteSelecionado.lote.plantas_colhidas = plantasColhidas;

    finalizarLotes = List.from(finalizarLotes);
  }

  @action
  void deletarAtividades(int index) {
    atividadesDeletadas.add(atividadesPendentes[index].agenda);
    atividadesPendentes.removeAt(index);

    atividadesPendentes = List.from(atividadesPendentes);
    atividadesDeletadas = List.from(atividadesDeletadas);
  }

  @action
  void verificarMarcarTodos() {
    for (var atividade in atividadesPendentes) {
      atividade.selected = true;
    }
    atividadesPendentes = List.from(atividadesPendentes);
  }

  @action
  bool podemosFinalizarLotes() {
    for (var element in lotesParaFinalizar) {
      if (element.lote.plantas_colhidas == null ||
          element.lote.embalagens_produzidas == null) {
        return false;
      }
    }
    return true;
  }

  @action
  Future<void> finalizarTodosLotes() async {
    isNovoLoteLoading = true;
    SetorStore setorStore = GetIt.I<SetorStore>();

    // Requisição para deleção de "agendas" selecionadas
    deletarAtividadesSelecionadas();

    // Requisição para finalização "agendas" selecionadas
    finalizarAtividadesSelecionadas();

    List<Lote> seletedLotes = [];
    for (var element in finalizarLotes) {
      if (element.selected) {
        seletedLotes.add(element.lote);
      }
    }

    if (seletedLotes.isEmpty) {
      toastError(message: 'Selecione ao menos um lote para finalizar');
      return;
    }

    var result = await loteRepository.finalizarLotes(seletedLotes);
    Get.close(1);

    result.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        limparTudo();
        Get.close(1);
        setorStore.buscarSetores();
        if (setorSelecionado.id != null) {
          buscarLotes();
        }
      },
    );

    isNovoLoteLoading = false;
  }

  @action
  Future<void> deletarAtividadesSelecionadas() async {
    var ids = atividadesDeletadas.map((e) => e.id).toList();

    var result = await loteRepository.deletarAtividades(ids.cast<int>());

    result.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {},
    );
  }

  @action
  Future<void> finalizarAtividadesSelecionadas() async {
    var ids = atividadesPendentes.map((e) => e.agenda.id).toList();

    var result = await loteRepository.finalizarAtividades(ids.cast<int>());

    result.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {},
    );
  }

  @action
  bool lotesSelecionadosEstaVazio() {
    return finalizarLotes.where((element) => element.selected).isEmpty;
  }

  @action
  Future<void> verificarAtividades() async {
    carregandoFinalizarLotes = true;

    var lotesIds = finalizarLotes
        .where((element) => element.selected)
        .map((e) => e.lote.id)
        .toList();

    var buscarAtividadesPendentes =
        await loteRepository.verificarAtividades(lotesIds.cast<int>());

    buscarAtividadesPendentes.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        atividadesPendentes = data
            .map((agenda) => AgendaSelection(agenda: agenda, selected: false))
            .toList();
      },
    );

    carregandoFinalizarLotes = false;
  }

  @action
  void limparFinalizacao() {
    finalizarLotes.clear();
    atividadesPendentes.clear();
    searchLotePage = TextEditingController(text: '');
  }

  @computed
  List<LoteSelection> get getLotesGroup => finalizarLotes.where((element) {
        if (searchLotePage.text.isEmpty) return true;
        return element.lote.nome!
            .toLowerCase()
            .contains(searchLotePage.text.toLowerCase());
      }).toList();

  @computed
  List<LoteSelection> get lotesParaFinalizar => getLotesGroup.where((element) {
        return element.selected == true;
      }).toList();

  @computed
  bool get marcarTodasAtividades =>
      !atividadesPendentes.any((element) => !element.selected);

  ///
  /// ------------------------ PÁGINA DE LOTES FINALIZADOS ------------------------
  ///
  @observable
  List<Lote> lotesFinalizados = [];

  @action
  Future<void> buscarLotesFinalizados() async {
    isLoteListLoading = true;

    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    // ---------------------- Buscar Areas ----------------------
    var areas = await loteRepository.buscarTodasAreasId(
      contaId: authController.usuario.selected_conta!.conta!.id!,
    );

    if (areas.isLeft()) {
      lotesFinalizados = List.from([]);
      showLotesFinalizadosErrorToast();
      return;
    }

    List<int> areasIds = areas.fold((err) => [], (data) => data);
    // ----------------------------------------------------------

    // ---------------------- Buscar Setores ----------------------
    var setores = await loteRepository.buscarTodosSetoresId(areasId: areasIds);

    if (setores.isLeft()) {
      lotesFinalizados = List.from([]);
      showLotesFinalizadosErrorToast();
      return;
    }

    List<int> setoresIds = setores.fold((err) => [], (data) => data);
    // ----------------------------------------------------------

    // ---------------------- Buscar Lotes Finalizados ----------------------
    var lotes =
        await loteRepository.buscarLotesFinalizados(setoresId: setoresIds);

    if (lotes.isLeft()) {
      lotesFinalizados = List.from([]);
      showLotesFinalizadosErrorToast();
      return;
    }

    lotesFinalizados = List.from(lotes.fold((err) => [], (data) => data));
    // ----------------------------------------------------------

    isLoteListLoading = false;
  }

  void showLotesFinalizadosErrorToast() {
    toastError(message: 'Ocorreu um erro ao buscar os lotes finalizados');
  }
}
