// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SolucaoStore on _SolucaoStoreBase, Store {
  Computed<List<Fertilizante>>? _$selectedFertilizantesComputed;

  @override
  List<Fertilizante> get selectedFertilizantes =>
      (_$selectedFertilizantesComputed ??= Computed<List<Fertilizante>>(
              () => super.selectedFertilizantes,
              name: '_SolucaoStoreBase.selectedFertilizantes'))
          .value;
  Computed<List<FertilizanteNutriente>>? _$nutrientesCalculadosComputed;

  @override
  List<FertilizanteNutriente> get nutrientesCalculados =>
      (_$nutrientesCalculadosComputed ??= Computed<List<FertilizanteNutriente>>(
              () => super.nutrientesCalculados,
              name: '_SolucaoStoreBase.nutrientesCalculados'))
          .value;
  Computed<List<SolucaoNutritiva>>? _$searchSolucaoComputed;

  @override
  List<SolucaoNutritiva> get searchSolucao => (_$searchSolucaoComputed ??=
          Computed<List<SolucaoNutritiva>>(() => super.searchSolucao,
              name: '_SolucaoStoreBase.searchSolucao'))
      .value;
  Computed<List<SelecaoFertilizante>>? _$showFertilizantesNaoUtilizadosComputed;

  @override
  List<SelecaoFertilizante> get showFertilizantesNaoUtilizados =>
      (_$showFertilizantesNaoUtilizadosComputed ??=
              Computed<List<SelecaoFertilizante>>(
                  () => super.showFertilizantesNaoUtilizados,
                  name: '_SolucaoStoreBase.showFertilizantesNaoUtilizados'))
          .value;

  final _$valueAtom = Atom(name: '_SolucaoStoreBase.value');

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

  final _$mostrarErroFormularioAtom =
      Atom(name: '_SolucaoStoreBase.mostrarErroFormulario');

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

  final _$isSolucaoListLoadingAtom =
      Atom(name: '_SolucaoStoreBase.isSolucaoListLoading');

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

  final _$isNovaSolucaoLoadingAtom =
      Atom(name: '_SolucaoStoreBase.isNovaSolucaoLoading');

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

  final _$isFertilizanteListLoadingAtom =
      Atom(name: '_SolucaoStoreBase.isFertilizanteListLoading');

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

  final _$isSolucaoDetalhesLoadingAtom =
      Atom(name: '_SolucaoStoreBase.isSolucaoDetalhesLoading');

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

  final _$mostrarErroFormularioAtom =
      Atom(name: '_SolucaoStoreBase.mostrarErroFormulario');

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

  final _$dotIndicatorAtom = Atom(name: '_SolucaoStoreBase.dotIndicator');

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

  final _$novaSolucaoAtom = Atom(name: '_SolucaoStoreBase.novaSolucao');

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

  final _$solucaoListAtom = Atom(name: '_SolucaoStoreBase.solucaoList');

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

  final _$fertilizanteListAtom =
      Atom(name: '_SolucaoStoreBase.fertilizanteList');

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

  final _$expandedFertilizantesAtom =
      Atom(name: '_SolucaoStoreBase.expandedFertilizantes');

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

  final _$quantidadeFertilizantesAtom =
      Atom(name: '_SolucaoStoreBase.quantidadeFertilizantes');

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

  final _$nutrientesListAtom = Atom(name: '_SolucaoStoreBase.nutrientesList');

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

  final _$novaSolucaoNameAtom = Atom(name: '_SolucaoStoreBase.novaSolucaoName');

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

  final _$solucaoSelecionadaAtom =
      Atom(name: '_SolucaoStoreBase.solucaoSelecionada');

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

  final _$condutividadeEletricaAtom =
      Atom(name: '_SolucaoStoreBase.condutividadeEletrica');

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

  final _$searchSolucaoTextAtom =
      Atom(name: '_SolucaoStoreBase.searchSolucaoText');

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

  final _$fertilizantesEscolhidosAtom =
      Atom(name: '_SolucaoStoreBase.fertilizantesEscolhidos');

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

  final _$fatorConcentracaoAtom =
      Atom(name: '_SolucaoStoreBase.fatorConcentracao');

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

  final _$solucaoConcentradaListAtom =
      Atom(name: '_SolucaoStoreBase.solucaoConcentradaList');

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

  final _$buscarSolucoesAsyncAction =
      AsyncAction('_SolucaoStoreBase.buscarSolucoes');

  @override
  Future buscarSolucoes() {
    return _$buscarSolucoesAsyncAction.run(() => super.buscarSolucoes());
  }

  final _$buscarFertilizantesAsyncAction =
      AsyncAction('_SolucaoStoreBase.buscarFertilizantes');

  @override
  Future buscarFertilizantes() {
    return _$buscarFertilizantesAsyncAction
        .run(() => super.buscarFertilizantes());
  }

  final _$buscarDetalhesSolucaoAsyncAction =
      AsyncAction('_SolucaoStoreBase.buscarDetalhesSolucao');

  @override
  Future buscarDetalhesSolucao() {
    return _$buscarDetalhesSolucaoAsyncAction
        .run(() => super.buscarDetalhesSolucao());
  }

  final _$cadastrarSolucaoNutritivaAsyncAction =
      AsyncAction('_SolucaoStoreBase.cadastrarSolucaoNutritiva');

  @override
  Future cadastrarSolucaoNutritiva() {
    return _$cadastrarSolucaoNutritivaAsyncAction
        .run(() => super.cadastrarSolucaoNutritiva());
  }

  final _$_SolucaoStoreBaseActionController =
      ActionController(name: '_SolucaoStoreBase');

  @override
  void increment() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setExpandedCard(int index) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setExpandedCard');
    try {
      return super.setExpandedCard(index);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setsearchSolucaoText(String value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setsearchSolucaoText');
    try {
      return super.setsearchSolucaoText(value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarSolucao(SolucaoNutritiva solucaoNutritiva) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.selecionarSolucao');
    try {
      return super.selecionarSolucao(solucaoNutritiva);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeFromExpendedList(int id) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.removeFromExpendedList');
    try {
      return super.removeFromExpendedList(id);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeSelecaoFertilizante(int index, bool value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.changeSelecaoFertilizante');
    try {
      return super.changeSelecaoFertilizante(index, value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFertilizanteQuantidade(int id, String value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setFertilizanteQuantidade');
    try {
      return super.setFertilizanteQuantidade(id, value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic validarFertilizantes() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.validarFertilizantes');
    try {
      return super.validarFertilizantes();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic validarCadastro() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.validarCadastro');
    try {
      return super.validarCadastro();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double calcularCoeficienteEletrico() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.calcularCoeficienteEletrico');
    try {
      return super.calcularCoeficienteEletrico();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic generateSolucaoFertilizanteConcentrada() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.generateSolucaoFertilizanteConcentrada');
    try {
      return super.generateSolucaoFertilizanteConcentrada();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic validateNewSN() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.validateNewSN');
    try {
      return super.validateNewSN();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearAll() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFertilizantesEscolhidos() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setFertilizantesEscolhidos');
    try {
      return super.setFertilizantesEscolhidos();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeSelecaoFertilizantesEscolhidos(int index, bool value) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.changeSelecaoFertilizantesEscolhidos');
    try {
      return super.changeSelecaoFertilizantesEscolhidos(index, value);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addFertilizanteParaSolucao(int indexSolucaoConcentrada) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.addFertilizanteParaSolucao');
    try {
      return super.addFertilizanteParaSolucao(indexSolucaoConcentrada);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearSolucaoConcentrada() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.clearSolucaoConcentrada');
    try {
      return super.clearSolucaoConcentrada();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNomeSolucaoConcentrada(String nomeSolucaoConcentrada, int index) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.setNomeSolucaoConcentrada');
    try {
      return super.setNomeSolucaoConcentrada(nomeSolucaoConcentrada, index);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addToSolucaoConcentradaList() {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.addToSolucaoConcentradaList');
    try {
      return super.addToSolucaoConcentradaList();
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteSolucaoConcentradaToTheList(int index) {
    final _$actionInfo = _$_SolucaoStoreBaseActionController.startAction(
        name: '_SolucaoStoreBase.deleteSolucaoConcentradaToTheList');
    try {
      return super.deleteSolucaoConcentradaToTheList(index);
    } finally {
      _$_SolucaoStoreBaseActionController.endAction(_$actionInfo);
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
mostrarErroFormulario: ${mostrarErroFormulario},
dotIndicator: ${dotIndicator},
novaSolucao: ${novaSolucao},
solucaoList: ${solucaoList},
fertilizanteList: ${fertilizanteList},
expandedFertilizantes: ${expandedFertilizantes},
quantidadeFertilizantes: ${quantidadeFertilizantes},
nutrientesList: ${nutrientesList},
novaSolucaoName: ${novaSolucaoName},
solucaoSelecionada: ${solucaoSelecionada},
condutividadeEletrica: ${condutividadeEletrica},
searchSolucaoText: ${searchSolucaoText},
fertilizantesEscolhidos: ${fertilizantesEscolhidos},
fatorConcentracao: ${fatorConcentracao},
solucaoConcentradaList: ${solucaoConcentradaList},
selectedFertilizantes: ${selectedFertilizantes},
nutrientesCalculados: ${nutrientesCalculados},
searchSolucao: ${searchSolucao},
showFertilizantesNaoUtilizados: ${showFertilizantesNaoUtilizados}
    ''';
  }
}
