// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoteStore on _LoteStoreBase, Store {
  final _$isLoteListLoadingAtom =
      Atom(name: '_LoteStoreBase.isLoteListLoading');

  @override
  bool get isLoteListLoading {
    _$isLoteListLoadingAtom.reportRead();
    return super.isLoteListLoading;
  }

  @override
  set isLoteListLoading(bool value) {
    _$isLoteListLoadingAtom.reportWrite(value, super.isLoteListLoading, () {
      super.isLoteListLoading = value;
    });
  }

  final _$setorSelecionadoAtom = Atom(name: '_LoteStoreBase.setorSelecionado');

  @override
  Setor get setorSelecionado {
    _$setorSelecionadoAtom.reportRead();
    return super.setorSelecionado;
  }

  @override
  set setorSelecionado(Setor value) {
    _$setorSelecionadoAtom.reportWrite(value, super.setorSelecionado, () {
      super.setorSelecionado = value;
    });
  }

  final _$loteListAtom = Atom(name: '_LoteStoreBase.loteList');

  @override
  List<Lote> get loteList {
    _$loteListAtom.reportRead();
    return super.loteList;
  }

  @override
  set loteList(List<Lote> value) {
    _$loteListAtom.reportWrite(value, super.loteList, () {
      super.loteList = value;
    });
  }

  final _$isDetalhesLoteLoadingAtom =
      Atom(name: '_LoteStoreBase.isDetalhesLoteLoading');

  @override
  bool get isDetalhesLoteLoading {
    _$isDetalhesLoteLoadingAtom.reportRead();
    return super.isDetalhesLoteLoading;
  }

  @override
  set isDetalhesLoteLoading(bool value) {
    _$isDetalhesLoteLoadingAtom.reportWrite(value, super.isDetalhesLoteLoading,
        () {
      super.isDetalhesLoteLoading = value;
    });
  }

  final _$loteSelecionadoAtom = Atom(name: '_LoteStoreBase.loteSelecionado');

  @override
  Lote get loteSelecionado {
    _$loteSelecionadoAtom.reportRead();
    return super.loteSelecionado;
  }

  @override
  set loteSelecionado(Lote value) {
    _$loteSelecionadoAtom.reportWrite(value, super.loteSelecionado, () {
      super.loteSelecionado = value;
    });
  }

  final _$showTextFormFieldAtom =
      Atom(name: '_LoteStoreBase.showTextFormField');

  @override
  bool get showTextFormField {
    _$showTextFormFieldAtom.reportRead();
    return super.showTextFormField;
  }

  @override
  set showTextFormField(bool value) {
    _$showTextFormFieldAtom.reportWrite(value, super.showTextFormField, () {
      super.showTextFormField = value;
    });
  }

  final _$isNovaAreaLoadingAtom =
      Atom(name: '_LoteStoreBase.isNovaAreaLoading');

  @override
  bool get isNovaAreaLoading {
    _$isNovaAreaLoadingAtom.reportRead();
    return super.isNovaAreaLoading;
  }

  @override
  set isNovaAreaLoading(bool value) {
    _$isNovaAreaLoadingAtom.reportWrite(value, super.isNovaAreaLoading, () {
      super.isNovaAreaLoading = value;
    });
  }

  final _$novoLoteNameAtom = Atom(name: '_LoteStoreBase.novoLoteName');

  @override
  TextEditingController get novoLoteName {
    _$novoLoteNameAtom.reportRead();
    return super.novoLoteName;
  }

  @override
  set novoLoteName(TextEditingController value) {
    _$novoLoteNameAtom.reportWrite(value, super.novoLoteName, () {
      super.novoLoteName = value;
    });
  }

  final _$novoLoteDescricaoAtom =
      Atom(name: '_LoteStoreBase.novoLoteDescricao');

  @override
  TextEditingController get novoLoteDescricao {
    _$novoLoteDescricaoAtom.reportRead();
    return super.novoLoteDescricao;
  }

  @override
  set novoLoteDescricao(TextEditingController value) {
    _$novoLoteDescricaoAtom.reportWrite(value, super.novoLoteDescricao, () {
      super.novoLoteDescricao = value;
    });
  }

  final _$buscarLotesAsyncAction = AsyncAction('_LoteStoreBase.buscarLotes');

  @override
  Future buscarLotes() {
    return _$buscarLotesAsyncAction.run(() => super.buscarLotes());
  }

  final _$buscarDetalhesLoteAsyncAction =
      AsyncAction('_LoteStoreBase.buscarDetalhesLote');

  @override
  Future buscarDetalhesLote() {
    return _$buscarDetalhesLoteAsyncAction
        .run(() => super.buscarDetalhesLote());
  }

  final _$_LoteStoreBaseActionController =
      ActionController(name: '_LoteStoreBase');

  @override
  dynamic setSetorSelecionado(Setor setor) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setSetorSelecionado');
    try {
      return super.setSetorSelecionado(setor);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarLote(Lote lote) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarLote');
    try {
      return super.selecionarLote(lote);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoteListLoading: ${isLoteListLoading},
setorSelecionado: ${setorSelecionado},
loteList: ${loteList},
isDetalhesLoteLoading: ${isDetalhesLoteLoading},
loteSelecionado: ${loteSelecionado},
showTextFormField: ${showTextFormField},
isNovaAreaLoading: ${isNovaAreaLoading},
novoLoteName: ${novoLoteName},
novoLoteDescricao: ${novoLoteDescricao}
    ''';
  }
}
