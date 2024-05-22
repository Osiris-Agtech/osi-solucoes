enum FormaProtocoloEnum {
  semeadura,
  mudas,
}

extension FormaProtocoloEnumExt on FormaProtocoloEnum {
  String get nome {
    switch (this) {
      case FormaProtocoloEnum.semeadura:
        return 'Semeadura';
      case FormaProtocoloEnum.mudas:
        return 'Mudas';
      default:
        return '';
    }
  }
}

List<String> formaProtocoloList =
    FormaProtocoloEnum.values.map((e) => e.nome).toList();
