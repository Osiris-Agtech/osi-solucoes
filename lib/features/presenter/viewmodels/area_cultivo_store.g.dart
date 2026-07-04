// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_cultivo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AreaCultivoStore on AreaCultivoStoreBase, Store {
  Computed<List<Area>>? _$searchAreaComputed;

  @override
  List<Area> get searchArea =>
      (_$searchAreaComputed ??= Computed<List<Area>>(() => super.searchArea,
              name: 'AreaCultivoStoreBase.searchArea'))
          .value;

  late final _$isAreaLoadingAtom =
      Atom(name: 'AreaCultivoStoreBase.isAreaLoading', context: context);

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

  late final _$dropDownValueAtom =
      Atom(name: 'AreaCultivoStoreBase.dropDownValue', context: context);

  @override
  String get dropDownValue {
    _$dropDownValueAtom.reportRead();
    return super.dropDownValue;
  }

  @override
  set dropDownValue(String value) {
    _$dropDownValueAtom.reportWrite(value, super.dropDownValue, () {
      super.dropDownValue = value;
    });
  }

  late final _$orderAtom =
      Atom(name: 'AreaCultivoStoreBase.order', context: context);

  @override
  String get order {
    _$orderAtom.reportRead();
    return super.order;
  }

  @override
  set order(String value) {
    _$orderAtom.reportWrite(value, super.order, () {
      super.order = value;
    });
  }

  late final _$data2Atom =
      Atom(name: 'AreaCultivoStoreBase.data2', context: context);

  @override
  DateTime get data2 {
    _$data2Atom.reportRead();
    return super.data2;
  }

  @override
  set data2(DateTime value) {
    _$data2Atom.reportWrite(value, super.data2, () {
      super.data2 = value;
    });
  }

  late final _$data1Atom =
      Atom(name: 'AreaCultivoStoreBase.data1', context: context);

  @override
  DateTime get data1 {
    _$data1Atom.reportRead();
    return super.data1;
  }

  @override
  set data1(DateTime value) {
    _$data1Atom.reportWrite(value, super.data1, () {
      super.data1 = value;
    });
  }

  late final _$valueAtom =
      Atom(name: 'AreaCultivoStoreBase.value', context: context);

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$areaListAtom =
      Atom(name: 'AreaCultivoStoreBase.areaList', context: context);

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

  late final _$searchAreaTextAtom =
      Atom(name: 'AreaCultivoStoreBase.searchAreaText', context: context);

  @override
  String get searchAreaText {
    _$searchAreaTextAtom.reportRead();
    return super.searchAreaText;
  }

  @override
  set searchAreaText(String value) {
    _$searchAreaTextAtom.reportWrite(value, super.searchAreaText, () {
      super.searchAreaText = value;
    });
  }

  late final _$mostrarErroFormularioAtom = Atom(
      name: 'AreaCultivoStoreBase.mostrarErroFormulario', context: context);

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

  late final _$isNovaAreaLoadingAtom =
      Atom(name: 'AreaCultivoStoreBase.isNovaAreaLoading', context: context);

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

  late final _$isDeletingAreaCascadeAtom = Atom(
      name: 'AreaCultivoStoreBase.isDeletingAreaCascade', context: context);

  @override
  bool get isDeletingAreaCascade {
    _$isDeletingAreaCascadeAtom.reportRead();
    return super.isDeletingAreaCascade;
  }

  @override
  set isDeletingAreaCascade(bool value) {
    _$isDeletingAreaCascadeAtom.reportWrite(value, super.isDeletingAreaCascade,
        () {
      super.isDeletingAreaCascade = value;
    });
  }

  late final _$showTextFormFieldAtom =
      Atom(name: 'AreaCultivoStoreBase.showTextFormField', context: context);

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

  late final _$isEditingAtom =
      Atom(name: 'AreaCultivoStoreBase.isEditing', context: context);

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

  late final _$dotIndicatorAtom =
      Atom(name: 'AreaCultivoStoreBase.dotIndicator', context: context);

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

  late final _$localizacaoListAtom =
      Atom(name: 'AreaCultivoStoreBase.localizacaoList', context: context);

  @override
  List<Localizacao> get localizacaoList {
    _$localizacaoListAtom.reportRead();
    return super.localizacaoList;
  }

  @override
  set localizacaoList(List<Localizacao> value) {
    _$localizacaoListAtom.reportWrite(value, super.localizacaoList, () {
      super.localizacaoList = value;
    });
  }

  late final _$novaAreaAtom =
      Atom(name: 'AreaCultivoStoreBase.novaArea', context: context);

  @override
  Area get novaArea {
    _$novaAreaAtom.reportRead();
    return super.novaArea;
  }

  @override
  set novaArea(Area value) {
    _$novaAreaAtom.reportWrite(value, super.novaArea, () {
      super.novaArea = value;
    });
  }

  late final _$responseCEPAtom =
      Atom(name: 'AreaCultivoStoreBase.responseCEP', context: context);

  @override
  String? get responseCEP {
    _$responseCEPAtom.reportRead();
    return super.responseCEP;
  }

  @override
  set responseCEP(String? value) {
    _$responseCEPAtom.reportWrite(value, super.responseCEP, () {
      super.responseCEP = value;
    });
  }

  late final _$localizacaoSelecionadaAtom = Atom(
      name: 'AreaCultivoStoreBase.localizacaoSelecionada', context: context);

  @override
  Localizacao get localizacaoSelecionada {
    _$localizacaoSelecionadaAtom.reportRead();
    return super.localizacaoSelecionada;
  }

  @override
  set localizacaoSelecionada(Localizacao value) {
    _$localizacaoSelecionadaAtom
        .reportWrite(value, super.localizacaoSelecionada, () {
      super.localizacaoSelecionada = value;
    });
  }

  late final _$novaAreaNameAtom =
      Atom(name: 'AreaCultivoStoreBase.novaAreaName', context: context);

  @override
  TextEditingController get novaAreaName {
    _$novaAreaNameAtom.reportRead();
    return super.novaAreaName;
  }

  @override
  set novaAreaName(TextEditingController value) {
    _$novaAreaNameAtom.reportWrite(value, super.novaAreaName, () {
      super.novaAreaName = value;
    });
  }

  late final _$novaAreaDescricaoAtom =
      Atom(name: 'AreaCultivoStoreBase.novaAreaDescricao', context: context);

  @override
  TextEditingController get novaAreaDescricao {
    _$novaAreaDescricaoAtom.reportRead();
    return super.novaAreaDescricao;
  }

  @override
  set novaAreaDescricao(TextEditingController value) {
    _$novaAreaDescricaoAtom.reportWrite(value, super.novaAreaDescricao, () {
      super.novaAreaDescricao = value;
    });
  }

  late final _$cepAtom =
      Atom(name: 'AreaCultivoStoreBase.cep', context: context);

  @override
  TextEditingController get cep {
    _$cepAtom.reportRead();
    return super.cep;
  }

  @override
  set cep(TextEditingController value) {
    _$cepAtom.reportWrite(value, super.cep, () {
      super.cep = value;
    });
  }

  late final _$enderecoAtom =
      Atom(name: 'AreaCultivoStoreBase.endereco', context: context);

  @override
  TextEditingController get endereco {
    _$enderecoAtom.reportRead();
    return super.endereco;
  }

  @override
  set endereco(TextEditingController value) {
    _$enderecoAtom.reportWrite(value, super.endereco, () {
      super.endereco = value;
    });
  }

  late final _$bairroAtom =
      Atom(name: 'AreaCultivoStoreBase.bairro', context: context);

  @override
  TextEditingController get bairro {
    _$bairroAtom.reportRead();
    return super.bairro;
  }

  @override
  set bairro(TextEditingController value) {
    _$bairroAtom.reportWrite(value, super.bairro, () {
      super.bairro = value;
    });
  }

  late final _$cidadeAtom =
      Atom(name: 'AreaCultivoStoreBase.cidade', context: context);

  @override
  TextEditingController get cidade {
    _$cidadeAtom.reportRead();
    return super.cidade;
  }

  @override
  set cidade(TextEditingController value) {
    _$cidadeAtom.reportWrite(value, super.cidade, () {
      super.cidade = value;
    });
  }

  late final _$numeroAtom =
      Atom(name: 'AreaCultivoStoreBase.numero', context: context);

  @override
  TextEditingController get numero {
    _$numeroAtom.reportRead();
    return super.numero;
  }

  @override
  set numero(TextEditingController value) {
    _$numeroAtom.reportWrite(value, super.numero, () {
      super.numero = value;
    });
  }

  late final _$complementoAtom =
      Atom(name: 'AreaCultivoStoreBase.complemento', context: context);

  @override
  TextEditingController get complemento {
    _$complementoAtom.reportRead();
    return super.complemento;
  }

  @override
  set complemento(TextEditingController value) {
    _$complementoAtom.reportWrite(value, super.complemento, () {
      super.complemento = value;
    });
  }

  late final _$paisAtom =
      Atom(name: 'AreaCultivoStoreBase.pais', context: context);

  @override
  TextEditingController get pais {
    _$paisAtom.reportRead();
    return super.pais;
  }

  @override
  set pais(TextEditingController value) {
    _$paisAtom.reportWrite(value, super.pais, () {
      super.pais = value;
    });
  }

  late final _$estadoAtom =
      Atom(name: 'AreaCultivoStoreBase.estado', context: context);

  @override
  TextEditingController get estado {
    _$estadoAtom.reportRead();
    return super.estado;
  }

  @override
  set estado(TextEditingController value) {
    _$estadoAtom.reportWrite(value, super.estado, () {
      super.estado = value;
    });
  }

  late final _$buscarAreaAsyncAction =
      AsyncAction('AreaCultivoStoreBase.buscarArea', context: context);

  @override
  Future<void> buscarArea() {
    return _$buscarAreaAsyncAction.run(() => super.buscarArea());
  }

  late final _$cadastrarNovaLocalizacaoAsyncAction = AsyncAction(
      'AreaCultivoStoreBase.cadastrarNovaLocalizacao',
      context: context);

  @override
  Future<void> cadastrarNovaLocalizacao(BuildContext context) {
    return _$cadastrarNovaLocalizacaoAsyncAction
        .run(() => super.cadastrarNovaLocalizacao(context));
  }

  late final _$buscarLocalizacoesAsyncAction =
      AsyncAction('AreaCultivoStoreBase.buscarLocalizacoes', context: context);

  @override
  Future<void> buscarLocalizacoes() {
    return _$buscarLocalizacoesAsyncAction
        .run(() => super.buscarLocalizacoes());
  }

  late final _$deletarAreaCascadeAsyncAction =
      AsyncAction('AreaCultivoStoreBase.deletarAreaCascade', context: context);

  @override
  Future<void> deletarAreaCascade(int areaId) {
    return _$deletarAreaCascadeAsyncAction
        .run(() => super.deletarAreaCascade(areaId));
  }

  late final _$registrarAreaAsyncAction =
      AsyncAction('AreaCultivoStoreBase.registrarArea', context: context);

  @override
  Future<void> registrarArea() {
    return _$registrarAreaAsyncAction.run(() => super.registrarArea());
  }

  late final _$alterarAreaAsyncAction =
      AsyncAction('AreaCultivoStoreBase.alterarArea', context: context);

  @override
  Future<void> alterarArea() {
    return _$alterarAreaAsyncAction.run(() => super.alterarArea());
  }

  late final _$buscaCEPAsyncAction =
      AsyncAction('AreaCultivoStoreBase.buscaCEP', context: context);

  @override
  Future<String> buscaCEP() {
    return _$buscaCEPAsyncAction.run(() => super.buscaCEP());
  }

  late final _$AreaCultivoStoreBaseActionController =
      ActionController(name: 'AreaCultivoStoreBase', context: context);

  @override
  String setDropDown(String value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setDropDown');
    try {
      return super.setDropDown(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String changeOrder() {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.changeOrder');
    try {
      return super.changeOrder();
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setData2(DateTime value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setData2');
    try {
      return super.setData2(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setData1(DateTime value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setData1');
    try {
      return super.setData1(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setSearchAreaText(String value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setSearchAreaText');
    try {
      return super.setSearchAreaText(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsEditing(bool value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAreaEditing(Area area) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setAreaEditing');
    try {
      return super.setAreaEditing(area);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarCadastro() {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.validarCadastro');
    try {
      return super.validarCadastro();
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Localizacao setLocalizacaoSelecionada(int index) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setLocalizacaoSelecionada');
    try {
      return super.setLocalizacaoSelecionada(index);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparLocalizacao() {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.limparLocalizacao');
    try {
      return super.limparLocalizacao();
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowTextFormField(bool value) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.setShowTextFormField');
    try {
      return super.setShowTextFormField(value);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarNome(String name) {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparTudo() {
    final _$actionInfo = _$AreaCultivoStoreBaseActionController.startAction(
        name: 'AreaCultivoStoreBase.limparTudo');
    try {
      return super.limparTudo();
    } finally {
      _$AreaCultivoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isAreaLoading: ${isAreaLoading},
dropDownValue: ${dropDownValue},
order: ${order},
data2: ${data2},
data1: ${data1},
value: ${value},
areaList: ${areaList},
searchAreaText: ${searchAreaText},
mostrarErroFormulario: ${mostrarErroFormulario},
isNovaAreaLoading: ${isNovaAreaLoading},
isDeletingAreaCascade: ${isDeletingAreaCascade},
showTextFormField: ${showTextFormField},
isEditing: ${isEditing},
dotIndicator: ${dotIndicator},
localizacaoList: ${localizacaoList},
novaArea: ${novaArea},
responseCEP: ${responseCEP},
localizacaoSelecionada: ${localizacaoSelecionada},
novaAreaName: ${novaAreaName},
novaAreaDescricao: ${novaAreaDescricao},
cep: ${cep},
endereco: ${endereco},
bairro: ${bairro},
cidade: ${cidade},
numero: ${numero},
complemento: ${complemento},
pais: ${pais},
estado: ${estado},
searchArea: ${searchArea}
    ''';
  }
}
