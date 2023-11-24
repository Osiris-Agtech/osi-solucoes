import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
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
  bool isProtocoloListLoading = false;

  @observable
  bool isEditing = false;

  @observable
  bool canNotificate = false;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  TextEditingController novoTipoProtocolo = TextEditingController();

  @observable
  TextEditingController novoSistemaProtocolo = TextEditingController();

  @observable
  TextEditingController novoFormaProtocolo = TextEditingController();

  @observable
  Cultura novaCulturaProtocolo = Cultura();

  @observable
  List<Atividade> novasAtividadesProtocolo = [];

  @observable
  List<Protocolo> protocoloList = [];

  @action
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  setCanNotificate(bool value) => canNotificate = value;

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
        print(protocoloList);
      },
    );

    isProtocoloListLoading = false;
  }
}
