import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

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
  bool isNovaFaseBottonSheet = false;

  @observable
  bool isProtocoloListLoading = false;

  @observable
  bool isEditing = false;

  @observable
  bool canNotificate = false;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  bool isNovaCultura = false;

  @observable
  List<Cultura> culturaList = [];

  @observable
  String? novoTipoProtocolo;

  @observable
  String? novoSistemaProtocolo;

  @observable
  String? novoFormaProtocolo;

  @observable
  TextEditingController novaCulturaController = TextEditingController();

  @observable
  String? novoNomeProtocolo;

  @observable
  List<Cultura> novaCulturaProtocolo = [];

  @observable
  List<Atividade> novasAtividadesProtocolo = [];

  @observable
  List<Protocolo> protocoloList = [];

  @action
  setIsNovaCultura(bool value) => isNovaCultura = value;

  @action
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  setCanNotificate(bool value) => canNotificate = value;

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
  alterarRadioIndicator(int value) {
    radioIndicator = value;
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
  registrarCultura() async {
    isProtocoloListLoading = true;

    if (novaCulturaController.text.isNotEmpty) {
      Cultura novaCultura = Cultura(
        nome: novaCulturaController.text,
        privado: true,
      );

      // var conta = await loteRepository.registrarCultura(
      //     novaCultura, authController.usuario.selected_conta!.conta!.id!);

      // conta.fold(
      //   (err) {
      //     toastError(message: err.message);
      //   },
      //   (data) async {
      //     // culturaList = List.from([data, ...culturaList]);
      //     setIsNovaCultura(false);
      //   },
      // );
    }
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
  limparTudo() {
    novoNomeProtocolo = null;
    novoFormaProtocolo = null;
    novoTipoProtocolo = null;
    novoSistemaProtocolo = null;
    novaCulturaProtocolo.clear();
  }
}
