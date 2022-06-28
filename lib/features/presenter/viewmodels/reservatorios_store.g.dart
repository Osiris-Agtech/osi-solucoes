// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservatorios_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReservatoriosStore on _ReservatoriosStoreBase, Store {
  final _$novoReservatorioAtom =
      Atom(name: '_ReservatoriosStoreBase.novoReservatorio');

  @override
  Reservatorio get novoReservatorio {
    _$novoReservatorioAtom.reportRead();
    return super.novoReservatorio;
  }

  @override
  set novoReservatorio(Reservatorio value) {
    _$novoReservatorioAtom.reportWrite(value, super.novoReservatorio, () {
      super.novoReservatorio = value;
    });
  }

  final _$solucaoNutritivaAtom =
      Atom(name: '_ReservatoriosStoreBase.solucaoNutritiva');

  @override
  SolucaoNutritiva get solucaoNutritiva {
    _$solucaoNutritivaAtom.reportRead();
    return super.solucaoNutritiva;
  }

  @override
  set solucaoNutritiva(SolucaoNutritiva value) {
    _$solucaoNutritivaAtom.reportWrite(value, super.solucaoNutritiva, () {
      super.solucaoNutritiva = value;
    });
  }

  final _$isSolucaoNutritivaValidAtom =
      Atom(name: '_ReservatoriosStoreBase.isSolucaoNutritivaValid');

  @override
  bool get isSolucaoNutritivaValid {
    _$isSolucaoNutritivaValidAtom.reportRead();
    return super.isSolucaoNutritivaValid;
  }

  @override
  set isSolucaoNutritivaValid(bool value) {
    _$isSolucaoNutritivaValidAtom
        .reportWrite(value, super.isSolucaoNutritivaValid, () {
      super.isSolucaoNutritivaValid = value;
    });
  }

  final _$novoReservatorioNameAtom =
      Atom(name: '_ReservatoriosStoreBase.novoReservatorioName');

  @override
  TextEditingController get novoReservatorioName {
    _$novoReservatorioNameAtom.reportRead();
    return super.novoReservatorioName;
  }

  @override
  set novoReservatorioName(TextEditingController value) {
    _$novoReservatorioNameAtom.reportWrite(value, super.novoReservatorioName,
        () {
      super.novoReservatorioName = value;
    });
  }

  final _$novoReservatorioVolumeAtom =
      Atom(name: '_ReservatoriosStoreBase.novoReservatorioVolume');

  @override
  TextEditingController get novoReservatorioVolume {
    _$novoReservatorioVolumeAtom.reportRead();
    return super.novoReservatorioVolume;
  }

  @override
  set novoReservatorioVolume(TextEditingController value) {
    _$novoReservatorioVolumeAtom
        .reportWrite(value, super.novoReservatorioVolume, () {
      super.novoReservatorioVolume = value;
    });
  }

  final _$_ReservatoriosStoreBaseActionController =
      ActionController(name: '_ReservatoriosStoreBase');

  @override
  dynamic setSolucaoNutritiva(SolucaoNutritiva solucao) {
    final _$actionInfo = _$_ReservatoriosStoreBaseActionController.startAction(
        name: '_ReservatoriosStoreBase.setSolucaoNutritiva');
    try {
      return super.setSolucaoNutritiva(solucao);
    } finally {
      _$_ReservatoriosStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
novoReservatorio: ${novoReservatorio},
solucaoNutritiva: ${solucaoNutritiva},
isSolucaoNutritivaValid: ${isSolucaoNutritivaValid},
novoReservatorioName: ${novoReservatorioName},
novoReservatorioVolume: ${novoReservatorioVolume}
    ''';
  }
}
