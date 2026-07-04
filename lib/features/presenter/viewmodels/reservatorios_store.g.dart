// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservatorios_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReservatoriosStore on ReservatoriosStoreBase, Store {
  Computed<List<Reservatorio>>? _$searchReservatorioComputed;

  @override
  List<Reservatorio> get searchReservatorio => (_$searchReservatorioComputed ??=
          Computed<List<Reservatorio>>(() => super.searchReservatorio,
              name: 'ReservatoriosStoreBase.searchReservatorio'))
      .value;

  late final _$reservatorioDetalhesAtom = Atom(
      name: 'ReservatoriosStoreBase.reservatorioDetalhes', context: context);

  @override
  Reservatorio get reservatorioDetalhes {
    _$reservatorioDetalhesAtom.reportRead();
    return super.reservatorioDetalhes;
  }

  @override
  set reservatorioDetalhes(Reservatorio value) {
    _$reservatorioDetalhesAtom.reportWrite(value, super.reservatorioDetalhes,
        () {
      super.reservatorioDetalhes = value;
    });
  }

  late final _$solucaoNutritivaListAtom = Atom(
      name: 'ReservatoriosStoreBase.solucaoNutritivaList', context: context);

  @override
  List<SolucaoFertilizanteConcentrada> get solucaoNutritivaList {
    _$solucaoNutritivaListAtom.reportRead();
    return super.solucaoNutritivaList;
  }

  @override
  set solucaoNutritivaList(List<SolucaoFertilizanteConcentrada> value) {
    _$solucaoNutritivaListAtom.reportWrite(value, super.solucaoNutritivaList,
        () {
      super.solucaoNutritivaList = value;
    });
  }

  late final _$solucaoConcentradaListAtom = Atom(
      name: 'ReservatoriosStoreBase.solucaoConcentradaList', context: context);

  @override
  List<SolucaoFertilizanteConcentrada> get solucaoConcentradaList {
    _$solucaoConcentradaListAtom.reportRead();
    return super.solucaoConcentradaList;
  }

  @override
  set solucaoConcentradaList(List<SolucaoFertilizanteConcentrada> value) {
    _$solucaoConcentradaListAtom
        .reportWrite(value, super.solucaoConcentradaList, () {
      super.solucaoConcentradaList = value;
    });
  }

  late final _$indexDotDetalheAtom =
      Atom(name: 'ReservatoriosStoreBase.indexDotDetalhe', context: context);

  @override
  double get indexDotDetalhe {
    _$indexDotDetalheAtom.reportRead();
    return super.indexDotDetalhe;
  }

  @override
  set indexDotDetalhe(double value) {
    _$indexDotDetalheAtom.reportWrite(value, super.indexDotDetalhe, () {
      super.indexDotDetalhe = value;
    });
  }

  late final _$mostrarErroFormularioAtom = Atom(
      name: 'ReservatoriosStoreBase.mostrarErroFormulario', context: context);

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

  late final _$isSolucaoListLoadingAtom = Atom(
      name: 'ReservatoriosStoreBase.isSolucaoListLoading', context: context);

  @override
  bool get isSolucaoListLoading {
    _$isSolucaoListLoadingAtom.reportRead();
    return super.isSolucaoListLoading;
  }

  @override
  set isSolucaoListLoading(bool value) {
    _$isSolucaoListLoadingAtom.reportWrite(value, super.isSolucaoListLoading,
        () {
      super.isSolucaoListLoading = value;
    });
  }

  late final _$isReservatorioListLoadingAtom = Atom(
      name: 'ReservatoriosStoreBase.isReservatorioListLoading',
      context: context);

  @override
  bool get isReservatorioListLoading {
    _$isReservatorioListLoadingAtom.reportRead();
    return super.isReservatorioListLoading;
  }

  @override
  set isReservatorioListLoading(bool value) {
    _$isReservatorioListLoadingAtom
        .reportWrite(value, super.isReservatorioListLoading, () {
      super.isReservatorioListLoading = value;
    });
  }

  late final _$isNovoReservatorioLoadingAtom = Atom(
      name: 'ReservatoriosStoreBase.isNovoReservatorioLoading',
      context: context);

  @override
  bool get isNovoReservatorioLoading {
    _$isNovoReservatorioLoadingAtom.reportRead();
    return super.isNovoReservatorioLoading;
  }

  @override
  set isNovoReservatorioLoading(bool value) {
    _$isNovoReservatorioLoadingAtom
        .reportWrite(value, super.isNovoReservatorioLoading, () {
      super.isNovoReservatorioLoading = value;
    });
  }

  late final _$isDeletingReservatorioAtom = Atom(
      name: 'ReservatoriosStoreBase.isDeletingReservatorio', context: context);

  @override
  bool get isDeletingReservatorio {
    _$isDeletingReservatorioAtom.reportRead();
    return super.isDeletingReservatorio;
  }

  @override
  set isDeletingReservatorio(bool value) {
    _$isDeletingReservatorioAtom
        .reportWrite(value, super.isDeletingReservatorio, () {
      super.isDeletingReservatorio = value;
    });
  }

  late final _$isDetalhesSolucaoLoadingAtom = Atom(
      name: 'ReservatoriosStoreBase.isDetalhesSolucaoLoading',
      context: context);

  @override
  bool get isDetalhesSolucaoLoading {
    _$isDetalhesSolucaoLoadingAtom.reportRead();
    return super.isDetalhesSolucaoLoading;
  }

  @override
  set isDetalhesSolucaoLoading(bool value) {
    _$isDetalhesSolucaoLoadingAtom
        .reportWrite(value, super.isDetalhesSolucaoLoading, () {
      super.isDetalhesSolucaoLoading = value;
    });
  }

  late final _$isEditingAtom =
      Atom(name: 'ReservatoriosStoreBase.isEditing', context: context);

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

  late final _$solucaoDetalhesAtom =
      Atom(name: 'ReservatoriosStoreBase.solucaoDetalhes', context: context);

  @override
  SolucaoNutritiva? get solucaoDetalhes {
    _$solucaoDetalhesAtom.reportRead();
    return super.solucaoDetalhes;
  }

  @override
  set solucaoDetalhes(SolucaoNutritiva? value) {
    _$solucaoDetalhesAtom.reportWrite(value, super.solucaoDetalhes, () {
      super.solucaoDetalhes = value;
    });
  }

  late final _$teorNutrientesAtom =
      Atom(name: 'ReservatoriosStoreBase.teorNutrientes', context: context);

  @override
  List<FertilizanteNutriente> get teorNutrientes {
    _$teorNutrientesAtom.reportRead();
    return super.teorNutrientes;
  }

  @override
  set teorNutrientes(List<FertilizanteNutriente> value) {
    _$teorNutrientesAtom.reportWrite(value, super.teorNutrientes, () {
      super.teorNutrientes = value;
    });
  }

  late final _$relacaoNutrientesAtom =
      Atom(name: 'ReservatoriosStoreBase.relacaoNutrientes', context: context);

  @override
  List<RelacaoNutriente> get relacaoNutrientes {
    _$relacaoNutrientesAtom.reportRead();
    return super.relacaoNutrientes;
  }

  @override
  set relacaoNutrientes(List<RelacaoNutriente> value) {
    _$relacaoNutrientesAtom.reportWrite(value, super.relacaoNutrientes, () {
      super.relacaoNutrientes = value;
    });
  }

  late final _$solucaoListAtom =
      Atom(name: 'ReservatoriosStoreBase.solucaoList', context: context);

  @override
  List<SolucaoNutritiva> get solucaoList {
    _$solucaoListAtom.reportRead();
    return super.solucaoList;
  }

  @override
  set solucaoList(List<SolucaoNutritiva> value) {
    _$solucaoListAtom.reportWrite(value, super.solucaoList, () {
      super.solucaoList = value;
    });
  }

  late final _$reservatorioListAtom =
      Atom(name: 'ReservatoriosStoreBase.reservatorioList', context: context);

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

  late final _$novoReservatorioAtom =
      Atom(name: 'ReservatoriosStoreBase.novoReservatorio', context: context);

  @override
  Reservatorio get novoReservatorio {
    _$novoReservatorioAtom.reportRead();
    return super.novoReservatorio;
  }

  @override
  set novoReservatorio(Reservatorio value) {
    _$novoReservatorioAtom.reportWrite(value, super.novoReservatorio, () {
      super.novoReservatorio = value;
    });
  }

  late final _$solucaoNutritivaAtom =
      Atom(name: 'ReservatoriosStoreBase.solucaoNutritiva', context: context);

  @override
  SolucaoNutritiva get solucaoNutritiva {
    _$solucaoNutritivaAtom.reportRead();
    return super.solucaoNutritiva;
  }

  @override
  set solucaoNutritiva(SolucaoNutritiva value) {
    _$solucaoNutritivaAtom.reportWrite(value, super.solucaoNutritiva, () {
      super.solucaoNutritiva = value;
    });
  }

  late final _$isSolucaoNutritivaValidAtom = Atom(
      name: 'ReservatoriosStoreBase.isSolucaoNutritivaValid', context: context);

  @override
  bool get isSolucaoNutritivaValid {
    _$isSolucaoNutritivaValidAtom.reportRead();
    return super.isSolucaoNutritivaValid;
  }

  @override
  set isSolucaoNutritivaValid(bool value) {
    _$isSolucaoNutritivaValidAtom
        .reportWrite(value, super.isSolucaoNutritivaValid, () {
      super.isSolucaoNutritivaValid = value;
    });
  }

  late final _$novoReservatorioNameAtom = Atom(
      name: 'ReservatoriosStoreBase.novoReservatorioName', context: context);

  @override
  TextEditingController get novoReservatorioName {
    _$novoReservatorioNameAtom.reportRead();
    return super.novoReservatorioName;
  }

  @override
  set novoReservatorioName(TextEditingController value) {
    _$novoReservatorioNameAtom.reportWrite(value, super.novoReservatorioName,
        () {
      super.novoReservatorioName = value;
    });
  }

  late final _$novoReservatorioVolumeAtom = Atom(
      name: 'ReservatoriosStoreBase.novoReservatorioVolume', context: context);

  @override
  TextEditingController get novoReservatorioVolume {
    _$novoReservatorioVolumeAtom.reportRead();
    return super.novoReservatorioVolume;
  }

  @override
  set novoReservatorioVolume(TextEditingController value) {
    _$novoReservatorioVolumeAtom
        .reportWrite(value, super.novoReservatorioVolume, () {
      super.novoReservatorioVolume = value;
    });
  }

  late final _$pesquisarReceitaAtom =
      Atom(name: 'ReservatoriosStoreBase.pesquisarReceita', context: context);

  @override
  TextEditingController get pesquisarReceita {
    _$pesquisarReceitaAtom.reportRead();
    return super.pesquisarReceita;
  }

  @override
  set pesquisarReceita(TextEditingController value) {
    _$pesquisarReceitaAtom.reportWrite(value, super.pesquisarReceita, () {
      super.pesquisarReceita = value;
    });
  }

  late final _$dotIndicatorAtom =
      Atom(name: 'ReservatoriosStoreBase.dotIndicator', context: context);

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

  late final _$searchReservatorioTextAtom = Atom(
      name: 'ReservatoriosStoreBase.searchReservatorioText', context: context);

  @override
  String get searchReservatorioText {
    _$searchReservatorioTextAtom.reportRead();
    return super.searchReservatorioText;
  }

  @override
  set searchReservatorioText(String value) {
    _$searchReservatorioTextAtom
        .reportWrite(value, super.searchReservatorioText, () {
      super.searchReservatorioText = value;
    });
  }

  late final _$buscarReservatorioDetalhesAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.buscarReservatorioDetalhes',
      context: context);

  @override
  Future<void> buscarReservatorioDetalhes({int? reservatorioId}) {
    return _$buscarReservatorioDetalhesAsyncAction.run(
        () => super.buscarReservatorioDetalhes(reservatorioId: reservatorioId));
  }

  late final _$setSolucaoDetalhesAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.setSolucaoDetalhes',
      context: context);

  @override
  Future<void> setSolucaoDetalhes(SolucaoNutritiva solucao) {
    return _$setSolucaoDetalhesAsyncAction
        .run(() => super.setSolucaoDetalhes(solucao));
  }

  late final _$buscarReservatoriosAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.buscarReservatorios',
      context: context);

  @override
  Future<void> buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  late final _$buscarSolucoesAsyncAction =
      AsyncAction('ReservatoriosStoreBase.buscarSolucoes', context: context);

  @override
  Future<void> buscarSolucoes() {
    return _$buscarSolucoesAsyncAction.run(() => super.buscarSolucoes());
  }

  late final _$deletarReservatorioAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.deletarReservatorio',
      context: context);

  @override
  Future<void> deletarReservatorio(int reservatorioId) {
    return _$deletarReservatorioAsyncAction
        .run(() => super.deletarReservatorio(reservatorioId));
  }

  late final _$registrarReservatorioAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.registrarReservatorio',
      context: context);

  @override
  Future<void> registrarReservatorio({bool isShortcut = false}) {
    return _$registrarReservatorioAsyncAction
        .run(() => super.registrarReservatorio(isShortcut: isShortcut));
  }

  late final _$updateReservatorioAsyncAction = AsyncAction(
      'ReservatoriosStoreBase.updateReservatorio',
      context: context);

  @override
  Future<void> updateReservatorio() {
    return _$updateReservatorioAsyncAction
        .run(() => super.updateReservatorio());
  }

  late final _$ReservatoriosStoreBaseActionController =
      ActionController(name: 'ReservatoriosStoreBase', context: context);

  @override
  double setIndexDotDetalhe(double value) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setIndexDotDetalhe');
    try {
      return super.setIndexDotDetalhe(value);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReservatorioDetalhes(Reservatorio reservatorio) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setReservatorioDetalhes');
    try {
      return super.setReservatorioDetalhes(reservatorio);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double calcularQuantidadeFertilizanteConcentrada(
      {required double quantidadeOriginal,
      required double volumeConcentrada,
      required double fator}) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name:
            'ReservatoriosStoreBase.calcularQuantidadeFertilizanteConcentrada');
    try {
      return super.calcularQuantidadeFertilizanteConcentrada(
          quantidadeOriginal: quantidadeOriginal,
          volumeConcentrada: volumeConcentrada,
          fator: fator);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setSearchReservatorioText(String value) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setSearchReservatorioText');
    try {
      return super.setSearchReservatorioText(value);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsEditing(bool value) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSolucaoNutritiva(SolucaoNutritiva solucao) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.setSolucaoNutritiva');
    try {
      return super.setSolucaoNutritiva(solucao);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void desvincularSolucaoNutritiva() {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.desvincularSolucaoNutritiva');
    try {
      return super.desvincularSolucaoNutritiva();
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarReservatorio() {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.validarReservatorio');
    try {
      return super.validarReservatorio();
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void carregarDadosReservatorio(Reservatorio reservatorio) {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.carregarDadosReservatorio');
    try {
      return super.carregarDadosReservatorio(reservatorio);
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparNovoReservatorio() {
    final _$actionInfo = _$ReservatoriosStoreBaseActionController.startAction(
        name: 'ReservatoriosStoreBase.limparNovoReservatorio');
    try {
      return super.limparNovoReservatorio();
    } finally {
      _$ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
reservatorioDetalhes: ${reservatorioDetalhes},
solucaoNutritivaList: ${solucaoNutritivaList},
solucaoConcentradaList: ${solucaoConcentradaList},
indexDotDetalhe: ${indexDotDetalhe},
mostrarErroFormulario: ${mostrarErroFormulario},
isSolucaoListLoading: ${isSolucaoListLoading},
isReservatorioListLoading: ${isReservatorioListLoading},
isNovoReservatorioLoading: ${isNovoReservatorioLoading},
isDeletingReservatorio: ${isDeletingReservatorio},
isDetalhesSolucaoLoading: ${isDetalhesSolucaoLoading},
isEditing: ${isEditing},
solucaoDetalhes: ${solucaoDetalhes},
teorNutrientes: ${teorNutrientes},
relacaoNutrientes: ${relacaoNutrientes},
solucaoList: ${solucaoList},
reservatorioList: ${reservatorioList},
novoReservatorio: ${novoReservatorio},
solucaoNutritiva: ${solucaoNutritiva},
isSolucaoNutritivaValid: ${isSolucaoNutritivaValid},
novoReservatorioName: ${novoReservatorioName},
novoReservatorioVolume: ${novoReservatorioVolume},
pesquisarReceita: ${pesquisarReceita},
dotIndicator: ${dotIndicator},
searchReservatorioText: ${searchReservatorioText},
searchReservatorio: ${searchReservatorio}
    ''';
  }
}
