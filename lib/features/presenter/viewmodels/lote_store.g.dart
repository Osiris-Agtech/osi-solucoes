// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoteStore on LoteStoreBase, Store {
  Computed<List<Lote>>? _$searchLoteComputed;

  @override
  List<Lote> get searchLote =>
      (_$searchLoteComputed ??= Computed<List<Lote>>(() => super.searchLote,
              name: 'LoteStoreBase.searchLote'))
          .value;
  Computed<bool>? _$validarMigracaoComputed;

  @override
  bool get validarMigracao =>
      (_$validarMigracaoComputed ??= Computed<bool>(() => super.validarMigracao,
              name: 'LoteStoreBase.validarMigracao'))
          .value;
  Computed<List<Protocolo>>? _$searchProtocoloComputed;

  @override
  List<Protocolo> get searchProtocolo => (_$searchProtocoloComputed ??=
          Computed<List<Protocolo>>(() => super.searchProtocolo,
              name: 'LoteStoreBase.searchProtocolo'))
      .value;
  Computed<bool>? _$isAlreadySelectedComputed;

  @override
  bool get isAlreadySelected => (_$isAlreadySelectedComputed ??= Computed<bool>(
          () => super.isAlreadySelected,
          name: 'LoteStoreBase.isAlreadySelected'))
      .value;
  Computed<List<LoteSelection>>? _$getLotesGroupComputed;

  @override
  List<LoteSelection> get getLotesGroup => (_$getLotesGroupComputed ??=
          Computed<List<LoteSelection>>(() => super.getLotesGroup,
              name: 'LoteStoreBase.getLotesGroup'))
      .value;
  Computed<List<LoteSelection>>? _$lotesParaFinalizarComputed;

  @override
  List<LoteSelection> get lotesParaFinalizar =>
      (_$lotesParaFinalizarComputed ??= Computed<List<LoteSelection>>(
              () => super.lotesParaFinalizar,
              name: 'LoteStoreBase.lotesParaFinalizar'))
          .value;
  Computed<bool>? _$marcarTodasAtividadesComputed;

  @override
  bool get marcarTodasAtividades => (_$marcarTodasAtividadesComputed ??=
          Computed<bool>(() => super.marcarTodasAtividades,
              name: 'LoteStoreBase.marcarTodasAtividades'))
      .value;

  late final _$isLoteListLoadingAtom =
      Atom(name: 'LoteStoreBase.isLoteListLoading', context: context);

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

  late final _$isProtocoloListLoadingAtom =
      Atom(name: 'LoteStoreBase.isProtocoloListLoading', context: context);

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

  late final _$dropDownValueAtom =
      Atom(name: 'LoteStoreBase.dropDownValue', context: context);

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

  late final _$searchLoteTextAtom =
      Atom(name: 'LoteStoreBase.searchLoteText', context: context);

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

  late final _$orderAtom = Atom(name: 'LoteStoreBase.order', context: context);

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

  late final _$setorSelecionadoAtom =
      Atom(name: 'LoteStoreBase.setorSelecionado', context: context);

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

  late final _$loteListAtom =
      Atom(name: 'LoteStoreBase.loteList', context: context);

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

  late final _$protocoloListAtom =
      Atom(name: 'LoteStoreBase.protocoloList', context: context);

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

  late final _$listaFaseDetalhesAtom =
      Atom(name: 'LoteStoreBase.listaFaseDetalhes', context: context);

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

  late final _$data1Atom = Atom(name: 'LoteStoreBase.data1', context: context);

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

  late final _$data2Atom = Atom(name: 'LoteStoreBase.data2', context: context);

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

  late final _$areaListAtom =
      Atom(name: 'LoteStoreBase.areaList', context: context);

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

  late final _$isAreaLoadingAtom =
      Atom(name: 'LoteStoreBase.isAreaLoading', context: context);

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

  late final _$isDetalhesLoteLoadingAtom =
      Atom(name: 'LoteStoreBase.isDetalhesLoteLoading', context: context);

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

  late final _$isMigrateLoteLoadingAtom =
      Atom(name: 'LoteStoreBase.isMigrateLoteLoading', context: context);

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

  late final _$isDeletingLoteCascadeAtom =
      Atom(name: 'LoteStoreBase.isDeletingLoteCascade', context: context);

  @override
  bool get isDeletingLoteCascade {
    _$isDeletingLoteCascadeAtom.reportRead();
    return super.isDeletingLoteCascade;
  }

  @override
  set isDeletingLoteCascade(bool value) {
    _$isDeletingLoteCascadeAtom.reportWrite(value, super.isDeletingLoteCascade,
        () {
      super.isDeletingLoteCascade = value;
    });
  }

  late final _$loteSelecionadoAtom =
      Atom(name: 'LoteStoreBase.loteSelecionado', context: context);

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

  late final _$areaSelecionadaAtom =
      Atom(name: 'LoteStoreBase.areaSelecionada', context: context);

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

  late final _$setorSelecionadoMigrarAtom =
      Atom(name: 'LoteStoreBase.setorSelecionadoMigrar', context: context);

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

  late final _$isLoadingLotePorIdAtom =
      Atom(name: 'LoteStoreBase.isLoadingLotePorId', context: context);

  @override
  bool get isLoadingLotePorId {
    _$isLoadingLotePorIdAtom.reportRead();
    return super.isLoadingLotePorId;
  }

  @override
  set isLoadingLotePorId(bool value) {
    _$isLoadingLotePorIdAtom.reportWrite(value, super.isLoadingLotePorId, () {
      super.isLoadingLotePorId = value;
    });
  }

  late final _$mostrarErroFormularioAtom =
      Atom(name: 'LoteStoreBase.mostrarErroFormulario', context: context);

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

  late final _$showTextFormFieldAtom =
      Atom(name: 'LoteStoreBase.showTextFormField', context: context);

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
      Atom(name: 'LoteStoreBase.isEditing', context: context);

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

  late final _$isBandeijasEditingAtom =
      Atom(name: 'LoteStoreBase.isBandeijasEditing', context: context);

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

  late final _$isMudasEditingAtom =
      Atom(name: 'LoteStoreBase.isMudasEditing', context: context);

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

  late final _$isPlantasEditingAtom =
      Atom(name: 'LoteStoreBase.isPlantasEditing', context: context);

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

  late final _$isEmbalagensEditingAtom =
      Atom(name: 'LoteStoreBase.isEmbalagensEditing', context: context);

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

  late final _$isVisibleAtom =
      Atom(name: 'LoteStoreBase.isVisible', context: context);

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

  late final _$isNovaAreaLoadingAtom =
      Atom(name: 'LoteStoreBase.isNovaAreaLoading', context: context);

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

  late final _$isNovoLoteLoadingAtom =
      Atom(name: 'LoteStoreBase.isNovoLoteLoading', context: context);

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

  late final _$showReservatorioDetalhesAtom =
      Atom(name: 'LoteStoreBase.showReservatorioDetalhes', context: context);

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

  late final _$showProtocoloDetalhesAtom =
      Atom(name: 'LoteStoreBase.showProtocoloDetalhes', context: context);

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

  late final _$isNovaCulturaAtom =
      Atom(name: 'LoteStoreBase.isNovaCultura', context: context);

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

  late final _$dotIndicatorAtom =
      Atom(name: 'LoteStoreBase.dotIndicator', context: context);

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

  late final _$culturaListAtom =
      Atom(name: 'LoteStoreBase.culturaList', context: context);

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

  late final _$novoLoteSetorAtom =
      Atom(name: 'LoteStoreBase.novoLoteSetor', context: context);

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

  late final _$novoLoteAreaAtom =
      Atom(name: 'LoteStoreBase.novoLoteArea', context: context);

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

  late final _$novoLoteNameAtom =
      Atom(name: 'LoteStoreBase.novoLoteName', context: context);

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

  late final _$novaCulturaControllerAtom =
      Atom(name: 'LoteStoreBase.novaCulturaController', context: context);

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

  late final _$bandeijasSemeadasControllerAtom =
      Atom(name: 'LoteStoreBase.bandeijasSemeadasController', context: context);

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

  late final _$mudasTransplantadasControllerAtom = Atom(
      name: 'LoteStoreBase.mudasTransplantadasController', context: context);

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

  late final _$plantasColhidasControllerAtom =
      Atom(name: 'LoteStoreBase.plantasColhidasController', context: context);

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

  late final _$embalagensProduzidasControllerAtom = Atom(
      name: 'LoteStoreBase.embalagensProduzidasController', context: context);

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

  late final _$novoLoteCulturaAtom =
      Atom(name: 'LoteStoreBase.novoLoteCultura', context: context);

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

  late final _$novoLoteReservatorioAtom =
      Atom(name: 'LoteStoreBase.novoLoteReservatorio', context: context);

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

  late final _$registroDataAtom =
      Atom(name: 'LoteStoreBase.registroData', context: context);

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

  late final _$semeaduraDataAtom =
      Atom(name: 'LoteStoreBase.semeaduraData', context: context);

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

  late final _$transplantioDataAtom =
      Atom(name: 'LoteStoreBase.transplantioData', context: context);

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

  late final _$colheitaDataAtom =
      Atom(name: 'LoteStoreBase.colheitaData', context: context);

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

  late final _$novoLoteDescricaoAtom =
      Atom(name: 'LoteStoreBase.novoLoteDescricao', context: context);

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

  late final _$reservatorioListAtom =
      Atom(name: 'LoteStoreBase.reservatorioList', context: context);

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

  late final _$reservatorioDetalhesAtom =
      Atom(name: 'LoteStoreBase.reservatorioDetalhes', context: context);

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

  late final _$protocoloDetalhesAtom =
      Atom(name: 'LoteStoreBase.protocoloDetalhes', context: context);

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

  late final _$protocoloVinculadoAtom =
      Atom(name: 'LoteStoreBase.protocoloVinculado', context: context);

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

  late final _$searchProtocoloTextAtom =
      Atom(name: 'LoteStoreBase.searchProtocoloText', context: context);

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

  late final _$solucaoNutritivaListAtom =
      Atom(name: 'LoteStoreBase.solucaoNutritivaList', context: context);

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

  late final _$solucaoConcentradaListAtom =
      Atom(name: 'LoteStoreBase.solucaoConcentradaList', context: context);

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

  late final _$novoLoteAtom =
      Atom(name: 'LoteStoreBase.novoLote', context: context);

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

  late final _$abrirProtocoloDetalhesAtvAtom =
      Atom(name: 'LoteStoreBase.abrirProtocoloDetalhesAtv', context: context);

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

  late final _$isProtocoloValidAtom =
      Atom(name: 'LoteStoreBase.isProtocoloValid', context: context);

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

  late final _$searchLotePageAtom =
      Atom(name: 'LoteStoreBase.searchLotePage', context: context);

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

  late final _$plantasColhidasAtom =
      Atom(name: 'LoteStoreBase.plantasColhidas', context: context);

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

  late final _$embalagensProduzidasAtom =
      Atom(name: 'LoteStoreBase.embalagensProduzidas', context: context);

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

  late final _$finalizarLotesAtom =
      Atom(name: 'LoteStoreBase.finalizarLotes', context: context);

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

  late final _$atividadesPendentesAtom =
      Atom(name: 'LoteStoreBase.atividadesPendentes', context: context);

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

  late final _$atividadesDeletadasAtom =
      Atom(name: 'LoteStoreBase.atividadesDeletadas', context: context);

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

  late final _$carregandoFinalizarLotesAtom =
      Atom(name: 'LoteStoreBase.carregandoFinalizarLotes', context: context);

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

  late final _$lotesFinalizadosAtom =
      Atom(name: 'LoteStoreBase.lotesFinalizados', context: context);

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

  late final _$buscarLotesAsyncAction =
      AsyncAction('LoteStoreBase.buscarLotes', context: context);

  @override
  Future<void> buscarLotes() {
    return _$buscarLotesAsyncAction.run(() => super.buscarLotes());
  }

  late final _$migrarLoteAsyncAction =
      AsyncAction('LoteStoreBase.migrarLote', context: context);

  @override
  Future<void> migrarLote(bool migrarReservatorio) {
    return _$migrarLoteAsyncAction
        .run(() => super.migrarLote(migrarReservatorio));
  }

  late final _$deletarLoteCascadeAsyncAction =
      AsyncAction('LoteStoreBase.deletarLoteCascade', context: context);

  @override
  Future<void> deletarLoteCascade(int loteId) {
    return _$deletarLoteCascadeAsyncAction
        .run(() => super.deletarLoteCascade(loteId));
  }

  late final _$buscarLotePorIdAsyncAction =
      AsyncAction('LoteStoreBase.buscarLotePorId', context: context);

  @override
  Future<bool> buscarLotePorId(int id) {
    return _$buscarLotePorIdAsyncAction.run(() => super.buscarLotePorId(id));
  }

  late final _$buscarDetalhesLoteAsyncAction =
      AsyncAction('LoteStoreBase.buscarDetalhesLote', context: context);

  @override
  Future<void> buscarDetalhesLote() {
    return _$buscarDetalhesLoteAsyncAction
        .run(() => super.buscarDetalhesLote());
  }

  late final _$buscarAreasListAsyncAction =
      AsyncAction('LoteStoreBase.buscarAreasList', context: context);

  @override
  Future<void> buscarAreasList() {
    return _$buscarAreasListAsyncAction.run(() => super.buscarAreasList());
  }

  late final _$buscarCulturasAsyncAction =
      AsyncAction('LoteStoreBase.buscarCulturas', context: context);

  @override
  Future<void> buscarCulturas() {
    return _$buscarCulturasAsyncAction.run(() => super.buscarCulturas());
  }

  late final _$buscarReservatoriosAsyncAction =
      AsyncAction('LoteStoreBase.buscarReservatorios', context: context);

  @override
  Future<void> buscarReservatorios() {
    return _$buscarReservatoriosAsyncAction
        .run(() => super.buscarReservatorios());
  }

  late final _$buscarReservatorioDetalhesAsyncAction =
      AsyncAction('LoteStoreBase.buscarReservatorioDetalhes', context: context);

  @override
  Future<void> buscarReservatorioDetalhes() {
    return _$buscarReservatorioDetalhesAsyncAction
        .run(() => super.buscarReservatorioDetalhes());
  }

  late final _$registrarLoteAsyncAction =
      AsyncAction('LoteStoreBase.registrarLote', context: context);

  @override
  Future<void> registrarLote() {
    return _$registrarLoteAsyncAction.run(() => super.registrarLote());
  }

  late final _$registrarCulturaAsyncAction =
      AsyncAction('LoteStoreBase.registrarCultura', context: context);

  @override
  Future<void> registrarCultura() {
    return _$registrarCulturaAsyncAction.run(() => super.registrarCultura());
  }

  late final _$alterarLoteAsyncAction =
      AsyncAction('LoteStoreBase.alterarLote', context: context);

  @override
  Future<void> alterarLote() {
    return _$alterarLoteAsyncAction.run(() => super.alterarLote());
  }

  late final _$alterarProducaoLoteAsyncAction =
      AsyncAction('LoteStoreBase.alterarProducaoLote', context: context);

  @override
  Future<void> alterarProducaoLote() {
    return _$alterarProducaoLoteAsyncAction
        .run(() => super.alterarProducaoLote());
  }

  late final _$alterarDatasLoteAsyncAction =
      AsyncAction('LoteStoreBase.alterarDatasLote', context: context);

  @override
  Future<void> alterarDatasLote() {
    return _$alterarDatasLoteAsyncAction.run(() => super.alterarDatasLote());
  }

  late final _$finalizarTodosLotesAsyncAction =
      AsyncAction('LoteStoreBase.finalizarTodosLotes', context: context);

  @override
  Future<void> finalizarTodosLotes() {
    return _$finalizarTodosLotesAsyncAction
        .run(() => super.finalizarTodosLotes());
  }

  late final _$deletarAtividadesSelecionadasAsyncAction = AsyncAction(
      'LoteStoreBase.deletarAtividadesSelecionadas',
      context: context);

  @override
  Future<void> deletarAtividadesSelecionadas() {
    return _$deletarAtividadesSelecionadasAsyncAction
        .run(() => super.deletarAtividadesSelecionadas());
  }

  late final _$finalizarAtividadesSelecionadasAsyncAction = AsyncAction(
      'LoteStoreBase.finalizarAtividadesSelecionadas',
      context: context);

  @override
  Future<void> finalizarAtividadesSelecionadas() {
    return _$finalizarAtividadesSelecionadasAsyncAction
        .run(() => super.finalizarAtividadesSelecionadas());
  }

  late final _$verificarAtividadesAsyncAction =
      AsyncAction('LoteStoreBase.verificarAtividades', context: context);

  @override
  Future<void> verificarAtividades() {
    return _$verificarAtividadesAsyncAction
        .run(() => super.verificarAtividades());
  }

  late final _$buscarLotesFinalizadosAsyncAction =
      AsyncAction('LoteStoreBase.buscarLotesFinalizados', context: context);

  @override
  Future<void> buscarLotesFinalizados() {
    return _$buscarLotesFinalizadosAsyncAction
        .run(() => super.buscarLotesFinalizados());
  }

  late final _$LoteStoreBaseActionController =
      ActionController(name: 'LoteStoreBase', context: context);

  @override
  DateTime setData1(DateTime value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setData1');
    try {
      return super.setData1(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setData2(DateTime value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setData2');
    try {
      return super.setData2(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String changeOrder() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.changeOrder');
    try {
      return super.changeOrder();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Setor setSetorSelecionado(Setor setor) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setSetorSelecionado');
    try {
      return super.setSetorSelecionado(setor);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setDropDown(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setDropDown');
    try {
      return super.setDropDown(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setSearchLoteText(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setSearchLoteText');
    try {
      return super.setSearchLoteText(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Setor selecionarSetorMigrar(Setor? setor) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarSetorMigrar');
    try {
      return super.selecionarSetorMigrar(setor);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Lote selecionarLote(Lote lote) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarLote');
    try {
      return super.selecionarLote(lote);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Area selecionarArea(Area area) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarArea');
    try {
      return super.selecionarArea(area);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAbrirProtocoloDetalhesAtv() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.toggleAbrirProtocoloDetalhesAtv');
    try {
      return super.toggleAbrirProtocoloDetalhesAtv();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Area selecionarNovoLoteArea(Area area) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarNovoLoteArea');
    try {
      return super.selecionarNovoLoteArea(area);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Setor selecionarNovoLoteSetor(Setor setor) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarNovoLoteSetor');
    try {
      return super.selecionarNovoLoteSetor(setor);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void carregarAreaSetor() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.carregarAreaSetor');
    try {
      return super.carregarAreaSetor();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Cultura setNovoLoteCultura(int index) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setNovoLoteCultura');
    try {
      return super.setNovoLoteCultura(index);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecionarNovoLoteReservatorio() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarNovoLoteReservatorio');
    try {
      return super.selecionarNovoLoteReservatorio();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecionarNovoLoteProtocolo() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarNovoLoteProtocolo');
    try {
      return super.selecionarNovoLoteProtocolo();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setRegistroData(DateTime dateTime) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setRegistroData');
    try {
      return super.setRegistroData(dateTime);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setSemeaduraData(DateTime dateTime) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setSemeaduraData');
    try {
      return super.setSemeaduraData(dateTime);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setTransplantioData(DateTime dateTime) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setTransplantioData');
    try {
      return super.setTransplantioData(dateTime);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setColheitaData(DateTime dateTime) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setColheitaData');
    try {
      return super.setColheitaData(dateTime);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsEditing(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsEditing');
    try {
      return super.setIsEditing(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsBandeijaEditing(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsBandeijaEditing');
    try {
      return super.setIsBandeijaEditing(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsMudasEditing(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsMudasEditing');
    try {
      return super.setIsMudasEditing(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsPlantasEditing(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsPlantasEditing');
    try {
      return super.setIsPlantasEditing(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsEmbalagensEditing(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsEmbalagensEditing');
    try {
      return super.setIsEmbalagensEditing(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarNome(String name) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoteEditing(Lote lote) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setLoteEditing');
    try {
      return super.setLoteEditing(lote);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setShowReservatorioDetalhes(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setShowReservatorioDetalhes');
    try {
      return super.setShowReservatorioDetalhes(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setShowProtocoloDetalhes(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setShowProtocoloDetalhes');
    try {
      return super.setShowProtocoloDetalhes(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setIsNovaCultura(bool value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setIsNovaCultura');
    try {
      return super.setIsNovaCultura(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReservatorioDetalhes(Reservatorio reservatorio) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setReservatorioDetalhes');
    try {
      return super.setReservatorioDetalhes(reservatorio);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProtocoloDetalhes(Protocolo protocolo) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setProtocoloDetalhes');
    try {
      return super.setProtocoloDetalhes(protocolo);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeProtocoloDetalhes() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.removeProtocoloDetalhes');
    try {
      return super.removeProtocoloDetalhes();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setSearchProtocoloText(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setSearchProtocoloText');
    try {
      return super.setSearchProtocoloText(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProtocolo(Protocolo protocolo) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setProtocolo');
    try {
      return super.setProtocolo(protocolo);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void desvincularProtocolo() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.desvincularProtocolo');
    try {
      return super.desvincularProtocolo();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepararListaDetalhesFase() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.prepararListaDetalhesFase');
    try {
      return super.prepararListaDetalhesFase();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validarRegistro() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.validarRegistro');
    try {
      return super.validarRegistro();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void listaLotesParaFinalizar() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.listaLotesParaFinalizar');
    try {
      return super.listaLotesParaFinalizar();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeachLotePage(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.setSeachLotePage');
    try {
      return super.setSeachLotePage(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecionarLoteParaFinalizar(int index) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarLoteParaFinalizar');
    try {
      return super.selecionarLoteParaFinalizar(index);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecionarAtividadesParaFinalizar(int index) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.selecionarAtividadesParaFinalizar');
    try {
      return super.selecionarAtividadesParaFinalizar(index);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void preencherPlantasColhidas(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.preencherPlantasColhidas');
    try {
      return super.preencherPlantasColhidas(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void preencherEmbalagensProduzidas(String value) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.preencherEmbalagensProduzidas');
    try {
      return super.preencherEmbalagensProduzidas(value);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deletarAtividades(int index) {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.deletarAtividades');
    try {
      return super.deletarAtividades(index);
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void verificarMarcarTodos() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.verificarMarcarTodos');
    try {
      return super.verificarMarcarTodos();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool podemosFinalizarLotes() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.podemosFinalizarLotes');
    try {
      return super.podemosFinalizarLotes();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool lotesSelecionadosEstaVazio() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.lotesSelecionadosEstaVazio');
    try {
      return super.lotesSelecionadosEstaVazio();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparFinalizacao() {
    final _$actionInfo = _$LoteStoreBaseActionController.startAction(
        name: 'LoteStoreBase.limparFinalizacao');
    try {
      return super.limparFinalizacao();
    } finally {
      _$LoteStoreBaseActionController.endAction(_$actionInfo);
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
isDeletingLoteCascade: ${isDeletingLoteCascade},
loteSelecionado: ${loteSelecionado},
areaSelecionada: ${areaSelecionada},
setorSelecionadoMigrar: ${setorSelecionadoMigrar},
isLoadingLotePorId: ${isLoadingLotePorId},
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
validarMigracao: ${validarMigracao},
searchProtocolo: ${searchProtocolo},
isAlreadySelected: ${isAlreadySelected},
getLotesGroup: ${getLotesGroup},
lotesParaFinalizar: ${lotesParaFinalizar},
marcarTodasAtividades: ${marcarTodasAtividades}
    ''';
  }
}
