import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';

part 'agenda_store.g.dart';

class AgendaStore = _AgendaStoreBase with _$AgendaStore;

abstract class _AgendaStoreBase with Store {
  AgendaRepository agendaRepository = GetIt.I<AgendaRepository>();

  @observable
  bool showEditPage = false;

  @observable
  bool isAcoesListLoading = false;

  @observable
  List<Acao> acoesList = [];

  @action
  setShowEditPage(bool value) => showEditPage = value;

  @action
  buscarAcoes() async {
    isAcoesListLoading = true;

    var acoes = await agendaRepository.buscarAcoes();

    acoes.fold(
      (err) {
        acoesList = List.from([]);
      },
      (data) async {
        acoesList = List.from(data);
        acoesList = List.from(acoesList);
      },
    );

    isAcoesListLoading = false;
  }
}
