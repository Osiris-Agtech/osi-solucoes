// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_agenda_tarefas_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioAgendaTarefasStore on RelatorioAgendaTarefasStoreBase, Store {
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioAgendaTarefasStoreBase.hasData'))
      .value;
  Computed<int>? _$totalVencidasComputed;

  @override
  int get totalVencidas =>
      (_$totalVencidasComputed ??= Computed<int>(() => super.totalVencidas,
              name: 'RelatorioAgendaTarefasStoreBase.totalVencidas'))
          .value;
  Computed<bool>? _$temVencidasComputed;

  @override
  bool get temVencidas =>
      (_$temVencidasComputed ??= Computed<bool>(() => super.temVencidas,
              name: 'RelatorioAgendaTarefasStoreBase.temVencidas'))
          .value;
  Computed<AgendaLoteTaxaConclusao?>? _$loteMaisCriticoComputed;

  @override
  AgendaLoteTaxaConclusao? get loteMaisCritico => (_$loteMaisCriticoComputed ??=
          Computed<AgendaLoteTaxaConclusao?>(() => super.loteMaisCritico,
              name: 'RelatorioAgendaTarefasStoreBase.loteMaisCritico'))
      .value;
  Computed<String?>? _$membroComMaisVencidasComputed;

  @override
  String? get membroComMaisVencidas => (_$membroComMaisVencidasComputed ??=
          Computed<String?>(() => super.membroComMaisVencidas,
              name: 'RelatorioAgendaTarefasStoreBase.membroComMaisVencidas'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'RelatorioAgendaTarefasStoreBase.isLoading', context: context);

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
      Atom(name: 'RelatorioAgendaTarefasStoreBase.hasError', context: context);

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
      name: 'RelatorioAgendaTarefasStoreBase.errorMessage', context: context);

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
      Atom(name: 'RelatorioAgendaTarefasStoreBase.resultado', context: context);

  @override
  RelatorioAgendaResult? get resultado {
    _$resultadoAtom.reportRead();
    return super.resultado;
  }

  @override
  set resultado(RelatorioAgendaResult? value) {
    _$resultadoAtom.reportWrite(value, super.resultado, () {
      super.resultado = value;
    });
  }

  late final _$filtrosAtom =
      Atom(name: 'RelatorioAgendaTarefasStoreBase.filtros', context: context);

  @override
  RelatorioAgendaFiltros get filtros {
    _$filtrosAtom.reportRead();
    return super.filtros;
  }

  @override
  set filtros(RelatorioAgendaFiltros value) {
    _$filtrosAtom.reportWrite(value, super.filtros, () {
      super.filtros = value;
    });
  }

  late final _$carregarRelatorioAsyncAction = AsyncAction(
      'RelatorioAgendaTarefasStoreBase.carregarRelatorio',
      context: context);

  @override
  Future<void> carregarRelatorio() {
    return _$carregarRelatorioAsyncAction.run(() => super.carregarRelatorio());
  }

  late final _$atualizarFiltrosAsyncAction = AsyncAction(
      'RelatorioAgendaTarefasStoreBase.atualizarFiltros',
      context: context);

  @override
  Future<void> atualizarFiltros(RelatorioAgendaFiltros novosFiltros) {
    return _$atualizarFiltrosAsyncAction
        .run(() => super.atualizarFiltros(novosFiltros));
  }

  late final _$RelatorioAgendaTarefasStoreBaseActionController =
      ActionController(
          name: 'RelatorioAgendaTarefasStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$RelatorioAgendaTarefasStoreBaseActionController
        .startAction(name: 'RelatorioAgendaTarefasStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioAgendaTarefasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo = _$RelatorioAgendaTarefasStoreBaseActionController
        .startAction(name: 'RelatorioAgendaTarefasStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioAgendaTarefasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResultado(RelatorioAgendaResult data) {
    final _$actionInfo = _$RelatorioAgendaTarefasStoreBaseActionController
        .startAction(name: 'RelatorioAgendaTarefasStoreBase.setResultado');
    try {
      return super.setResultado(data);
    } finally {
      _$RelatorioAgendaTarefasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limpar() {
    final _$actionInfo = _$RelatorioAgendaTarefasStoreBaseActionController
        .startAction(name: 'RelatorioAgendaTarefasStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$RelatorioAgendaTarefasStoreBaseActionController.endAction(_$actionInfo);
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
totalVencidas: ${totalVencidas},
temVencidas: ${temVencidas},
loteMaisCritico: ${loteMaisCritico},
membroComMaisVencidas: ${membroComMaisVencidas}
    ''';
  }
}
