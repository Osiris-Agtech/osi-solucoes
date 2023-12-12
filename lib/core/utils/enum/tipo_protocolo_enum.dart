enum TipoProtocoloEnum {
  lisa,
  crespa,
  romana,
  roxa,
}

extension TipoProtocoloEnumExt on TipoProtocoloEnum {
  String get nome {
    switch (this) {
      case TipoProtocoloEnum.lisa:
        return 'Lisa';
      case TipoProtocoloEnum.crespa:
        return 'Crespa';
      case TipoProtocoloEnum.romana:
        return 'Romana';
      case TipoProtocoloEnum.roxa:
        return 'Roxa';
      default:
        return '';
    }
  }
}

List<String> tipoProtocoloList =
    TipoProtocoloEnum.values.map((e) => e.nome).toList();
