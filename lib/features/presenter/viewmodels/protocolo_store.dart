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
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';

import '../../data/repositories/lote/lote_repository.dart';
import '../models/acao/acao_model.dart';

part 'protocolo_store.g.dart';

class ProtocoloStore = ProtocoloStoreBase with _$ProtocoloStore;

abstract class ProtocoloStoreBase with Store {
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
  List<int> diasDaAtiv = [];

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
  Cultura? novaCulturaProtocolo;

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

  @observable
  TextEditingController searchProtocoloPage = TextEditingController(text: '');

  @action
  bool setIsNovaCultura(bool value) => isNovaCultura = value;

  @action
  bool setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  int setDiaDaAtiv(int value) => diaDaAtiv = value;

  @action
  void toggleDiaAtividade(int value) {
    if (diasDaAtiv.contains(value)) {
      diasDaAtiv = List.from(diasDaAtiv)..remove(value);
      return;
    }
    diasDaAtiv = List.from(diasDaAtiv)..add(value);
  }

  @action
  void selecionarTodosDiasAtividade(int totalDias) {
    if (totalDias <= 0) {
      diasDaAtiv = [];
      return;
    }
    diasDaAtiv = List.generate(totalDias, (index) => index + 1);
  }

  @action
  void limparDiasAtividade() {
    diasDaAtiv = [];
  }

  @action
  void selecionarIntervaloDiasAtividade(int inicio, int fim) {
    if (inicio <= 0 || fim <= 0 || inicio > fim) {
      diasDaAtiv = [];
      return;
    }
    diasDaAtiv = List.generate(fim - inicio + 1, (index) => inicio + index);
  }

  @action
  void alterarForma(String forma) {
    novoFormaProtocolo = forma;
  }

  @action
  void alterarSistema(String sistema) {
    novoSistemaProtocolo = sistema;
  }

  @action
  void alterarTipo(String tipo) {
    novoTipoProtocolo = tipo;
  }

  @action
  void alterarNome(String name) {
    novoNomeProtocolo = name;
  }

  @action
  void alterarTituloFase(String name) {
    novoTituloFase = name;
  }

  @action
  void alterarTituloAtividade(String name) {
    novoTituloAtividade = name;
  }

  @action
  void alterarDescricaoAtividade(String name) {
    novoDescricaoAtividade = name;
  }

  List<int> normalizarDiasSelecionados(List<int> dias) {
    final normalizados = dias.where((dia) => dia > 0).toSet().toList();
    normalizados.sort();
    return normalizados;
  }

  String formatarDiasSelecionados(List<int> dias) {
    if (dias.isEmpty) return '';
    return dias.join(', ');
  }

  List<int> obterDiasSelecionadosAtividade() {
    if (diasDaAtiv.isNotEmpty) {
      return normalizarDiasSelecionados(diasDaAtiv);
    }
    final parsed = int.tryParse(diaDaAtivController.text);
    if (parsed == null || parsed <= 0) return [];
    return [parsed];
  }

  List<int> obterDiasSelecionadosAtividadeDetalhes() {
    if (diasDaAtivDetalhes.isNotEmpty) {
      return normalizarDiasSelecionados(diasDaAtivDetalhes);
    }
    final parsed = int.tryParse(diaDetalhesAtivController.text);
    if (parsed == null || parsed <= 0) return [];
    return [parsed];
  }

  bool existeDuplicataAcaoNaFase(Fase fase, String? titulo, int dia,
      {int? ignorarIndex}) {
    final tituloNormalizado = (titulo ?? '').trim();
    final acoes = fase.acao ?? [];
    for (var i = 0; i < acoes.length; i++) {
      if (ignorarIndex != null && i == ignorarIndex) continue;
      final acao = acoes[i];
      if ((acao.duracao_dias ?? -1) == dia &&
          (acao.titulo ?? '').trim() == tituloNormalizado) {
        return true;
      }
    }
    return false;
  }

  void ordenarAcoesDaFase(Fase fase) {
    if (fase.acao == null || fase.acao!.length < 2) return;
    fase.acao!.sort((a, b) => a.duracao_dias!.compareTo(b.duracao_dias!));
  }

  void recalcularDuracaoDiasReal() {
    int acumulado = 0;
    for (final fase in faseList) {
      final duracaoFase = fase.duracao_dias ?? 0;
      ordenarAcoesDaFase(fase);
      for (final acao in fase.acao ?? []) {
        final dia = acao.duracao_dias;
        if (dia == null || dia <= 0) continue;
        acao.duracao_dias_real = dia + acumulado;
      }
      acumulado += duracaoFase;
    }
  }

  void recalcularDuracaoDiasRealDetalhes() {
    int acumulado = 0;
    for (final fase in listaFaseDetalhes) {
      final duracaoFase = fase.duracao_dias ?? 0;
      ordenarAcoesDaFase(fase);
      for (final acao in fase.acao ?? []) {
        final dia = acao.duracao_dias;
        if (dia == null || dia <= 0) continue;
        acao.duracao_dias_real = dia + acumulado;
      }
      acumulado += duracaoFase;
    }
  }

  @action
  void alterarDropdownFase(Fase newFase) {
    selectedFase = newFase;
  }

  @action
  void setarDiasSelecionadosAtividade(List<int> dias) {
    diasDaAtiv = normalizarDiasSelecionados(dias);
    diaDaAtiv = diasDaAtiv.isNotEmpty ? diasDaAtiv.first : null;
    diaDaAtivController =
        TextEditingController(text: formatarDiasSelecionados(diasDaAtiv));
  }

  @action
  void alterarProtocoloSelecionado(Protocolo novoProtocolo) {
    protocoloSelecionado = novoProtocolo;
  }

  @action
  void alterarRadioIndicator(int value) {
    radioIndicator = value;
  }

  @action
  void alterarDuracaoDiasFase(int value) {
    novoDuracaoDiasFase = value;
    recalcularDuracaoDiasReal();
  }

  @action
  void setarDuracaoDiasFase(String value) {
    diaDaAtivController.clear();
    diaDaAtivController = TextEditingController(text: value);
  }

  @action
  void setarDuracaoDiasFaseDetalhes(String value) {
    diaDetalhesAtivController.clear();
    diaDetalhesAtivController = TextEditingController(text: value);
  }

  @action
  void alterarIsNovaFaseBottonSheet(bool value) {
    isNovaFaseBottonSheet = value;
  }

  @action
  void setDotIndicator(int value) {
    if (value >= 0 && value <= 4) {
      dotIndicator = value;
    }
  }

  @action
  void setDotIndicatorEdit(int value) {
    if (value >= 0 && value <= 4) {
      dotIndicatorEdit = value;
    }
  }

  @action
  Future<void> buscarProtocolos() async {
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
  Future<bool> deletarProtocolo(Protocolo protocolo) async {
    final protocoloId = protocolo.id;
    if (protocoloId == null) {
      toastError(message: 'Protocolo inválido para exclusão');
      return false;
    }

    isProtocoloListLoading = true;
    final result = await protocoloRepository.deletarProtocolo(protocoloId);

    bool isDeleted = false;
    result.fold(
      (err) {
        toastError(message: err.message);
      },
      (deleted) {
        if (deleted) {
          protocoloList = protocoloList
              .where((item) => item.id != protocoloId)
              .toList(growable: false);
          toastSuccess(message: 'Protocolo deletado com sucesso!');
          isDeleted = true;
          return;
        }

        toastError(message: 'Não foi possível deletar o protocolo');
      },
    );

    isProtocoloListLoading = false;
    return isDeleted;
  }

  @action
  void setSeachProtocoloPage(String value) {
    searchProtocoloPage = TextEditingController(text: value);
  }

  @computed
  List<Protocolo> get getProtocoloGroup => protocoloList.where((element) {
        if (searchProtocoloPage.text.isEmpty) return true;
        return element.nome!
            .toLowerCase()
            .contains(searchProtocoloPage.text.toLowerCase());
      }).toList();

  @action
  Future<void> buscarFases() async {
    faseDropDownList = List.from(faseList);
  }

  @action
  Future<void> registrarFase() async {
    isProtocoloListLoading = true;

    if (novoTituloFase != null && novoTituloFase != "") {
      final faseIdTemporaria = -(DateTime.now().microsecondsSinceEpoch);
      Fase novaFase = Fase(
        id: faseIdTemporaria,
        nome: novoTituloFase,
        duracao_dias: novoDuracaoDiasFase,
      );
      faseDropDownList = List.from([novaFase, ...faseDropDownList]);
    }
    isProtocoloListLoading = false;
  }

  @action
  Future<void> registrarCultura() async {
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
  Future<void> registrarProtocolo() async {
    isProtocoloListLoading = true;

    Protocolo novoProtocolo = Protocolo(
      nome: novoNomeProtocolo,
      implantacao: novoFormaProtocolo,
      sistema_cultivo: novoSistemaProtocolo,
      cultura: novaCulturaProtocolo,
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
        GetIt.I<HomeStore>().carregarHome();
        toastSuccess(message: "Protocolo cadastrado com sucesso!");
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  Future<void> buscarCulturas() async {
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
  void mudarSelecaoCultura(Cultura item) {
    novaCulturaProtocolo = item;
  }

  @action
  void atualizarNovasAtividades() {
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
  int calcularDuracaoDiasReal() {
    int duracaoTotal = 0;

    int index = faseList.indexWhere((item) => item.id == selectedFase!.id);
    if (index == -1) {
      for (var i = 0; i < faseList.length; i++) {
        duracaoTotal += faseList[i].duracao_dias!;
      }
      return duracaoTotal;
    }

    for (var i = 0; i < index; i++) {
      duracaoTotal += faseList[i].duracao_dias!;
    }

    return duracaoTotal;
  }

  @action
  void addToFaseList() {
    final index = faseList.indexWhere((item) => item.id == selectedFase!.id);
    final diasSelecionados = obterDiasSelecionadosAtividade();
    if (diasSelecionados.isEmpty) return;

    if (index == -1) {
      selectedFase?.acao = (selectedFase?.acao ?? []);
      for (final dia in diasSelecionados) {
        if (existeDuplicataAcaoNaFase(selectedFase!, novoTituloAtividade, dia)) {
          toastError(message: 'Atividade duplicada ignorada');
          continue;
        }
        selectedFase!.acao!.add(Acao(
          titulo: novoTituloAtividade,
          duracao_dias: dia,
          duracao_dias_real: dia + calcularDuracaoDiasReal(),
          descricao: novoDescricaoAtividade,
          fase: selectedFase,
          alerta: true,
        ));
      }
      ordenarAcoesDaFase(selectedFase!);
      faseList.add(selectedFase!);
      faseList = List.from(faseList);
      recalcularDuracaoDiasReal();
      return;
    }

    final fase = faseList[index];
    fase.acao = (fase.acao ?? []);
    for (final dia in diasSelecionados) {
      if (existeDuplicataAcaoNaFase(fase, novoTituloAtividade, dia)) {
        toastError(message: 'Atividade duplicada ignorada');
        continue;
      }
      fase.acao!.add(Acao(
        titulo: novoTituloAtividade,
        duracao_dias: dia,
        duracao_dias_real: dia + calcularDuracaoDiasReal(),
        descricao: novoDescricaoAtividade,
        fase: selectedFase,
        alerta: true,
      ));
    }
    ordenarAcoesDaFase(fase);
    faseList = List.from(faseList);
    recalcularDuracaoDiasReal();
  }

  @action
  void alterarAlertaAcao(int indexFase, int indexAcao) {
    faseList[indexFase].acao?[indexAcao].alerta =
        !(faseList[indexFase].acao?[indexAcao].alerta ?? false);
    faseList = List.from(faseList);
  }

  @action
  void prepararListaDetalhesFase() {
    listaFaseDetalhes = List.from([]);

    if (protocoloSelecionado?.acao != null) {
      for (var acao in protocoloSelecionado!.acao!) {
        Acao novaAcao = Acao.fromJson(acao.toMap());
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
    atualizarNovasAtividadesDetalhes();
  }

  @action
  void prepararEditAtiv(int indexFase, int indexAcao) {
    selectedFase = faseList[indexFase];
    novoTituloAtividade = faseList[indexFase].acao?[indexAcao].titulo ?? "";
    novoDescricaoAtividade =
        faseList[indexFase].acao?[indexAcao].descricao ?? "";
    diaDaAtivController = TextEditingController(
        text: faseList[indexFase].acao![indexAcao].duracao_dias.toString());
    diasDaAtiv = normalizarDiasSelecionados([
      faseList[indexFase].acao![indexAcao].duracao_dias ?? 0
    ]);
    diaDaAtiv = diasDaAtiv.isNotEmpty ? diasDaAtiv.first : null;
  }

  @action
  void editarAcao(int indexFase, int indexAcao) {
    final diasSelecionados = obterDiasSelecionadosAtividade();
    if (diasSelecionados.isEmpty) return;
    faseList[indexFase].acao?.removeAt(indexAcao);
    if (faseList[indexFase].acao!.isEmpty) {
      faseList.removeAt(indexFase);
    }
    addToFaseList();
    faseList = List.from(faseList);
    recalcularDuracaoDiasReal();
  }

  @action
  void removeAcao(int indexAcao, int indexFase) {
    faseList[indexFase].acao?.removeAt(indexAcao);
    if (faseList[indexFase].acao!.isEmpty) {
      faseList.removeAt(indexFase);
    }
    faseList = List.from(faseList);
    recalcularDuracaoDiasReal();
  }

  @action
  void removeFase(int indexFase) {
    faseList[indexFase].acao?.clear();
    faseList.removeAt(indexFase);
    faseList = List.from(faseList);
    recalcularDuracaoDiasReal();
  }

  @action
  void validarNovoProtocolo() {
    if (novoNomeProtocolo == null ||
        novoNomeProtocolo == "" ||
        novaCulturaProtocolo == null ||
        novasAtividadesProtocolo == [] ||
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
  void validarNovaFase() {
    if (novoTituloFase == null ||
        novoTituloFase == "" ||
        novoDuracaoDiasFase == null) {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  void validarAtividade() {
    if (novoTituloAtividade == null ||
        novoTituloAtividade == "" ||
        selectedFase == null ||
        obterDiasSelecionadosAtividade().isEmpty) {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  void limparTudo() {
    novoNomeProtocolo = null;
    novoFormaProtocolo = null;
    novoTipoProtocolo = null;
    novoSistemaProtocolo = null;
    novoTituloAtividade = null;
    novoDescricaoAtividade = null;
    selectedFase = null;
    novoDuracaoDiasFase = null;
    novaCulturaProtocolo = null;
    novasAtividadesProtocolo.clear();
    faseList.clear();
    faseDropDownList.clear();
    diaDaAtivController.clear();
  }

  @action
  void limparFaseBottomSheet() {
    novoTituloFase = null;
    novoDuracaoDiasFase = null;
  }

  @action
  void limparAtividadeBottomSheet() {
    novoTituloAtividade = null;
    selectedFase = null;
    novoDescricaoAtividade = null;
    diaDaAtivController.clear();
    diasDaAtiv = [];
    diaDaAtiv = null;
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
  List<int> diasDaAtivDetalhes = [];

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
  Cultura? novaCulturaProtocoloDetalhes;

  int? faseDetalhesEditIndex;

  @action
  void alterarLoteFoiAlterado(bool value) {
    loteFoiAlterado = value;
  }

  @action
  void editarNome(String name) {
    novoNomeProtocoloDetalhes = name;
    alterarLoteFoiAlterado(true);
  }

  void editarCultura(Cultura item) {
    novaCulturaProtocoloDetalhes = item;
    alterarLoteFoiAlterado(true);
  }

  @action
  void editarTipo(String tipo) {
    novoTipoProtocoloDetalhes = tipo;
    alterarLoteFoiAlterado(true);
  }

  @action
  void editarSistema(String sistema) {
    novoSistemaProtocoloDetalhes = sistema;
    alterarLoteFoiAlterado(true);
  }

  @action
  void editarForma(String forma) {
    novoFormaProtocoloDetalhes = forma;
    alterarLoteFoiAlterado(true);
  }

  @action
  int alterarDiaDaAtiv(int value) => diaDaAtivDetalhes = value;

  @action
  void toggleDiaAtividadeDetalhes(int value) {
    if (diasDaAtivDetalhes.contains(value)) {
      diasDaAtivDetalhes = List.from(diasDaAtivDetalhes)..remove(value);
      return;
    }
    diasDaAtivDetalhes = List.from(diasDaAtivDetalhes)..add(value);
  }

  @action
  void selecionarTodosDiasAtividadeDetalhes(int totalDias) {
    if (totalDias <= 0) {
      diasDaAtivDetalhes = [];
      return;
    }
    diasDaAtivDetalhes = List.generate(totalDias, (index) => index + 1);
  }

  @action
  void limparDiasAtividadeDetalhes() {
    diasDaAtivDetalhes = [];
  }

  @action
  void selecionarIntervaloDiasAtividadeDetalhes(int inicio, int fim) {
    if (inicio <= 0 || fim <= 0 || inicio > fim) {
      diasDaAtivDetalhes = [];
      return;
    }
    diasDaAtivDetalhes =
        List.generate(fim - inicio + 1, (index) => inicio + index);
  }

  @action
  void alterarAlertaAcaoDetalhes(int indexFase, int indexAcao) {
    listaFaseDetalhes[indexFase].acao?[indexAcao].alerta =
        !(listaFaseDetalhes[indexFase].acao?[indexAcao].alerta ?? false);

    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
  }

  @action
  void removeAcaoDetalhes(int indexAcao, int indexFase) {
    listaFaseDetalhes[indexFase].acao?.removeAt(indexAcao);
    if (listaFaseDetalhes[indexFase].acao!.isEmpty) {
      listaFaseDetalhes.removeAt(indexFase);
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
    recalcularDuracaoDiasRealDetalhes();
  }

  @action
  void removeFaseDetalhes(int indexFase) {
    listaFaseDetalhes[indexFase].acao?.clear();
    listaFaseDetalhes.removeAt(indexFase);
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
    recalcularDuracaoDiasRealDetalhes();
  }

  @action
  void atualizarNovasAtividadesDetalhes() {
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
  Future<void> registrarFaseDetalhes() async {
    isProtocoloListLoading = true;

    if (novoTituloFaseDetalhes != null && novoTituloFaseDetalhes != "") {
      final faseIdTemporaria = -(DateTime.now().microsecondsSinceEpoch);
      Fase novaFase = Fase(
        id: faseIdTemporaria,
        nome: novoTituloFaseDetalhes,
        duracao_dias: novoDuracaoDiasFaseDetalhes,
      );
      faseDropDownListDetelhes =
          List.from([novaFase, ...faseDropDownListDetelhes]);
    }
    isProtocoloListLoading = false;
  }

  void prepararEditFaseDetalhes(int indexFase) {
    if (indexFase < 0 || indexFase >= listaFaseDetalhes.length) {
      return;
    }

    final fase = listaFaseDetalhes[indexFase];
    faseDetalhesEditIndex = indexFase;
    novoTituloFaseDetalhes = fase.nome;
    novoDuracaoDiasFaseDetalhes = fase.duracao_dias;
    selectedDetalhesFase = fase;
    alterarLoteFoiAlterado(true);
  }

  bool editarFaseDetalhes() {
    final indexFase = faseDetalhesEditIndex;
    if (indexFase == null ||
        indexFase < 0 ||
        indexFase >= listaFaseDetalhes.length) {
      return false;
    }

    final faseAtual = listaFaseDetalhes[indexFase];
    final novoTitulo = (novoTituloFaseDetalhes ?? '').trim();
    final novaDuracao = novoDuracaoDiasFaseDetalhes;
    if (novoTitulo.isEmpty || novaDuracao == null || novaDuracao <= 0) {
      return false;
    }

    final existeAtividadeForaDaDuracao =
        (faseAtual.acao ?? []).any((acao) => (acao.duracao_dias ?? 0) > novaDuracao);
    if (existeAtividadeForaDaDuracao) {
      toastError(
          message:
              'Existem atividades além do novo período da fase. Ajuste os dias das atividades antes de salvar.');
      return false;
    }

    faseAtual.nome = novoTitulo;
    faseAtual.duracao_dias = novaDuracao;

    if (selectedDetalhesFase?.id == faseAtual.id) {
      selectedDetalhesFase = faseAtual;
    }

    listaFaseDetalhes = List.from(listaFaseDetalhes);
    faseDropDownListDetelhes = List.from(listaFaseDetalhes);
    recalcularDuracaoDiasRealDetalhes();
    atualizarNovasAtividadesDetalhes();
    alterarLoteFoiAlterado(true);
    faseDetalhesEditIndex = null;
    return true;
  }

  @action
  void alterarDuracaoDiasFaseDetalhes(int value) {
    novoDuracaoDiasFaseDetalhes = value;
    recalcularDuracaoDiasRealDetalhes();
  }

  @action
  void alterarTituloFaseDetalhes(String name) {
    novoTituloFaseDetalhes = name;
  }

  @action
  void alterarDropdownFaseDetalhes(Fase newFase) {
    selectedDetalhesFase = newFase;
  }

  @action
  void setarDiasSelecionadosAtividadeDetalhes(List<int> dias) {
    diasDaAtivDetalhes = normalizarDiasSelecionados(dias);
    diaDaAtivDetalhes =
        diasDaAtivDetalhes.isNotEmpty ? diasDaAtivDetalhes.first : null;
    diaDetalhesAtivController = TextEditingController(
        text: formatarDiasSelecionados(diasDaAtivDetalhes));
  }

  @action
  void prepararEditDetalhesAtiv(int indexFase, int indexAcao) {
    faseDropDownListDetelhes = List.from(listaFaseDetalhes);
    final faseAtual = listaFaseDetalhes[indexFase];
    selectedDetalhesFase = faseDropDownListDetelhes.firstWhereOrNull(
            (element) => element.id == faseAtual.id) ??
        faseAtual;
    novoTituloDetalhesAtividade = TextEditingController(
        text: listaFaseDetalhes[indexFase].acao?[indexAcao].titulo ?? "");
    novoDescricaoDetalhesAtividade = TextEditingController(
        text: listaFaseDetalhes[indexFase].acao?[indexAcao].descricao ?? "");
    diaDetalhesAtivController = TextEditingController(
        text: listaFaseDetalhes[indexFase]
            .acao![indexAcao]
            .duracao_dias
            .toString());
    diasDaAtivDetalhes = normalizarDiasSelecionados([
      listaFaseDetalhes[indexFase].acao![indexAcao].duracao_dias ?? 0
    ]);
    diaDaAtivDetalhes =
        diasDaAtivDetalhes.isNotEmpty ? diasDaAtivDetalhes.first : null;
  }

  @action
  int calcularDuracaoDiasRealDetalhes() {
    int duracaoTotal = 0;

    int index = listaFaseDetalhes
        .indexWhere((item) => item.id == selectedDetalhesFase!.id);
    if (index == -1) {
      for (var i = 0; i < listaFaseDetalhes.length; i++) {
        duracaoTotal += listaFaseDetalhes[i].duracao_dias!;
      }
      return duracaoTotal;
    }

    for (var i = 0; i < index; i++) {
      duracaoTotal += listaFaseDetalhes[i].duracao_dias!;
    }

    return duracaoTotal;
  }

  @action
  void addToFaseListDetalhes() {
    final index = listaFaseDetalhes
        .indexWhere((item) => item.id == selectedDetalhesFase!.id);
    final diasSelecionados = obterDiasSelecionadosAtividadeDetalhes();
    if (diasSelecionados.isEmpty) return;

    if (index == -1) {
      selectedDetalhesFase?.acao = (selectedDetalhesFase?.acao ?? []);
      for (final dia in diasSelecionados) {
        if (existeDuplicataAcaoNaFase(
            selectedDetalhesFase!, novoTituloDetalhesAtividade.text, dia)) {
          toastError(message: 'Atividade duplicada ignorada');
          continue;
        }
        selectedDetalhesFase!.acao!.add(Acao(
          titulo: novoTituloDetalhesAtividade.text,
          duracao_dias: dia,
          duracao_dias_real: dia + calcularDuracaoDiasRealDetalhes(),
          descricao: novoDescricaoDetalhesAtividade.text,
          fase: selectedDetalhesFase,
          alerta: true,
        ));
      }
      ordenarAcoesDaFase(selectedDetalhesFase!);
      listaFaseDetalhes.add(selectedDetalhesFase!);
      listaFaseDetalhes = List.from(listaFaseDetalhes);
      alterarLoteFoiAlterado(true);
      recalcularDuracaoDiasRealDetalhes();
      return;
    }

    final fase = listaFaseDetalhes[index];
    fase.acao = (fase.acao ?? []);
    for (final dia in diasSelecionados) {
      if (existeDuplicataAcaoNaFase(
          fase, novoTituloDetalhesAtividade.text, dia)) {
        toastError(message: 'Atividade duplicada ignorada');
        continue;
      }
      fase.acao!.add(Acao(
        titulo: novoTituloDetalhesAtividade.text,
        duracao_dias: dia,
        duracao_dias_real: dia + calcularDuracaoDiasRealDetalhes(),
        descricao: novoDescricaoDetalhesAtividade.text,
        fase: selectedDetalhesFase,
        alerta: true,
      ));
    }
    ordenarAcoesDaFase(fase);
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
    recalcularDuracaoDiasRealDetalhes();
  }

  @action
  void editarAcaoDetalhes(int indexFase, int indexAcao) {
    final diasSelecionados = obterDiasSelecionadosAtividadeDetalhes();
    if (diasSelecionados.isEmpty) return;
    listaFaseDetalhes[indexFase].acao?.removeAt(indexAcao);
    if (listaFaseDetalhes[indexFase].acao!.isEmpty) {
      listaFaseDetalhes.removeAt(indexFase);
    }
    addToFaseListDetalhes();
    listaFaseDetalhes = List.from(listaFaseDetalhes);
    alterarLoteFoiAlterado(true);
    recalcularDuracaoDiasRealDetalhes();
  }

  @action
  Future<void> buscarFasesDetalhes() async {
    faseDropDownListDetelhes = List.from(listaFaseDetalhes);
    return;
  }

  @action
  Future<void> atualizarProtocolo() async {
    isProtocoloListLoading = true;
    protocoloSelecionado!.conta =
        GetIt.I<AuthController>().usuario.selected_conta!.conta;
    protocoloSelecionado!.nome =
        novoNomeProtocoloDetalhes ?? protocoloSelecionado!.nome;
    protocoloSelecionado!.cultura =
        novaCulturaProtocoloDetalhes ?? protocoloSelecionado!.cultura;

    protocoloSelecionado!.implantacao =
        novoFormaProtocoloDetalhes ?? protocoloSelecionado!.implantacao;
    protocoloSelecionado!.sistema_cultivo =
        novoSistemaProtocoloDetalhes ?? protocoloSelecionado!.sistema_cultivo;
    protocoloSelecionado!.acao = List.from(novasAtividadesDetalhesProtocolo);

    var protocolo =
        await protocoloRepository.atualizarProtocolo(protocoloSelecionado!);

    protocolo.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        Get.back();
        toastSuccess(message: "Alterado com sucesso");
        buscarProtocolos();
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  void validarAtividadeDetalhes() {
    if (novoTituloDetalhesAtividade.text == "" ||
        selectedDetalhesFase == null ||
        obterDiasSelecionadosAtividadeDetalhes().isEmpty) {
      isValid = false;
      return;
    }
    isValid = true;
  }

  @action
  void limparFaseDetalhesBottomSheet() {
    novoTituloFaseDetalhes = null;
    novoDuracaoDiasFaseDetalhes = null;
    faseDetalhesEditIndex = null;
  }

  @action
  void limparProtocoloDetalhes() {
    novoNomeProtocoloDetalhes = null;
    novaCulturaProtocoloDetalhes = null;
    novoFormaProtocoloDetalhes = null;
    novoSistemaProtocoloDetalhes = null;
    novoTipoProtocoloDetalhes = null;
  }

  @action
  void limparAtividadeBottomSheetDetalhes() {
    novoTituloDetalhesAtividade.clear();
    selectedDetalhesFase = null;
    novoDescricaoDetalhesAtividade.clear();
    diaDetalhesAtivController.clear();
    diasDaAtivDetalhes = [];
    diaDaAtivDetalhes = null;
  }

  @action
  void validarNovaFaseDetalhes() {
    if (novoTituloFaseDetalhes == null ||
        novoTituloFaseDetalhes == "" ||
        novoDuracaoDiasFaseDetalhes == null) {
      isValid = false;
      return;
    }
    isValid = true;
  }
}
