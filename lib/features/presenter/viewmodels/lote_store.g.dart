// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoteStore on _LoteStoreBase, Store {
  Computed<List<Lote>>? _$searchLoteComputed;

  @override
  List<Lote> get searchLote =>
      (_$searchLoteComputed ??= Computed<List<Lote>>(() => super.searchLote,
              name: '_LoteStoreBase.searchLote'))
          .value;
  Computed<List<Protocolo>>? _$searchProtocoloComputed;

  @override
  List<Protocolo> get searchProtocolo => (_$searchProtocoloComputed ??=
          Computed<List<Protocolo>>(() => super.searchProtocolo,
              name: '_LoteStoreBase.searchProtocolo'))
      .value;
  Computed<bool>? _$isAlreadySelectedComputed;

  @override
  bool get isAlreadySelected => (_$isAlreadySelectedComputed ??= Computed<bool>(
          () => super.isAlreadySelected,
          name: '_LoteStoreBase.isAlreadySelected'))
      .value;
  Computed<List<LoteSelection>>? _$getLotesGroupComputed;

  @override
  List<LoteSelection> get getLotesGroup => (_$getLotesGroupComputed ??=
          Computed<List<LoteSelection>>(() => super.getLotesGroup,
              name: '_LoteStoreBase.getLotesGroup'))
      .value;
  Computed<List<LoteSelection>>? _$lotesParaFinalizarComputed;

  @override
  List<LoteSelection> get lotesParaFinalizar =>
      (_$lotesParaFinalizarComputed ??= Computed<List<LoteSelection>>(
              () => super.lotesParaFinalizar,
              name: '_LoteStoreBase.lotesParaFinalizar'))
          .value;
  Computed<bool>? _$marcarTodasAtividadesComputed;

  @override
  bool get marcarTodasAtividades => (_$marcarTodasAtividadesComputed ??=
          Computed<bool>(() => super.marcarTodasAtividades,
              name: '_LoteStoreBase.marcarTodasAtividades'))
      .value;

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

  final _$isProtocoloListLoadingAtom =
      Atom(name: '_LoteStoreBase.isProtocoloListLoading');

  @override
  bool get isProtocoloListLoading {
    _$isProtocoloListLoadingAtom.reportRead();
    return super.isProtocoloListLoading;
  }

  @override
  set isProtocoloListLoading(bool value) {
    _$isProtocoloListLoadingAtom
        .reportWrite(value, super.isProtocoloListLoading, () {
      super.isProtocoloListLoading = value;
    });
  }

  final _$dropDownValueAtom = Atom(name: '_LoteStoreBase.dropDownValue');

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

  final _$searchLoteTextAtom = Atom(name: '_LoteStoreBase.searchLoteText');

  @override
  String get searchLoteText {
    _$searchLoteTextAtom.reportRead();
    return super.searchLoteText;
  }

  @override
  set searchLoteText(String value) {
    _$searchLoteTextAtom.reportWrite(value, super.searchLoteText, () {
      super.searchLoteText = value;
    });
  }

  final _$orderAtom = Atom(name: '_LoteStoreBase.order');

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

  final _$protocoloListAtom = Atom(name: '_LoteStoreBase.protocoloList');

  @override
  List<Protocolo> get protocoloList {
    _$protocoloListAtom.reportRead();
    return super.protocoloList;
  }

  @override
  set protocoloList(List<Protocolo> value) {
    _$protocoloListAtom.reportWrite(value, super.protocoloList, () {
      super.protocoloList = value;
    });
  }

  final _$listaFaseDetalhesAtom =
      Atom(name: '_LoteStoreBase.listaFaseDetalhes');

  @override
  List<Fase> get listaFaseDetalhes {
    _$listaFaseDetalhesAtom.reportRead();
    return super.listaFaseDetalhes;
  }

  @override
  set listaFaseDetalhes(List<Fase> value) {
    _$listaFaseDetalhesAtom.reportWrite(value, super.listaFaseDetalhes, () {
      super.listaFaseDetalhes = value;
    });
  }

  final _$data1Atom = Atom(name: '_LoteStoreBase.data1');

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

  final _$data2Atom = Atom(name: '_LoteStoreBase.data2');

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

  final _$areaListAtom = Atom(name: '_LoteStoreBase.areaList');

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

  final _$isAreaLoadingAtom = Atom(name: '_LoteStoreBase.isAreaLoading');

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

  final _$isMigrateLoteLoadingAtom =
      Atom(name: '_LoteStoreBase.isMigrateLoteLoading');

  @override
  bool get isMigrateLoteLoading {
    _$isMigrateLoteLoadingAtom.reportRead();
    return super.isMigrateLoteLoading;
  }

  @override
  set isMigrateLoteLoading(bool value) {
    _$isMigrateLoteLoadingAtom.reportWrite(value, super.isMigrateLoteLoading,
        () {
      super.isMigrateLoteLoading = value;
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

  final _$areaSelecionadaAtom = Atom(name: '_LoteStoreBase.areaSelecionada');

  @override
  Area get areaSelecionada {
    _$areaSelecionadaAtom.reportRead();
    return super.areaSelecionada;
  }

  @override
  set areaSelecionada(Area value) {
    _$areaSelecionadaAtom.reportWrite(value, super.areaSelecionada, () {
      super.areaSelecionada = value;
    });
  }

  final _$setorSelecionadoMigrarAtom =
      Atom(name: '_LoteStoreBase.setorSelecionadoMigrar');

  @override
  Setor get setorSelecionadoMigrar {
    _$setorSelecionadoMigrarAtom.reportRead();
    return super.setorSelecionadoMigrar;
  }

  @override
  set setorSelecionadoMigrar(Setor value) {
    _$setorSelecionadoMigrarAtom
        .reportWrite(value, super.setorSelecionadoMigrar, () {
      super.setorSelecionadoMigrar = value;
    });
  }

  final _$mostrarErroFormularioAtom =
      Atom(name: '_LoteStoreBase.mostrarErroFormulario');

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

  final _$isEditingAtom = Atom(name: '_LoteStoreBase.isEditing');

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

  final _$isBandeijasEditingAtom =
      Atom(name: '_LoteStoreBase.isBandeijasEditing');

  @override
  bool get isBandeijasEditing {
    _$isBandeijasEditingAtom.reportRead();
    return super.isBandeijasEditing;
  }

  @override
  set isBandeijasEditing(bool value) {
    _$isBandeijasEditingAtom.reportWrite(value, super.isBandeijasEditing, () {
      super.isBandeijasEditing = value;
    });
  }

  final _$isMudasEditingAtom = Atom(name: '_LoteStoreBase.isMudasEditing');

  @override
  bool get isMudasEditing {
    _$isMudasEditingAtom.reportRead();
    return super.isMudasEditing;
  }

  @override
  set isMudasEditing(bool value) {
    _$isMudasEditingAtom.reportWrite(value, super.isMudasEditing, () {
      super.isMudasEditing = value;
    });
  }

  final _$isPlantasEditingAtom = Atom(name: '_LoteStoreBase.isPlantasEditing');

  @override
  bool get isPlantasEditing {
    _$isPlantasEditingAtom.reportRead();
    return super.isPlantasEditing;
  }

  @override
  set isPlantasEditing(bool value) {
    _$isPlantasEditingAtom.reportWrite(value, super.isPlantasEditing, () {
      super.isPlantasEditing = value;
    });
  }

  final _$isEmbalagensEditingAtom =
      Atom(name: '_LoteStoreBase.isEmbalagensEditing');

  @override
  bool get isEmbalagensEditing {
    _$isEmbalagensEditingAtom.reportRead();
    return super.isEmbalagensEditing;
  }

  @override
  set isEmbalagensEditing(bool value) {
    _$isEmbalagensEditingAtom.reportWrite(value, super.isEmbalagensEditing, () {
      super.isEmbalagensEditing = value;
    });
  }

  final _$isVisibleAtom = Atom(name: '_LoteStoreBase.isVisible');

  @override
  bool get isVisible {
    _$isVisibleAtom.reportRead();
    return super.isVisible;
  }

  @override
  set isVisible(bool value) {
    _$isVisibleAtom.reportWrite(value, super.isVisible, () {
      super.isVisible = value;
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

  final _$isNovoLoteLoadingAtom =
      Atom(name: '_LoteStoreBase.isNovoLoteLoading');

  @override
  bool get isNovoLoteLoading {
    _$isNovoLoteLoadingAtom.reportRead();
    return super.isNovoLoteLoading;
  }

  @override
  set isNovoLoteLoading(bool value) {
    _$isNovoLoteLoadingAtom.reportWrite(value, super.isNovoLoteLoading, () {
      super.isNovoLoteLoading = value;
    });
  }

  final _$showReservatorioDetalhesAtom =
      Atom(name: '_LoteStoreBase.showReservatorioDetalhes');

  @override
  bool get showReservatorioDetalhes {
    _$showReservatorioDetalhesAtom.reportRead();
    return super.showReservatorioDetalhes;
  }

  @override
  set showReservatorioDetalhes(bool value) {
    _$showReservatorioDetalhesAtom
        .reportWrite(value, super.showReservatorioDetalhes, () {
      super.showReservatorioDetalhes = value;
    });
  }

  final _$showProtocoloDetalhesAtom =
      Atom(name: '_LoteStoreBase.showProtocoloDetalhes');

  @override
  bool get showProtocoloDetalhes {
    _$showProtocoloDetalhesAtom.reportRead();
    return super.showProtocoloDetalhes;
  }

  @override
  set showProtocoloDetalhes(bool value) {
    _$showProtocoloDetalhesAtom.reportWrite(value, super.showProtocoloDetalhes,
        () {
      super.showProtocoloDetalhes = value;
    });
  }

  final _$isNovaCulturaAtom = Atom(name: '_LoteStoreBase.isNovaCultura');

  @override
  bool get isNovaCultura {
    _$isNovaCulturaAtom.reportRead();
    return super.isNovaCultura;
  }

  @override
  set isNovaCultura(bool value) {
    _$isNovaCulturaAtom.reportWrite(value, super.isNovaCultura, () {
      super.isNovaCultura = value;
    });
  }

  final _$dotIndicatorAtom = Atom(name: '_LoteStoreBase.dotIndicator');

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

  final _$culturaListAtom = Atom(name: '_LoteStoreBase.culturaList');

  @override
  List<Cultura> get culturaList {
    _$culturaListAtom.reportRead();
    return super.culturaList;
  }

  @override
  set culturaList(List<Cultura> value) {
    _$culturaListAtom.reportWrite(value, super.culturaList, () {
      super.culturaList = value;
    });
  }

  final _$novoLoteSetorAtom = Atom(name: '_LoteStoreBase.novoLoteSetor');

  @override
  Setor get novoLoteSetor {
    _$novoLoteSetorAtom.reportRead();
    return super.novoLoteSetor;
  }

  @override
  set novoLoteSetor(Setor value) {
    _$novoLoteSetorAtom.reportWrite(value, super.novoLoteSetor, () {
      super.novoLoteSetor = value;
    });
  }

  final _$novoLoteAreaAtom = Atom(name: '_LoteStoreBase.novoLoteArea');

  @override
  Area get novoLoteArea {
    _$novoLoteAreaAtom.reportRead();
    return super.novoLoteArea;
  }

  @override
  set novoLoteArea(Area value) {
    _$novoLoteAreaAtom.reportWrite(value, super.novoLoteArea, () {
      super.novoLoteArea = value;
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

  final _$novaCulturaControllerAtom =
      Atom(name: '_LoteStoreBase.novaCulturaController');

  @override
  TextEditingController get novaCulturaController {
    _$novaCulturaControllerAtom.reportRead();
    return super.novaCulturaController;
  }

  @override
  set novaCulturaController(TextEditingController value) {
    _$novaCulturaControllerAtom.reportWrite(value, super.novaCulturaController,
        () {
      super.novaCulturaController = value;
    });
  }

  final _$bandeijasSemeadasControllerAtom =
      Atom(name: '_LoteStoreBase.bandeijasSemeadasController');

  @override
  TextEditingController get bandeijasSemeadasController {
    _$bandeijasSemeadasControllerAtom.reportRead();
    return super.bandeijasSemeadasController;
  }

  @override
  set bandeijasSemeadasController(TextEditingController value) {
    _$bandeijasSemeadasControllerAtom
        .reportWrite(value, super.bandeijasSemeadasController, () {
      super.bandeijasSemeadasController = value;
    });
  }

  final _$mudasTransplantadasControllerAtom =
      Atom(name: '_LoteStoreBase.mudasTransplantadasController');

  @override
  TextEditingController get mudasTransplantadasController {
    _$mudasTransplantadasControllerAtom.reportRead();
    return super.mudasTransplantadasController;
  }

  @override
  set mudasTransplantadasController(TextEditingController value) {
    _$mudasTransplantadasControllerAtom
        .reportWrite(value, super.mudasTransplantadasController, () {
      super.mudasTransplantadasController = value;
    });
  }

  final _$plantasColhidasControllerAtom =
      Atom(name: '_LoteStoreBase.plantasColhidasController');

  @override
  TextEditingController get plantasColhidasController {
    _$plantasColhidasControllerAtom.reportRead();
    return super.plantasColhidasController;
  }

  @override
  set plantasColhidasController(TextEditingController value) {
    _$plantasColhidasControllerAtom
        .reportWrite(value, super.plantasColhidasController, () {
      super.plantasColhidasController = value;
    });
  }

  final _$embalagensProduzidasControllerAtom =
      Atom(name: '_LoteStoreBase.embalagensProduzidasController');

  @override
  TextEditingController get embalagensProduzidasController {
    _$embalagensProduzidasControllerAtom.reportRead();
    return super.embalagensProduzidasController;
  }

  @override
  set embalagensProduzidasController(TextEditingController value) {
    _$embalagensProduzidasControllerAtom
        .reportWrite(value, super.embalagensProduzidasController, () {
      super.embalagensProduzidasController = value;
    });
  }

  final _$novoLoteCulturaAtom = Atom(name: '_LoteStoreBase.novoLoteCultura');

  @override
  Cultura get novoLoteCultura {
    _$novoLoteCulturaAtom.reportRead();
    return super.novoLoteCultura;
  }

  @override
  set novoLoteCultura(Cultura value) {
    _$novoLoteCulturaAtom.reportWrite(value, super.novoLoteCultura, () {
      super.novoLoteCultura = value;
    });
  }

  final _$novoLoteReservatorioAtom =
      Atom(name: '_LoteStoreBase.novoLoteReservatorio');

  @override
  Reservatorio get novoLoteReservatorio {
    _$novoLoteReservatorioAtom.reportRead();
    return super.novoLoteReservatorio;
  }

  @override
  set novoLoteReservatorio(Reservatorio value) {
    _$novoLoteReservatorioAtom.reportWrite(value, super.novoLoteReservatorio,
        () {
      super.novoLoteReservatorio = value;
    });
  }

  final _$registroDataAtom = Atom(name: '_LoteStoreBase.registroData');

  @override
  DateTime get registroData {
    _$registroDataAtom.reportRead();
    return super.registroData;
  }

  @override
  set registroData(DateTime value) {
    _$registroDataAtom.reportWrite(value, super.registroData, () {
      super.registroData = value;
    });
  }

  final _$semeaduraDataAtom = Atom(name: '_LoteStoreBase.semeaduraData');

  @override
  DateTime? get semeaduraData {
    _$semeaduraDataAtom.reportRead();
    return super.semeaduraData;
  }

  @override
  set semeaduraData(DateTime? value) {
    _$semeaduraDataAtom.reportWrite(value, super.semeaduraData, () {
      super.semeaduraData = value;
    });
  }

  final _$transplantioDataAtom = Atom(name: '_LoteStoreBase.transplantioData');

  @override
  DateTime? get transplantioData {
    _$transplantioDataAtom.reportRead();
    return super.transplantioData;
  }

  @override
  set transplantioData(DateTime? value) {
    _$transplantioDataAtom.reportWrite(value, super.transplantioData, () {
      super.transplantioData = value;
    });
  }

  final _$colheitaDataAtom = Atom(name: '_LoteStoreBase.colheitaData');

  @override
  DateTime? get colheitaData {
    _$colheitaDataAtom.reportRead();
    return super.colheitaData;
  }

  @override
  set colheitaData(DateTime? value) {
    _$colheitaDataAtom.reportWrite(value, super.colheitaData, () {
      super.colheitaData = value;
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

  final _$reservatorioListAtom = Atom(name: '_LoteStoreBase.reservatorioList');

  @override
  List<Reservatorio> get reservatorioList {
    _$reservatorioListAtom.reportRead();
    return super.reservatorioList;
  }

  @override
  set reservatorioList(List<Reservatorio> value) {
    _$reservatorioListAtom.reportWrite(value, super.reservatorioList, () {
      super.reservatorioList = value;
    });
  }

  final _$reservatorioDetalhesAtom =
      Atom(name: '_LoteStoreBase.reservatorioDetalhes');

  @override
  Reservatorio get reservatorioDetalhes {
    _$reservatorioDetalhesAtom.reportRead();
    return super.reservatorioDetalhes;
  }

  @override
  set reservatorioDetalhes(Reservatorio value) {
    _$reservatorioDetalhesAtom.reportWrite(value, super.reservatorioDetalhes,
        () {
      super.reservatorioDetalhes = value;
    });
  }

  final _$protocoloDetalhesAtom =
      Atom(name: '_LoteStoreBase.protocoloDetalhes');

  @override
  Protocolo? get protocoloDetalhes {
    _$protocoloDetalhesAtom.reportRead();
    return super.protocoloDetalhes;
  }

  @override
  set protocoloDetalhes(Protocolo? value) {
    _$protocoloDetalhesAtom.reportWrite(value, super.protocoloDetalhes, () {
      super.protocoloDetalhes = value;
    });
  }

  final _$protocoloVinculadoAtom =
      Atom(name: '_LoteStoreBase.protocoloVinculado');

  @override
  Protocolo? get protocoloVinculado {
    _$protocoloVinculadoAtom.reportRead();
    return super.protocoloVinculado;
  }

  @override
  set protocoloVinculado(Protocolo? value) {
    _$protocoloVinculadoAtom.reportWrite(value, super.protocoloVinculado, () {
      super.protocoloVinculado = value;
    });
  }

  final _$searchProtocoloTextAtom =
      Atom(name: '_LoteStoreBase.searchProtocoloText');

  @override
  String get searchProtocoloText {
    _$searchProtocoloTextAtom.reportRead();
    return super.searchProtocoloText;
  }

  @override
  set searchProtocoloText(String value) {
    _$searchProtocoloTextAtom.reportWrite(value, super.searchProtocoloText, () {
      super.searchProtocoloText = value;
    });
  }

  final _$solucaoNutritivaListAtom =
      Atom(name: '_LoteStoreBase.solucaoNutritivaList');

  @override
  List<SolucaoFertilizanteConcentrada> get solucaoNutritivaList {
    _$solucaoNutritivaListAtom.reportRead();
    return super.solucaoNutritivaList;
  }

  @override
  set solucaoNutritivaList(List<SolucaoFertilizanteConcentrada> value) {
    _$solucaoNutritivaListAtom.reportWrite(value, super.solucaoNutritivaList,
        () {
      super.solucaoNutritivaList = value;
    });
  }

  final _$solucaoConcentradaListAtom =
      Atom(name: '_LoteStoreBase.solucaoConcentradaList');

  @override
  List<SolucaoFertilizanteConcentrada> get solucaoConcentradaList {
    _$solucaoConcentradaListAtom.reportRead();
    return super.solucaoConcentradaList;
  }

  @override
  set solucaoConcentradaList(List<SolucaoFertilizanteConcentrada> value) {
    _$solucaoConcentradaListAtom
        .reportWrite(value, super.solucaoConcentradaList, () {
      super.solucaoConcentradaList = value;
    });
  }

  final _$novoLoteAtom = Atom(name: '_LoteStoreBase.novoLote');

  @override
  Lote get novoLote {
    _$novoLoteAtom.reportRead();
    return super.novoLote;
  }

  @override
  set novoLote(Lote value) {
    _$novoLoteAtom.reportWrite(value, super.novoLote, () {
      super.novoLote = value;
    });
  }

  final _$abrirProtocoloDetalhesAtvAtom =
      Atom(name: '_LoteStoreBase.abrirProtocoloDetalhesAtv');

  @override
  bool get abrirProtocoloDetalhesAtv {
    _$abrirProtocoloDetalhesAtvAtom.reportRead();
    return super.abrirProtocoloDetalhesAtv;
  }

  @override
  set abrirProtocoloDetalhesAtv(bool value) {
    _$abrirProtocoloDetalhesAtvAtom
        .reportWrite(value, super.abrirProtocoloDetalhesAtv, () {
      super.abrirProtocoloDetalhesAtv = value;
    });
  }

  final _$isProtocoloValidAtom = Atom(name: '_LoteStoreBase.isProtocoloValid');

  @override
  bool get isProtocoloValid {
    _$isProtocoloValidAtom.reportRead();
    return super.isProtocoloValid;
  }

  @override
  set isProtocoloValid(bool value) {
    _$isProtocoloValidAtom.reportWrite(value, super.isProtocoloValid, () {
      super.isProtocoloValid = value;
    });
  }

  final _$searchLotePageAtom = Atom(name: '_LoteStoreBase.searchLotePage');

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

  final _$plantasColhidasAtom = Atom(name: '_LoteStoreBase.plantasColhidas');

  @override
  int? get plantasColhidas {
    _$plantasColhidasAtom.reportRead();
    return super.plantasColhidas;
  }

  @override
  set plantasColhidas(int? value) {
    _$plantasColhidasAtom.reportWrite(value, super.plantasColhidas, () {
      super.plantasColhidas = value;
    });
  }

  final _$embalagensProduzidasAtom =
      Atom(name: '_LoteStoreBase.embalagensProduzidas');

  @override
  int? get embalagensProduzidas {
    _$embalagensProduzidasAtom.reportRead();
    return super.embalagensProduzidas;
  }

  @override
  set embalagensProduzidas(int? value) {
    _$embalagensProduzidasAtom.reportWrite(value, super.embalagensProduzidas,
        () {
      super.embalagensProduzidas = value;
    });
  }

  final _$finalizarLotesAtom = Atom(name: '_LoteStoreBase.finalizarLotes');

  @override
  List<LoteSelection> get finalizarLotes {
    _$finalizarLotesAtom.reportRead();
    return super.finalizarLotes;
  }

  @override
  set finalizarLotes(List<LoteSelection> value) {
    _$finalizarLotesAtom.reportWrite(value, super.finalizarLotes, () {
      super.finalizarLotes = value;
    });
  }

  final _$atividadesPendentesAtom =
      Atom(name: '_LoteStoreBase.atividadesPendentes');

  @override
  List<AgendaSelection> get atividadesPendentes {
    _$atividadesPendentesAtom.reportRead();
    return super.atividadesPendentes;
  }

  @override
  set atividadesPendentes(List<AgendaSelection> value) {
    _$atividadesPendentesAtom.reportWrite(value, super.atividadesPendentes, () {
      super.atividadesPendentes = value;
    });
  }

  final _$atividadesDeletadasAtom =
      Atom(name: '_LoteStoreBase.atividadesDeletadas');

  @override
  List<Agenda> get atividadesDeletadas {
    _$atividadesDeletadasAtom.reportRead();
    return super.atividadesDeletadas;
  }

  @override
  set atividadesDeletadas(List<Agenda> value) {
    _$atividadesDeletadasAtom.reportWrite(value, super.atividadesDeletadas, () {
      super.atividadesDeletadas = value;
    });
  }

  final _$carregandoFinalizarLotesAtom =
      Atom(name: '_LoteStoreBase.carregandoFinalizarLotes');

  @override
  bool get carregandoFinalizarLotes {
    _$carregandoFinalizarLotesAtom.reportRead();
    return super.carregandoFinalizarLotes;
  }

  @override
  set carregandoFinalizarLotes(bool value) {
    _$carregandoFinalizarLotesAtom
        .reportWrite(value, super.carregandoFinalizarLotes, () {
      super.carregandoFinalizarLotes = value;
    });
  }

  final _$lotesFinalizadosAtom = Atom(name: '_LoteStoreBase.lotesFinalizados');

  @override
  List<Lote> get lotesFinalizados {
    _$lotesFinalizadosAtom.reportRead();
    return super.lotesFinalizados;
  }

  @override
  set lotesFinalizados(List<Lote> value) {
    _$lotesFinalizadosAtom.reportWrite(value, super.lotesFinalizados, () {
      super.lotesFinalizados = value;
    });
  }

  final _$buscarLotesAsyncAction = AsyncAction('_LoteStoreBase.buscarLotes');

  @override
  Future buscarLotes() {
    return _$buscarLotesAsyncAction.run(() => super.buscarLotes());
  }

  final _$migrarLoteAsyncAction = AsyncAction('_LoteStoreBase.migrarLote');

  @override
  Future migrarLote(bool migrarReservatorio) {
    return _$migrarLoteAsyncAction
        .run(() => super.migrarLote(migrarReservatorio));
  }

  final _$buscarDetalhesLoteAsyncAction =
      AsyncAction('_LoteStoreBase.buscarDetalhesLote');

  @override
  Future buscarDetalhesLote() {
    return _$buscarDetalhesLoteAsyncAction
        .run(() => super.buscarDetalhesLote());
  }

  final _$buscarAreasListAsyncAction =
      AsyncAction('_LoteStoreBase.buscarAreasList');

  @override
  Future buscarAreasList() {
    return _$buscarAreasListAsyncAction.run(() => super.buscarAreasList());
  }

  final _$buscarCulturasAsyncAction =
      AsyncAction('_LoteStoreBase.buscarCulturas');

  @override
  Future buscarCulturas() {
    return _$buscarCulturasAsyncAction.run(() => super.buscarCulturas());
  }

  final _$buscarReservatoriosAsyncAction =
      AsyncAction('_LoteStoreBase.buscarReservatorios');

  @override
  Future buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  final _$buscarReservatorioDetalhesAsyncAction =
      AsyncAction('_LoteStoreBase.buscarReservatorioDetalhes');

  @override
  Future buscarReservatorioDetalhes() {
    return _$buscarReservatorioDetalhesAsyncAction
        .run(() => super.buscarReservatorioDetalhes());
  }

  final _$registrarLoteAsyncAction =
      AsyncAction('_LoteStoreBase.registrarLote');

  @override
  Future registrarLote() {
    return _$registrarLoteAsyncAction.run(() => super.registrarLote());
  }

  final _$registrarCulturaAsyncAction =
      AsyncAction('_LoteStoreBase.registrarCultura');

  @override
  Future registrarCultura() {
    return _$registrarCulturaAsyncAction.run(() => super.registrarCultura());
  }

  final _$alterarLoteAsyncAction = AsyncAction('_LoteStoreBase.alterarLote');

  @override
  Future alterarLote() {
    return _$alterarLoteAsyncAction.run(() => super.alterarLote());
  }

  final _$alterarProducaoLoteAsyncAction =
      AsyncAction('_LoteStoreBase.alterarProducaoLote');

  @override
  Future alterarProducaoLote() {
    return _$alterarProducaoLoteAsyncAction
        .run(() => super.alterarProducaoLote());
  }

  final _$alterarDatasLoteAsyncAction =
      AsyncAction('_LoteStoreBase.alterarDatasLote');

  @override
  Future alterarDatasLote() {
    return _$alterarDatasLoteAsyncAction.run(() => super.alterarDatasLote());
  }

  final _$finalizarTodosLotesAsyncAction =
      AsyncAction('_LoteStoreBase.finalizarTodosLotes');

  @override
  Future finalizarTodosLotes() {
    return _$finalizarTodosLotesAsyncAction
        .run(() => super.finalizarTodosLotes());
  }

  final _$deletarAtividadesSelecionadasAsyncAction =
      AsyncAction('_LoteStoreBase.deletarAtividadesSelecionadas');

  @override
  Future deletarAtividadesSelecionadas() {
    return _$deletarAtividadesSelecionadasAsyncAction
        .run(() => super.deletarAtividadesSelecionadas());
  }

  final _$finalizarAtividadesSelecionadasAsyncAction =
      AsyncAction('_LoteStoreBase.finalizarAtividadesSelecionadas');

  @override
  Future finalizarAtividadesSelecionadas() {
    return _$finalizarAtividadesSelecionadasAsyncAction
        .run(() => super.finalizarAtividadesSelecionadas());
  }

  final _$verificarAtividadesAsyncAction =
      AsyncAction('_LoteStoreBase.verificarAtividades');

  @override
  Future verificarAtividades() {
    return _$verificarAtividadesAsyncAction
        .run(() => super.verificarAtividades());
  }

  final _$buscarLotesFinalizadosAsyncAction =
      AsyncAction('_LoteStoreBase.buscarLotesFinalizados');

  @override
  Future buscarLotesFinalizados() {
    return _$buscarLotesFinalizadosAsyncAction
        .run(() => super.buscarLotesFinalizados());
  }

  final _$_LoteStoreBaseActionController =
      ActionController(name: '_LoteStoreBase');

  @override
  dynamic setData1(DateTime value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setData1');
    try {
      return super.setData1(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setData2(DateTime value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setData2');
    try {
      return super.setData2(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeOrder() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.changeOrder');
    try {
      return super.changeOrder();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  dynamic setDropDown(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setDropDown');
    try {
      return super.setDropDown(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSearchLoteText(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setSearchLoteText');
    try {
      return super.setSearchLoteText(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarSetorMigrar(Setor setor) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarSetorMigrar');
    try {
      return super.selecionarSetorMigrar(setor);
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
  dynamic selecionarArea(Area area) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarArea');
    try {
      return super.selecionarArea(area);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAbrirProtocoloDetalhesAtv() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.toggleAbrirProtocoloDetalhesAtv');
    try {
      return super.toggleAbrirProtocoloDetalhesAtv();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarNovoLoteArea(Area area) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarNovoLoteArea');
    try {
      return super.selecionarNovoLoteArea(area);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarNovoLoteSetor(Setor setor) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarNovoLoteSetor');
    try {
      return super.selecionarNovoLoteSetor(setor);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic carregarAreaSetor() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.carregarAreaSetor');
    try {
      return super.carregarAreaSetor();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNovoLoteCultura(int index) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setNovoLoteCultura');
    try {
      return super.setNovoLoteCultura(index);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarNovoLoteReservatorio() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarNovoLoteReservatorio');
    try {
      return super.selecionarNovoLoteReservatorio();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarNovoLoteProtocolo() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarNovoLoteProtocolo');
    try {
      return super.selecionarNovoLoteProtocolo();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setRegistroData(DateTime dateTime) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setRegistroData');
    try {
      return super.setRegistroData(dateTime);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSemeaduraData(DateTime dateTime) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setSemeaduraData');
    try {
      return super.setSemeaduraData(dateTime);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTransplantioData(DateTime dateTime) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setTransplantioData');
    try {
      return super.setTransplantioData(dateTime);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setColheitaData(DateTime dateTime) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setColheitaData');
    try {
      return super.setColheitaData(dateTime);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsEditing(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsBandeijaEditing(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsBandeijaEditing');
    try {
      return super.setIsBandeijaEditing(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsMudasEditing(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsMudasEditing');
    try {
      return super.setIsMudasEditing(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsPlantasEditing(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsPlantasEditing');
    try {
      return super.setIsPlantasEditing(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsEmbalagensEditing(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsEmbalagensEditing');
    try {
      return super.setIsEmbalagensEditing(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic alterarNome(String name) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoteEditing(Lote lote) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setLoteEditing');
    try {
      return super.setLoteEditing(lote);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setShowReservatorioDetalhes(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setShowReservatorioDetalhes');
    try {
      return super.setShowReservatorioDetalhes(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setShowProtocoloDetalhes(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setShowProtocoloDetalhes');
    try {
      return super.setShowProtocoloDetalhes(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsNovaCultura(bool value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setIsNovaCultura');
    try {
      return super.setIsNovaCultura(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReservatorioDetalhes(Reservatorio reservatorio) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setReservatorioDetalhes');
    try {
      return super.setReservatorioDetalhes(reservatorio);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setProtocoloDetalhes(Protocolo protocolo) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setProtocoloDetalhes');
    try {
      return super.setProtocoloDetalhes(protocolo);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeProtocoloDetalhes() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.removeProtocoloDetalhes');
    try {
      return super.removeProtocoloDetalhes();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSearchProtocoloText(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setSearchProtocoloText');
    try {
      return super.setSearchProtocoloText(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setProtocolo(Protocolo protocolo) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setProtocolo');
    try {
      return super.setProtocolo(protocolo);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic desvincularProtocolo() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.desvincularProtocolo');
    try {
      return super.desvincularProtocolo();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic prepararListaDetalhesFase() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.prepararListaDetalhesFase');
    try {
      return super.prepararListaDetalhesFase();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic validarRegistro() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.validarRegistro');
    try {
      return super.validarRegistro();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic listaLotesParaFinalizar() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.listaLotesParaFinalizar');
    try {
      return super.listaLotesParaFinalizar();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSeachLotePage(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.setSeachLotePage');
    try {
      return super.setSeachLotePage(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarLoteParaFinalizar(int index) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarLoteParaFinalizar');
    try {
      return super.selecionarLoteParaFinalizar(index);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selecionarAtividadesParaFinalizar(int index) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.selecionarAtividadesParaFinalizar');
    try {
      return super.selecionarAtividadesParaFinalizar(index);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic preencherPlantasColhidas(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.preencherPlantasColhidas');
    try {
      return super.preencherPlantasColhidas(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic preencherEmbalagensProduzidas(String value) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.preencherEmbalagensProduzidas');
    try {
      return super.preencherEmbalagensProduzidas(value);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deletarAtividades(int index) {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.deletarAtividades');
    try {
      return super.deletarAtividades(index);
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic verificarMarcarTodos() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.verificarMarcarTodos');
    try {
      return super.verificarMarcarTodos();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool podemosFinalizarLotes() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.podemosFinalizarLotes');
    try {
      return super.podemosFinalizarLotes();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool lotesSelecionadosEstaVazio() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.lotesSelecionadosEstaVazio');
    try {
      return super.lotesSelecionadosEstaVazio();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic limparFinalizacao() {
    final _$actionInfo = _$_LoteStoreBaseActionController.startAction(
        name: '_LoteStoreBase.limparFinalizacao');
    try {
      return super.limparFinalizacao();
    } finally {
      _$_LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoteListLoading: ${isLoteListLoading},
isProtocoloListLoading: ${isProtocoloListLoading},
dropDownValue: ${dropDownValue},
searchLoteText: ${searchLoteText},
order: ${order},
setorSelecionado: ${setorSelecionado},
loteList: ${loteList},
protocoloList: ${protocoloList},
listaFaseDetalhes: ${listaFaseDetalhes},
data1: ${data1},
data2: ${data2},
areaList: ${areaList},
isAreaLoading: ${isAreaLoading},
isDetalhesLoteLoading: ${isDetalhesLoteLoading},
isMigrateLoteLoading: ${isMigrateLoteLoading},
loteSelecionado: ${loteSelecionado},
areaSelecionada: ${areaSelecionada},
setorSelecionadoMigrar: ${setorSelecionadoMigrar},
mostrarErroFormulario: ${mostrarErroFormulario},
showTextFormField: ${showTextFormField},
isEditing: ${isEditing},
isBandeijasEditing: ${isBandeijasEditing},
isMudasEditing: ${isMudasEditing},
isPlantasEditing: ${isPlantasEditing},
isEmbalagensEditing: ${isEmbalagensEditing},
isVisible: ${isVisible},
isNovaAreaLoading: ${isNovaAreaLoading},
isNovoLoteLoading: ${isNovoLoteLoading},
showReservatorioDetalhes: ${showReservatorioDetalhes},
showProtocoloDetalhes: ${showProtocoloDetalhes},
isNovaCultura: ${isNovaCultura},
dotIndicator: ${dotIndicator},
culturaList: ${culturaList},
novoLoteSetor: ${novoLoteSetor},
novoLoteArea: ${novoLoteArea},
novoLoteName: ${novoLoteName},
novaCulturaController: ${novaCulturaController},
bandeijasSemeadasController: ${bandeijasSemeadasController},
mudasTransplantadasController: ${mudasTransplantadasController},
plantasColhidasController: ${plantasColhidasController},
embalagensProduzidasController: ${embalagensProduzidasController},
novoLoteCultura: ${novoLoteCultura},
novoLoteReservatorio: ${novoLoteReservatorio},
registroData: ${registroData},
semeaduraData: ${semeaduraData},
transplantioData: ${transplantioData},
colheitaData: ${colheitaData},
novoLoteDescricao: ${novoLoteDescricao},
reservatorioList: ${reservatorioList},
reservatorioDetalhes: ${reservatorioDetalhes},
protocoloDetalhes: ${protocoloDetalhes},
protocoloVinculado: ${protocoloVinculado},
searchProtocoloText: ${searchProtocoloText},
solucaoNutritivaList: ${solucaoNutritivaList},
solucaoConcentradaList: ${solucaoConcentradaList},
novoLote: ${novoLote},
abrirProtocoloDetalhesAtv: ${abrirProtocoloDetalhesAtv},
isProtocoloValid: ${isProtocoloValid},
searchLotePage: ${searchLotePage},
plantasColhidas: ${plantasColhidas},
embalagensProduzidas: ${embalagensProduzidas},
finalizarLotes: ${finalizarLotes},
atividadesPendentes: ${atividadesPendentes},
atividadesDeletadas: ${atividadesDeletadas},
carregandoFinalizarLotes: ${carregandoFinalizarLotes},
lotesFinalizados: ${lotesFinalizados},
searchLote: ${searchLote},
searchProtocolo: ${searchProtocolo},
isAlreadySelected: ${isAlreadySelected},
getLotesGroup: ${getLotesGroup},
lotesParaFinalizar: ${lotesParaFinalizar},
marcarTodasAtividades: ${marcarTodasAtividades}
    ''';
  }
}
