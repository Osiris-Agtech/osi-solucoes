// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_ciclo_cultura_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioCicloCulturaStore on RelatorioCicloCulturaStoreBase, Store {
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioCicloCulturaStoreBase.hasData'))
      .value;
  Computed<CicloRankingCultura?>? _$melhorCulturaComputed;

  @override
  CicloRankingCultura? get melhorCultura => (_$melhorCulturaComputed ??=
          Computed<CicloRankingCultura?>(() => super.melhorCultura,
              name: 'RelatorioCicloCulturaStoreBase.melhorCultura'))
      .value;
  Computed<CicloRankingCultura?>? _$piorCulturaComputed;

  @override
  CicloRankingCultura? get piorCultura => (_$piorCulturaComputed ??=
          Computed<CicloRankingCultura?>(() => super.piorCultura,
              name: 'RelatorioCicloCulturaStoreBase.piorCultura'))
      .value;
  Computed<bool>? _$temAtrasoRecorrenteComputed;

  @override
  bool get temAtrasoRecorrente => (_$temAtrasoRecorrenteComputed ??=
          Computed<bool>(() => super.temAtrasoRecorrente,
              name: 'RelatorioCicloCulturaStoreBase.temAtrasoRecorrente'))
      .value;
  Computed<bool>? _$producaoAdiantadaComputed;

  @override
  bool get producaoAdiantada => (_$producaoAdiantadaComputed ??= Computed<bool>(
          () => super.producaoAdiantada,
          name: 'RelatorioCicloCulturaStoreBase.producaoAdiantada'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'RelatorioCicloCulturaStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$hasErrorAtom =
      Atom(name: 'RelatorioCicloCulturaStoreBase.hasError', context: context);

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  late final _$errorMessageAtom = Atom(
      name: 'RelatorioCicloCulturaStoreBase.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$resultadoAtom =
      Atom(name: 'RelatorioCicloCulturaStoreBase.resultado', context: context);

  @override
  RelatorioCicloResult? get resultado {
    _$resultadoAtom.reportRead();
    return super.resultado;
  }

  @override
  set resultado(RelatorioCicloResult? value) {
    _$resultadoAtom.reportWrite(value, super.resultado, () {
      super.resultado = value;
    });
  }

  late final _$filtrosAtom =
      Atom(name: 'RelatorioCicloCulturaStoreBase.filtros', context: context);

  @override
  RelatorioCicloFiltros get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(RelatorioCicloFiltros value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$carregarRelatorioAsyncAction = AsyncAction(
      'RelatorioCicloCulturaStoreBase.carregarRelatorio',
      context: context);

  @override
  Future<void> carregarRelatorio() {
    return _$carregarRelatorioAsyncAction.run(() => super.carregarRelatorio());
  }

  late final _$atualizarFiltrosAsyncAction = AsyncAction(
      'RelatorioCicloCulturaStoreBase.atualizarFiltros',
      context: context);

  @override
  Future<void> atualizarFiltros(RelatorioCicloFiltros novosFiltros) {
    return _$atualizarFiltrosAsyncAction
        .run(() => super.atualizarFiltros(novosFiltros));
  }

  late final _$RelatorioCicloCulturaStoreBaseActionController =
      ActionController(
          name: 'RelatorioCicloCulturaStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$RelatorioCicloCulturaStoreBaseActionController
        .startAction(name: 'RelatorioCicloCulturaStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioCicloCulturaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo = _$RelatorioCicloCulturaStoreBaseActionController
        .startAction(name: 'RelatorioCicloCulturaStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioCicloCulturaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResultado(RelatorioCicloResult data) {
    final _$actionInfo = _$RelatorioCicloCulturaStoreBaseActionController
        .startAction(name: 'RelatorioCicloCulturaStoreBase.setResultado');
    try {
      return super.setResultado(data);
    } finally {
      _$RelatorioCicloCulturaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limpar() {
    final _$actionInfo = _$RelatorioCicloCulturaStoreBaseActionController
        .startAction(name: 'RelatorioCicloCulturaStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$RelatorioCicloCulturaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasError: ${hasError},
errorMessage: ${errorMessage},
resultado: ${resultado},
filtros: ${filtros},
hasData: ${hasData},
melhorCultura: ${melhorCultura},
piorCultura: ${piorCultura},
temAtrasoRecorrente: ${temAtrasoRecorrente},
producaoAdiantada: ${producaoAdiantada}
    ''';
  }
}
