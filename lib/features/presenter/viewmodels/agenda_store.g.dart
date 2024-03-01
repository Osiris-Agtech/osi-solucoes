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

  final _$isAcoesListLoadingAtom =
      Atom(name: '_AgendaStoreBase.isAcoesListLoading');

  @override
  bool get isAcoesListLoading {
    _$isAcoesListLoadingAtom.reportRead();
    return super.isAcoesListLoading;
  }

  @override
  set isAcoesListLoading(bool value) {
    _$isAcoesListLoadingAtom.reportWrite(value, super.isAcoesListLoading, () {
      super.isAcoesListLoading = value;
    });
  }

  final _$selectedDayAtom = Atom(name: '_AgendaStoreBase.selectedDay');

  @override
  DateTime get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(DateTime value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  final _$focusedDayAtom = Atom(name: '_AgendaStoreBase.focusedDay');

  @override
  DateTime get focusedDay {
    _$focusedDayAtom.reportRead();
    return super.focusedDay;
  }

  @override
  set focusedDay(DateTime value) {
    _$focusedDayAtom.reportWrite(value, super.focusedDay, () {
      super.focusedDay = value;
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

  final _$buscarAtividadesAsyncAction =
      AsyncAction('_AgendaStoreBase.buscarAtividades');

  @override
  Future buscarAtividades() {
    return _$buscarAtividadesAsyncAction.run(() => super.buscarAtividades());
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
  void onDaySelected(DateTime day, DateTime focusedDay) {
    final _$actionInfo = _$_AgendaStoreBaseActionController.startAction(
        name: '_AgendaStoreBase.onDaySelected');
    try {
      return super.onDaySelected(day, focusedDay);
    } finally {
      _$_AgendaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showEditPage: ${showEditPage},
isAcoesListLoading: ${isAcoesListLoading},
selectedDay: ${selectedDay},
focusedDay: ${focusedDay},
atividadeList: ${atividadeList},
filteredAtividades: ${filteredAtividades}
    ''';
  }
}
