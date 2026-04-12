// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_desempenho_equipe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioDesempenhoEquipeStore
    on RelatorioDesempenhoEquipeStoreBase, Store {
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioDesempenhoEquipeStoreBase.hasData'))
      .value;
  Computed<DesempenhoUsuarioRanking?>? _$membroMaisAtivoComputed;

  @override
  DesempenhoUsuarioRanking? get membroMaisAtivo =>
      (_$membroMaisAtivoComputed ??= Computed<DesempenhoUsuarioRanking?>(
              () => super.membroMaisAtivo,
              name: 'RelatorioDesempenhoEquipeStoreBase.membroMaisAtivo'))
          .value;
  Computed<DesempenhoUsuarioRanking?>? _$membroMaiorConclusaoComputed;

  @override
  DesempenhoUsuarioRanking? get membroMaiorConclusao =>
      (_$membroMaiorConclusaoComputed ??= Computed<DesempenhoUsuarioRanking?>(
              () => super.membroMaiorConclusao,
              name: 'RelatorioDesempenhoEquipeStoreBase.membroMaiorConclusao'))
          .value;
  Computed<List<DesempenhoUsuarioRanking>>? _$membrosComAlertaComputed;

  @override
  List<DesempenhoUsuarioRanking> get membrosComAlerta =>
      (_$membrosComAlertaComputed ??= Computed<List<DesempenhoUsuarioRanking>>(
              () => super.membrosComAlerta,
              name: 'RelatorioDesempenhoEquipeStoreBase.membrosComAlerta'))
          .value;
  Computed<bool>? _$equipeComBaixaConclusaoComputed;

  @override
  bool get equipeComBaixaConclusao => (_$equipeComBaixaConclusaoComputed ??=
          Computed<bool>(() => super.equipeComBaixaConclusao,
              name:
                  'RelatorioDesempenhoEquipeStoreBase.equipeComBaixaConclusao'))
      .value;
  Computed<List<DesempenhoUsuarioRanking>>? _$membrosComAtrasosComputed;

  @override
  List<DesempenhoUsuarioRanking> get membrosComAtrasos =>
      (_$membrosComAtrasosComputed ??= Computed<List<DesempenhoUsuarioRanking>>(
              () => super.membrosComAtrasos,
              name: 'RelatorioDesempenhoEquipeStoreBase.membrosComAtrasos'))
          .value;

  late final _$isLoadingAtom = Atom(
      name: 'RelatorioDesempenhoEquipeStoreBase.isLoading', context: context);

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
      name: 'RelatorioDesempenhoEquipeStoreBase.hasError', context: context);

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
      name: 'RelatorioDesempenhoEquipeStoreBase.errorMessage',
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
      name: 'RelatorioDesempenhoEquipeStoreBase.resultado', context: context);

  @override
  RelatorioDesempenhoResult? get resultado {
    _$resultadoAtom.reportRead();
    return super.resultado;
  }

  @override
  set resultado(RelatorioDesempenhoResult? value) {
    _$resultadoAtom.reportWrite(value, super.resultado, () {
      super.resultado = value;
    });
  }

  late final _$filtrosAtom = Atom(
      name: 'RelatorioDesempenhoEquipeStoreBase.filtros', context: context);

  @override
  RelatorioDesempenhoFiltros get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(RelatorioDesempenhoFiltros value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$carregarRelatorioAsyncAction = AsyncAction(
      'RelatorioDesempenhoEquipeStoreBase.carregarRelatorio',
      context: context);

  @override
  Future<void> carregarRelatorio() {
    return _$carregarRelatorioAsyncAction.run(() => super.carregarRelatorio());
  }

  late final _$atualizarFiltrosAsyncAction = AsyncAction(
      'RelatorioDesempenhoEquipeStoreBase.atualizarFiltros',
      context: context);

  @override
  Future<void> atualizarFiltros(RelatorioDesempenhoFiltros novosFiltros) {
    return _$atualizarFiltrosAsyncAction
        .run(() => super.atualizarFiltros(novosFiltros));
  }

  late final _$RelatorioDesempenhoEquipeStoreBaseActionController =
      ActionController(
          name: 'RelatorioDesempenhoEquipeStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$RelatorioDesempenhoEquipeStoreBaseActionController
        .startAction(name: 'RelatorioDesempenhoEquipeStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioDesempenhoEquipeStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo = _$RelatorioDesempenhoEquipeStoreBaseActionController
        .startAction(name: 'RelatorioDesempenhoEquipeStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioDesempenhoEquipeStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setResultado(RelatorioDesempenhoResult data) {
    final _$actionInfo = _$RelatorioDesempenhoEquipeStoreBaseActionController
        .startAction(name: 'RelatorioDesempenhoEquipeStoreBase.setResultado');
    try {
      return super.setResultado(data);
    } finally {
      _$RelatorioDesempenhoEquipeStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void limpar() {
    final _$actionInfo = _$RelatorioDesempenhoEquipeStoreBaseActionController
        .startAction(name: 'RelatorioDesempenhoEquipeStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$RelatorioDesempenhoEquipeStoreBaseActionController
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
membroMaisAtivo: ${membroMaisAtivo},
membroMaiorConclusao: ${membroMaiorConclusao},
membrosComAlerta: ${membrosComAlerta},
equipeComBaixaConclusao: ${equipeComBaixaConclusao},
membrosComAtrasos: ${membrosComAtrasos}
    ''';
  }
}
