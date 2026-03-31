// ignore_for_file: avoid_print

class RelatorioCicloFiltros {
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<int>? culturaIds;
  final List<int>? setorIds;
  final List<int>? areaIds;

  const RelatorioCicloFiltros({
    required this.dataInicio,
    required this.dataFim,
    this.culturaIds,
    this.setorIds,
    this.areaIds,
  });

  factory RelatorioCicloFiltros.ultimos6Meses() {
    final fim = DateTime.now();
    final inicio = DateTime(fim.year, fim.month - 6, fim.day);
    return RelatorioCicloFiltros(dataInicio: inicio, dataFim: fim);
  }

  Map<String, dynamic> toVariables() {
    return {
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      if (culturaIds != null && culturaIds!.isNotEmpty) 'culturaIds': culturaIds,
      if (setorIds != null && setorIds!.isNotEmpty) 'setorIds': setorIds,
      if (areaIds != null && areaIds!.isNotEmpty) 'areaIds': areaIds,
    };
  }

  RelatorioCicloFiltros copyWith({
    DateTime? dataInicio,
    DateTime? dataFim,
    List<int>? culturaIds,
    List<int>? setorIds,
    List<int>? areaIds,
  }) {
    return RelatorioCicloFiltros(
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      culturaIds: culturaIds ?? this.culturaIds,
      setorIds: setorIds ?? this.setorIds,
      areaIds: areaIds ?? this.areaIds,
    );
  }
}

class CicloLoteDetalhe {
  final int loteId;
  final String? loteNome;
  final String? semeaduraData;
  final String? transplantioData;
  final String? colheitaData;
  final int duracaoRealDias;
  final int? duracaoPlanejadaDias;
  final int? desvioDias;
  final double? desvioPercentual;
  final String? setorNome;
  final String? areaNome;

  const CicloLoteDetalhe({
    required this.loteId,
    this.loteNome,
    this.semeaduraData,
    this.transplantioData,
    this.colheitaData,
    required this.duracaoRealDias,
    this.duracaoPlanejadaDias,
    this.desvioDias,
    this.desvioPercentual,
    this.setorNome,
    this.areaNome,
  });

  factory CicloLoteDetalhe.fromJson(Map<String, dynamic> json) {
    return CicloLoteDetalhe(
      loteId: json['loteId'] as int,
      loteNome: json['loteNome'] as String?,
      semeaduraData: json['semeaduraData'] as String?,
      transplantioData: json['transplantioData'] as String?,
      colheitaData: json['colheitaData'] as String?,
      duracaoRealDias: json['duracaoRealDias'] as int? ?? 0,
      duracaoPlanejadaDias: json['duracaoPlanejadaDias'] as int?,
      desvioDias: json['desvioDias'] as int?,
      desvioPercentual: _toDouble(json['desvioPercentual']),
      setorNome: json['setorNome'] as String?,
      areaNome: json['areaNome'] as String?,
    );
  }
}

class CicloRankingCultura {
  final int culturaId;
  final String culturaNome;
  final int totalLotes;
  final double duracaoRealMedia;
  final double? duracaoPlanejadaMedia;
  final double? desvioMedioDias;
  final double? desvioMedioPercentual;
  final double? desvioMaxDias;
  final double? desvioMinDias;
  final List<CicloLoteDetalhe> lotes;

  const CicloRankingCultura({
    required this.culturaId,
    required this.culturaNome,
    required this.totalLotes,
    required this.duracaoRealMedia,
    this.duracaoPlanejadaMedia,
    this.desvioMedioDias,
    this.desvioMedioPercentual,
    this.desvioMaxDias,
    this.desvioMinDias,
    required this.lotes,
  });

  factory CicloRankingCultura.fromJson(Map<String, dynamic> json) {
    final lotesJson = json['lotes'] as List<dynamic>? ?? [];
    return CicloRankingCultura(
      culturaId: json['culturaId'] as int,
      culturaNome: json['culturaNome'] as String? ?? '',
      totalLotes: json['totalLotes'] as int? ?? 0,
      duracaoRealMedia: _toDouble(json['duracaoRealMedia']) ?? 0.0,
      duracaoPlanejadaMedia: _toDouble(json['duracaoPlanejadaMedia']),
      desvioMedioDias: _toDouble(json['desvioMedioDias']),
      desvioMedioPercentual: _toDouble(json['desvioMedioPercentual']),
      desvioMaxDias: _toDouble(json['desvioMaxDias']),
      desvioMinDias: _toDouble(json['desvioMinDias']),
      lotes: lotesJson
          .map((l) => CicloLoteDetalhe.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RelatorioCicloResult {
  final List<CicloRankingCultura> culturas;
  final int totalLotes;
  final double desvioMedioGeral;
  final String periodoInicio;
  final String periodoFim;

  const RelatorioCicloResult({
    required this.culturas,
    required this.totalLotes,
    required this.desvioMedioGeral,
    required this.periodoInicio,
    required this.periodoFim,
  });

  factory RelatorioCicloResult.fromJson(Map<String, dynamic> json) {
    final culturasJson = json['culturas'] as List<dynamic>? ?? [];
    return RelatorioCicloResult(
      culturas: culturasJson
          .map((c) => CicloRankingCultura.fromJson(c as Map<String, dynamic>))
          .toList(),
      totalLotes: json['totalLotes'] as int? ?? 0,
      desvioMedioGeral: _toDouble(json['desvioMedioGeral']) ?? 0.0,
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
