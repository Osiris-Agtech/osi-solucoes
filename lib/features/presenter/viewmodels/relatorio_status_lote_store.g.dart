// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_status_lote_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioStatusLoteStore on RelatorioStatusLoteStoreBase, Store {
  Computed<List<LotStatusData>>? _$lotStatusDataComputed;

  @override
  List<LotStatusData> get lotStatusData => (_$lotStatusDataComputed ??=
          Computed<List<LotStatusData>>(() => super.lotStatusData,
              name: 'RelatorioStatusLoteStoreBase.lotStatusData'))
      .value;
  Computed<String>? _$reportTitleComputed;

  @override
  String get reportTitle =>
      (_$reportTitleComputed ??= Computed<String>(() => super.reportTitle,
              name: 'RelatorioStatusLoteStoreBase.reportTitle'))
          .value;
  Computed<String>? _$reportSubtitleComputed;

  @override
  String get reportSubtitle =>
      (_$reportSubtitleComputed ??= Computed<String>(() => super.reportSubtitle,
              name: 'RelatorioStatusLoteStoreBase.reportSubtitle'))
          .value;
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioStatusLoteStoreBase.hasData'))
      .value;
  Computed<Map<String, int>>? _$estatisticasResumoComputed;

  @override
  Map<String, int> get estatisticasResumo => (_$estatisticasResumoComputed ??=
          Computed<Map<String, int>>(() => super.estatisticasResumo,
              name: 'RelatorioStatusLoteStoreBase.estatisticasResumo'))
      .value;
  Computed<double>? _$percentualConclusaoComputed;

  @override
  double get percentualConclusao => (_$percentualConclusaoComputed ??=
          Computed<double>(() => super.percentualConclusao,
              name: 'RelatorioStatusLoteStoreBase.percentualConclusao'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'RelatorioStatusLoteStoreBase.isLoading', context: context);

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
      Atom(name: 'RelatorioStatusLoteStoreBase.hasError', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: 'RelatorioStatusLoteStoreBase.errorMessage', context: context);

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

  late final _$relatorioDataAtom = Atom(
      name: 'RelatorioStatusLoteStoreBase.relatorioData', context: context);

  @override
  RelatorioStatusLotes? get relatorioData {
    _$relatorioDataAtom.reportRead();
    return super.relatorioData;
  }

  @override
  set relatorioData(RelatorioStatusLotes? value) {
    _$relatorioDataAtom.reportWrite(value, super.relatorioData, () {
      super.relatorioData = value;
    });
  }

  late final _$widgetDataAtom =
      Atom(name: 'RelatorioStatusLoteStoreBase.widgetData', context: context);

  @override
  List<LotStatusData> get widgetData {
    _$widgetDataAtom.reportRead();
    return super.widgetData;
  }

  @override
  set widgetData(List<LotStatusData> value) {
    _$widgetDataAtom.reportWrite(value, super.widgetData, () {
      super.widgetData = value;
    });
  }

  late final _$buscarRelatorioStatusLotesAsyncAction = AsyncAction(
      'RelatorioStatusLoteStoreBase.buscarRelatorioStatusLotes',
      context: context);

  @override
  Future<void> buscarRelatorioStatusLotes({int? contaId}) {
    return _$buscarRelatorioStatusLotesAsyncAction
        .run(() => super.buscarRelatorioStatusLotes(contaId: contaId));
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('RelatorioStatusLoteStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData({int? contaId}) {
    return _$refreshDataAsyncAction
        .run(() => super.refreshData(contaId: contaId));
  }

  late final _$RelatorioStatusLoteStoreBaseActionController =
      ActionController(name: 'RelatorioStatusLoteStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$RelatorioStatusLoteStoreBaseActionController
        .startAction(name: 'RelatorioStatusLoteStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioStatusLoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo = _$RelatorioStatusLoteStoreBaseActionController
        .startAction(name: 'RelatorioStatusLoteStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioStatusLoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRelatorioData(RelatorioStatusLotes data) {
    final _$actionInfo = _$RelatorioStatusLoteStoreBaseActionController
        .startAction(name: 'RelatorioStatusLoteStoreBase.setRelatorioData');
    try {
      return super.setRelatorioData(data);
    } finally {
      _$RelatorioStatusLoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearData() {
    final _$actionInfo = _$RelatorioStatusLoteStoreBaseActionController
        .startAction(name: 'RelatorioStatusLoteStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$RelatorioStatusLoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasError: ${hasError},
errorMessage: ${errorMessage},
relatorioData: ${relatorioData},
widgetData: ${widgetData},
lotStatusData: ${lotStatusData},
reportTitle: ${reportTitle},
reportSubtitle: ${reportSubtitle},
hasData: ${hasData},
estatisticasResumo: ${estatisticasResumo},
percentualConclusao: ${percentualConclusao}
    ''';
  }
}
