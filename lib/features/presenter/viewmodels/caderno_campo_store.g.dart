// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caderno_campo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CadernoCampoStore on CadernoCampoStoreBase, Store {
  Computed<List<LotesAtividades>>? _$getLotesAtividadesFilterComputed;

  @override
  List<LotesAtividades> get getLotesAtividadesFilter =>
      (_$getLotesAtividadesFilterComputed ??= Computed<List<LotesAtividades>>(
              () => super.getLotesAtividadesFilter,
              name: 'CadernoCampoStoreBase.getLotesAtividadesFilter'))
          .value;
  Computed<List<Lote>>? _$getLotesFilterComputed;

  @override
  List<Lote> get getLotesFilter => (_$getLotesFilterComputed ??=
          Computed<List<Lote>>(() => super.getLotesFilter,
              name: 'CadernoCampoStoreBase.getLotesFilter'))
      .value;
  Computed<List<LoteByFilter>>? _$getLotesGroupComputed;

  @override
  List<LoteByFilter> get getLotesGroup => (_$getLotesGroupComputed ??=
          Computed<List<LoteByFilter>>(() => super.getLotesGroup,
              name: 'CadernoCampoStoreBase.getLotesGroup'))
      .value;
  Computed<List<Lote>>? _$selectedLotesComputed;

  @override
  List<Lote> get selectedLotes => (_$selectedLotesComputed ??=
          Computed<List<Lote>>(() => super.selectedLotes,
              name: 'CadernoCampoStoreBase.selectedLotes'))
      .value;

  late final _$loteListAtom =
      Atom(name: 'CadernoCampoStoreBase.loteList', context: context);

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

  late final _$areaListAtom =
      Atom(name: 'CadernoCampoStoreBase.areaList', context: context);

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

  late final _$isLoteListLoadingAtom =
      Atom(name: 'CadernoCampoStoreBase.isLoteListLoading', context: context);

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

  late final _$isAreaLoadingAtom =
      Atom(name: 'CadernoCampoStoreBase.isAreaLoading', context: context);

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

  late final _$mostrarRegistrosSistemaAtom = Atom(
      name: 'CadernoCampoStoreBase.mostrarRegistrosSistema', context: context);

  @override
  bool get mostrarRegistrosSistema {
    _$mostrarRegistrosSistemaAtom.reportRead();
    return super.mostrarRegistrosSistema;
  }

  @override
  set mostrarRegistrosSistema(bool value) {
    _$mostrarRegistrosSistemaAtom
        .reportWrite(value, super.mostrarRegistrosSistema, () {
      super.mostrarRegistrosSistema = value;
    });
  }

  late final _$setorSelecionadoAtom =
      Atom(name: 'CadernoCampoStoreBase.setorSelecionado', context: context);

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

  late final _$dropButtonSetorAtom =
      Atom(name: 'CadernoCampoStoreBase.dropButtonSetor', context: context);

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

  late final _$dropButtonAreaAtom =
      Atom(name: 'CadernoCampoStoreBase.dropButtonArea', context: context);

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

  late final _$loteSelecionadoAtom =
      Atom(name: 'CadernoCampoStoreBase.loteSelecionado', context: context);

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

  late final _$expandedCardAtom =
      Atom(name: 'CadernoCampoStoreBase.expandedCard', context: context);

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

  late final _$searchAtividadeAtom =
      Atom(name: 'CadernoCampoStoreBase.searchAtividade', context: context);

  @override
  String get searchAtividade {
    _$searchAtividadeAtom.reportRead();
    return super.searchAtividade;
  }

  @override
  set searchAtividade(String value) {
    _$searchAtividadeAtom.reportWrite(value, super.searchAtividade, () {
      super.searchAtividade = value;
    });
  }

  late final _$searchLoteAtom =
      Atom(name: 'CadernoCampoStoreBase.searchLote', context: context);

  @override
  String get searchLote {
    _$searchLoteAtom.reportRead();
    return super.searchLote;
  }

  @override
  set searchLote(String value) {
    _$searchLoteAtom.reportWrite(value, super.searchLote, () {
      super.searchLote = value;
    });
  }

  late final _$dotIndicatorAtom =
      Atom(name: 'CadernoCampoStoreBase.dotIndicator', context: context);

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

  late final _$mostrarErroFormularioAtom = Atom(
      name: 'CadernoCampoStoreBase.mostrarErroFormulario', context: context);

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

  late final _$isCadastroLoteLoadingAtom = Atom(
      name: 'CadernoCampoStoreBase.isCadastroLoteLoading', context: context);

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

  late final _$showTextFormFieldAtom =
      Atom(name: 'CadernoCampoStoreBase.showTextFormField', context: context);

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

  late final _$isNovoRegistroLoadingAtom = Atom(
      name: 'CadernoCampoStoreBase.isNovoRegistroLoading', context: context);

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

  late final _$isEditingAtom =
      Atom(name: 'CadernoCampoStoreBase.isEditing', context: context);

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

  late final _$selectedGroupAtom =
      Atom(name: 'CadernoCampoStoreBase.selectedGroup', context: context);

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

  late final _$lotesGroupAtom =
      Atom(name: 'CadernoCampoStoreBase.lotesGroup', context: context);

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

  late final _$usuariosContaAtom =
      Atom(name: 'CadernoCampoStoreBase.usuariosConta', context: context);

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

  late final _$selectedUsuarioAtom =
      Atom(name: 'CadernoCampoStoreBase.selectedUsuario', context: context);

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

  late final _$novoAutorNameAtom =
      Atom(name: 'CadernoCampoStoreBase.novoAutorName', context: context);

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

  late final _$searchLotePageAtom =
      Atom(name: 'CadernoCampoStoreBase.searchLotePage', context: context);

  @override
  String get searchLotePage {
    _$searchLotePageAtom.reportRead();
    return super.searchLotePage;
  }

  @override
  set searchLotePage(String value) {
    _$searchLotePageAtom.reportWrite(value, super.searchLotePage, () {
      super.searchLotePage = value;
    });
  }

  late final _$dateRegistroAtom =
      Atom(name: 'CadernoCampoStoreBase.dateRegistro', context: context);

  @override
  DateTime get dateRegistro {
    _$dateRegistroAtom.reportRead();
    return super.dateRegistro;
  }

  @override
  set dateRegistro(DateTime value) {
    _$dateRegistroAtom.reportWrite(value, super.dateRegistro, () {
      super.dateRegistro = value;
    });
  }

  late final _$loteCadastroAtom =
      Atom(name: 'CadernoCampoStoreBase.loteCadastro', context: context);

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

  late final _$buscarLotesByContaAsyncAction =
      AsyncAction('CadernoCampoStoreBase.buscarLotesByConta', context: context);

  @override
  Future<void> buscarLotesByConta() {
    return _$buscarLotesByContaAsyncAction
        .run(() => super.buscarLotesByConta());
  }

  late final _$buscarAtividadesAsyncAction =
      AsyncAction('CadernoCampoStoreBase.buscarAtividades', context: context);

  @override
  Future<void> buscarAtividades() {
    return _$buscarAtividadesAsyncAction.run(() => super.buscarAtividades());
  }

  late final _$buscarLotesBySetorAsyncAction =
      AsyncAction('CadernoCampoStoreBase.buscarLotesBySetor', context: context);

  @override
  Future<void> buscarLotesBySetor() {
    return _$buscarLotesBySetorAsyncAction
        .run(() => super.buscarLotesBySetor());
  }

  late final _$buscarLotesByAreaAsyncAction =
      AsyncAction('CadernoCampoStoreBase.buscarLotesByArea', context: context);

  @override
  Future<void> buscarLotesByArea() {
    return _$buscarLotesByAreaAsyncAction.run(() => super.buscarLotesByArea());
  }

  late final _$buscarAreasListAsyncAction =
      AsyncAction('CadernoCampoStoreBase.buscarAreasList', context: context);

  @override
  Future<void> buscarAreasList() {
    return _$buscarAreasListAsyncAction.run(() => super.buscarAreasList());
  }

  late final _$buscarUsuariosContaAsyncAction = AsyncAction(
      'CadernoCampoStoreBase.buscarUsuariosConta',
      context: context);

  @override
  Future<void> buscarUsuariosConta() {
    return _$buscarUsuariosContaAsyncAction
        .run(() => super.buscarUsuariosConta());
  }

  late final _$cadastrarAtividadeAsyncAction =
      AsyncAction('CadernoCampoStoreBase.cadastrarAtividade', context: context);

  @override
  Future<void> cadastrarAtividade() {
    return _$cadastrarAtividadeAsyncAction
        .run(() => super.cadastrarAtividade());
  }

  late final _$groupLotesByAsyncAction =
      AsyncAction('CadernoCampoStoreBase.groupLotesBy', context: context);

  @override
  Future<void> groupLotesBy() {
    return _$groupLotesByAsyncAction.run(() => super.groupLotesBy());
  }

  late final _$CadernoCampoStoreBaseActionController =
      ActionController(name: 'CadernoCampoStoreBase', context: context);

  @override
  void setSearchAtividade(String value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setSearchAtividade');
    try {
      return super.setSearchAtividade(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchLote(String value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setSearchLote');
    try {
      return super.setSearchLote(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Area selecionarDropButtonArea(Area area) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selecionarDropButtonArea');
    try {
      return super.selecionarDropButtonArea(area);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Setor selecionarDropButtonSetor(Setor setor) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selecionarDropButtonSetor');
    try {
      return super.selecionarDropButtonSetor(setor);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Lote setLoteSelecionado(Lote lote) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setLoteSelecionado');
    try {
      return super.setLoteSelecionado(lote);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setExpandedCard(int index) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setExpandedCard');
    try {
      return super.setExpandedCard(index);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleMostrarRegistrosSistema() {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.toggleMostrarRegistrosSistema');
    try {
      return super.toggleMostrarRegistrosSistema();
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Lote limparLoteSelecionado() {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.limparLoteSelecionado');
    try {
      return super.limparLoteSelecionado();
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparLotes() {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.limparLotes');
    try {
      return super.limparLotes();
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime selectDateRegistro(DateTime value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectDateRegistro');
    try {
      return super.selectDateRegistro(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime selectTimeRegistro(TimeOfDay value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectTimeRegistro');
    try {
      return super.selectTimeRegistro(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeachLotePage(String value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setSeachLotePage');
    try {
      return super.setSeachLotePage(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectUser(Usuario? usuario) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectUser');
    try {
      return super.selectUser(usuario);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedGroup(String name) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setSelectedGroup');
    try {
      return super.setSelectedGroup(name);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowTextFormField(bool value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setShowTextFormField');
    try {
      return super.setShowTextFormField(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsCadastroLoteLoading(bool value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.setIsCadastroLoteLoading');
    try {
      return super.setIsCadastroLoteLoading(value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectLotesGroup(int index, bool value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectLotesGroup');
    try {
      return super.selectLotesGroup(index, value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectLotesByLote(Lote lote, bool value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectLotesByLote');
    try {
      return super.selectLotesByLote(lote, value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectLotesSelection(int index1, int index2, bool value) {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.selectLotesSelection');
    try {
      return super.selectLotesSelection(index1, index2, value);
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarCadastro() {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.validarCadastro');
    try {
      return super.validarCadastro();
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparTudo() {
    final _$actionInfo = _$CadernoCampoStoreBaseActionController.startAction(
        name: 'CadernoCampoStoreBase.limparTudo');
    try {
      return super.limparTudo();
    } finally {
      _$CadernoCampoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loteList: ${loteList},
areaList: ${areaList},
isLoteListLoading: ${isLoteListLoading},
isAreaLoading: ${isAreaLoading},
mostrarRegistrosSistema: ${mostrarRegistrosSistema},
setorSelecionado: ${setorSelecionado},
dropButtonSetor: ${dropButtonSetor},
dropButtonArea: ${dropButtonArea},
loteSelecionado: ${loteSelecionado},
expandedCard: ${expandedCard},
searchAtividade: ${searchAtividade},
searchLote: ${searchLote},
dotIndicator: ${dotIndicator},
mostrarErroFormulario: ${mostrarErroFormulario},
isCadastroLoteLoading: ${isCadastroLoteLoading},
showTextFormField: ${showTextFormField},
isNovoRegistroLoading: ${isNovoRegistroLoading},
isEditing: ${isEditing},
selectedGroup: ${selectedGroup},
lotesGroup: ${lotesGroup},
usuariosConta: ${usuariosConta},
selectedUsuario: ${selectedUsuario},
novoAutorName: ${novoAutorName},
searchLotePage: ${searchLotePage},
dateRegistro: ${dateRegistro},
loteCadastro: ${loteCadastro},
getLotesAtividadesFilter: ${getLotesAtividadesFilter},
getLotesFilter: ${getLotesFilter},
getLotesGroup: ${getLotesGroup},
selectedLotes: ${selectedLotes}
    ''';
  }
}
