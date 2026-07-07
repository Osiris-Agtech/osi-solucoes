import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_interaction_reporter.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_sequence_signals_store.dart';

import '../../data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import '../models/lote/lote_model.dart';
import '../states/agenda_page_enum.dart';
import 'auth_controller.dart';

part 'agenda_store.g.dart';

class AgendaStore = AgendaStoreBase with _$AgendaStore;

abstract class AgendaStoreBase with Store {
  AgendaRepository agendaRepository = GetIt.I<AgendaRepository>();

  @observable
  AgendaState state = AgendaState.loading;

  @observable
  AgendaFilter filter = AgendaFilter.todos;

  @observable
  Lote? filtroLote;

  @observable
  Usuario? filtroResponsavel;

  @observable
  bool showEditPage = false;

  @observable
  DateTime? selectedDay;

  @observable
  List<Agenda> atividadeList = [];

  @observable
  List<Usuario> usuariosConta = [];

  @observable
  List<Lote> lotesConta = [];

  @action
  bool setShowEditPage(bool value) => showEditPage = value;

  @action
  AgendaState setPageState(AgendaState value) => state = value;

  @action
  Future<void> buscarAtividades() async {
    state = AgendaState.loading;

    AuthController authController = GetIt.I<AuthController>();
    var atividades = await agendaRepository
        .buscarAtividades(authController.usuario.selected_conta!.conta!.id!);

    atividades.fold(
      (err) {
        toastError(message: err.message);
        atividadeList = List.from([]);
      },
      (data) async {
        for (var atividade in data) {
          int index = usuariosConta
              .indexWhere((element) => atividade.usuario?.id == element.id);
          if (index != -1) {
            atividade.usuario = usuariosConta[index];
          }
        }
        atividadeList = List.from(data);
        if (atividadeList.isNotEmpty &&
            _hasScopedLotWithProtocolCreated() &&
            GetIt.I.isRegistered<InstantSequenceInteractionReporter>()) {
          GetIt.I<InstantSequenceInteractionReporter>()
              .reportGeneratedAgendaActivitiesChecked();
        }
      },
    );

    state = AgendaState.loaded;
    return;
  }

  bool _hasScopedLotWithProtocolCreated() {
    final getIt = GetIt.I;
    if (!getIt.isRegistered<InstantSequenceSignalsStore>() ||
        !getIt.isRegistered<HomeStore>()) {
      return false;
    }

    final store = getIt<InstantSequenceSignalsStore>();
    final homeStore = getIt<HomeStore>();
    store.syncScope(_resolveScopeKey(homeStore));
    return store.snapshot.lotWithProtocolCreated;
  }

  String _resolveScopeKey(HomeStore homeStore) {
    final userId = homeStore.authController.usuario.id?.toString() ?? 'unknown';
    final accountId = homeStore.authController.usuario.selected_conta?.conta?.id
            ?.toString() ??
        'unknown';
    final sessionId = homeStore.currentSessionId ?? 'unknown';
    final adaptiveMode = homeStore.adaptiveMode;
    return '$userId|$accountId|$sessionId|$adaptiveMode';
  }

  @action
  Future<void> buscarUsuariosConta() async {
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
    return;
  }

  @action
  Future<void> buscarLotesConta() async {
    AuthController authController = GetIt.I<AuthController>();

    var usuariosContaResult = await agendaRepository
        .buscarLotesConta(authController.usuario.selected_conta!.conta!.id!);

    usuariosContaResult.fold(
      (err) {
        lotesConta = List.from([]);
      },
      (data) async {
        lotesConta = List.from(data);
      },
    );
  }

  @action
  void setInitialStateForFilter() {
    filter = AgendaFilter.todos;
    filtroLote = null;
    filtroResponsavel = null;
  }

  @action
  void setFiltro(AgendaFilter? value) {
    filter = value ?? AgendaFilter.todos;
    filtroLote = null;
    filtroResponsavel = null;
  }

  @action
  void setFiltroLote(Lote? value, {int? loteId}) {
    filtroLote = value;

    if (loteId != null && lotesConta.isNotEmpty) {
      filtroLote = lotesConta.firstWhere((element) => element.id == loteId);
      if (filtroLote != null) {
        filter = AgendaFilter.lote;
        filtroResponsavel = null;
      }
    }
  }

  @action
  void setFiltroResponsavel(Usuario? value) {
    filtroResponsavel = value;
  }

  @action
  List<Agenda> getEventsForDay(DateTime day) {
    List<Agenda> list = atividadeList
        .where((element) =>
            element.data?.year == day.year &&
            element.data?.month == day.month &&
            element.data?.day == day.day)
        .toList();
    return list;
  }

  @computed
  List<Agenda> get listaParaSerUsada {
    switch (filter) {
      case AgendaFilter.todos:
        if (selectedDay != null) return filteredAtividades;
        return atividadeList;
      case AgendaFilter.lote:
        return filtrarPorLote;
      case AgendaFilter.responsavel:
        return filtrarPorResponsavel;
    }
  }

  @computed
  List<Agenda> get filtrarPorLote {
    if (filtroLote == null) {
      return atividadeList;
    }
    return atividadeList
        .where((element) => element.lote?.id == filtroLote?.id)
        .toList();
  }

  @computed
  List<Agenda> get filtrarPorResponsavel {
    if (filtroResponsavel == null) {
      return atividadeList;
    }
    return atividadeList
        .where((element) => element.usuario?.id == filtroResponsavel?.id)
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
  Future<void> marcarAtividadeComoFeita(int id) async {
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
        final changed =
            GetIt.I.isRegistered<InstantSequenceInteractionReporter>() &&
                GetIt.I<InstantSequenceInteractionReporter>()
                    .reportAgendaActivitiesCompleted();
        if (!changed) {
          final homeStore = GetIt.I<HomeStore>();
          homeStore.pendingActivityTitle = data.titulo;
          homeStore.pendingActivityDescription = data.descricao;
          homeStore.pendingActivityInteractionType = 'completed';
          await homeStore.refreshHomeAfterAgendaMutation();
        }
      },
    );

    state = AgendaState.loaded;
    return;
  }

  @action
  Future<void> deletarAtividade(int id) async {
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
        final homeStore = GetIt.I<HomeStore>();
        homeStore.pendingActivityTitle = null;
        homeStore.pendingActivityDescription = null;
        homeStore.pendingActivityInteractionType = 'deleted';
        await homeStore.refreshHomeAfterAgendaMutation();
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
  DateTime? setDataAtividade(DateTime? value) => dataAtividade = value;

  @action
  Usuario? setUsuarioAtividade(Usuario? value) => usuarioAtividade = value;

  @action
  void carregarDadosDaAtividade(Agenda agenda) {
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
  void limparDadosDaAtividade() {
    tituloController.text = '';
    descricaoController.text = '';
    dataAtividade = DateTime.now();
    usuarioAtividade = null;
  }

  @action
  Future<void> editAgenda(Agenda agenda) async {
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
        final homeStore = GetIt.I<HomeStore>();
        homeStore.pendingActivityTitle = data.titulo;
        homeStore.pendingActivityDescription = data.descricao;
        homeStore.pendingActivityInteractionType = 'edited';
        await homeStore.refreshHomeAfterAgendaMutation();
      },
    );

    state = AgendaState.loaded;
    return;
  }

  @action
  Future<void> cadastrarAtividade() async {
    Get.back();
    showEditPage = false;
    state = AgendaState.loading;

    AuthController authController = GetIt.I<AuthController>();
    Agenda agenda = Agenda(
      titulo: tituloController.text,
      descricao: descricaoController.text,
      data: dataAtividade,
      usuario: usuarioAtividade,
      conta: authController.usuario.selected_conta!.conta!,
    );

    var atividade = await agendaRepository.cadastrarAtividade(agenda);

    atividade.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: 'Atividade cadastrada com sucesso!');
        await buscarAtividades();
        final homeStore = GetIt.I<HomeStore>();
        homeStore.pendingActivityTitle = tituloController.text;
        homeStore.pendingActivityDescription = descricaoController.text;
        homeStore.pendingActivityInteractionType = 'created';
        await homeStore.refreshHomeAfterAgendaMutation();
      },
    );

    state = AgendaState.loaded;
    return;
  }
}
