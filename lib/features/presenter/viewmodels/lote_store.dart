import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:sigma_hort_gestao_producao/core/utils/toast.dart';
import 'package:sigma_hort_gestao_producao/features/data/repositories/lote/lote_repository.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/cultura/cultura_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/lote/lote_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/setor/setor_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/auth_controller.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/setor_store.dart';

import '../models/area/area_model.dart';

part 'lote_store.g.dart';

class LoteStore = _LoteStoreBase with _$LoteStore;

abstract class _LoteStoreBase with Store {
  LoteRepository loteRepository = GetIt.I<LoteRepository>();
  AuthController authController = GetIt.I<AuthController>();

  @observable
  bool isLoteListLoading = false;

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
  DateTime data1 = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);

  @observable
  DateTime data2 = DateTime.now();

  @action
  setData1(DateTime value) => data1 = value;

  @action
  setData2(DateTime value) => data2 = value;

  @action
  changeOrder() => order == "asc" ? order = "desc" : order = "asc";

  @action
  setSetorSelecionado(Setor setor) => setorSelecionado = setor;

  @action
  setDropDown(String value) => dropDownValue = value;

  @action
  setSearchLoteText(String value) => searchLoteText = value;

  @action
  buscarLotes() async {
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
  selecionarSetorMigrar(Setor setor) => setorSelecionadoMigrar = setor;

  @action
  migrarLote(bool migrarReservatorio) async {
    isMigrateLoteLoading = true;

    SetorStore setorStore = GetIt.I<SetorStore>();
    LoteRepository loteRepository = GetIt.I<LoteRepository>();

    var lote = await loteRepository.migrarLote(
      loteSelecionado.id!,
      setorSelecionadoMigrar.id!,
      migrarReservatorio
          ? setorSelecionadoMigrar.reservatorio!.id!
          : loteSelecionado.reservatorio!.id!,
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
  List<SolucaoFertilizanteConcentrada> solucaoNutritivaList = [];

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

  @observable
  Lote novoLote = Lote();

  @action
  selecionarNovoLoteArea(Area area) => novoLoteArea = area;

  @action
  selecionarNovoLoteSetor(Setor setor) => novoLoteSetor = setor;

  @action
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  carregarAreaSetor() {
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
  setNovoLoteCultura(int index) => novoLoteCultura = culturaList[index];

  @action
  selecionarNovoLoteReservatorio() {
    novoLoteReservatorio = reservatorioDetalhes;
    setShowReservatorioDetalhes(false);
  }

  @action
  setRegistroData(DateTime dateTime) => registroData = dateTime;

  @action
  setSemeaduraData(DateTime dateTime) => semeaduraData = dateTime;

  @action
  setTransplantioData(DateTime dateTime) => transplantioData = dateTime;

  @action
  setColheitaData(DateTime dateTime) => colheitaData = dateTime;

  @action
  setIsEditing(bool value) => isEditing = value;

  @action
  setIsBandeijaEditing(bool value) {
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
  setIsMudasEditing(bool value) {
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
  setIsPlantasEditing(bool value) {
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
  setIsEmbalagensEditing(bool value) {
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
  alterarNome(String name) {
    novoLoteName = TextEditingController(text: name);
  }

  @action
  setLoteEditing(Lote lote) {
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
      },
      (data) async {
        reservatorioList = List.from(data);
      },
    );
  }

  @action
  setShowReservatorioDetalhes(bool value) => showReservatorioDetalhes = value;

  @action
  setIsNovaCultura(bool value) => isNovaCultura = value;

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

    isNovoLoteLoading = false;
  }

  @action
  registrarCultura() async {
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
  validarRegistro() {
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
  alterarLote() async {
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
  alterarProducaoLote() async {
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
  alterarDatasLote() async {
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
