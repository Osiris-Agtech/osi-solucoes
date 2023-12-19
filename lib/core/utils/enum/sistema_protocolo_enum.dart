enum SistemaProtocoloEnum {
  hidroponia,
  solo,
  estufa,
}

extension SistemaProtocoloEnumExt on SistemaProtocoloEnum {
  String get nome {
    switch (this) {
      case SistemaProtocoloEnum.hidroponia:
        return 'Hidroponia';
      case SistemaProtocoloEnum.solo:
        return 'Solo (Tradicional)';
      case SistemaProtocoloEnum.estufa:
        return 'Estufa';
      default:
        return '';
    }
  }
}

List<String> sistemaProtocoloList =
    SistemaProtocoloEnum.values.map((e) => e.nome).toList();
