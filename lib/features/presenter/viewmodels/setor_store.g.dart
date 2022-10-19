// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SetorStore on _SetorStoreBase, Store {
  final _$isSetorListLoadingAtom =
      Atom(name: '_SetorStoreBase.isSetorListLoading');

  @override
  bool get isSetorListLoading {
    _$isSetorListLoadingAtom.reportRead();
    return super.isSetorListLoading;
  }

  @override
  set isSetorListLoading(bool value) {
    _$isSetorListLoadingAtom.reportWrite(value, super.isSetorListLoading, () {
      super.isSetorListLoading = value;
    });
  }

  final _$areaSelecionadaAtom = Atom(name: '_SetorStoreBase.areaSelecionada');

  @override
  Area get areaSelecionada {
    _$areaSelecionadaAtom.reportRead();
    return super.areaSelecionada;
  }

  @override
  set areaSelecionada(Area value) {
    _$areaSelecionadaAtom.reportWrite(value, super.areaSelecionada, () {
      super.areaSelecionada = value;
    });
  }

  final _$setorListAtom = Atom(name: '_SetorStoreBase.setorList');

  @override
  List<Setor> get setorList {
    _$setorListAtom.reportRead();
    return super.setorList;
  }

  @override
  set setorList(List<Setor> value) {
    _$setorListAtom.reportWrite(value, super.setorList, () {
      super.setorList = value;
    });
  }

  final _$isEditingAtom = Atom(name: '_SetorStoreBase.isEditing');

  @override
  bool get isEditing {
    _$isEditingAtom.reportRead();
    return super.isEditing;
  }

  @override
  set isEditing(bool value) {
    _$isEditingAtom.reportWrite(value, super.isEditing, () {
      super.isEditing = value;
    });
  }

  final _$reservatorioListAtom = Atom(name: '_SetorStoreBase.reservatorioList');

  @override
  List<Reservatorio> get reservatorioList {
    _$reservatorioListAtom.reportRead();
    return super.reservatorioList;
  }

  @override
  set reservatorioList(List<Reservatorio> value) {
    _$reservatorioListAtom.reportWrite(value, super.reservatorioList, () {
      super.reservatorioList = value;
    });
  }

  final _$novoSetorNameAtom = Atom(name: '_SetorStoreBase.novoSetorName');

  @override
  TextEditingController get novoSetorName {
    _$novoSetorNameAtom.reportRead();
    return super.novoSetorName;
  }

  @override
  set novoSetorName(TextEditingController value) {
    _$novoSetorNameAtom.reportWrite(value, super.novoSetorName, () {
      super.novoSetorName = value;
    });
  }

  final _$novoSetorDescriptionAtom =
      Atom(name: '_SetorStoreBase.novoSetorDescription');

  @override
  TextEditingController get novoSetorDescription {
    _$novoSetorDescriptionAtom.reportRead();
    return super.novoSetorDescription;
  }

  @override
  set novoSetorDescription(TextEditingController value) {
    _$novoSetorDescriptionAtom.reportWrite(value, super.novoSetorDescription,
        () {
      super.novoSetorDescription = value;
    });
  }

  final _$novoSetorReservatorioAtom =
      Atom(name: '_SetorStoreBase.novoSetorReservatorio');

  @override
  Reservatorio get novoSetorReservatorio {
    _$novoSetorReservatorioAtom.reportRead();
    return super.novoSetorReservatorio;
  }

  @override
  set novoSetorReservatorio(Reservatorio value) {
    _$novoSetorReservatorioAtom.reportWrite(value, super.novoSetorReservatorio,
        () {
      super.novoSetorReservatorio = value;
    });
  }

  final _$showTextFormFieldAtom =
      Atom(name: '_SetorStoreBase.showTextFormField');

  @override
  bool get showTextFormField {
    _$showTextFormFieldAtom.reportRead();
    return super.showTextFormField;
  }

  @override
  set showTextFormField(bool value) {
    _$showTextFormFieldAtom.reportWrite(value, super.showTextFormField, () {
      super.showTextFormField = value;
    });
  }

  final _$isNovoSetorLoadingAtom =
      Atom(name: '_SetorStoreBase.isNovoSetorLoading');

  @override
  bool get isNovoSetorLoading {
    _$isNovoSetorLoadingAtom.reportRead();
    return super.isNovoSetorLoading;
  }

  @override
  set isNovoSetorLoading(bool value) {
    _$isNovoSetorLoadingAtom.reportWrite(value, super.isNovoSetorLoading, () {
      super.isNovoSetorLoading = value;
    });
  }

  final _$dotIndicatorAtom = Atom(name: '_SetorStoreBase.dotIndicator');

  @override
  int get dotIndicator {
    _$dotIndicatorAtom.reportRead();
    return super.dotIndicator;
  }

  @override
  set dotIndicator(int value) {
    _$dotIndicatorAtom.reportWrite(value, super.dotIndicator, () {
      super.dotIndicator = value;
    });
  }

  final _$novoSetorAtom = Atom(name: '_SetorStoreBase.novoSetor');

  @override
  Setor get novoSetor {
    _$novoSetorAtom.reportRead();
    return super.novoSetor;
  }

  @override
  set novoSetor(Setor value) {
    _$novoSetorAtom.reportWrite(value, super.novoSetor, () {
      super.novoSetor = value;
    });
  }

  final _$buscarSetoresAsyncAction =
      AsyncAction('_SetorStoreBase.buscarSetores');

  @override
  Future buscarSetores() {
    return _$buscarSetoresAsyncAction.run(() => super.buscarSetores());
  }

  final _$buscarReservatoriosAsyncAction =
      AsyncAction('_SetorStoreBase.buscarReservatorios');

  @override
  Future buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  final _$registrarSetorAsyncAction =
      AsyncAction('_SetorStoreBase.registrarSetor');

  @override
  Future registrarSetor() {
    return _$registrarSetorAsyncAction.run(() => super.registrarSetor());
  }

  final _$alterarSetorAsyncAction = AsyncAction('_SetorStoreBase.alterarSetor');

  @override
  Future alterarSetor() {
    return _$alterarSetorAsyncAction.run(() => super.alterarSetor());
  }

  final _$_SetorStoreBaseActionController =
      ActionController(name: '_SetorStoreBase');

  @override
  dynamic setAreaSelecionada(Area estufa) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setAreaSelecionada');
    try {
      return super.setAreaSelecionada(estufa);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsEditing(bool value) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSetorEditing(Setor setor) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setSetorEditing');
    try {
      return super.setSetorEditing(setor);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setShowTextFormField(bool value) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setShowTextFormField');
    try {
      return super.setShowTextFormField(value);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic limparTudo() {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.limparTudo');
    try {
      return super.limparTudo();
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic alterarNome(String name) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReservatorioSelecionada(Reservatorio reservatorio) {
    final _$actionInfo = _$_SetorStoreBaseActionController.startAction(
        name: '_SetorStoreBase.setReservatorioSelecionada');
    try {
      return super.setReservatorioSelecionada(reservatorio);
    } finally {
      _$_SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSetorListLoading: ${isSetorListLoading},
areaSelecionada: ${areaSelecionada},
setorList: ${setorList},
isEditing: ${isEditing},
reservatorioList: ${reservatorioList},
novoSetorName: ${novoSetorName},
novoSetorDescription: ${novoSetorDescription},
novoSetorReservatorio: ${novoSetorReservatorio},
showTextFormField: ${showTextFormField},
isNovoSetorLoading: ${isNovoSetorLoading},
dotIndicator: ${dotIndicator},
novoSetor: ${novoSetor}
    ''';
  }
}
