// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SetorStore on SetorStoreBase, Store {
  Computed<List<Setor>>? _$searchSetorComputed;

  @override
  List<Setor> get searchSetor =>
      (_$searchSetorComputed ??= Computed<List<Setor>>(() => super.searchSetor,
              name: 'SetorStoreBase.searchSetor'))
          .value;

  late final _$searchSetorTextAtom =
      Atom(name: 'SetorStoreBase.searchSetorText', context: context);

  @override
  String get searchSetorText {
    _$searchSetorTextAtom.reportRead();
    return super.searchSetorText;
  }

  @override
  set searchSetorText(String value) {
    _$searchSetorTextAtom.reportWrite(value, super.searchSetorText, () {
      super.searchSetorText = value;
    });
  }

  late final _$dropDownValueAtom =
      Atom(name: 'SetorStoreBase.dropDownValue', context: context);

  @override
  String get dropDownValue {
    _$dropDownValueAtom.reportRead();
    return super.dropDownValue;
  }

  @override
  set dropDownValue(String value) {
    _$dropDownValueAtom.reportWrite(value, super.dropDownValue, () {
      super.dropDownValue = value;
    });
  }

  late final _$orderAtom = Atom(name: 'SetorStoreBase.order', context: context);

  @override
  String get order {
    _$orderAtom.reportRead();
    return super.order;
  }

  @override
  set order(String value) {
    _$orderAtom.reportWrite(value, super.order, () {
      super.order = value;
    });
  }

  late final _$isSetorListLoadingAtom =
      Atom(name: 'SetorStoreBase.isSetorListLoading', context: context);

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

  late final _$areaSelecionadaAtom =
      Atom(name: 'SetorStoreBase.areaSelecionada', context: context);

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

  late final _$setorListAtom =
      Atom(name: 'SetorStoreBase.setorList', context: context);

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

  late final _$data1Atom = Atom(name: 'SetorStoreBase.data1', context: context);

  @override
  DateTime get data1 {
    _$data1Atom.reportRead();
    return super.data1;
  }

  @override
  set data1(DateTime value) {
    _$data1Atom.reportWrite(value, super.data1, () {
      super.data1 = value;
    });
  }

  late final _$data2Atom = Atom(name: 'SetorStoreBase.data2', context: context);

  @override
  DateTime get data2 {
    _$data2Atom.reportRead();
    return super.data2;
  }

  @override
  set data2(DateTime value) {
    _$data2Atom.reportWrite(value, super.data2, () {
      super.data2 = value;
    });
  }

  late final _$isEditingAtom =
      Atom(name: 'SetorStoreBase.isEditing', context: context);

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

  late final _$mostrarErroFormularioAtom =
      Atom(name: 'SetorStoreBase.mostrarErroFormulario', context: context);

  @override
  bool get mostrarErroFormulario {
    _$mostrarErroFormularioAtom.reportRead();
    return super.mostrarErroFormulario;
  }

  @override
  set mostrarErroFormulario(bool value) {
    _$mostrarErroFormularioAtom.reportWrite(value, super.mostrarErroFormulario,
        () {
      super.mostrarErroFormulario = value;
    });
  }

  late final _$reservatorioListAtom =
      Atom(name: 'SetorStoreBase.reservatorioList', context: context);

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

  late final _$novoSetorNameAtom =
      Atom(name: 'SetorStoreBase.novoSetorName', context: context);

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

  late final _$novoSetorDescriptionAtom =
      Atom(name: 'SetorStoreBase.novoSetorDescription', context: context);

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

  late final _$novoSetorReservatorioAtom =
      Atom(name: 'SetorStoreBase.novoSetorReservatorio', context: context);

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

  late final _$showTextFormFieldAtom =
      Atom(name: 'SetorStoreBase.showTextFormField', context: context);

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

  late final _$isNovoSetorLoadingAtom =
      Atom(name: 'SetorStoreBase.isNovoSetorLoading', context: context);

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

  late final _$isDeletingSetorCascadeAtom =
      Atom(name: 'SetorStoreBase.isDeletingSetorCascade', context: context);

  @override
  bool get isDeletingSetorCascade {
    _$isDeletingSetorCascadeAtom.reportRead();
    return super.isDeletingSetorCascade;
  }

  @override
  set isDeletingSetorCascade(bool value) {
    _$isDeletingSetorCascadeAtom
        .reportWrite(value, super.isDeletingSetorCascade, () {
      super.isDeletingSetorCascade = value;
    });
  }

  late final _$dotIndicatorAtom =
      Atom(name: 'SetorStoreBase.dotIndicator', context: context);

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

  late final _$novoSetorAtom =
      Atom(name: 'SetorStoreBase.novoSetor', context: context);

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

  late final _$buscarSetoresAsyncAction =
      AsyncAction('SetorStoreBase.buscarSetores', context: context);

  @override
  Future<void> buscarSetores() {
    return _$buscarSetoresAsyncAction.run(() => super.buscarSetores());
  }

  late final _$buscarReservatoriosAsyncAction =
      AsyncAction('SetorStoreBase.buscarReservatorios', context: context);

  @override
  Future<void> buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  late final _$deletarSetorCascadeAsyncAction =
      AsyncAction('SetorStoreBase.deletarSetorCascade', context: context);

  @override
  Future<void> deletarSetorCascade(int setorId) {
    return _$deletarSetorCascadeAsyncAction
        .run(() => super.deletarSetorCascade(setorId));
  }

  late final _$registrarSetorAsyncAction =
      AsyncAction('SetorStoreBase.registrarSetor', context: context);

  @override
  Future<void> registrarSetor() {
    return _$registrarSetorAsyncAction.run(() => super.registrarSetor());
  }

  late final _$alterarSetorAsyncAction =
      AsyncAction('SetorStoreBase.alterarSetor', context: context);

  @override
  Future<void> alterarSetor() {
    return _$alterarSetorAsyncAction.run(() => super.alterarSetor());
  }

  late final _$SetorStoreBaseActionController =
      ActionController(name: 'SetorStoreBase', context: context);

  @override
  String changeOrder() {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.changeOrder');
    try {
      return super.changeOrder();
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setData1(DateTime value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setData1');
    try {
      return super.setData1(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setData2(DateTime value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setData2');
    try {
      return super.setData2(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Area setAreaSelecionada(Area estufa) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setAreaSelecionada');
    try {
      return super.setAreaSelecionada(estufa);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setDropDown(String value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setDropDown');
    try {
      return super.setDropDown(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setSearchSetorText(String value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setSearchSetorText');
    try {
      return super.setSearchSetorText(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsEditing(bool value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSetorEditing(Setor setor) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setSetorEditing');
    try {
      return super.setSetorEditing(setor);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowTextFormField(bool value) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setShowTextFormField');
    try {
      return super.setShowTextFormField(value);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparTudo() {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.limparTudo');
    try {
      return super.limparTudo();
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarNome(String name) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Reservatorio setReservatorioSelecionada(Reservatorio reservatorio) {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.setReservatorioSelecionada');
    try {
      return super.setReservatorioSelecionada(reservatorio);
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarCadastro() {
    final _$actionInfo = _$SetorStoreBaseActionController.startAction(
        name: 'SetorStoreBase.validarCadastro');
    try {
      return super.validarCadastro();
    } finally {
      _$SetorStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchSetorText: ${searchSetorText},
dropDownValue: ${dropDownValue},
order: ${order},
isSetorListLoading: ${isSetorListLoading},
areaSelecionada: ${areaSelecionada},
setorList: ${setorList},
data1: ${data1},
data2: ${data2},
isEditing: ${isEditing},
mostrarErroFormulario: ${mostrarErroFormulario},
reservatorioList: ${reservatorioList},
novoSetorName: ${novoSetorName},
novoSetorDescription: ${novoSetorDescription},
novoSetorReservatorio: ${novoSetorReservatorio},
showTextFormField: ${showTextFormField},
isNovoSetorLoading: ${isNovoSetorLoading},
isDeletingSetorCascade: ${isDeletingSetorCascade},
dotIndicator: ${dotIndicator},
novoSetor: ${novoSetor},
searchSetor: ${searchSetor}
    ''';
  }
}
