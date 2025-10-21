// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocolo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProtocoloStore on ProtocoloStoreBase, Store {
  Computed<List<Protocolo>>? _$getProtocoloGroupComputed;

  @override
  List<Protocolo> get getProtocoloGroup => (_$getProtocoloGroupComputed ??=
          Computed<List<Protocolo>>(() => super.getProtocoloGroup,
              name: 'ProtocoloStoreBase.getProtocoloGroup'))
      .value;

  late final _$dotIndicatorAtom =
      Atom(name: 'ProtocoloStoreBase.dotIndicator', context: context);

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

  late final _$dotIndicatorEditAtom =
      Atom(name: 'ProtocoloStoreBase.dotIndicatorEdit', context: context);

  @override
  int get dotIndicatorEdit {
    _$dotIndicatorEditAtom.reportRead();
    return super.dotIndicatorEdit;
  }

  @override
  set dotIndicatorEdit(int value) {
    _$dotIndicatorEditAtom.reportWrite(value, super.dotIndicatorEdit, () {
      super.dotIndicatorEdit = value;
    });
  }

  late final _$radioIndicatorAtom =
      Atom(name: 'ProtocoloStoreBase.radioIndicator', context: context);

  @override
  int get radioIndicator {
    _$radioIndicatorAtom.reportRead();
    return super.radioIndicator;
  }

  @override
  set radioIndicator(int value) {
    _$radioIndicatorAtom.reportWrite(value, super.radioIndicator, () {
      super.radioIndicator = value;
    });
  }

  late final _$isValidAtom =
      Atom(name: 'ProtocoloStoreBase.isValid', context: context);

  @override
  bool get isValid {
    _$isValidAtom.reportRead();
    return super.isValid;
  }

  @override
  set isValid(bool value) {
    _$isValidAtom.reportWrite(value, super.isValid, () {
      super.isValid = value;
    });
  }

  late final _$isNovaFaseBottonSheetAtom =
      Atom(name: 'ProtocoloStoreBase.isNovaFaseBottonSheet', context: context);

  @override
  bool get isNovaFaseBottonSheet {
    _$isNovaFaseBottonSheetAtom.reportRead();
    return super.isNovaFaseBottonSheet;
  }

  @override
  set isNovaFaseBottonSheet(bool value) {
    _$isNovaFaseBottonSheetAtom.reportWrite(value, super.isNovaFaseBottonSheet,
        () {
      super.isNovaFaseBottonSheet = value;
    });
  }

  late final _$isProtocoloListLoadingAtom =
      Atom(name: 'ProtocoloStoreBase.isProtocoloListLoading', context: context);

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

  late final _$isEditingAtom =
      Atom(name: 'ProtocoloStoreBase.isEditing', context: context);

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

  late final _$diaDaAtivAtom =
      Atom(name: 'ProtocoloStoreBase.diaDaAtiv', context: context);

  @override
  int? get diaDaAtiv {
    _$diaDaAtivAtom.reportRead();
    return super.diaDaAtiv;
  }

  @override
  set diaDaAtiv(int? value) {
    _$diaDaAtivAtom.reportWrite(value, super.diaDaAtiv, () {
      super.diaDaAtiv = value;
    });
  }

  late final _$mostrarErroFormularioAtom =
      Atom(name: 'ProtocoloStoreBase.mostrarErroFormulario', context: context);

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

  late final _$isNovaCulturaAtom =
      Atom(name: 'ProtocoloStoreBase.isNovaCultura', context: context);

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

  late final _$novoTipoProtocoloAtom =
      Atom(name: 'ProtocoloStoreBase.novoTipoProtocolo', context: context);

  @override
  String? get novoTipoProtocolo {
    _$novoTipoProtocoloAtom.reportRead();
    return super.novoTipoProtocolo;
  }

  @override
  set novoTipoProtocolo(String? value) {
    _$novoTipoProtocoloAtom.reportWrite(value, super.novoTipoProtocolo, () {
      super.novoTipoProtocolo = value;
    });
  }

  late final _$novoSistemaProtocoloAtom =
      Atom(name: 'ProtocoloStoreBase.novoSistemaProtocolo', context: context);

  @override
  String? get novoSistemaProtocolo {
    _$novoSistemaProtocoloAtom.reportRead();
    return super.novoSistemaProtocolo;
  }

  @override
  set novoSistemaProtocolo(String? value) {
    _$novoSistemaProtocoloAtom.reportWrite(value, super.novoSistemaProtocolo,
        () {
      super.novoSistemaProtocolo = value;
    });
  }

  late final _$novoFormaProtocoloAtom =
      Atom(name: 'ProtocoloStoreBase.novoFormaProtocolo', context: context);

  @override
  String? get novoFormaProtocolo {
    _$novoFormaProtocoloAtom.reportRead();
    return super.novoFormaProtocolo;
  }

  @override
  set novoFormaProtocolo(String? value) {
    _$novoFormaProtocoloAtom.reportWrite(value, super.novoFormaProtocolo, () {
      super.novoFormaProtocolo = value;
    });
  }

  late final _$novoTituloFaseAtom =
      Atom(name: 'ProtocoloStoreBase.novoTituloFase', context: context);

  @override
  String? get novoTituloFase {
    _$novoTituloFaseAtom.reportRead();
    return super.novoTituloFase;
  }

  @override
  set novoTituloFase(String? value) {
    _$novoTituloFaseAtom.reportWrite(value, super.novoTituloFase, () {
      super.novoTituloFase = value;
    });
  }

  late final _$novoTituloAtividadeAtom =
      Atom(name: 'ProtocoloStoreBase.novoTituloAtividade', context: context);

  @override
  String? get novoTituloAtividade {
    _$novoTituloAtividadeAtom.reportRead();
    return super.novoTituloAtividade;
  }

  @override
  set novoTituloAtividade(String? value) {
    _$novoTituloAtividadeAtom.reportWrite(value, super.novoTituloAtividade, () {
      super.novoTituloAtividade = value;
    });
  }

  late final _$novoDescricaoAtividadeAtom =
      Atom(name: 'ProtocoloStoreBase.novoDescricaoAtividade', context: context);

  @override
  String? get novoDescricaoAtividade {
    _$novoDescricaoAtividadeAtom.reportRead();
    return super.novoDescricaoAtividade;
  }

  @override
  set novoDescricaoAtividade(String? value) {
    _$novoDescricaoAtividadeAtom
        .reportWrite(value, super.novoDescricaoAtividade, () {
      super.novoDescricaoAtividade = value;
    });
  }

  late final _$novoDuracaoDiasFaseAtom =
      Atom(name: 'ProtocoloStoreBase.novoDuracaoDiasFase', context: context);

  @override
  int? get novoDuracaoDiasFase {
    _$novoDuracaoDiasFaseAtom.reportRead();
    return super.novoDuracaoDiasFase;
  }

  @override
  set novoDuracaoDiasFase(int? value) {
    _$novoDuracaoDiasFaseAtom.reportWrite(value, super.novoDuracaoDiasFase, () {
      super.novoDuracaoDiasFase = value;
    });
  }

  late final _$selectedFaseAtom =
      Atom(name: 'ProtocoloStoreBase.selectedFase', context: context);

  @override
  Fase? get selectedFase {
    _$selectedFaseAtom.reportRead();
    return super.selectedFase;
  }

  @override
  set selectedFase(Fase? value) {
    _$selectedFaseAtom.reportWrite(value, super.selectedFase, () {
      super.selectedFase = value;
    });
  }

  late final _$protocoloSelecionadoAtom =
      Atom(name: 'ProtocoloStoreBase.protocoloSelecionado', context: context);

  @override
  Protocolo? get protocoloSelecionado {
    _$protocoloSelecionadoAtom.reportRead();
    return super.protocoloSelecionado;
  }

  @override
  set protocoloSelecionado(Protocolo? value) {
    _$protocoloSelecionadoAtom.reportWrite(value, super.protocoloSelecionado,
        () {
      super.protocoloSelecionado = value;
    });
  }

  late final _$novaCulturaControllerAtom =
      Atom(name: 'ProtocoloStoreBase.novaCulturaController', context: context);

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

  late final _$diaDaAtivControllerAtom =
      Atom(name: 'ProtocoloStoreBase.diaDaAtivController', context: context);

  @override
  TextEditingController get diaDaAtivController {
    _$diaDaAtivControllerAtom.reportRead();
    return super.diaDaAtivController;
  }

  @override
  set diaDaAtivController(TextEditingController value) {
    _$diaDaAtivControllerAtom.reportWrite(value, super.diaDaAtivController, () {
      super.diaDaAtivController = value;
    });
  }

  late final _$dropdownTitleAtom =
      Atom(name: 'ProtocoloStoreBase.dropdownTitle', context: context);

  @override
  TextEditingController get dropdownTitle {
    _$dropdownTitleAtom.reportRead();
    return super.dropdownTitle;
  }

  @override
  set dropdownTitle(TextEditingController value) {
    _$dropdownTitleAtom.reportWrite(value, super.dropdownTitle, () {
      super.dropdownTitle = value;
    });
  }

  late final _$novoNomeProtocoloAtom =
      Atom(name: 'ProtocoloStoreBase.novoNomeProtocolo', context: context);

  @override
  String? get novoNomeProtocolo {
    _$novoNomeProtocoloAtom.reportRead();
    return super.novoNomeProtocolo;
  }

  @override
  set novoNomeProtocolo(String? value) {
    _$novoNomeProtocoloAtom.reportWrite(value, super.novoNomeProtocolo, () {
      super.novoNomeProtocolo = value;
    });
  }

  late final _$culturaListAtom =
      Atom(name: 'ProtocoloStoreBase.culturaList', context: context);

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

  late final _$novaCulturaProtocoloAtom =
      Atom(name: 'ProtocoloStoreBase.novaCulturaProtocolo', context: context);

  @override
  Cultura? get novaCulturaProtocolo {
    _$novaCulturaProtocoloAtom.reportRead();
    return super.novaCulturaProtocolo;
  }

  @override
  set novaCulturaProtocolo(Cultura? value) {
    _$novaCulturaProtocoloAtom.reportWrite(value, super.novaCulturaProtocolo,
        () {
      super.novaCulturaProtocolo = value;
    });
  }

  late final _$novasAtividadesProtocoloAtom = Atom(
      name: 'ProtocoloStoreBase.novasAtividadesProtocolo', context: context);

  @override
  List<Acao> get novasAtividadesProtocolo {
    _$novasAtividadesProtocoloAtom.reportRead();
    return super.novasAtividadesProtocolo;
  }

  @override
  set novasAtividadesProtocolo(List<Acao> value) {
    _$novasAtividadesProtocoloAtom
        .reportWrite(value, super.novasAtividadesProtocolo, () {
      super.novasAtividadesProtocolo = value;
    });
  }

  late final _$protocoloListAtom =
      Atom(name: 'ProtocoloStoreBase.protocoloList', context: context);

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

  late final _$faseDropDownListAtom =
      Atom(name: 'ProtocoloStoreBase.faseDropDownList', context: context);

  @override
  List<Fase> get faseDropDownList {
    _$faseDropDownListAtom.reportRead();
    return super.faseDropDownList;
  }

  @override
  set faseDropDownList(List<Fase> value) {
    _$faseDropDownListAtom.reportWrite(value, super.faseDropDownList, () {
      super.faseDropDownList = value;
    });
  }

  late final _$faseListAtom =
      Atom(name: 'ProtocoloStoreBase.faseList', context: context);

  @override
  List<Fase> get faseList {
    _$faseListAtom.reportRead();
    return super.faseList;
  }

  @override
  set faseList(List<Fase> value) {
    _$faseListAtom.reportWrite(value, super.faseList, () {
      super.faseList = value;
    });
  }

  late final _$listaFaseDetalhesAtom =
      Atom(name: 'ProtocoloStoreBase.listaFaseDetalhes', context: context);

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

  late final _$searchProtocoloPageAtom =
      Atom(name: 'ProtocoloStoreBase.searchProtocoloPage', context: context);

  @override
  TextEditingController get searchProtocoloPage {
    _$searchProtocoloPageAtom.reportRead();
    return super.searchProtocoloPage;
  }

  @override
  set searchProtocoloPage(TextEditingController value) {
    _$searchProtocoloPageAtom.reportWrite(value, super.searchProtocoloPage, () {
      super.searchProtocoloPage = value;
    });
  }

  late final _$novasAtividadesDetalhesProtocoloAtom = Atom(
      name: 'ProtocoloStoreBase.novasAtividadesDetalhesProtocolo',
      context: context);

  @override
  List<Acao> get novasAtividadesDetalhesProtocolo {
    _$novasAtividadesDetalhesProtocoloAtom.reportRead();
    return super.novasAtividadesDetalhesProtocolo;
  }

  @override
  set novasAtividadesDetalhesProtocolo(List<Acao> value) {
    _$novasAtividadesDetalhesProtocoloAtom
        .reportWrite(value, super.novasAtividadesDetalhesProtocolo, () {
      super.novasAtividadesDetalhesProtocolo = value;
    });
  }

  late final _$novoTituloDetalhesAtividadeAtom = Atom(
      name: 'ProtocoloStoreBase.novoTituloDetalhesAtividade', context: context);

  @override
  TextEditingController get novoTituloDetalhesAtividade {
    _$novoTituloDetalhesAtividadeAtom.reportRead();
    return super.novoTituloDetalhesAtividade;
  }

  @override
  set novoTituloDetalhesAtividade(TextEditingController value) {
    _$novoTituloDetalhesAtividadeAtom
        .reportWrite(value, super.novoTituloDetalhesAtividade, () {
      super.novoTituloDetalhesAtividade = value;
    });
  }

  late final _$novoDescricaoDetalhesAtividadeAtom = Atom(
      name: 'ProtocoloStoreBase.novoDescricaoDetalhesAtividade',
      context: context);

  @override
  TextEditingController get novoDescricaoDetalhesAtividade {
    _$novoDescricaoDetalhesAtividadeAtom.reportRead();
    return super.novoDescricaoDetalhesAtividade;
  }

  @override
  set novoDescricaoDetalhesAtividade(TextEditingController value) {
    _$novoDescricaoDetalhesAtividadeAtom
        .reportWrite(value, super.novoDescricaoDetalhesAtividade, () {
      super.novoDescricaoDetalhesAtividade = value;
    });
  }

  late final _$selectedDetalhesFaseAtom =
      Atom(name: 'ProtocoloStoreBase.selectedDetalhesFase', context: context);

  @override
  Fase? get selectedDetalhesFase {
    _$selectedDetalhesFaseAtom.reportRead();
    return super.selectedDetalhesFase;
  }

  @override
  set selectedDetalhesFase(Fase? value) {
    _$selectedDetalhesFaseAtom.reportWrite(value, super.selectedDetalhesFase,
        () {
      super.selectedDetalhesFase = value;
    });
  }

  late final _$loteFoiAlteradoAtom =
      Atom(name: 'ProtocoloStoreBase.loteFoiAlterado', context: context);

  @override
  bool get loteFoiAlterado {
    _$loteFoiAlteradoAtom.reportRead();
    return super.loteFoiAlterado;
  }

  @override
  set loteFoiAlterado(bool value) {
    _$loteFoiAlteradoAtom.reportWrite(value, super.loteFoiAlterado, () {
      super.loteFoiAlterado = value;
    });
  }

  late final _$diaDetalhesAtivControllerAtom = Atom(
      name: 'ProtocoloStoreBase.diaDetalhesAtivController', context: context);

  @override
  TextEditingController get diaDetalhesAtivController {
    _$diaDetalhesAtivControllerAtom.reportRead();
    return super.diaDetalhesAtivController;
  }

  @override
  set diaDetalhesAtivController(TextEditingController value) {
    _$diaDetalhesAtivControllerAtom
        .reportWrite(value, super.diaDetalhesAtivController, () {
      super.diaDetalhesAtivController = value;
    });
  }

  late final _$novoTituloFaseDetalhesAtom =
      Atom(name: 'ProtocoloStoreBase.novoTituloFaseDetalhes', context: context);

  @override
  String? get novoTituloFaseDetalhes {
    _$novoTituloFaseDetalhesAtom.reportRead();
    return super.novoTituloFaseDetalhes;
  }

  @override
  set novoTituloFaseDetalhes(String? value) {
    _$novoTituloFaseDetalhesAtom
        .reportWrite(value, super.novoTituloFaseDetalhes, () {
      super.novoTituloFaseDetalhes = value;
    });
  }

  late final _$novoDuracaoDiasFaseDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novoDuracaoDiasFaseDetalhes', context: context);

  @override
  int? get novoDuracaoDiasFaseDetalhes {
    _$novoDuracaoDiasFaseDetalhesAtom.reportRead();
    return super.novoDuracaoDiasFaseDetalhes;
  }

  @override
  set novoDuracaoDiasFaseDetalhes(int? value) {
    _$novoDuracaoDiasFaseDetalhesAtom
        .reportWrite(value, super.novoDuracaoDiasFaseDetalhes, () {
      super.novoDuracaoDiasFaseDetalhes = value;
    });
  }

  late final _$diaDaAtivDetalhesAtom =
      Atom(name: 'ProtocoloStoreBase.diaDaAtivDetalhes', context: context);

  @override
  int? get diaDaAtivDetalhes {
    _$diaDaAtivDetalhesAtom.reportRead();
    return super.diaDaAtivDetalhes;
  }

  @override
  set diaDaAtivDetalhes(int? value) {
    _$diaDaAtivDetalhesAtom.reportWrite(value, super.diaDaAtivDetalhes, () {
      super.diaDaAtivDetalhes = value;
    });
  }

  late final _$faseDropDownListDetelhesAtom = Atom(
      name: 'ProtocoloStoreBase.faseDropDownListDetelhes', context: context);

  @override
  List<Fase> get faseDropDownListDetelhes {
    _$faseDropDownListDetelhesAtom.reportRead();
    return super.faseDropDownListDetelhes;
  }

  @override
  set faseDropDownListDetelhes(List<Fase> value) {
    _$faseDropDownListDetelhesAtom
        .reportWrite(value, super.faseDropDownListDetelhes, () {
      super.faseDropDownListDetelhes = value;
    });
  }

  late final _$novoNomeProtocoloDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novoNomeProtocoloDetalhes', context: context);

  @override
  String? get novoNomeProtocoloDetalhes {
    _$novoNomeProtocoloDetalhesAtom.reportRead();
    return super.novoNomeProtocoloDetalhes;
  }

  @override
  set novoNomeProtocoloDetalhes(String? value) {
    _$novoNomeProtocoloDetalhesAtom
        .reportWrite(value, super.novoNomeProtocoloDetalhes, () {
      super.novoNomeProtocoloDetalhes = value;
    });
  }

  late final _$novoFormaProtocoloDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novoFormaProtocoloDetalhes', context: context);

  @override
  String? get novoFormaProtocoloDetalhes {
    _$novoFormaProtocoloDetalhesAtom.reportRead();
    return super.novoFormaProtocoloDetalhes;
  }

  @override
  set novoFormaProtocoloDetalhes(String? value) {
    _$novoFormaProtocoloDetalhesAtom
        .reportWrite(value, super.novoFormaProtocoloDetalhes, () {
      super.novoFormaProtocoloDetalhes = value;
    });
  }

  late final _$novoTipoProtocoloDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novoTipoProtocoloDetalhes', context: context);

  @override
  String? get novoTipoProtocoloDetalhes {
    _$novoTipoProtocoloDetalhesAtom.reportRead();
    return super.novoTipoProtocoloDetalhes;
  }

  @override
  set novoTipoProtocoloDetalhes(String? value) {
    _$novoTipoProtocoloDetalhesAtom
        .reportWrite(value, super.novoTipoProtocoloDetalhes, () {
      super.novoTipoProtocoloDetalhes = value;
    });
  }

  late final _$novoSistemaProtocoloDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novoSistemaProtocoloDetalhes',
      context: context);

  @override
  String? get novoSistemaProtocoloDetalhes {
    _$novoSistemaProtocoloDetalhesAtom.reportRead();
    return super.novoSistemaProtocoloDetalhes;
  }

  @override
  set novoSistemaProtocoloDetalhes(String? value) {
    _$novoSistemaProtocoloDetalhesAtom
        .reportWrite(value, super.novoSistemaProtocoloDetalhes, () {
      super.novoSistemaProtocoloDetalhes = value;
    });
  }

  late final _$novaCulturaProtocoloDetalhesAtom = Atom(
      name: 'ProtocoloStoreBase.novaCulturaProtocoloDetalhes',
      context: context);

  @override
  Cultura? get novaCulturaProtocoloDetalhes {
    _$novaCulturaProtocoloDetalhesAtom.reportRead();
    return super.novaCulturaProtocoloDetalhes;
  }

  @override
  set novaCulturaProtocoloDetalhes(Cultura? value) {
    _$novaCulturaProtocoloDetalhesAtom
        .reportWrite(value, super.novaCulturaProtocoloDetalhes, () {
      super.novaCulturaProtocoloDetalhes = value;
    });
  }

  late final _$buscarProtocolosAsyncAction =
      AsyncAction('ProtocoloStoreBase.buscarProtocolos', context: context);

  @override
  Future<void> buscarProtocolos() {
    return _$buscarProtocolosAsyncAction.run(() => super.buscarProtocolos());
  }

  late final _$buscarFasesAsyncAction =
      AsyncAction('ProtocoloStoreBase.buscarFases', context: context);

  @override
  Future<void> buscarFases() {
    return _$buscarFasesAsyncAction.run(() => super.buscarFases());
  }

  late final _$registrarFaseAsyncAction =
      AsyncAction('ProtocoloStoreBase.registrarFase', context: context);

  @override
  Future<void> registrarFase() {
    return _$registrarFaseAsyncAction.run(() => super.registrarFase());
  }

  late final _$registrarCulturaAsyncAction =
      AsyncAction('ProtocoloStoreBase.registrarCultura', context: context);

  @override
  Future<void> registrarCultura() {
    return _$registrarCulturaAsyncAction.run(() => super.registrarCultura());
  }

  late final _$registrarProtocoloAsyncAction =
      AsyncAction('ProtocoloStoreBase.registrarProtocolo', context: context);

  @override
  Future<void> registrarProtocolo() {
    return _$registrarProtocoloAsyncAction
        .run(() => super.registrarProtocolo());
  }

  late final _$buscarCulturasAsyncAction =
      AsyncAction('ProtocoloStoreBase.buscarCulturas', context: context);

  @override
  Future<void> buscarCulturas() {
    return _$buscarCulturasAsyncAction.run(() => super.buscarCulturas());
  }

  late final _$registrarFaseDetalhesAsyncAction =
      AsyncAction('ProtocoloStoreBase.registrarFaseDetalhes', context: context);

  @override
  Future<void> registrarFaseDetalhes() {
    return _$registrarFaseDetalhesAsyncAction
        .run(() => super.registrarFaseDetalhes());
  }

  late final _$buscarFasesDetalhesAsyncAction =
      AsyncAction('ProtocoloStoreBase.buscarFasesDetalhes', context: context);

  @override
  Future<void> buscarFasesDetalhes() {
    return _$buscarFasesDetalhesAsyncAction
        .run(() => super.buscarFasesDetalhes());
  }

  late final _$atualizarProtocoloAsyncAction =
      AsyncAction('ProtocoloStoreBase.atualizarProtocolo', context: context);

  @override
  Future<void> atualizarProtocolo() {
    return _$atualizarProtocoloAsyncAction
        .run(() => super.atualizarProtocolo());
  }

  late final _$ProtocoloStoreBaseActionController =
      ActionController(name: 'ProtocoloStoreBase', context: context);

  @override
  bool setIsNovaCultura(bool value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setIsNovaCultura');
    try {
      return super.setIsNovaCultura(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int setDiaDaAtiv(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setDiaDaAtiv');
    try {
      return super.setDiaDaAtiv(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarForma(String forma) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarForma');
    try {
      return super.alterarForma(forma);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarSistema(String sistema) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarSistema');
    try {
      return super.alterarSistema(sistema);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarTipo(String tipo) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarTipo');
    try {
      return super.alterarTipo(tipo);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarNome(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarNome');
    try {
      return super.alterarNome(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarTituloFase(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarTituloFase');
    try {
      return super.alterarTituloFase(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarTituloAtividade(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarTituloAtividade');
    try {
      return super.alterarTituloAtividade(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarDescricaoAtividade(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDescricaoAtividade');
    try {
      return super.alterarDescricaoAtividade(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarDropdownFase(Fase newFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDropdownFase');
    try {
      return super.alterarDropdownFase(newFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarProtocoloSelecionado(Protocolo novoProtocolo) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarProtocoloSelecionado');
    try {
      return super.alterarProtocoloSelecionado(novoProtocolo);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarRadioIndicator(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarRadioIndicator');
    try {
      return super.alterarRadioIndicator(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarDuracaoDiasFase(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDuracaoDiasFase');
    try {
      return super.alterarDuracaoDiasFase(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setarDuracaoDiasFase(String value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setarDuracaoDiasFase');
    try {
      return super.setarDuracaoDiasFase(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarIsNovaFaseBottonSheet(bool value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarIsNovaFaseBottonSheet');
    try {
      return super.alterarIsNovaFaseBottonSheet(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicator(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDotIndicatorEdit(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setDotIndicatorEdit');
    try {
      return super.setDotIndicatorEdit(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeachProtocoloPage(String value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setSeachProtocoloPage');
    try {
      return super.setSeachProtocoloPage(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void mudarSelecaoCultura(Cultura item) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.mudarSelecaoCultura');
    try {
      return super.mudarSelecaoCultura(item);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void atualizarNovasAtividades() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.atualizarNovasAtividades');
    try {
      return super.atualizarNovasAtividades();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int calcularDuracaoDiasReal() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.calcularDuracaoDiasReal');
    try {
      return super.calcularDuracaoDiasReal();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToFaseList() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.addToFaseList');
    try {
      return super.addToFaseList();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarAlertaAcao(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarAlertaAcao');
    try {
      return super.alterarAlertaAcao(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepararListaDetalhesFase() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.prepararListaDetalhesFase');
    try {
      return super.prepararListaDetalhesFase();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepararEditAtiv(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.prepararEditAtiv');
    try {
      return super.prepararEditAtiv(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarAcao(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarAcao');
    try {
      return super.editarAcao(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAcao(int indexAcao, int indexFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.removeAcao');
    try {
      return super.removeAcao(indexAcao, indexFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFase(int indexFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.removeFase');
    try {
      return super.removeFase(indexFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarNovoProtocolo() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.validarNovoProtocolo');
    try {
      return super.validarNovoProtocolo();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarNovaFase() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.validarNovaFase');
    try {
      return super.validarNovaFase();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarAtividade() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.validarAtividade');
    try {
      return super.validarAtividade();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparTudo() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparTudo');
    try {
      return super.limparTudo();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparFaseBottomSheet() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparFaseBottomSheet');
    try {
      return super.limparFaseBottomSheet();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparAtividadeBottomSheet() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparAtividadeBottomSheet');
    try {
      return super.limparAtividadeBottomSheet();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarLoteFoiAlterado(bool value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarLoteFoiAlterado');
    try {
      return super.alterarLoteFoiAlterado(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarNome(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarNome');
    try {
      return super.editarNome(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarTipo(String tipo) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarTipo');
    try {
      return super.editarTipo(tipo);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarSistema(String sistema) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarSistema');
    try {
      return super.editarSistema(sistema);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarForma(String forma) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarForma');
    try {
      return super.editarForma(forma);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int alterarDiaDaAtiv(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDiaDaAtiv');
    try {
      return super.alterarDiaDaAtiv(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setarDuracaoDiasFaseDetalhes(String value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.setarDuracaoDiasFaseDetalhes');
    try {
      return super.setarDuracaoDiasFaseDetalhes(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarAlertaAcaoDetalhes(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarAlertaAcaoDetalhes');
    try {
      return super.alterarAlertaAcaoDetalhes(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAcaoDetalhes(int indexAcao, int indexFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.removeAcaoDetalhes');
    try {
      return super.removeAcaoDetalhes(indexAcao, indexFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFaseDetalhes(int indexFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.removeFaseDetalhes');
    try {
      return super.removeFaseDetalhes(indexFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void atualizarNovasAtividadesDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.atualizarNovasAtividadesDetalhes');
    try {
      return super.atualizarNovasAtividadesDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarDuracaoDiasFaseDetalhes(int value) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDuracaoDiasFaseDetalhes');
    try {
      return super.alterarDuracaoDiasFaseDetalhes(value);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarTituloFaseDetalhes(String name) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarTituloFaseDetalhes');
    try {
      return super.alterarTituloFaseDetalhes(name);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarDropdownFaseDetalhes(Fase newFase) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.alterarDropdownFaseDetalhes');
    try {
      return super.alterarDropdownFaseDetalhes(newFase);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void prepararEditDetalhesAtiv(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.prepararEditDetalhesAtiv');
    try {
      return super.prepararEditDetalhesAtiv(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int calcularDuracaoDiasRealDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.calcularDuracaoDiasRealDetalhes');
    try {
      return super.calcularDuracaoDiasRealDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToFaseListDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.addToFaseListDetalhes');
    try {
      return super.addToFaseListDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editarAcaoDetalhes(int indexFase, int indexAcao) {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.editarAcaoDetalhes');
    try {
      return super.editarAcaoDetalhes(indexFase, indexAcao);
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarAtividadeDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.validarAtividadeDetalhes');
    try {
      return super.validarAtividadeDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparFaseDetalhesBottomSheet() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparFaseDetalhesBottomSheet');
    try {
      return super.limparFaseDetalhesBottomSheet();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparProtocoloDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparProtocoloDetalhes');
    try {
      return super.limparProtocoloDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparAtividadeBottomSheetDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.limparAtividadeBottomSheetDetalhes');
    try {
      return super.limparAtividadeBottomSheetDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validarNovaFaseDetalhes() {
    final _$actionInfo = _$ProtocoloStoreBaseActionController.startAction(
        name: 'ProtocoloStoreBase.validarNovaFaseDetalhes');
    try {
      return super.validarNovaFaseDetalhes();
    } finally {
      _$ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dotIndicator: ${dotIndicator},
dotIndicatorEdit: ${dotIndicatorEdit},
radioIndicator: ${radioIndicator},
isValid: ${isValid},
isNovaFaseBottonSheet: ${isNovaFaseBottonSheet},
isProtocoloListLoading: ${isProtocoloListLoading},
isEditing: ${isEditing},
diaDaAtiv: ${diaDaAtiv},
mostrarErroFormulario: ${mostrarErroFormulario},
isNovaCultura: ${isNovaCultura},
novoTipoProtocolo: ${novoTipoProtocolo},
novoSistemaProtocolo: ${novoSistemaProtocolo},
novoFormaProtocolo: ${novoFormaProtocolo},
novoTituloFase: ${novoTituloFase},
novoTituloAtividade: ${novoTituloAtividade},
novoDescricaoAtividade: ${novoDescricaoAtividade},
novoDuracaoDiasFase: ${novoDuracaoDiasFase},
selectedFase: ${selectedFase},
protocoloSelecionado: ${protocoloSelecionado},
novaCulturaController: ${novaCulturaController},
diaDaAtivController: ${diaDaAtivController},
dropdownTitle: ${dropdownTitle},
novoNomeProtocolo: ${novoNomeProtocolo},
culturaList: ${culturaList},
novaCulturaProtocolo: ${novaCulturaProtocolo},
novasAtividadesProtocolo: ${novasAtividadesProtocolo},
protocoloList: ${protocoloList},
faseDropDownList: ${faseDropDownList},
faseList: ${faseList},
listaFaseDetalhes: ${listaFaseDetalhes},
searchProtocoloPage: ${searchProtocoloPage},
novasAtividadesDetalhesProtocolo: ${novasAtividadesDetalhesProtocolo},
novoTituloDetalhesAtividade: ${novoTituloDetalhesAtividade},
novoDescricaoDetalhesAtividade: ${novoDescricaoDetalhesAtividade},
selectedDetalhesFase: ${selectedDetalhesFase},
loteFoiAlterado: ${loteFoiAlterado},
diaDetalhesAtivController: ${diaDetalhesAtivController},
novoTituloFaseDetalhes: ${novoTituloFaseDetalhes},
novoDuracaoDiasFaseDetalhes: ${novoDuracaoDiasFaseDetalhes},
diaDaAtivDetalhes: ${diaDaAtivDetalhes},
faseDropDownListDetelhes: ${faseDropDownListDetelhes},
novoNomeProtocoloDetalhes: ${novoNomeProtocoloDetalhes},
novoFormaProtocoloDetalhes: ${novoFormaProtocoloDetalhes},
novoTipoProtocoloDetalhes: ${novoTipoProtocoloDetalhes},
novoSistemaProtocoloDetalhes: ${novoSistemaProtocoloDetalhes},
novaCulturaProtocoloDetalhes: ${novaCulturaProtocoloDetalhes},
getProtocoloGroup: ${getProtocoloGroup}
    ''';
  }
}
