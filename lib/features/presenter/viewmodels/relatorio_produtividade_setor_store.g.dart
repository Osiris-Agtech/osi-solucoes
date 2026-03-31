// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_produtividade_setor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioProdutividadeSetorStore
    on RelatorioProdutividadeSetorStoreBase, Store {
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioProdutividadeSetorStoreBase.hasData'))
      .value;
  Computed<ProdutividadeSetorRanking?>? _$melhorSetorComputed;

  @override
  ProdutividadeSetorRanking? get melhorSetor =>
      (_$melhorSetorComputed ??= Computed<ProdutividadeSetorRanking?>(
              () => super.melhorSetor,
              name: 'RelatorioProdutividadeSetorStoreBase.melhorSetor'))
          .value;
  Computed<ProdutividadeSetorRanking?>? _$piorSetorComputed;

  @override
  ProdutividadeSetorRanking? get piorSetor =>
      (_$piorSetorComputed ??= Computed<ProdutividadeSetorRanking?>(
              () => super.piorSetor,
              name: 'RelatorioProdutividadeSetorStoreBase.piorSetor'))
          .value;
  Computed<String?>? _$etapaGargaloComputed;

  @override
  String? get etapaGargalo => (_$etapaGargaloComputed ??= Computed<String?>(
          () => super.etapaGargalo,
          name: 'RelatorioProdutividadeSetorStoreBase.etapaGargalo'))
      .value;

  late final _$isLoadingAtom = Atom(
      name: 'RelatorioProdutividadeSetorStoreBase.isLoading', context: context);

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

  late final _$hasErrorAtom = Atom(
      name: 'RelatorioProdutividadeSetorStoreBase.hasError', context: context);

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
      name: 'RelatorioProdutividadeSetorStoreBase.errorMessage',
      context: context);

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

  late final _$resultadoAtom = Atom(
      name: 'RelatorioProdutividadeSetorStoreBase.resultado', context: context);

  @override
  RelatorioProdutividadeResult? get resultado {
    _$resultadoAtom.reportRead();
    return super.resultado;
  }

  @override
  set resultado(RelatorioProdutividadeResult? value) {
    _$resultadoAtom.reportWrite(value, super.resultado, () {
      super.resultado = value;
    });
  }

  late final _$filtrosAtom = Atom(
      name: 'RelatorioProdutividadeSetorStoreBase.filtros', context: context);

  @override
  RelatorioProdutividadeFiltros get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(RelatorioProdutividadeFiltros value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$carregarRelatorioAsyncAction = AsyncAction(
      'RelatorioProdutividadeSetorStoreBase.carregarRelatorio',
      context: context);

  @override
  Future<void> carregarRelatorio() {
    return _$carregarRelatorioAsyncAction
        .run(() => super.carregarRelatorio());
  }

  late final _$atualizarFiltrosAsyncAction = AsyncAction(
      'RelatorioProdutividadeSetorStoreBase.atualizarFiltros',
      context: context);

  @override
  Future<void> atualizarFiltros(RelatorioProdutividadeFiltros novosFiltros) {
    return _$atualizarFiltrosAsyncAction
        .run(() => super.atualizarFiltros(novosFiltros));
  }

  late final _$RelatorioProdutividadeSetorStoreBaseActionController =
      ActionController(
          name: 'RelatorioProdutividadeSetorStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$RelatorioProdutividadeSetorStoreBaseActionController.startAction(
            name: 'RelatorioProdutividadeSetorStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioProdutividadeSetorStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo =
        _$RelatorioProdutividadeSetorStoreBaseActionController.startAction(
            name: 'RelatorioProdutividadeSetorStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioProdutividadeSetorStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setResultado(RelatorioProdutividadeResult data) {
    final _$actionInfo =
        _$RelatorioProdutividadeSetorStoreBaseActionController.startAction(
            name: 'RelatorioProdutividadeSetorStoreBase.setResultado');
    try {
      return super.setResultado(data);
    } finally {
      _$RelatorioProdutividadeSetorStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void limpar() {
    final _$actionInfo =
        _$RelatorioProdutividadeSetorStoreBaseActionController.startAction(
            name: 'RelatorioProdutividadeSetorStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$RelatorioProdutividadeSetorStoreBaseActionController
          .endAction(_$actionInfo);
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
melhorSetor: ${melhorSetor},
piorSetor: ${piorSetor},
etapaGargalo: ${etapaGargalo}
    ''';
  }
}
