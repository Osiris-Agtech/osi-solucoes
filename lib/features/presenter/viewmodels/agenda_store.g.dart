// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgendaStore on _AgendaStoreBase, Store {
  Computed<List<Agenda>>? _$filteredAtividadesComputed;

  @override
  List<Agenda> get filteredAtividades => (_$filteredAtividadesComputed ??=
          Computed<List<Agenda>>(() => super.filteredAtividades,
              name: '_AgendaStoreBase.filteredAtividades'))
      .value;

  final _$stateAtom = Atom(name: '_AgendaStoreBase.state');

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

  final _$showEditPageAtom = Atom(name: '_AgendaStoreBase.showEditPage');

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

  final _$selectedDayAtom = Atom(name: '_AgendaStoreBase.selectedDay');

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

  final _$atividadeListAtom = Atom(name: '_AgendaStoreBase.atividadeList');

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

  final _$usuariosContaAtom = Atom(name: '_AgendaStoreBase.usuariosConta');

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

  final _$tituloControllerAtom =
      Atom(name: '_AgendaStoreBase.tituloController');

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

  final _$descricaoControllerAtom =
      Atom(name: '_AgendaStoreBase.descricaoController');

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

  final _$dataAtividadeAtom = Atom(name: '_AgendaStoreBase.dataAtividade');

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

  final _$usuarioAtividadeAtom =
      Atom(name: '_AgendaStoreBase.usuarioAtividade');

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

  final _$buscarAtividadesAsyncAction =
      AsyncAction('_AgendaStoreBase.buscarAtividades');

  @override
  Future buscarAtividades() {
    return _$buscarAtividadesAsyncAction.run(() => super.buscarAtividades());
  }

  final _$buscarUsuariosContaAsyncAction =
      AsyncAction('_AgendaStoreBase.buscarUsuariosConta');

  @override
  Future buscarUsuariosConta() {
    return _$buscarUsuariosContaAsyncAction
        .run(() => super.buscarUsuariosConta());
  }

  final _$deletarAtividadeAsyncAction =
      AsyncAction('_AgendaStoreBase.deletarAtividade');

  @override
  Future deletarAtividade(int id) {
    return _$deletarAtividadeAsyncAction.run(() => super.deletarAtividade(id));
  }

  final _$editAgendaAsyncAction = AsyncAction('_AgendaStoreBase.editAgenda');

  @override
  Future editAgenda(Agenda agenda) {
    return _$editAgendaAsyncAction.run(() => super.editAgenda(agenda));
  }

  final _$_AgendaStoreBaseActionController =
      ActionController(name: '_AgendaStoreBase');

  @override
  dynamic setShowEditPage(bool value) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.setShowEditPage');
    try {
      return super.setShowEditPage(value);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Agenda> getEventsForDay(DateTime day) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.getEventsForDay');
    try {
      return super.getEventsForDay(day);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onDaySelected(DateTime? day) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.onDaySelected');
    try {
      return super.onDaySelected(day);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDataAtividade(DateTime? value) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.setDataAtividade');
    try {
      return super.setDataAtividade(value);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUsuarioAtividade(Usuario? value) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.setUsuarioAtividade');
    try {
      return super.setUsuarioAtividade(value);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic carregarDadosDaAtividade(Agenda agenda) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.carregarDadosDaAtividade');
    try {
      return super.carregarDadosDaAtividade(agenda);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic limparDadosDaAtividade() {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.limparDadosDaAtividade');
    try {
      return super.limparDadosDaAtividade();
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
showEditPage: ${showEditPage},
selectedDay: ${selectedDay},
atividadeList: ${atividadeList},
usuariosConta: ${usuariosConta},
tituloController: ${tituloController},
descricaoController: ${descricaoController},
dataAtividade: ${dataAtividade},
usuarioAtividade: ${usuarioAtividade},
filteredAtividades: ${filteredAtividades}
    ''';
  }
}
