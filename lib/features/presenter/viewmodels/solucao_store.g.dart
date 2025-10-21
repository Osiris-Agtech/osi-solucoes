// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SolucaoStore on SolucaoStoreBase, Store {
  Computed<List<Fertilizante>>? _$selectedFertilizantesComputed;

  @override
  List<Fertilizante> get selectedFertilizantes =>
      (_$selectedFertilizantesComputed ??= Computed<List<Fertilizante>>(
              () => super.selectedFertilizantes,
              name: 'SolucaoStoreBase.selectedFertilizantes'))
          .value;
  Computed<List<FertilizanteNutriente>>? _$nutrientesCalculadosComputed;

  @override
  List<FertilizanteNutriente> get nutrientesCalculados =>
      (_$nutrientesCalculadosComputed ??= Computed<List<FertilizanteNutriente>>(
              () => super.nutrientesCalculados,
              name: 'SolucaoStoreBase.nutrientesCalculados'))
          .value;
  Computed<List<SolucaoNutritiva>>? _$searchSolucaoComputed;

  @override
  List<SolucaoNutritiva> get searchSolucao => (_$searchSolucaoComputed ??=
          Computed<List<SolucaoNutritiva>>(() => super.searchSolucao,
              name: 'SolucaoStoreBase.searchSolucao'))
      .value;
  Computed<List<SelecaoFertilizante>>? _$showFertilizantesNaoUtilizadosComputed;

  @override
  List<SelecaoFertilizante> get showFertilizantesNaoUtilizados =>
      (_$showFertilizantesNaoUtilizadosComputed ??=
              Computed<List<SelecaoFertilizante>>(
                  () => super.showFertilizantesNaoUtilizados,
                  name: 'SolucaoStoreBase.showFertilizantesNaoUtilizados'))
          .value;
  Computed<List<SelecaoFertilizante>>? _$showSelectedFertilizantesComputed;

  @override
  List<SelecaoFertilizante> get showSelectedFertilizantes =>
      (_$showSelectedFertilizantesComputed ??=
              Computed<List<SelecaoFertilizante>>(
                  () => super.showSelectedFertilizantes,
                  name: 'SolucaoStoreBase.showSelectedFertilizantes'))
          .value;

  late final _$valueAtom =
      Atom(name: 'SolucaoStoreBase.value', context: context);

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$mostrarErroFormularioAtom =
      Atom(name: 'SolucaoStoreBase.mostrarErroFormulario', context: context);

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

  late final _$isSolucaoListLoadingAtom =
      Atom(name: 'SolucaoStoreBase.isSolucaoListLoading', context: context);

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

  late final _$isNovaSolucaoLoadingAtom =
      Atom(name: 'SolucaoStoreBase.isNovaSolucaoLoading', context: context);

  @override
  bool get isNovaSolucaoLoading {
    _$isNovaSolucaoLoadingAtom.reportRead();
    return super.isNovaSolucaoLoading;
  }

  @override
  set isNovaSolucaoLoading(bool value) {
    _$isNovaSolucaoLoadingAtom.reportWrite(value, super.isNovaSolucaoLoading,
        () {
      super.isNovaSolucaoLoading = value;
    });
  }

  late final _$isFertilizanteListLoadingAtom = Atom(
      name: 'SolucaoStoreBase.isFertilizanteListLoading', context: context);

  @override
  bool get isFertilizanteListLoading {
    _$isFertilizanteListLoadingAtom.reportRead();
    return super.isFertilizanteListLoading;
  }

  @override
  set isFertilizanteListLoading(bool value) {
    _$isFertilizanteListLoadingAtom
        .reportWrite(value, super.isFertilizanteListLoading, () {
      super.isFertilizanteListLoading = value;
    });
  }

  late final _$isSolucaoDetalhesLoadingAtom =
      Atom(name: 'SolucaoStoreBase.isSolucaoDetalhesLoading', context: context);

  @override
  bool get isSolucaoDetalhesLoading {
    _$isSolucaoDetalhesLoadingAtom.reportRead();
    return super.isSolucaoDetalhesLoading;
  }

  @override
  set isSolucaoDetalhesLoading(bool value) {
    _$isSolucaoDetalhesLoadingAtom
        .reportWrite(value, super.isSolucaoDetalhesLoading, () {
      super.isSolucaoDetalhesLoading = value;
    });
  }

  late final _$dotIndicatorAtom =
      Atom(name: 'SolucaoStoreBase.dotIndicator', context: context);

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

  late final _$novaSolucaoAtom =
      Atom(name: 'SolucaoStoreBase.novaSolucao', context: context);

  @override
  SolucaoNutritiva get novaSolucao {
    _$novaSolucaoAtom.reportRead();
    return super.novaSolucao;
  }

  @override
  set novaSolucao(SolucaoNutritiva value) {
    _$novaSolucaoAtom.reportWrite(value, super.novaSolucao, () {
      super.novaSolucao = value;
    });
  }

  late final _$solucaoListAtom =
      Atom(name: 'SolucaoStoreBase.solucaoList', context: context);

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

  late final _$fertilizanteListAtom =
      Atom(name: 'SolucaoStoreBase.fertilizanteList', context: context);

  @override
  List<SelecaoFertilizante> get fertilizanteList {
    _$fertilizanteListAtom.reportRead();
    return super.fertilizanteList;
  }

  @override
  set fertilizanteList(List<SelecaoFertilizante> value) {
    _$fertilizanteListAtom.reportWrite(value, super.fertilizanteList, () {
      super.fertilizanteList = value;
    });
  }

  late final _$expandedFertilizantesAtom =
      Atom(name: 'SolucaoStoreBase.expandedFertilizantes', context: context);

  @override
  List<ItemFertilizante> get expandedFertilizantes {
    _$expandedFertilizantesAtom.reportRead();
    return super.expandedFertilizantes;
  }

  @override
  set expandedFertilizantes(List<ItemFertilizante> value) {
    _$expandedFertilizantesAtom.reportWrite(value, super.expandedFertilizantes,
        () {
      super.expandedFertilizantes = value;
    });
  }

  late final _$quantidadeFertilizantesAtom =
      Atom(name: 'SolucaoStoreBase.quantidadeFertilizantes', context: context);

  @override
  List<String> get quantidadeFertilizantes {
    _$quantidadeFertilizantesAtom.reportRead();
    return super.quantidadeFertilizantes;
  }

  @override
  set quantidadeFertilizantes(List<String> value) {
    _$quantidadeFertilizantesAtom
        .reportWrite(value, super.quantidadeFertilizantes, () {
      super.quantidadeFertilizantes = value;
    });
  }

  late final _$nutrientesListAtom =
      Atom(name: 'SolucaoStoreBase.nutrientesList', context: context);

  @override
  List<FertilizanteNutrienteMap> get nutrientesList {
    _$nutrientesListAtom.reportRead();
    return super.nutrientesList;
  }

  @override
  set nutrientesList(List<FertilizanteNutrienteMap> value) {
    _$nutrientesListAtom.reportWrite(value, super.nutrientesList, () {
      super.nutrientesList = value;
    });
  }

  late final _$solucaoConcentradaListDetalhesAtom = Atom(
      name: 'SolucaoStoreBase.solucaoConcentradaListDetalhes',
      context: context);

  @override
  List<SolucaoFertilizanteConcentrada> get solucaoConcentradaListDetalhes {
    _$solucaoConcentradaListDetalhesAtom.reportRead();
    return super.solucaoConcentradaListDetalhes;
  }

  @override
  set solucaoConcentradaListDetalhes(
      List<SolucaoFertilizanteConcentrada> value) {
    _$solucaoConcentradaListDetalhesAtom
        .reportWrite(value, super.solucaoConcentradaListDetalhes, () {
      super.solucaoConcentradaListDetalhes = value;
    });
  }

  late final _$novaSolucaoNameAtom =
      Atom(name: 'SolucaoStoreBase.novaSolucaoName', context: context);

  @override
  TextEditingController get novaSolucaoName {
    _$novaSolucaoNameAtom.reportRead();
    return super.novaSolucaoName;
  }

  @override
  set novaSolucaoName(TextEditingController value) {
    _$novaSolucaoNameAtom.reportWrite(value, super.novaSolucaoName, () {
      super.novaSolucaoName = value;
    });
  }

  late final _$solucaoSelecionadaAtom =
      Atom(name: 'SolucaoStoreBase.solucaoSelecionada', context: context);

  @override
  SolucaoNutritiva get solucaoSelecionada {
    _$solucaoSelecionadaAtom.reportRead();
    return super.solucaoSelecionada;
  }

  @override
  set solucaoSelecionada(SolucaoNutritiva value) {
    _$solucaoSelecionadaAtom.reportWrite(value, super.solucaoSelecionada, () {
      super.solucaoSelecionada = value;
    });
  }

  late final _$condutividadeEletricaAtom =
      Atom(name: 'SolucaoStoreBase.condutividadeEletrica', context: context);

  @override
  TextEditingController get condutividadeEletrica {
    _$condutividadeEletricaAtom.reportRead();
    return super.condutividadeEletrica;
  }

  @override
  set condutividadeEletrica(TextEditingController value) {
    _$condutividadeEletricaAtom.reportWrite(value, super.condutividadeEletrica,
        () {
      super.condutividadeEletrica = value;
    });
  }

  late final _$searchSolucaoTextAtom =
      Atom(name: 'SolucaoStoreBase.searchSolucaoText', context: context);

  @override
  String get searchSolucaoText {
    _$searchSolucaoTextAtom.reportRead();
    return super.searchSolucaoText;
  }

  @override
  set searchSolucaoText(String value) {
    _$searchSolucaoTextAtom.reportWrite(value, super.searchSolucaoText, () {
      super.searchSolucaoText = value;
    });
  }

  late final _$fertilizantesEscolhidosAtom =
      Atom(name: 'SolucaoStoreBase.fertilizantesEscolhidos', context: context);

  @override
  List<SelecaoFertilizante> get fertilizantesEscolhidos {
    _$fertilizantesEscolhidosAtom.reportRead();
    return super.fertilizantesEscolhidos;
  }

  @override
  set fertilizantesEscolhidos(List<SelecaoFertilizante> value) {
    _$fertilizantesEscolhidosAtom
        .reportWrite(value, super.fertilizantesEscolhidos, () {
      super.fertilizantesEscolhidos = value;
    });
  }

  late final _$fatorConcentracaoAtom =
      Atom(name: 'SolucaoStoreBase.fatorConcentracao', context: context);

  @override
  TextEditingController get fatorConcentracao {
    _$fatorConcentracaoAtom.reportRead();
    return super.fatorConcentracao;
  }

  @override
  set fatorConcentracao(TextEditingController value) {
    _$fatorConcentracaoAtom.reportWrite(value, super.fatorConcentracao, () {
      super.fatorConcentracao = value;
    });
  }

  late final _$volumeConcentracaoAtom =
      Atom(name: 'SolucaoStoreBase.volumeConcentracao', context: context);

  @override
  TextEditingController get volumeConcentracao {
    _$volumeConcentracaoAtom.reportRead();
    return super.volumeConcentracao;
  }

  @override
  set volumeConcentracao(TextEditingController value) {
    _$volumeConcentracaoAtom.reportWrite(value, super.volumeConcentracao, () {
      super.volumeConcentracao = value;
    });
  }

  late final _$solucaoConcentradaListAtom =
      Atom(name: 'SolucaoStoreBase.solucaoConcentradaList', context: context);

  @override
  List<SolucaoConcentrada> get solucaoConcentradaList {
    _$solucaoConcentradaListAtom.reportRead();
    return super.solucaoConcentradaList;
  }

  @override
  set solucaoConcentradaList(List<SolucaoConcentrada> value) {
    _$solucaoConcentradaListAtom
        .reportWrite(value, super.solucaoConcentradaList, () {
      super.solucaoConcentradaList = value;
    });
  }

  late final _$buscarSolucoesAsyncAction =
      AsyncAction('SolucaoStoreBase.buscarSolucoes', context: context);

  @override
  Future<void> buscarSolucoes() {
    return _$buscarSolucoesAsyncAction.run(() => super.buscarSolucoes());
  }

  late final _$buscarFertilizantesAsyncAction =
      AsyncAction('SolucaoStoreBase.buscarFertilizantes', context: context);

  @override
  Future<void> buscarFertilizantes() {
    return _$buscarFertilizantesAsyncAction
        .run(() => super.buscarFertilizantes());
  }

  late final _$buscarDetalhesSolucaoAsyncAction =
      AsyncAction('SolucaoStoreBase.buscarDetalhesSolucao', context: context);

  @override
  Future<void> buscarDetalhesSolucao() {
    return _$buscarDetalhesSolucaoAsyncAction
        .run(() => super.buscarDetalhesSolucao());
  }

  late final _$cadastrarSolucaoNutritivaAsyncAction = AsyncAction(
      'SolucaoStoreBase.cadastrarSolucaoNutritiva',
      context: context);

  @override
  Future<void> cadastrarSolucaoNutritiva({bool isShortcut = false}) {
    return _$cadastrarSolucaoNutritivaAsyncAction
        .run(() => super.cadastrarSolucaoNutritiva(isShortcut: isShortcut));
  }

  late final _$criarSolucaoConcentradaAsyncAction =
      AsyncAction('SolucaoStoreBase.criarSolucaoConcentrada', context: context);

  @override
  Future<void> criarSolucaoConcentrada() {
    return _$criarSolucaoConcentradaAsyncAction
        .run(() => super.criarSolucaoConcentrada());
  }

  late final _$SolucaoStoreBaseActionController =
      ActionController(name: 'SolucaoStoreBase', context: context);

  @override
  void increment() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setExpandedCard(int index) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setExpandedCard');
    try {
      return super.setExpandedCard(index);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setsearchSolucaoText(String value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setsearchSolucaoText');
    try {
      return super.setsearchSolucaoText(value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  SolucaoNutritiva selecionarSolucao(SolucaoNutritiva solucaoNutritiva) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.selecionarSolucao');
    try {
      return super.selecionarSolucao(solucaoNutritiva);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromExpendedList(int id) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.removeFromExpendedList');
    try {
      return super.removeFromExpendedList(id);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeSelecaoFertilizante(int index, bool value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.changeSelecaoFertilizante');
    try {
      return super.changeSelecaoFertilizante(index, value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFertilizanteQuantidade(int id, String value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setFertilizanteQuantidade');
    try {
      return super.setFertilizanteQuantidade(id, value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double calcularQuantidadeFertilizanteConcentrada(
      {required double quantidadeOriginal,
      required double volumeConcentrada,
      required double fator}) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.calcularQuantidadeFertilizanteConcentrada');
    try {
      return super.calcularQuantidadeFertilizanteConcentrada(
          quantidadeOriginal: quantidadeOriginal,
          volumeConcentrada: volumeConcentrada,
          fator: fator);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void multiplicarTeorNitratoEAmonia() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.multiplicarTeorNitratoEAmonia');
    try {
      return super.multiplicarTeorNitratoEAmonia();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarFertilizantes() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.validarFertilizantes');
    try {
      return super.validarFertilizantes();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double calcularCoeficienteEletrico() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.calcularCoeficienteEletrico');
    try {
      return super.calcularCoeficienteEletrico();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<SolucaoFertilizanteConcentrada>
      generateSolucaoFertilizanteConcentrada() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.generateSolucaoFertilizanteConcentrada');
    try {
      return super.generateSolucaoFertilizanteConcentrada();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateNewSN() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.validateNewSN');
    try {
      return super.validateNewSN();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarCadastroConcentrada() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.validarCadastroConcentrada');
    try {
      return super.validarCadastroConcentrada();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFertilizantesEscolhidos() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setFertilizantesEscolhidos');
    try {
      return super.setFertilizantesEscolhidos();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeSelecaoFertilizantesEscolhidos(int index, bool value) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.changeSelecaoFertilizantesEscolhidos');
    try {
      return super.changeSelecaoFertilizantesEscolhidos(index, value);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addFertilizanteParaSolucao(int indexSolucaoConcentrada) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.addFertilizanteParaSolucao');
    try {
      return super.addFertilizanteParaSolucao(indexSolucaoConcentrada);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSolucaoConcentrada() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.clearSolucaoConcentrada');
    try {
      return super.clearSolucaoConcentrada();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNomeSolucaoConcentrada(String nomeSolucaoConcentrada, int index) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.setNomeSolucaoConcentrada');
    try {
      return super.setNomeSolucaoConcentrada(nomeSolucaoConcentrada, index);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToSolucaoConcentradaList() {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.addToSolucaoConcentradaList');
    try {
      return super.addToSolucaoConcentradaList();
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteSolucaoConcentradaToTheList(int index) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.deleteSolucaoConcentradaToTheList');
    try {
      return super.deleteSolucaoConcentradaToTheList(index);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkCompatibilidade(
      {required int number, required int indexConcentrada}) {
    final _$actionInfo = _$SolucaoStoreBaseActionController.startAction(
        name: 'SolucaoStoreBase.checkCompatibilidade');
    try {
      return super.checkCompatibilidade(
          number: number, indexConcentrada: indexConcentrada);
    } finally {
      _$SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
mostrarErroFormulario: ${mostrarErroFormulario},
isSolucaoListLoading: ${isSolucaoListLoading},
isNovaSolucaoLoading: ${isNovaSolucaoLoading},
isFertilizanteListLoading: ${isFertilizanteListLoading},
isSolucaoDetalhesLoading: ${isSolucaoDetalhesLoading},
dotIndicator: ${dotIndicator},
novaSolucao: ${novaSolucao},
solucaoList: ${solucaoList},
fertilizanteList: ${fertilizanteList},
expandedFertilizantes: ${expandedFertilizantes},
quantidadeFertilizantes: ${quantidadeFertilizantes},
nutrientesList: ${nutrientesList},
solucaoConcentradaListDetalhes: ${solucaoConcentradaListDetalhes},
novaSolucaoName: ${novaSolucaoName},
solucaoSelecionada: ${solucaoSelecionada},
condutividadeEletrica: ${condutividadeEletrica},
searchSolucaoText: ${searchSolucaoText},
fertilizantesEscolhidos: ${fertilizantesEscolhidos},
fatorConcentracao: ${fatorConcentracao},
volumeConcentracao: ${volumeConcentracao},
solucaoConcentradaList: ${solucaoConcentradaList},
selectedFertilizantes: ${selectedFertilizantes},
nutrientesCalculados: ${nutrientesCalculados},
searchSolucao: ${searchSolucao},
showFertilizantesNaoUtilizados: ${showFertilizantesNaoUtilizados},
showSelectedFertilizantes: ${showSelectedFertilizantes}
    ''';
  }
}
