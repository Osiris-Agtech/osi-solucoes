enum SistemaProtocoloEnum {
  hidroponia,
  solo,
  substrato,
}

extension SistemaProtocoloEnumExt on SistemaProtocoloEnum {
  String get nome {
    switch (this) {
      case SistemaProtocoloEnum.hidroponia:
        return 'Hidroponia';
      case SistemaProtocoloEnum.solo:
        return 'Solo (Tradicional)';
      case SistemaProtocoloEnum.substrato:
        return 'Substrado';
      }
  }
}

List<String> sistemaProtocoloList =
    SistemaProtocoloEnum.values.map((e) => e.nome).toList();
