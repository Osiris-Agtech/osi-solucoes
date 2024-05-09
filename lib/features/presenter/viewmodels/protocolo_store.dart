import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../data/repositories/lote/lote_repository.dart';
import '../models/acao/acao_model.dart';

part 'protocolo_store.g.dart';

class ProtocoloStore = _ProtocoloStoreBase with _$ProtocoloStore;

abstract class _ProtocoloStoreBase with Store {
  ProtocoloRepository protocoloRepository = GetIt.I<ProtocoloRepository>();
  // AuthController authController = GetIt.I<AuthController>();

  @observable
  int dotIndicator = 1;

  @observable
  int dotIndicatorEdit = 1;

  @observable
  int radioIndicator = 1;

  @observable
  bool isValid = false;

  @observable
  bool isNovaFaseBottonSheet = false;

  @observable
  bool isProtocoloListLoading = false;

  @observable
  bool isEditing = false;

  @observable
  int? diaDaAtiv;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  bool isNovaCultura = false;

  @observable
  String? novoTipoProtocolo;

  @observable
  String? novoSistemaProtocolo;

  @observable
  String? novoFormaProtocolo;

  @observable
  String? novoTituloFase;

  @observable
  String? novoTituloAtividade;

  @observable
  String? novoDescricaoAtividade;

  @observable
  int? novoDuracaoDiasFase;

  @observable
  Fase? selectedFase;

  @observable
  Protocolo? protocoloSelecionado;

  @observable
  TextEditingController novaCulturaController = TextEditingController();

  @observable
  TextEditingController diaDaAtivController = TextEditingController();

  @observable
  TextEditingController dropdownTitle = TextEditingController(text: 'teste1');

  @observable
  String? novoNomeProtocolo;

  @observable
  List<Cultura> culturaList = [];

  @observable
  List<Cultura> novaCulturaProtocolo = [];

  @observable
  List<Acao> novasAtividadesProtocolo = [];

  @observable
  List<Protocolo> protocoloList = [];

  @observable
  List<Fase> faseDropDownList = [];

  @observable
  List<Fase> faseList = [];

  @observable
  List<Fase> listaFaseDetalhes = [];

  @action
  setIsNovaCultura(bool value) => isNovaCultura = value;

  @action
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  setDiaDaAtiv(int value) => diaDaAtiv = value;

  @action
  alterarForma(String forma) {
    novoFormaProtocolo = forma;
  }

  @action
  alterarSistema(String sistema) {
    novoSistemaProtocolo = sistema;
  }

  @action
  alterarTipo(String tipo) {
    novoTipoProtocolo = tipo;
  }

  @action
  alterarNome(String name) {
    novoNomeProtocolo = name;
  }

  @action
  alterarTituloFase(String name) {
    novoTituloFase = name;
  }

  @action
  alterarTituloAtividade(String name) {
    novoTituloAtividade = name;
  }

  @action
  alterarDescricaoAtividade(String name) {
    novoDescricaoAtividade = name;
  }

  @action
  alterarDropdownFase(Fase newFase) {
    selectedFase = newFase;
  }

  @action
  alterarProtocoloSelecionado(Protocolo novoProtocolo) {
    protocoloSelecionado = novoProtocolo;
  }

  @action
  alterarRadioIndicator(int value) {
    radioIndicator = value;
  }

  @action
  alterarDuracaoDiasFase(int value) {
    novoDuracaoDiasFase = value;
  }

  @action
  setarDuracaoDiasFase(String value) {
    diaDaAtivController.clear();
    diaDaAtivController = TextEditingController(text: value);
  }

  @action
  alterarIsNovaFaseBottonSheet(bool value) {
    isNovaFaseBottonSheet = value;
  }

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 5) {
      dotIndicator = value;
    }
  }

  @action
  setDotIndicatorEdit(int value) {
    if (value >= 0 && value <= 5) {
      dotIndicatorEdit = value;
    }
  }

  @action
  buscarProtocolos() async {
    isProtocoloListLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    var protocolos = await protocoloRepository
        .buscarProtocolos(authController.usuario.selected_conta!.conta!.id!);

    protocolos.fold(
      (err) {
        protocoloList = List.from([]);
      },
      (data) async {
        protocoloList = List.from(data);
        protocoloList = List.from(protocoloList);
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  buscarFases() async {
    AuthController authController = GetIt.I<AuthController>();
    var fases = await protocoloRepository
        .buscarFases(authController.usuario.selected_conta!.conta!.id!);

    fases.fold(
      (err) {
        faseDropDownList = List.from([]);
      },
      (data) async {
        faseDropDownList = List.from(data);
      },
    );
  }

  @action
  registrarFase() async {
    isProtocoloListLoading = true;

    if (novoTituloFase != null && novoTituloFase != "") {
      Fase novaFase = Fase(
        nome: novoTituloFase,
        duracao_dias: novoDuracaoDiasFase,
        conta: GetIt.I<AuthController>().usuario.selected_conta!.conta!,
      );

      var fase = await protocoloRepository.registrarFase(novaFase);

      fase.fold(
        (err) {
          toastError(message: err.message);
        },
        (data) async {
          faseDropDownList = List.from([data, ...faseDropDownList]);
        },
      );
    }
    isProtocoloListLoading = false;
  }

  @action
  registrarCultura() async {
    if (novaCulturaController.text.isNotEmpty) {
      Cultura novaCultura = Cultura(
        nome: novaCulturaController.text,
        privado: true,
      );

      LoteRepository loteRepository = GetIt.I<LoteRepository>();
      AuthController authController = GetIt.I<AuthController>();
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
  registrarProtocolo() async {
    isProtocoloListLoading = true;

    Protocolo novoProtocolo = Protocolo(
      nome: novoNomeProtocolo,
      implantacao: novoFormaProtocolo,
      tipo_cultura: novoTipoProtocolo,
      sistema_cultivo: novoSistemaProtocolo,
      cultura: novaCulturaProtocolo.isNotEmpty
          ? novaCulturaProtocolo.first
          : null, //List.from(novaCulturaProtocolo),
      acao: List.from(novasAtividadesProtocolo),
      conta: GetIt.I<AuthController>().usuario.selected_conta!.conta!,
    );

    var protocolo = await protocoloRepository.registrarProtocolo(novoProtocolo);

    protocolo.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        protocoloList = List.from([data, ...protocoloList]);
        Get.back();
        toastSuccess(message: "Protocolo cadastrado com sucesso!");
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  buscarCulturas() async {
    isProtocoloListLoading = true;

    AuthController authController = GetIt.I<AuthController>();
    var culturas = await protocoloRepository
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
    isProtocoloListLoading = false;
  }

  @action
  mudarSelecaoCultura(Cultura item) {
    if (novaCulturaProtocolo.contains(item)) {
      novaCulturaProtocolo.remove(item);
    } else {
      novaCulturaProtocolo.add(item);
    }
    novaCulturaProtocolo = List.from(novaCulturaProtocolo);
  }

  @action
  atualizarNovasAtividades() {
    novasAtividadesProtocolo
        .clear(); // Limpa a lista antes de adicionar novas ações
    for (var fase in faseList) {
      if (fase.acao != null && fase.acao!.isNotEmpty) {
        // Se ação não é nula E ação não está vazia
        for (var acao in fase.acao!) {
          novasAtividadesProtocolo.add(acao);
        }
      }
    }
    novasAtividadesProtocolo = List.from(novasAtividadesProtocolo);
  }

  @action
  addToFaseList() {
    Acao acao = Acao(
      titulo: novoTituloAtividade,
      duracao_dias: int.parse(diaDaAtivController.text),
      descricao: novoDescricaoAtividade,
      fase: selectedFase,
      alerta: true,
    );

    final index = faseList.indexWhere((item) => item.id == selectedFase!.id);
    // Add Fase e acao
    if (index == -1) {
      selectedFase?.acao = (selectedFase?.acao ?? [])..add(acao);
      // Ordena a lista caso maior que 1
      if (selectedFase!.acao!.length > 1) {
        selectedFase!.acao!
            .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
      }
      faseList.add(selectedFase!);
      faseList = List.from(faseList);
      return;
    }
    // Add apenas acao quando a fase ja existe na lista
    faseList[index].acao = (faseList[index].acao ?? [])..add(acao);
    if (faseList[index].acao!.length > 1) {
      // Ordena a lista caso maior que 1
      faseList[index]
          .acao!
          .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
    }
    faseList = List.from(faseList);
  }

  @action
  alterarAlertaAcao(int indexFase, int indexAcao) {
    faseList[indexFase].acao?[indexAcao].alerta =
        !(faseList[indexFase].acao?[indexAcao].alerta ?? false);
    faseList = List.from(faseList);
  }

  @action
  prepararListaDetalhesFase() {
    listaFaseDetalhes = List.from([]);

    if (protocoloSelecionado?.acao != null) {
      for (var acao in protocoloSelecionado!.acao!) {
        Acao novaAcao = Acao.fromJson(acao.toJson());
        if (novaAcao.fase != null) {
          // Procura a fase na listaFaseDetalhes
          var fase = listaFaseDetalhes.firstWhere(
            (f) => f.id == novaAcao.fase!.id,
            orElse: () => Fase(),
          );

          if (fase.id == null) {
            // Verifica se a fase retornada é a fase vazia
            // Se a fase não está na lista, adiciona ela e inicializa a lista de ações
            novaAcao.fase!.acao = [novaAcao];
            listaFaseDetalhes.add(novaAcao.fase!);
          } else {
            // Se a fase já está na lista, apenas adiciona a ação à sua lista de ações
            fase.acao?.add(novaAcao);
          }
        }
      }
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);
  }

  @action
  prepararEditAtiv(int indexFase, int indexAcao) {
    selectedFase = faseList[indexFase];
    novoTituloAtividade = faseList[indexFase].acao?[indexAcao].titulo ?? "";
    novoDescricaoAtividade =
        faseList[indexFase].acao?[indexAcao].descricao ?? "";
    diaDaAtivController = TextEditingController(
        text: faseList[indexFase].acao![indexAcao].duracao_dias.toString());
  }

  @action
  editarAcao(int indexFase, int indexAcao) {
    if (selectedFase!.id != faseList[indexFase].id) {
      addToFaseList();
      faseList[indexFase].acao?.removeAt(indexAcao);
      if (faseList[indexFase].acao!.isEmpty) {
        faseList.removeAt(indexFase);
      }
      faseList = List.from(faseList);
      return;
    }
    faseList[indexFase].acao?[indexAcao].titulo = novoTituloAtividade;
    faseList[indexFase].acao?[indexAcao].descricao = novoDescricaoAtividade;
    faseList[indexFase].acao![indexAcao].duracao_dias =
        int.parse(diaDaAtivController.text);
    faseList[indexFase]
        .acao!
        .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
    faseList = List.from(faseList);
  }

  @action
  removeAcao(int indexAcao, int indexFase) {
    faseList[indexFase].acao?.removeAt(indexAcao);
    if (faseList[indexFase].acao!.isEmpty) {
      faseList.removeAt(indexFase);
    }
    faseList = List.from(faseList);
  }

  @action
  removeFase(int indexFase) {
    faseList[indexFase].acao?.clear();
    faseList.removeAt(indexFase);
    faseList = List.from(faseList);
  }

  @action
  validarNovoProtocolo() {
    if (novoNomeProtocolo == null ||
        novoNomeProtocolo == "" ||
        novaCulturaProtocolo == [] ||
        novasAtividadesProtocolo == [] ||
        novoTipoProtocolo == null ||
        novoTipoProtocolo == "" ||
        novoSistemaProtocolo == null ||
        novoSistemaProtocolo == "" ||
        novoFormaProtocolo == "" ||
        novoFormaProtocolo == null) {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  validarNovaFase() {
    if (novoTituloFase == null ||
        novoTituloFase == "" ||
        novoDuracaoDiasFase == null) {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  validarAtividade() {
    if (novoTituloAtividade == null ||
        novoTituloAtividade == "" ||
        selectedFase == null ||
        diaDaAtivController.text == "") {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  limparTudo() {
    novoNomeProtocolo = null;
    novoFormaProtocolo = null;
    novoTipoProtocolo = null;
    novoSistemaProtocolo = null;
    novoTituloAtividade = null;
    novoDescricaoAtividade = null;
    selectedFase = null;
    novoDuracaoDiasFase = null;
    novasAtividadesProtocolo.clear();
    faseList.clear();
    faseDropDownList.clear();
    diaDaAtivController.clear();
    novaCulturaProtocolo.clear();
  }

  @action
  limparFaseBottomSheet() {
    novoTituloFase = null;
    novoDuracaoDiasFase = null;
  }

  @action
  limparAtividadeBottomSheet() {
    novoTituloAtividade = null;
    selectedFase = null;
    novoDescricaoAtividade = null;
    diaDaAtivController.clear();
  }

  // ##################### START DETALHES ######################

  @observable
  List<Acao> novasAtividadesDetalhesProtocolo = [];

  @observable
  TextEditingController novoTituloDetalhesAtividade = TextEditingController();

  @observable
  TextEditingController novoDescricaoDetalhesAtividade =
      TextEditingController();

  @observable
  Fase? selectedDetalhesFase;

  @observable
  bool loteFoiAlterado = false;

  @observable
  TextEditingController diaDetalhesAtivController = TextEditingController();

  @observable
  String? novoTituloFaseDetalhes;

  @observable
  int? novoDuracaoDiasFaseDetalhes;

  @observable
  int? diaDaAtivDetalhes;

  @observable
  List<Fase> faseDropDownListDetelhes = [];

  @observable
  String? novoNomeProtocoloDetalhes;

  @observable
  String? novoFormaProtocoloDetalhes;

  @observable
  String? novoTipoProtocoloDetalhes;

  @observable
  String? novoSistemaProtocoloDetalhes;

  @observable
  Cultura novaCulturaProtocoloDetalhes = Cultura();

  @action
  alterarLoteFoiAlterado(bool value) {
    loteFoiAlterado = value;
  }

  @action
  editarNome(String name) {
    novoNomeProtocoloDetalhes = name;
    alterarLoteFoiAlterado(true);
  }

  editarCultura(Cultura item) {
    novaCulturaProtocoloDetalhes = item;
    alterarLoteFoiAlterado(true);
  }

  @action
  editarTipo(String tipo) {
    novoTipoProtocoloDetalhes = tipo;
    alterarLoteFoiAlterado(true);
  }

  @action
  editarSistema(String sistema) {
    novoSistemaProtocoloDetalhes = sistema;
    alterarLoteFoiAlterado(true);
  }

  @action
  editarForma(String forma) {
    novoFormaProtocoloDetalhes = forma;
    alterarLoteFoiAlterado(true);
  }

  @action
  alterarDiaDaAtiv(int value) => diaDaAtivDetalhes = value;

  @action
  setarDuracaoDiasFaseDetalhes(String value) {
    diaDetalhesAtivController.clear();
    diaDetalhesAtivController = TextEditingController(text: value);
  }

  @action
  alterarAlertaAcaoDetalhes(int indexFase, int indexAcao) {
    listaFaseDetalhes[indexFase].acao?[indexAcao].alerta =
        !(listaFaseDetalhes[indexFase].acao?[indexAcao].alerta ?? false);

    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  removeAcaoDetalhes(int indexAcao, int indexFase) {
    listaFaseDetalhes[indexFase].acao?.removeAt(indexAcao);
    if (listaFaseDetalhes[indexFase].acao!.isEmpty) {
      listaFaseDetalhes.removeAt(indexFase);
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  removeFaseDetalhes(int indexFase) {
    listaFaseDetalhes[indexFase].acao?.clear();
    listaFaseDetalhes.removeAt(indexFase);
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  atualizarNovasAtividadesDetalhes() {
    novasAtividadesDetalhesProtocolo
        .clear(); // Limpa a lista antes de adicionar novas ações
    for (var fase in listaFaseDetalhes) {
      if (fase.acao != null && fase.acao!.isNotEmpty) {
        // Se ação não é nula E ação não está vazia
        for (var acao in fase.acao!) {
          novasAtividadesDetalhesProtocolo.add(acao);
        }
      }
    }
    novasAtividadesDetalhesProtocolo = List.from(
        novasAtividadesDetalhesProtocolo); // Atualiza a lista após todas as adições
  }

  @action
  registrarFaseDetalhes() async {
    isProtocoloListLoading = true;

    if (novoTituloFaseDetalhes != null && novoTituloFaseDetalhes != "") {
      Fase novaFase = Fase(
        nome: novoTituloFaseDetalhes,
        duracao_dias: novoDuracaoDiasFaseDetalhes,
        conta: GetIt.I<AuthController>().usuario.selected_conta!.conta!,
      );

      var fase = await protocoloRepository.registrarFase(novaFase);

      fase.fold(
        (err) {
          toastError(message: err.message);
        },
        (data) async {
          faseDropDownListDetelhes =
              List.from([data, ...faseDropDownListDetelhes]);
        },
      );
    }
    isProtocoloListLoading = false;
  }

  @action
  alterarDuracaoDiasFaseDetalhes(int value) {
    novoDuracaoDiasFaseDetalhes = value;
  }

  @action
  alterarTituloFaseDetalhes(String name) {
    novoTituloFaseDetalhes = name;
  }

  @action
  alterarDropdownFaseDetalhes(Fase newFase) {
    selectedDetalhesFase = newFase;
  }

  @action
  prepararEditDetalhesAtiv(int indexFase, int indexAcao) {
    selectedDetalhesFase = faseDropDownListDetelhes.firstWhereOrNull(
        (element) => element.id == listaFaseDetalhes[indexFase].id);
    novoTituloDetalhesAtividade = TextEditingController(
        text: listaFaseDetalhes[indexFase].acao?[indexAcao].titulo ?? "");
    novoDescricaoDetalhesAtividade = TextEditingController(
        text: listaFaseDetalhes[indexFase].acao?[indexAcao].descricao ?? "");
    diaDetalhesAtivController = TextEditingController(
        text: listaFaseDetalhes[indexFase]
            .acao![indexAcao]
            .duracao_dias
            .toString());
  }

  @action
  addToFaseListDetalhes() {
    Acao acao = Acao(
      titulo: novoTituloDetalhesAtividade.text,
      duracao_dias: int.parse(diaDetalhesAtivController.text),
      descricao: novoDescricaoDetalhesAtividade.text,
      fase: selectedDetalhesFase,
      alerta: true,
    );

    final index = listaFaseDetalhes
        .indexWhere((item) => item.id == selectedDetalhesFase!.id);
    // Add Fase e acao
    if (index == -1) {
      selectedDetalhesFase?.acao = (selectedDetalhesFase?.acao ?? [])
        ..add(acao);
      // Ordena a lista caso maior que 1
      if (selectedDetalhesFase!.acao!.length > 1) {
        selectedDetalhesFase!.acao!
            .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
      }
      listaFaseDetalhes.add(selectedDetalhesFase!);
      listaFaseDetalhes = List.from(listaFaseDetalhes);
      alterarLoteFoiAlterado(true);
      return;
    }
    // Add apenas acao quando a fase ja existe na lista
    listaFaseDetalhes[index].acao = (listaFaseDetalhes[index].acao ?? [])
      ..add(acao);
    if (listaFaseDetalhes[index].acao!.length > 1) {
      // Ordena a lista caso maior que 1
      listaFaseDetalhes[index]
          .acao!
          .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  editarAcaoDetalhes(int indexFase, int indexAcao) {
    if (selectedDetalhesFase!.id != listaFaseDetalhes[indexFase].id) {
      addToFaseListDetalhes();
      listaFaseDetalhes[indexFase].acao?.removeAt(indexAcao);
      if (listaFaseDetalhes[indexFase].acao!.isEmpty) {
        listaFaseDetalhes.removeAt(indexFase);
      }
      listaFaseDetalhes = List.from(listaFaseDetalhes);
      return;
    }
    listaFaseDetalhes[indexFase].acao?[indexAcao].titulo =
        novoTituloDetalhesAtividade.text;
    listaFaseDetalhes[indexFase].acao?[indexAcao].descricao =
        novoDescricaoDetalhesAtividade.text;
    listaFaseDetalhes[indexFase].acao![indexAcao].duracao_dias =
        int.parse(diaDetalhesAtivController.text);
    listaFaseDetalhes[indexFase]
        .acao!
        .sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  buscarFasesDetalhes() async {
    AuthController authController = GetIt.I<AuthController>();
    var fases = await protocoloRepository
        .buscarFases(authController.usuario.selected_conta!.conta!.id!);

    fases.fold(
      (err) {
        faseDropDownListDetelhes = List.from([]);
      },
      (data) async {
        faseDropDownListDetelhes = List.from(data);
      },
    );
    return;
  }

  @action
  atualizarProtocolo() async {
    isProtocoloListLoading = true;
    protocoloSelecionado!.nome = novoNomeProtocoloDetalhes;
    protocoloSelecionado!.cultura = novaCulturaProtocoloDetalhes;
    protocoloSelecionado!.implantacao = novoFormaProtocoloDetalhes;
    protocoloSelecionado!.sistema_cultivo = novoSistemaProtocoloDetalhes;
    protocoloSelecionado!.tipo_cultura = novoTipoProtocoloDetalhes;
    protocoloSelecionado!.acao = List.from(novasAtividadesDetalhesProtocolo);

    var protocolo =
        await protocoloRepository.atualizarProtocolo(protocoloSelecionado!);

    protocolo.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarProtocolos();
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  validarAtividadeDetalhes() {
    if (novoTituloDetalhesAtividade.text == "" ||
        selectedDetalhesFase == null ||
        diaDetalhesAtivController.text == "") {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  limparFaseDetalhesBottomSheet() {
    novoTituloFaseDetalhes = null;
    novoDuracaoDiasFaseDetalhes = null;
  }

  @action
  limparAtividadeBottomSheetDetalhes() {
    novoTituloDetalhesAtividade.clear();
    selectedDetalhesFase = null;
    novoDescricaoDetalhesAtividade.clear();
    diaDetalhesAtivController.clear();
  }

  @action
  validarNovaFaseDetalhes() {
    if (novoTituloFaseDetalhes == null ||
        novoTituloFaseDetalhes == "" ||
        novoDuracaoDiasFaseDetalhes == null) {
      isValid = false;
      return;
    }
    isValid = true;
  }
}
