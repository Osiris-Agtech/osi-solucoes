// ignore_for_file: avoid_print

class RelatorioDesempenhoFiltros {
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<int>? usuarioIds;

  const RelatorioDesempenhoFiltros({
    required this.dataInicio,
    required this.dataFim,
    this.usuarioIds,
  });

  factory RelatorioDesempenhoFiltros.ultimos6Meses() {
    final fim = DateTime.now();
    final inicio = DateTime(fim.year, fim.month - 6, fim.day);
    return RelatorioDesempenhoFiltros(dataInicio: inicio, dataFim: fim);
  }

  Map<String, dynamic> toVariables() {
    return {
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      if (usuarioIds != null && usuarioIds!.isNotEmpty) 'usuarioIds': usuarioIds,
    };
  }

  RelatorioDesempenhoFiltros copyWith({
    DateTime? dataInicio,
    DateTime? dataFim,
    List<int>? usuarioIds,
  }) {
    return RelatorioDesempenhoFiltros(
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      usuarioIds: usuarioIds ?? this.usuarioIds,
    );
  }
}

class DesempenhoAtividadeItem {
  final int atividadeId;
  final String atividadeNome;
  final int loteId;
  final String? loteNome;

  const DesempenhoAtividadeItem({
    required this.atividadeId,
    required this.atividadeNome,
    required this.loteId,
    this.loteNome,
  });

  factory DesempenhoAtividadeItem.fromJson(Map<String, dynamic> json) {
    return DesempenhoAtividadeItem(
      atividadeId: json['atividadeId'] as int,
      atividadeNome: json['atividadeNome'] as String? ?? '',
      loteId: json['loteId'] as int,
      loteNome: json['loteNome'] as String?,
    );
  }
}

class DesempenhoAgendaItem {
  final int agendaId;
  final String? titulo;
  final String data;
  final bool finalizado;
  final bool vencida;

  const DesempenhoAgendaItem({
    required this.agendaId,
    this.titulo,
    required this.data,
    required this.finalizado,
    required this.vencida,
  });

  factory DesempenhoAgendaItem.fromJson(Map<String, dynamic> json) {
    return DesempenhoAgendaItem(
      agendaId: json['agendaId'] as int,
      titulo: json['titulo'] as String?,
      data: json['data'] as String? ?? '',
      finalizado: json['finalizado'] as bool? ?? false,
      vencida: json['vencida'] as bool? ?? false,
    );
  }
}

class DesempenhoUsuarioRanking {
  final int usuarioId;
  final String usuarioNome;
  final int totalAtividades;
  final int totalAgendas;
  final int agendasFinalizadas;
  final int agendasNoPrazo;
  final double? taxaConclusao;
  final double? taxaPrazo;
  final List<DesempenhoAtividadeItem> ultimasAtividades;
  final List<DesempenhoAgendaItem> agendasPendentes;

  const DesempenhoUsuarioRanking({
    required this.usuarioId,
    required this.usuarioNome,
    required this.totalAtividades,
    required this.totalAgendas,
    required this.agendasFinalizadas,
    required this.agendasNoPrazo,
    this.taxaConclusao,
    this.taxaPrazo,
    required this.ultimasAtividades,
    required this.agendasPendentes,
  });

  factory DesempenhoUsuarioRanking.fromJson(Map<String, dynamic> json) {
    final atividadesJson = json['ultimasAtividades'] as List<dynamic>? ?? [];
    final agendasJson = json['agendasPendentes'] as List<dynamic>? ?? [];
    return DesempenhoUsuarioRanking(
      usuarioId: json['usuarioId'] as int,
      usuarioNome: json['usuarioNome'] as String? ?? '',
      totalAtividades: json['totalAtividades'] as int? ?? 0,
      totalAgendas: json['totalAgendas'] as int? ?? 0,
      agendasFinalizadas: json['agendasFinalizadas'] as int? ?? 0,
      agendasNoPrazo: json['agendasNoPrazo'] as int? ?? 0,
      taxaConclusao: _toDouble(json['taxaConclusao']),
      taxaPrazo: _toDouble(json['taxaPrazo']),
      ultimasAtividades: atividadesJson
          .map((a) => DesempenhoAtividadeItem.fromJson(a as Map<String, dynamic>))
          .toList(),
      agendasPendentes: agendasJson
          .map((a) => DesempenhoAgendaItem.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RelatorioDesempenhoResult {
  final List<DesempenhoUsuarioRanking> usuarios;
  final int totalUsuarios;
  final double taxaConclusaoMedia;
  final String periodoInicio;
  final String periodoFim;

  const RelatorioDesempenhoResult({
    required this.usuarios,
    required this.totalUsuarios,
    required this.taxaConclusaoMedia,
    required this.periodoInicio,
    required this.periodoFim,
  });

  factory RelatorioDesempenhoResult.fromJson(Map<String, dynamic> json) {
    final usuariosJson = json['usuarios'] as List<dynamic>? ?? [];
    return RelatorioDesempenhoResult(
      usuarios: usuariosJson
          .map((u) => DesempenhoUsuarioRanking.fromJson(u as Map<String, dynamic>))
          .toList(),
      totalUsuarios: json['totalUsuarios'] as int? ?? 0,
      taxaConclusaoMedia: _toDouble(json['taxaConclusaoMedia']) ?? 0.0,
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
