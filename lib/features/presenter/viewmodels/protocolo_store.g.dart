// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocolo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProtocoloStore on _ProtocoloStoreBase, Store {
  final _$dotIndicatorAtom = Atom(name: '_ProtocoloStoreBase.dotIndicator');

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

  final _$isProtocoloListLoadingAtom =
      Atom(name: '_ProtocoloStoreBase.isProtocoloListLoading');

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

  final _$isEditingAtom = Atom(name: '_ProtocoloStoreBase.isEditing');

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

  final _$canNotificateAtom = Atom(name: '_ProtocoloStoreBase.canNotificate');

  @override
  bool get canNotificate {
    _$canNotificateAtom.reportRead();
    return super.canNotificate;
  }

  @override
  set canNotificate(bool value) {
    _$canNotificateAtom.reportWrite(value, super.canNotificate, () {
      super.canNotificate = value;
    });
  }

  final _$mostrarErroFormularioAtom =
      Atom(name: '_ProtocoloStoreBase.mostrarErroFormulario');

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

  final _$novoTipoProtocoloAtom =
      Atom(name: '_ProtocoloStoreBase.novoTipoProtocolo');

  @override
  TextEditingController get novoTipoProtocolo {
    _$novoTipoProtocoloAtom.reportRead();
    return super.novoTipoProtocolo;
  }

  @override
  set novoTipoProtocolo(TextEditingController value) {
    _$novoTipoProtocoloAtom.reportWrite(value, super.novoTipoProtocolo, () {
      super.novoTipoProtocolo = value;
    });
  }

  final _$novoSistemaProtocoloAtom =
      Atom(name: '_ProtocoloStoreBase.novoSistemaProtocolo');

  @override
  TextEditingController get novoSistemaProtocolo {
    _$novoSistemaProtocoloAtom.reportRead();
    return super.novoSistemaProtocolo;
  }

  @override
  set novoSistemaProtocolo(TextEditingController value) {
    _$novoSistemaProtocoloAtom.reportWrite(value, super.novoSistemaProtocolo,
        () {
      super.novoSistemaProtocolo = value;
    });
  }

  final _$novoFormaProtocoloAtom =
      Atom(name: '_ProtocoloStoreBase.novoFormaProtocolo');

  @override
  TextEditingController get novoFormaProtocolo {
    _$novoFormaProtocoloAtom.reportRead();
    return super.novoFormaProtocolo;
  }

  @override
  set novoFormaProtocolo(TextEditingController value) {
    _$novoFormaProtocoloAtom.reportWrite(value, super.novoFormaProtocolo, () {
      super.novoFormaProtocolo = value;
    });
  }

  final _$novaCulturaProtocoloAtom =
      Atom(name: '_ProtocoloStoreBase.novaCulturaProtocolo');

  @override
  Cultura get novaCulturaProtocolo {
    _$novaCulturaProtocoloAtom.reportRead();
    return super.novaCulturaProtocolo;
  }

  @override
  set novaCulturaProtocolo(Cultura value) {
    _$novaCulturaProtocoloAtom.reportWrite(value, super.novaCulturaProtocolo,
        () {
      super.novaCulturaProtocolo = value;
    });
  }

  final _$novasAtividadesProtocoloAtom =
      Atom(name: '_ProtocoloStoreBase.novasAtividadesProtocolo');

  @override
  List<Atividade> get novasAtividadesProtocolo {
    _$novasAtividadesProtocoloAtom.reportRead();
    return super.novasAtividadesProtocolo;
  }

  @override
  set novasAtividadesProtocolo(List<Atividade> value) {
    _$novasAtividadesProtocoloAtom
        .reportWrite(value, super.novasAtividadesProtocolo, () {
      super.novasAtividadesProtocolo = value;
    });
  }

  final _$protocoloListAtom = Atom(name: '_ProtocoloStoreBase.protocoloList');

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

  final _$buscarProtocolosAsyncAction =
      AsyncAction('_ProtocoloStoreBase.buscarProtocolos');

  @override
  Future buscarProtocolos() {
    return _$buscarProtocolosAsyncAction.run(() => super.buscarProtocolos());
  }

  final _$_ProtocoloStoreBaseActionController =
      ActionController(name: '_ProtocoloStoreBase');

  @override
  dynamic setMostrarErroFormulario(bool value) {
    final _$actionInfo = _$_ProtocoloStoreBaseActionController.startAction(
        name: '_ProtocoloStoreBase.setMostrarErroFormulario');
    try {
      return super.setMostrarErroFormulario(value);
    } finally {
      _$_ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCanNotificate(bool value) {
    final _$actionInfo = _$_ProtocoloStoreBaseActionController.startAction(
        name: '_ProtocoloStoreBase.setCanNotificate');
    try {
      return super.setCanNotificate(value);
    } finally {
      _$_ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDotIndicator(int value) {
    final _$actionInfo = _$_ProtocoloStoreBaseActionController.startAction(
        name: '_ProtocoloStoreBase.setDotIndicator');
    try {
      return super.setDotIndicator(value);
    } finally {
      _$_ProtocoloStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dotIndicator: ${dotIndicator},
isProtocoloListLoading: ${isProtocoloListLoading},
isEditing: ${isEditing},
canNotificate: ${canNotificate},
mostrarErroFormulario: ${mostrarErroFormulario},
novoTipoProtocolo: ${novoTipoProtocolo},
novoSistemaProtocolo: ${novoSistemaProtocolo},
novoFormaProtocolo: ${novoFormaProtocolo},
novaCulturaProtocolo: ${novaCulturaProtocolo},
novasAtividadesProtocolo: ${novasAtividadesProtocolo},
protocoloList: ${protocoloList}
    ''';
  }
}
