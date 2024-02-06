import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';

part 'agenda_store.g.dart';

class AgendaStore = _AgendaStoreBase with _$AgendaStore;

abstract class _AgendaStoreBase with Store {
  AgendaRepository agendaRepository = GetIt.I<AgendaRepository>();

  @observable
  bool showEditPage = false;

  @observable
  bool isAcoesListLoading = false;

  @observable
  DateTime selectedDay = DateTime.now();

  @observable
  DateTime focusedDay = DateTime.now();

  @observable
  List<Agenda> atividadeList = [];

  @action
  setShowEditPage(bool value) => showEditPage = value;

  @action
  buscarAtividades() async {
    isAcoesListLoading = true;

    var atividades = await agendaRepository.buscarAtividades();

    atividades.fold(
      (err) {
        atividadeList = List.from([]);
      },
      (data) async {
        atividadeList = List.from(data);
        atividadeList = List.from(atividadeList);
      },
    );

    isAcoesListLoading = false;
  }

  @computed
  List<Agenda> get filteredAtividades {
    return atividadeList
        .where((atividade) =>
            atividade.data?.year == selectedDay.year &&
            atividade.data?.month == selectedDay.month &&
            atividade.data?.day == selectedDay.day)
        .toList();
  }

  @action
  void onDaySelected(DateTime day, DateTime focusedDay) {
    selectedDay = day;
    this.focusedDay = focusedDay;
  }
}
