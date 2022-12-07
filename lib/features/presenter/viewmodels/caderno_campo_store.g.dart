// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caderno_campo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadernoCampoStore on _CadernoCampoStoreBase, Store {
  Computed<List<LoteByFilter>>? _$getLotesGroupComputed;

  @override
  List<LoteByFilter> get getLotesGroup => (_$getLotesGroupComputed ??=
          Computed<List<LoteByFilter>>(() => super.getLotesGroup,
              name: '_CadernoCampoStoreBase.getLotesGroup'))
      .value;

  final _$loteListAtom = Atom(name: '_CadernoCampoStoreBase.loteList');

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

  final _$areaListAtom = Atom(name: '_CadernoCampoStoreBase.areaList');

  @override
  List<Area> get areaList {
    _$areaListAtom.reportRead();
    return super.areaList;
  }

  @override
  set areaList(List<Area> value) {
    _$areaListAtom.reportWrite(value, super.areaList, () {
      super.areaList = value;
    });
  }

  final _$isLoteListLoadingAtom =
      Atom(name: '_CadernoCampoStoreBase.isLoteListLoading');

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

  final _$isAreaLoadingAtom =
      Atom(name: '_CadernoCampoStoreBase.isAreaLoading');

  @override
  bool get isAreaLoading {
    _$isAreaLoadingAtom.reportRead();
    return super.isAreaLoading;
  }

  @override
  set isAreaLoading(bool value) {
    _$isAreaLoadingAtom.reportWrite(value, super.isAreaLoading, () {
      super.isAreaLoading = value;
    });
  }

  final _$setorSelecionadoAtom =
      Atom(name: '_CadernoCampoStoreBase.setorSelecionado');

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

  final _$dropButtonSetorAtom =
      Atom(name: '_CadernoCampoStoreBase.dropButtonSetor');

  @override
  Setor get dropButtonSetor {
    _$dropButtonSetorAtom.reportRead();
    return super.dropButtonSetor;
  }

  @override
  set dropButtonSetor(Setor value) {
    _$dropButtonSetorAtom.reportWrite(value, super.dropButtonSetor, () {
      super.dropButtonSetor = value;
    });
  }

  final _$dropButtonAreaAtom =
      Atom(name: '_CadernoCampoStoreBase.dropButtonArea');

  @override
  Area get dropButtonArea {
    _$dropButtonAreaAtom.reportRead();
    return super.dropButtonArea;
  }

  @override
  set dropButtonArea(Area value) {
    _$dropButtonAreaAtom.reportWrite(value, super.dropButtonArea, () {
      super.dropButtonArea = value;
    });
  }

  final _$loteSelecionadoAtom =
      Atom(name: '_CadernoCampoStoreBase.loteSelecionado');

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

  final _$expandedCardAtom = Atom(name: '_CadernoCampoStoreBase.expandedCard');

  @override
  List<bool> get expandedCard {
    _$expandedCardAtom.reportRead();
    return super.expandedCard;
  }

  @override
  set expandedCard(List<bool> value) {
    _$expandedCardAtom.reportWrite(value, super.expandedCard, () {
      super.expandedCard = value;
    });
  }

  final _$dotIndicatorAtom = Atom(name: '_CadernoCampoStoreBase.dotIndicator');

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

  final _$isCadastroLoteLoadingAtom =
      Atom(name: '_CadernoCampoStoreBase.isCadastroLoteLoading');

  @override
  bool get isCadastroLoteLoading {
    _$isCadastroLoteLoadingAtom.reportRead();
    return super.isCadastroLoteLoading;
  }

  @override
  set isCadastroLoteLoading(bool value) {
    _$isCadastroLoteLoadingAtom.reportWrite(value, super.isCadastroLoteLoading,
        () {
      super.isCadastroLoteLoading = value;
    });
  }

  final _$showTextFormFieldAtom =
      Atom(name: '_CadernoCampoStoreBase.showTextFormField');

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

  final _$isNovoRegistroLoadingAtom =
      Atom(name: '_CadernoCampoStoreBase.isNovoRegistroLoading');

  @override
  bool get isNovoRegistroLoading {
    _$isNovoRegistroLoadingAtom.reportRead();
    return super.isNovoRegistroLoading;
  }

  @override
  set isNovoRegistroLoading(bool value) {
    _$isNovoRegistroLoadingAtom.reportWrite(value, super.isNovoRegistroLoading,
        () {
      super.isNovoRegistroLoading = value;
    });
  }

  final _$isEditingAtom = Atom(name: '_CadernoCampoStoreBase.isEditing');

  @override
  bool get isEditing {
    _$isEditingAtom.reportRead();
    return super.isEditing;
  }

  @override
  set isEditing(bool value) {
    _$isEditingAtom.reportWrite(value, super.isEditing, () {
      super.isEditing = value;
    });
  }

  final _$selectedGroupAtom =
      Atom(name: '_CadernoCampoStoreBase.selectedGroup');

  @override
  String get selectedGroup {
    _$selectedGroupAtom.reportRead();
    return super.selectedGroup;
  }

  @override
  set selectedGroup(String value) {
    _$selectedGroupAtom.reportWrite(value, super.selectedGroup, () {
      super.selectedGroup = value;
    });
  }

  final _$lotesGroupAtom = Atom(name: '_CadernoCampoStoreBase.lotesGroup');

  @override
  List<LoteByFilter> get lotesGroup {
    _$lotesGroupAtom.reportRead();
    return super.lotesGroup;
  }

  @override
  set lotesGroup(List<LoteByFilter> value) {
    _$lotesGroupAtom.reportWrite(value, super.lotesGroup, () {
      super.lotesGroup = value;
    });
  }

  final _$usuariosContaAtom =
      Atom(name: '_CadernoCampoStoreBase.usuariosConta');

  @override
  List<Usuario> get usuariosConta {
    _$usuariosContaAtom.reportRead();
    return super.usuariosConta;
  }

  @override
  set usuariosConta(List<Usuario> value) {
    _$usuariosContaAtom.reportWrite(value, super.usuariosConta, () {
      super.usuariosConta = value;
    });
  }

  final _$selectedUsuarioAtom =
      Atom(name: '_CadernoCampoStoreBase.selectedUsuario');

  @override
  Usuario? get selectedUsuario {
    _$selectedUsuarioAtom.reportRead();
    return super.selectedUsuario;
  }

  @override
  set selectedUsuario(Usuario? value) {
    _$selectedUsuarioAtom.reportWrite(value, super.selectedUsuario, () {
      super.selectedUsuario = value;
    });
  }

  final _$novoAtividadeNameAtom =
      Atom(name: '_CadernoCampoStoreBase.novoAtividadeName');

  @override
  TextEditingController get novoAtividadeName {
    _$novoAtividadeNameAtom.reportRead();
    return super.novoAtividadeName;
  }

  @override
  set novoAtividadeName(TextEditingController value) {
    _$novoAtividadeNameAtom.reportWrite(value, super.novoAtividadeName, () {
      super.novoAtividadeName = value;
    });
  }

  final _$novoAutorNameAtom =
      Atom(name: '_CadernoCampoStoreBase.novoAutorName');

  @override
  TextEditingController get novoAutorName {
    _$novoAutorNameAtom.reportRead();
    return super.novoAutorName;
  }

  @override
  set novoAutorName(TextEditingController value) {
    _$novoAutorNameAtom.reportWrite(value, super.novoAutorName, () {
      super.novoAutorName = value;
    });
  }

  final _$novaDescricaoAtom =
      Atom(name: '_CadernoCampoStoreBase.novaDescricao');

  @override
  TextEditingController get novaDescricao {
    _$novaDescricaoAtom.reportRead();
    return super.novaDescricao;
  }

  @override
  set novaDescricao(TextEditingController value) {
    _$novaDescricaoAtom.reportWrite(value, super.novaDescricao, () {
      super.novaDescricao = value;
    });
  }

  final _$searchLotePageAtom =
      Atom(name: '_CadernoCampoStoreBase.searchLotePage');

  @override
  TextEditingController get searchLotePage {
    _$searchLotePageAtom.reportRead();
    return super.searchLotePage;
  }

  @override
  set searchLotePage(TextEditingController value) {
    _$searchLotePageAtom.reportWrite(value, super.searchLotePage, () {
      super.searchLotePage = value;
    });
  }

  final _$dataRegistroAtom = Atom(name: '_CadernoCampoStoreBase.dataRegistro');

  @override
  DateTime? get dataRegistro {
    _$dataRegistroAtom.reportRead();
    return super.dataRegistro;
  }

  @override
  set dataRegistro(DateTime? value) {
    _$dataRegistroAtom.reportWrite(value, super.dataRegistro, () {
      super.dataRegistro = value;
    });
  }

  final _$loteCadastroAtom = Atom(name: '_CadernoCampoStoreBase.loteCadastro');

  @override
  Lote get loteCadastro {
    _$loteCadastroAtom.reportRead();
    return super.loteCadastro;
  }

  @override
  set loteCadastro(Lote value) {
    _$loteCadastroAtom.reportWrite(value, super.loteCadastro, () {
      super.loteCadastro = value;
    });
  }

  final _$buscarLotesByContaAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarLotesByConta');

  @override
  Future buscarLotesByConta() {
    return _$buscarLotesByContaAsyncAction
        .run(() => super.buscarLotesByConta());
  }

  final _$buscarAtividadesAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarAtividades');

  @override
  Future buscarAtividades() {
    return _$buscarAtividadesAsyncAction.run(() => super.buscarAtividades());
  }

  final _$buscarLotesBySetorAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarLotesBySetor');

  @override
  Future buscarLotesBySetor() {
    return _$buscarLotesBySetorAsyncAction
        .run(() => super.buscarLotesBySetor());
  }

  final _$buscarLotesByAreaAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarLotesByArea');

  @override
  Future buscarLotesByArea() {
    return _$buscarLotesByAreaAsyncAction.run(() => super.buscarLotesByArea());
  }

  final _$buscarAreasListAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarAreasList');

  @override
  Future buscarAreasList() {
    return _$buscarAreasListAsyncAction.run(() => super.buscarAreasList());
  }

  final _$buscarUsuariosContaAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.buscarUsuariosConta');

  @override
  Future buscarUsuariosConta() {
    return _$buscarUsuariosContaAsyncAction
        .run(() => super.buscarUsuariosConta());
  }

  final _$groupLotesByAsyncAction =
      AsyncAction('_CadernoCampoStoreBase.groupLotesBy');

  @override
  Future groupLotesBy() {
    return _$groupLotesByAsyncAction.run(() => super.groupLotesBy());
  }

  final _$_CadernoCampoStoreBaseActionController =
      ActionController(name: '_CadernoCampoStoreBase');

  @override
  dynamic selecionarDropButtonArea(Area area) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.selecionarDropButtonArea');
    try {
      return super.selecionarDropButtonArea(area);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarDropButtonSetor(Setor setor) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.selecionarDropButtonSetor');
    try {
      return super.selecionarDropButtonSetor(setor);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoteSelecionado(Lote lote) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setLoteSelecionado');
    try {
      return super.setLoteSelecionado(lote);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setExpandedCard(int index) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setExpandedCard');
    try {
      return super.setExpandedCard(index);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSeachLotePage(String value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setSeachLotePage');
    try {
      return super.setSeachLotePage(value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectUser(Usuario? usuario) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.selectUser');
    try {
      return super.selectUser(usuario);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSelectedGroup(String name) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setSelectedGroup');
    try {
      return super.setSelectedGroup(name);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setShowTextFormField(bool value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setShowTextFormField');
    try {
      return super.setShowTextFormField(value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsCadastroLoteLoading(bool value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.setIsCadastroLoteLoading');
    try {
      return super.setIsCadastroLoteLoading(value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic alterarAtividadeNome(String name) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.alterarAtividadeNome');
    try {
      return super.alterarAtividadeNome(name);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectLotesGroup(int index, bool value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.selectLotesGroup');
    try {
      return super.selectLotesGroup(index, value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectLotesSelection(int index1, int index2, bool value) {
    final _$actionInfo = _$_CadernoCampoStoreBaseActionController.startAction(
        name: '_CadernoCampoStoreBase.selectLotesSelection');
    try {
      return super.selectLotesSelection(index1, index2, value);
    } finally {
      _$_CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loteList: ${loteList},
areaList: ${areaList},
isLoteListLoading: ${isLoteListLoading},
isAreaLoading: ${isAreaLoading},
setorSelecionado: ${setorSelecionado},
dropButtonSetor: ${dropButtonSetor},
dropButtonArea: ${dropButtonArea},
loteSelecionado: ${loteSelecionado},
expandedCard: ${expandedCard},
dotIndicator: ${dotIndicator},
isCadastroLoteLoading: ${isCadastroLoteLoading},
showTextFormField: ${showTextFormField},
isNovoRegistroLoading: ${isNovoRegistroLoading},
isEditing: ${isEditing},
selectedGroup: ${selectedGroup},
lotesGroup: ${lotesGroup},
usuariosConta: ${usuariosConta},
selectedUsuario: ${selectedUsuario},
novoAtividadeName: ${novoAtividadeName},
novoAutorName: ${novoAutorName},
novaDescricao: ${novaDescricao},
searchLotePage: ${searchLotePage},
dataRegistro: ${dataRegistro},
loteCadastro: ${loteCadastro},
getLotesGroup: ${getLotesGroup}
    ''';
  }
}
