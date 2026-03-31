// ignore_for_file: avoid_print

class RelatorioProdutividadeFiltros {
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<int>? setorIds;
  final List<int>? areaIds;
  final List<int>? culturaIds;

  const RelatorioProdutividadeFiltros({
    required this.dataInicio,
    required this.dataFim,
    this.setorIds,
    this.areaIds,
    this.culturaIds,
  });

  factory RelatorioProdutividadeFiltros.ultimos6Meses() {
    final fim = DateTime.now();
    final inicio = DateTime(fim.year, fim.month - 6, fim.day);
    return RelatorioProdutividadeFiltros(dataInicio: inicio, dataFim: fim);
  }

  Map<String, dynamic> toVariables() {
    return {
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      if (setorIds != null && setorIds!.isNotEmpty) 'setorIds': setorIds,
      if (areaIds != null && areaIds!.isNotEmpty) 'areaIds': areaIds,
      if (culturaIds != null && culturaIds!.isNotEmpty) 'culturaIds': culturaIds,
    };
  }

  RelatorioProdutividadeFiltros copyWith({
    DateTime? dataInicio,
    DateTime? dataFim,
    List<int>? setorIds,
    List<int>? areaIds,
    List<int>? culturaIds,
  }) {
    return RelatorioProdutividadeFiltros(
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      setorIds: setorIds ?? this.setorIds,
      areaIds: areaIds ?? this.areaIds,
      culturaIds: culturaIds ?? this.culturaIds,
    );
  }
}

class ProdutividadeAreaDetalhe {
  final int areaId;
  final String areaNome;
  final int totalLotes;
  final int totalBandejasSemeadas;
  final int totalMudasTransplantadas;
  final int totalPlantasColhidas;
  final int totalEmbalagensProduzidas;
  final double? taxaGerminacao;
  final double? taxaTransplantio;
  final double? taxaEmbalagem;
  final double? taxaGlobal;

  const ProdutividadeAreaDetalhe({
    required this.areaId,
    required this.areaNome,
    required this.totalLotes,
    required this.totalBandejasSemeadas,
    required this.totalMudasTransplantadas,
    required this.totalPlantasColhidas,
    required this.totalEmbalagensProduzidas,
    this.taxaGerminacao,
    this.taxaTransplantio,
    this.taxaEmbalagem,
    this.taxaGlobal,
  });

  factory ProdutividadeAreaDetalhe.fromJson(Map<String, dynamic> json) {
    return ProdutividadeAreaDetalhe(
      areaId: json['areaId'] as int,
      areaNome: json['areaNome'] as String? ?? '',
      totalLotes: json['totalLotes'] as int? ?? 0,
      totalBandejasSemeadas: json['totalBandejasSemeadas'] as int? ?? 0,
      totalMudasTransplantadas: json['totalMudasTransplantadas'] as int? ?? 0,
      totalPlantasColhidas: json['totalPlantasColhidas'] as int? ?? 0,
      totalEmbalagensProduzidas: json['totalEmbalagensProduzidas'] as int? ?? 0,
      taxaGerminacao: _toDouble(json['taxaGerminacao']),
      taxaTransplantio: _toDouble(json['taxaTransplantio']),
      taxaEmbalagem: _toDouble(json['taxaEmbalagem']),
      taxaGlobal: _toDouble(json['taxaGlobal']),
    );
  }
}

class ProdutividadeSetorRanking {
  final int setorId;
  final String setorNome;
  final String? areaNome;
  final int totalLotes;
  final int totalBandejasSemeadas;
  final int totalMudasTransplantadas;
  final int totalPlantasColhidas;
  final int totalEmbalagensProduzidas;
  final double? taxaGerminacao;
  final double? taxaTransplantio;
  final double? taxaEmbalagem;
  final double? taxaGlobal;
  final List<ProdutividadeAreaDetalhe> areas;

  const ProdutividadeSetorRanking({
    required this.setorId,
    required this.setorNome,
    this.areaNome,
    required this.totalLotes,
    required this.totalBandejasSemeadas,
    required this.totalMudasTransplantadas,
    required this.totalPlantasColhidas,
    required this.totalEmbalagensProduzidas,
    this.taxaGerminacao,
    this.taxaTransplantio,
    this.taxaEmbalagem,
    this.taxaGlobal,
    required this.areas,
  });

  factory ProdutividadeSetorRanking.fromJson(Map<String, dynamic> json) {
    final areasJson = json['areas'] as List<dynamic>? ?? [];
    return ProdutividadeSetorRanking(
      setorId: json['setorId'] as int,
      setorNome: json['setorNome'] as String? ?? '',
      areaNome: json['areaNome'] as String?,
      totalLotes: json['totalLotes'] as int? ?? 0,
      totalBandejasSemeadas: json['totalBandejasSemeadas'] as int? ?? 0,
      totalMudasTransplantadas: json['totalMudasTransplantadas'] as int? ?? 0,
      totalPlantasColhidas: json['totalPlantasColhidas'] as int? ?? 0,
      totalEmbalagensProduzidas: json['totalEmbalagensProduzidas'] as int? ?? 0,
      taxaGerminacao: _toDouble(json['taxaGerminacao']),
      taxaTransplantio: _toDouble(json['taxaTransplantio']),
      taxaEmbalagem: _toDouble(json['taxaEmbalagem']),
      taxaGlobal: _toDouble(json['taxaGlobal']),
      areas: areasJson
          .map((a) => ProdutividadeAreaDetalhe.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RelatorioProdutividadeResult {
  final List<ProdutividadeSetorRanking> setores;
  final int totalLotes;
  final double taxaGlobalMedia;
  final String periodoInicio;
  final String periodoFim;

  const RelatorioProdutividadeResult({
    required this.setores,
    required this.totalLotes,
    required this.taxaGlobalMedia,
    required this.periodoInicio,
    required this.periodoFim,
  });

  factory RelatorioProdutividadeResult.fromJson(Map<String, dynamic> json) {
    final setoresJson = json['setores'] as List<dynamic>? ?? [];
    return RelatorioProdutividadeResult(
      setores: setoresJson
          .map((s) => ProdutividadeSetorRanking.fromJson(s as Map<String, dynamic>))
          .toList(),
      totalLotes: json['totalLotes'] as int? ?? 0,
      taxaGlobalMedia: _toDouble(json['taxaGlobalMedia']) ?? 0.0,
      periodoInicio: json['periodoInicio'] as String? ?? '',
      periodoFim: json['periodoFim'] as String? ?? '',
    );
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
