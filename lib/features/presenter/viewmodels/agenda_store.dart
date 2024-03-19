import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

import '../../data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import '../states/agenda_page_states_enum.dart';
import 'auth_controller.dart';

part 'agenda_store.g.dart';

class AgendaStore = _AgendaStoreBase with _$AgendaStore;

abstract class _AgendaStoreBase with Store {
  AgendaRepository agendaRepository = GetIt.I<AgendaRepository>();

  @observable
  AgendaState state = AgendaState.loading;

  @observable
  bool showEditPage = false;

  @observable
  DateTime? selectedDay;

  @observable
  List<Agenda> atividadeList = [];

  @observable
  List<Usuario> usuariosConta = [];

  @action
  setShowEditPage(bool value) => showEditPage = value;

  @action
  buscarAtividades() async {
    state = AgendaState.loading;

    var atividades = await agendaRepository.buscarAtividades();

    atividades.fold(
      (err) {
        toastError(message: err.message);
        atividadeList = List.from([]);
      },
      (data) async {
        atividadeList = List.from(data);
      },
    );

    state = AgendaState.loaded;
    return;
  }

  @action
  buscarUsuariosConta() async {
    AuthController authController = GetIt.I<AuthController>();
    CadernoCampoRepository cadernoCampoRepository =
        GetIt.I<CadernoCampoRepository>();

    var usuariosContaResult = await cadernoCampoRepository
        .buscarUsuariosConta(authController.usuario.selected_conta!.conta!.id!);

    usuariosContaResult.fold(
      (err) {
        usuariosConta = List.from([]);
      },
      (data) async {
        usuariosConta = data;
        for (var user in usuariosConta) {
          int index = user.contas!.indexWhere((element) =>
              element.conta!.id ==
              authController.usuario.selected_conta!.conta!.id);
          if (index != -1) {
            user.selected_conta = user.contas?[index];
          }
        }
        usuariosConta = List.from(usuariosConta);
      },
    );
  }

  @action
  List<Agenda> getEventsForDay(DateTime day) {
    return atividadeList
        .where((element) =>
            element.data?.year == day.year &&
            element.data?.month == day.month &&
            element.data?.day == day.day)
        .toList();
  }

  @computed
  List<Agenda> get filteredAtividades {
    return atividadeList
        .where((atividade) =>
            atividade.data?.year == selectedDay?.year &&
            atividade.data?.month == selectedDay?.month &&
            atividade.data?.day == selectedDay?.day)
        .toList();
  }

  @action
  void onDaySelected(DateTime? day) {
    if (day == selectedDay) {
      selectedDay = null;
      return;
    }

    selectedDay = day;
  }

  @action
  marcarAtividadeComoFeita(int id) async {
    Get.back();
    showEditPage = false;
    state = AgendaState.loading;

    var atividade = await agendaRepository.marcarComoFeito(id);

    atividade.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: 'Atividade marcada como feita!');
        await buscarAtividades();
      },
    );

    state = AgendaState.loaded;
    return;
  }

  @action
  deletarAtividade(int id) async {
    Get.back();
    showEditPage = false;
    state = AgendaState.loading;

    var atividades = await agendaRepository.deletarAtividade(id);

    atividades.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        await buscarAtividades();
        toastSuccess(message: 'Atividade deletada com sucesso!');
      },
    );

    state = AgendaState.loaded;
  }

  // ------------------- CADASTRO DE ATIVIDADE -------------------

  @observable
  TextEditingController tituloController = TextEditingController();

  @observable
  TextEditingController descricaoController = TextEditingController();

  @observable
  DateTime? dataAtividade;

  @observable
  Usuario? usuarioAtividade;

  @action
  setDataAtividade(DateTime? value) => dataAtividade = value;

  @action
  setUsuarioAtividade(Usuario? value) => usuarioAtividade = value;

  @action
  carregarDadosDaAtividade(Agenda agenda) {
    tituloController.text = agenda.titulo ?? '';
    descricaoController.text = agenda.descricao ?? '';
    dataAtividade = agenda.data;
    usuarioAtividade = null;

    int index =
        usuariosConta.indexWhere((element) => agenda.usuario?.id == element.id);
    if (index != -1) {
      usuarioAtividade = usuariosConta[index];
    }
  }

  @action
  Agenda atualizarDadosDaAtividade(Agenda agenda) {
    agenda.titulo = tituloController.text;
    agenda.descricao = descricaoController.text;
    agenda.data = dataAtividade;
    agenda.usuario = usuarioAtividade;
    return agenda;
  }

  @action
  limparDadosDaAtividade() {
    tituloController.text = '';
    descricaoController.text = '';
    dataAtividade = null;
    usuarioAtividade = null;
  }

  @action
  editAgenda(Agenda agenda) async {
    Get.back();
    showEditPage = false;
    state = AgendaState.loading;

    var atividades = await agendaRepository
        .editarAtividade(atualizarDadosDaAtividade(agenda));

    atividades.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: 'Atividade atualizada com sucesso!');
        await buscarAtividades();
      },
    );

    state = AgendaState.loaded;
    return;
  }
}
