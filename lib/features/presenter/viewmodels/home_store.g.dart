// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$isNotifiedAtom =
      Atom(name: 'HomeStoreBase.isNotified', context: context);

  @override
  bool get isNotified {
    _$isNotifiedAtom.reportRead();
    return super.isNotified;
  }

  @override
  set isNotified(bool value) {
    _$isNotifiedAtom.reportWrite(value, super.isNotified, () {
      super.isNotified = value;
    });
  }

  late final _$isCollapsedAtom =
      Atom(name: 'HomeStoreBase.isCollapsed', context: context);

  @override
  bool get isCollapsed {
    _$isCollapsedAtom.reportRead();
    return super.isCollapsed;
  }

  @override
  set isCollapsed(bool value) {
    _$isCollapsedAtom.reportWrite(value, super.isCollapsed, () {
      super.isCollapsed = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'HomeStoreBase.isLoading', context: context);

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
      Atom(name: 'HomeStoreBase.hasError', context: context);

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
      Atom(name: 'HomeStoreBase.errorMessage', context: context);

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

  late final _$dashboardAtom =
      Atom(name: 'HomeStoreBase.dashboard', context: context);

  @override
  HomeDashboard? get dashboard {
    _$dashboardAtom.reportRead();
    return super.dashboard;
  }

  @override
  set dashboard(HomeDashboard? value) {
    _$dashboardAtom.reportWrite(value, super.dashboard, () {
      super.dashboard = value;
    });
  }

  late final _$recommendedShortcutsAtom =
      Atom(name: 'HomeStoreBase.recommendedShortcuts', context: context);

  @override
  List<ShortcutModel> get recommendedShortcuts {
    _$recommendedShortcutsAtom.reportRead();
    return super.recommendedShortcuts;
  }

  @override
  set recommendedShortcuts(List<ShortcutModel> value) {
    _$recommendedShortcutsAtom.reportWrite(value, super.recommendedShortcuts,
        () {
      super.recommendedShortcuts = value;
    });
  }

  late final _$isLoadingShortcutsAtom =
      Atom(name: 'HomeStoreBase.isLoadingShortcuts', context: context);

  @override
  bool get isLoadingShortcuts {
    _$isLoadingShortcutsAtom.reportRead();
    return super.isLoadingShortcuts;
  }

  @override
  set isLoadingShortcuts(bool value) {
    _$isLoadingShortcutsAtom.reportWrite(value, super.isLoadingShortcuts, () {
      super.isLoadingShortcuts = value;
    });
  }

  late final _$adaptiveDashboardAtom =
      Atom(name: 'HomeStoreBase.adaptiveDashboard', context: context);

  @override
  String? get adaptiveDashboard {
    _$adaptiveDashboardAtom.reportRead();
    return super.adaptiveDashboard;
  }

  @override
  set adaptiveDashboard(String? value) {
    _$adaptiveDashboardAtom.reportWrite(value, super.adaptiveDashboard, () {
      super.adaptiveDashboard = value;
    });
  }

  late final _$dashboardConfidenceAtom =
      Atom(name: 'HomeStoreBase.dashboardConfidence', context: context);

  @override
  double get dashboardConfidence {
    _$dashboardConfidenceAtom.reportRead();
    return super.dashboardConfidence;
  }

  @override
  set dashboardConfidence(double value) {
    _$dashboardConfidenceAtom.reportWrite(value, super.dashboardConfidence, () {
      super.dashboardConfidence = value;
    });
  }

  late final _$currentCardIndexAtom =
      Atom(name: 'HomeStoreBase.currentCardIndex', context: context);

  @override
  int get currentCardIndex {
    _$currentCardIndexAtom.reportRead();
    return super.currentCardIndex;
  }

  @override
  set currentCardIndex(int value) {
    _$currentCardIndexAtom.reportWrite(value, super.currentCardIndex, () {
      super.currentCardIndex = value;
    });
  }

  late final _$cardOrderAtom =
      Atom(name: 'HomeStoreBase.cardOrder', context: context);

  @override
  List<String> get cardOrder {
    _$cardOrderAtom.reportRead();
    return super.cardOrder;
  }

  @override
  set cardOrder(List<String> value) {
    _$cardOrderAtom.reportWrite(value, super.cardOrder, () {
      super.cardOrder = value;
    });
  }

  late final _$loadAdaptiveInterfaceAsyncAction =
      AsyncAction('HomeStoreBase.loadAdaptiveInterface', context: context);

  @override
  Future<void> loadAdaptiveInterface() {
    return _$loadAdaptiveInterfaceAsyncAction
        .run(() => super.loadAdaptiveInterface());
  }

  late final _$carregarHomeAsyncAction =
      AsyncAction('HomeStoreBase.carregarHome', context: context);

  @override
  Future<void> carregarHome() {
    return _$carregarHomeAsyncAction.run(() => super.carregarHome());
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  bool toggleNotified() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.toggleNotified');
    try {
      return super.toggleNotified();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsCollaped() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setIsCollaped');
    try {
      return super.setIsCollaped();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextCard() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.nextCard');
    try {
      return super.nextCard();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousCard() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.previousCard');
    try {
      return super.previousCard();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToCard(int index) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.goToCard');
    try {
      return super.goToCard(index);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isNotified: ${isNotified},
isCollapsed: ${isCollapsed},
isLoading: ${isLoading},
hasError: ${hasError},
errorMessage: ${errorMessage},
dashboard: ${dashboard},
recommendedShortcuts: ${recommendedShortcuts},
isLoadingShortcuts: ${isLoadingShortcuts},
adaptiveDashboard: ${adaptiveDashboard},
dashboardConfidence: ${dashboardConfidence},
currentCardIndex: ${currentCardIndex},
cardOrder: ${cardOrder}
    ''';
  }
}
