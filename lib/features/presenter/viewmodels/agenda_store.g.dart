// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AgendaStore on AgendaStoreBase, Store {
  Computed<List<Agenda>>? _$listaParaSerUsadaComputed;

  @override
  List<Agenda> get listaParaSerUsada => (_$listaParaSerUsadaComputed ??=
          Computed<List<Agenda>>(() => super.listaParaSerUsada,
              name: 'AgendaStoreBase.listaParaSerUsada'))
      .value;
  Computed<List<Agenda>>? _$filtrarPorLoteComputed;

  @override
  List<Agenda> get filtrarPorLote => (_$filtrarPorLoteComputed ??=
          Computed<List<Agenda>>(() => super.filtrarPorLote,
              name: 'AgendaStoreBase.filtrarPorLote'))
      .value;
  Computed<List<Agenda>>? _$filtrarPorResponsavelComputed;

  @override
  List<Agenda> get filtrarPorResponsavel => (_$filtrarPorResponsavelComputed ??=
          Computed<List<Agenda>>(() => super.filtrarPorResponsavel,
              name: 'AgendaStoreBase.filtrarPorResponsavel'))
      .value;
  Computed<List<Agenda>>? _$filteredAtividadesComputed;

  @override
  List<Agenda> get filteredAtividades => (_$filteredAtividadesComputed ??=
          Computed<List<Agenda>>(() => super.filteredAtividades,
              name: 'AgendaStoreBase.filteredAtividades'))
      .value;

  late final _$stateAtom =
      Atom(name: 'AgendaStoreBase.state', context: context);

  @override
  AgendaState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(AgendaState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$filterAtom =
      Atom(name: 'AgendaStoreBase.filter', context: context);

  @override
  AgendaFilter get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(AgendaFilter value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$filtroLoteAtom =
      Atom(name: 'AgendaStoreBase.filtroLote', context: context);

  @override
  Lote? get filtroLote {
    _$filtroLoteAtom.reportRead();
    return super.filtroLote;
  }

  @override
  set filtroLote(Lote? value) {
    _$filtroLoteAtom.reportWrite(value, super.filtroLote, () {
      super.filtroLote = value;
    });
  }

  late final _$filtroResponsavelAtom =
      Atom(name: 'AgendaStoreBase.filtroResponsavel', context: context);

  @override
  Usuario? get filtroResponsavel {
    _$filtroResponsavelAtom.reportRead();
    return super.filtroResponsavel;
  }

  @override
  set filtroResponsavel(Usuario? value) {
    _$filtroResponsavelAtom.reportWrite(value, super.filtroResponsavel, () {
      super.filtroResponsavel = value;
    });
  }

  late final _$showEditPageAtom =
      Atom(name: 'AgendaStoreBase.showEditPage', context: context);

  @override
  bool get showEditPage {
    _$showEditPageAtom.reportRead();
    return super.showEditPage;
  }

  @override
  set showEditPage(bool value) {
    _$showEditPageAtom.reportWrite(value, super.showEditPage, () {
      super.showEditPage = value;
    });
  }

  late final _$selectedDayAtom =
      Atom(name: 'AgendaStoreBase.selectedDay', context: context);

  @override
  DateTime? get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(DateTime? value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  late final _$atividadeListAtom =
      Atom(name: 'AgendaStoreBase.atividadeList', context: context);

  @override
  List<Agenda> get atividadeList {
    _$atividadeListAtom.reportRead();
    return super.atividadeList;
  }

  @override
  set atividadeList(List<Agenda> value) {
    _$atividadeListAtom.reportWrite(value, super.atividadeList, () {
      super.atividadeList = value;
    });
  }

  late final _$usuariosContaAtom =
      Atom(name: 'AgendaStoreBase.usuariosConta', context: context);

  @override
  List<Usuario> get usuariosConta {
    _$usuariosContaAtom.reportRead();
    return super.usuariosConta;
  }

  @override
  set usuariosConta(List<Usuario> value) {
    _$usuariosContaAtom.reportWrite(value, super.usuariosConta, () {
      super.usuariosConta = value;
    });
  }

  late final _$lotesContaAtom =
      Atom(name: 'AgendaStoreBase.lotesConta', context: context);

  @override
  List<Lote> get lotesConta {
    _$lotesContaAtom.reportRead();
    return super.lotesConta;
  }

  @override
  set lotesConta(List<Lote> value) {
    _$lotesContaAtom.reportWrite(value, super.lotesConta, () {
      super.lotesConta = value;
    });
  }

  late final _$tituloControllerAtom =
      Atom(name: 'AgendaStoreBase.tituloController', context: context);

  @override
  TextEditingController get tituloController {
    _$tituloControllerAtom.reportRead();
    return super.tituloController;
  }

  @override
  set tituloController(TextEditingController value) {
    _$tituloControllerAtom.reportWrite(value, super.tituloController, () {
      super.tituloController = value;
    });
  }

  late final _$descricaoControllerAtom =
      Atom(name: 'AgendaStoreBase.descricaoController', context: context);

  @override
  TextEditingController get descricaoController {
    _$descricaoControllerAtom.reportRead();
    return super.descricaoController;
  }

  @override
  set descricaoController(TextEditingController value) {
    _$descricaoControllerAtom.reportWrite(value, super.descricaoController, () {
      super.descricaoController = value;
    });
  }

  late final _$dataAtividadeAtom =
      Atom(name: 'AgendaStoreBase.dataAtividade', context: context);

  @override
  DateTime? get dataAtividade {
    _$dataAtividadeAtom.reportRead();
    return super.dataAtividade;
  }

  @override
  set dataAtividade(DateTime? value) {
    _$dataAtividadeAtom.reportWrite(value, super.dataAtividade, () {
      super.dataAtividade = value;
    });
  }

  late final _$usuarioAtividadeAtom =
      Atom(name: 'AgendaStoreBase.usuarioAtividade', context: context);

  @override
  Usuario? get usuarioAtividade {
    _$usuarioAtividadeAtom.reportRead();
    return super.usuarioAtividade;
  }

  @override
  set usuarioAtividade(Usuario? value) {
    _$usuarioAtividadeAtom.reportWrite(value, super.usuarioAtividade, () {
      super.usuarioAtividade = value;
    });
  }

  late final _$buscarAtividadesAsyncAction =
      AsyncAction('AgendaStoreBase.buscarAtividades', context: context);

  @override
  Future<void> buscarAtividades() {
    return _$buscarAtividadesAsyncAction.run(() => super.buscarAtividades());
  }

  late final _$buscarUsuariosContaAsyncAction =
      AsyncAction('AgendaStoreBase.buscarUsuariosConta', context: context);

  @override
  Future<void> buscarUsuariosConta() {
    return _$buscarUsuariosContaAsyncAction
        .run(() => super.buscarUsuariosConta());
  }

  late final _$buscarLotesContaAsyncAction =
      AsyncAction('AgendaStoreBase.buscarLotesConta', context: context);

  @override
  Future<void> buscarLotesConta() {
    return _$buscarLotesContaAsyncAction.run(() => super.buscarLotesConta());
  }

  late final _$marcarAtividadeComoFeitaAsyncAction =
      AsyncAction('AgendaStoreBase.marcarAtividadeComoFeita', context: context);

  @override
  Future<void> marcarAtividadeComoFeita(int id) {
    return _$marcarAtividadeComoFeitaAsyncAction
        .run(() => super.marcarAtividadeComoFeita(id));
  }

  late final _$deletarAtividadeAsyncAction =
      AsyncAction('AgendaStoreBase.deletarAtividade', context: context);

  @override
  Future<void> deletarAtividade(int id) {
    return _$deletarAtividadeAsyncAction.run(() => super.deletarAtividade(id));
  }

  late final _$editAgendaAsyncAction =
      AsyncAction('AgendaStoreBase.editAgenda', context: context);

  @override
  Future<void> editAgenda(Agenda agenda) {
    return _$editAgendaAsyncAction.run(() => super.editAgenda(agenda));
  }

  late final _$cadastrarAtividadeAsyncAction =
      AsyncAction('AgendaStoreBase.cadastrarAtividade', context: context);

  @override
  Future<void> cadastrarAtividade() {
    return _$cadastrarAtividadeAsyncAction
        .run(() => super.cadastrarAtividade());
  }

  late final _$AgendaStoreBaseActionController =
      ActionController(name: 'AgendaStoreBase', context: context);

  @override
  bool setShowEditPage(bool value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setShowEditPage');
    try {
      return super.setShowEditPage(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  AgendaState setPageState(AgendaState value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setPageState');
    try {
      return super.setPageState(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInitialStateForFilter() {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setInitialStateForFilter');
    try {
      return super.setInitialStateForFilter();
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltro(AgendaFilter? value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setFiltro');
    try {
      return super.setFiltro(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltroLote(Lote? value, {int? loteId}) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setFiltroLote');
    try {
      return super.setFiltroLote(value, loteId: loteId);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltroResponsavel(Usuario? value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setFiltroResponsavel');
    try {
      return super.setFiltroResponsavel(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Agenda> getEventsForDay(DateTime day) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.getEventsForDay');
    try {
      return super.getEventsForDay(day);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onDaySelected(DateTime? day) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.onDaySelected');
    try {
      return super.onDaySelected(day);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime? setDataAtividade(DateTime? value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setDataAtividade');
    try {
      return super.setDataAtividade(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Usuario? setUsuarioAtividade(Usuario? value) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.setUsuarioAtividade');
    try {
      return super.setUsuarioAtividade(value);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void carregarDadosDaAtividade(Agenda agenda) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.carregarDadosDaAtividade');
    try {
      return super.carregarDadosDaAtividade(agenda);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Agenda atualizarDadosDaAtividade(Agenda agenda) {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.atualizarDadosDaAtividade');
    try {
      return super.atualizarDadosDaAtividade(agenda);
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparDadosDaAtividade() {
    final _$actionInfo = _$AgendaStoreBaseActionController.startAction(
        name: 'AgendaStoreBase.limparDadosDaAtividade');
    try {
      return super.limparDadosDaAtividade();
    } finally {
      _$AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
filter: ${filter},
filtroLote: ${filtroLote},
filtroResponsavel: ${filtroResponsavel},
showEditPage: ${showEditPage},
selectedDay: ${selectedDay},
atividadeList: ${atividadeList},
usuariosConta: ${usuariosConta},
lotesConta: ${lotesConta},
tituloController: ${tituloController},
descricaoController: ${descricaoController},
dataAtividade: ${dataAtividade},
usuarioAtividade: ${usuarioAtividade},
listaParaSerUsada: ${listaParaSerUsada},
filtrarPorLote: ${filtrarPorLote},
filtrarPorResponsavel: ${filtrarPorResponsavel},
filteredAtividades: ${filteredAtividades}
    ''';
  }
}
