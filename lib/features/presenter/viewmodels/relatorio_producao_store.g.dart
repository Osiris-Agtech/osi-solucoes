// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_producao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RelatorioProducaoStore on RelatorioProducaoStoreBase, Store {
  Computed<List<CultureData>>? _$cultureDataComputed;

  @override
  List<CultureData> get cultureData => (_$cultureDataComputed ??=
          Computed<List<CultureData>>(() => super.cultureData,
              name: 'RelatorioProducaoStoreBase.cultureData'))
      .value;
  Computed<String>? _$reportTitleComputed;

  @override
  String get reportTitle =>
      (_$reportTitleComputed ??= Computed<String>(() => super.reportTitle,
              name: 'RelatorioProducaoStoreBase.reportTitle'))
          .value;
  Computed<String>? _$reportSubtitleComputed;

  @override
  String get reportSubtitle =>
      (_$reportSubtitleComputed ??= Computed<String>(() => super.reportSubtitle,
              name: 'RelatorioProducaoStoreBase.reportSubtitle'))
          .value;
  Computed<String>? _$totalUnitComputed;

  @override
  String get totalUnit =>
      (_$totalUnitComputed ??= Computed<String>(() => super.totalUnit,
              name: 'RelatorioProducaoStoreBase.totalUnit'))
          .value;
  Computed<List<String>>? _$monthsComputed;

  @override
  List<String> get months =>
      (_$monthsComputed ??= Computed<List<String>>(() => super.months,
              name: 'RelatorioProducaoStoreBase.months'))
          .value;
  Computed<List<double>>? _$monthlyDataComputed;

  @override
  List<double> get monthlyData =>
      (_$monthlyDataComputed ??= Computed<List<double>>(() => super.monthlyData,
              name: 'RelatorioProducaoStoreBase.monthlyData'))
          .value;
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(() => super.hasData,
          name: 'RelatorioProducaoStoreBase.hasData'))
      .value;
  Computed<double>? _$totalProductionComputed;

  @override
  double get totalProduction => (_$totalProductionComputed ??= Computed<double>(
          () => super.totalProduction,
          name: 'RelatorioProducaoStoreBase.totalProduction'))
      .value;
  Computed<Map<String, dynamic>>? _$estatisticasResumoComputed;

  @override
  Map<String, dynamic> get estatisticasResumo =>
      (_$estatisticasResumoComputed ??= Computed<Map<String, dynamic>>(
              () => super.estatisticasResumo,
              name: 'RelatorioProducaoStoreBase.estatisticasResumo'))
          .value;
  Computed<double>? _$mediaProducaoMensalComputed;

  @override
  double get mediaProducaoMensal => (_$mediaProducaoMensalComputed ??=
          Computed<double>(() => super.mediaProducaoMensal,
              name: 'RelatorioProducaoStoreBase.mediaProducaoMensal'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'RelatorioProducaoStoreBase.isLoading', context: context);

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
      Atom(name: 'RelatorioProducaoStoreBase.hasError', context: context);

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
      Atom(name: 'RelatorioProducaoStoreBase.errorMessage', context: context);

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

  late final _$relatorioDataAtom =
      Atom(name: 'RelatorioProducaoStoreBase.relatorioData', context: context);

  @override
  RelatorioProducao? get relatorioData {
    _$relatorioDataAtom.reportRead();
    return super.relatorioData;
  }

  @override
  set relatorioData(RelatorioProducao? value) {
    _$relatorioDataAtom.reportWrite(value, super.relatorioData, () {
      super.relatorioData = value;
    });
  }

  late final _$widgetDataAtom =
      Atom(name: 'RelatorioProducaoStoreBase.widgetData', context: context);

  @override
  List<CultureData> get widgetData {
    _$widgetDataAtom.reportRead();
    return super.widgetData;
  }

  @override
  set widgetData(List<CultureData> value) {
    _$widgetDataAtom.reportWrite(value, super.widgetData, () {
      super.widgetData = value;
    });
  }

  late final _$buscarRelatorioProducaoAsyncAction = AsyncAction(
      'RelatorioProducaoStoreBase.buscarRelatorioProducao',
      context: context);

  @override
  Future<void> buscarRelatorioProducao() {
    return _$buscarRelatorioProducaoAsyncAction
        .run(() => super.buscarRelatorioProducao());
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('RelatorioProducaoStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$RelatorioProducaoStoreBaseActionController =
      ActionController(name: 'RelatorioProducaoStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$RelatorioProducaoStoreBaseActionController
        .startAction(name: 'RelatorioProducaoStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$RelatorioProducaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(bool hasErr, String message) {
    final _$actionInfo = _$RelatorioProducaoStoreBaseActionController
        .startAction(name: 'RelatorioProducaoStoreBase.setError');
    try {
      return super.setError(hasErr, message);
    } finally {
      _$RelatorioProducaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRelatorioData(RelatorioProducao data) {
    final _$actionInfo = _$RelatorioProducaoStoreBaseActionController
        .startAction(name: 'RelatorioProducaoStoreBase.setRelatorioData');
    try {
      return super.setRelatorioData(data);
    } finally {
      _$RelatorioProducaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearData() {
    final _$actionInfo = _$RelatorioProducaoStoreBaseActionController
        .startAction(name: 'RelatorioProducaoStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$RelatorioProducaoStoreBaseActionController.endAction(_$actionInfo);
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
cultureData: ${cultureData},
reportTitle: ${reportTitle},
reportSubtitle: ${reportSubtitle},
totalUnit: ${totalUnit},
months: ${months},
monthlyData: ${monthlyData},
hasData: ${hasData},
totalProduction: ${totalProduction},
estatisticasResumo: ${estatisticasResumo},
mediaProducaoMensal: ${mediaProducaoMensal}
    ''';
  }
}
