import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

import '../models/acao/acao_model.dart';

part 'protocolo_store.g.dart';

class ProtocoloStore = _ProtocoloStoreBase with _$ProtocoloStore;

abstract class _ProtocoloStoreBase with Store {
  ProtocoloRepository protocoloRepository = GetIt.I<ProtocoloRepository>();
  // AuthController authController = GetIt.I<AuthController>();

  @observable
  int dotIndicator = 1;

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
  buscarProtocolos() async {
    isProtocoloListLoading = true;

    var protocolos = await protocoloRepository.buscarProtocolos();

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
  registrarFase() async {
    isProtocoloListLoading = true;

    if (novoTituloFase != null && novoTituloFase != "") {
      Fase novaFase = Fase(
        id: faker.guid.random.integer(50), // retirar junto com mock
        nome: novoTituloFase,
        duracao_dias: novoDuracaoDiasFase,
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
  registrarProtocolo() async {
    isProtocoloListLoading = true;

    Protocolo novoProtocolo = Protocolo(
      nome: novoNomeProtocolo,
      implantacao: novoFormaProtocolo,
      tipo_cultura: novoTipoProtocolo,
      sistema_cultivo: novoSistemaProtocolo,
      cultura: List.from(novaCulturaProtocolo),
      acao: List.from(novasAtividadesProtocolo),
    );

    var protocolo = await protocoloRepository.registrarProtocolo(novoProtocolo);

    protocolo.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        protocoloList = List.from([data, ...protocoloList]);
        Get.back();
        toastSuccess(message: "Protocolo cadastrada com sucesso !");
      },
    );
    isProtocoloListLoading = false;
  }

  @action
  buscarCulturas() async {
    isProtocoloListLoading = true;
    var culturas = await protocoloRepository.buscarCulturas();

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
    novasAtividadesProtocolo = List.from(
        novasAtividadesProtocolo); // Atualiza a lista após todas as adições
    print(novasAtividadesProtocolo
        .map((e) => e.titulo)); // Imprime os títulos após a atualização
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
    listaFaseDetalhes.clear(); // Limpa a lista antes de adicionar novas fases
    print('inicio: ${protocoloSelecionado?.acao?.length}');
    if (protocoloSelecionado?.acao != null) {
      for (var acao in protocoloSelecionado!.acao!) {
        if (acao.fase != null) {
          // Procura a fase na listaFaseDetalhes
          var fase = listaFaseDetalhes.firstWhere(
            (f) => f.id == acao.fase!.id,
            orElse: () => Fase(),
          );

          print(fase.nome);

          if (fase.id == null) {
            // Verifica se a fase retornada é a fase vazia
            // Se a fase não está na lista, adiciona ela e inicializa a lista de ações
            acao.fase!.acao = [acao];
            listaFaseDetalhes.add(acao.fase!);
          } else {
            // Se a fase já está na lista, apenas adiciona a ação à sua lista de ações
            fase.acao?.add(acao);
          }
        }
        print(acao.fase?.nome);
      }
    }
    listaFaseDetalhes = List.from(listaFaseDetalhes);

    print('inicio: ${protocoloSelecionado?.acao?.length}');
    print(listaFaseDetalhes.map((e) => e.nome));
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
}
