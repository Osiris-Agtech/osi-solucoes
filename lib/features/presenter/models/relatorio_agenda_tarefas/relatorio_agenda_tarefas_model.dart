// ignore_for_file: avoid_print

class RelatorioAgendaFiltros {
  final int diasAVencer;
  final List<int>? usuarioIds;
  final List<int>? loteIds;
  final bool apenasComAlerta;

  const RelatorioAgendaFiltros({
    this.diasAVencer = 7,
    this.usuarioIds,
    this.loteIds,
    this.apenasComAlerta = false,
  });

  factory RelatorioAgendaFiltros.padrao() {
    return const RelatorioAgendaFiltros(diasAVencer: 7);
  }

  Map<String, dynamic> toVariables() {
    return {
      'diasAVencer': diasAVencer,
      if (usuarioIds != null && usuarioIds!.isNotEmpty) 'usuarioIds': usuarioIds,
      if (loteIds != null && loteIds!.isNotEmpty) 'loteIds': loteIds,
      if (apenasComAlerta) 'apenasComAlerta': true,
    };
  }

  RelatorioAgendaFiltros copyWith({
    int? diasAVencer,
    List<int>? usuarioIds,
    List<int>? loteIds,
    bool? apenasComAlerta,
  }) {
    return RelatorioAgendaFiltros(
      diasAVencer: diasAVencer ?? this.diasAVencer,
      usuarioIds: usuarioIds ?? this.usuarioIds,
      loteIds: loteIds ?? this.loteIds,
      apenasComAlerta: apenasComAlerta ?? this.apenasComAlerta,
    );
  }
}

class AgendaTarefaItem {
  final int id;
  final String? titulo;
  final String? descricao;
  final String? data; // ISO string — prazo (deadline)
  final bool alerta;
  final String? usuarioNome;
  final int? usuarioId;
  final String? loteNome;
  final int? loteId;
  final String? setorNome;

  const AgendaTarefaItem({
    required this.id,
    this.titulo,
    this.descricao,
    this.data,
    required this.alerta,
    this.usuarioNome,
    this.usuarioId,
    this.loteNome,
    this.loteId,
    this.setorNome,
  });

  factory AgendaTarefaItem.fromJson(Map<String, dynamic> json) {
    return AgendaTarefaItem(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String?,
      data: json['data'] as String?,
      alerta: json['alerta'] as bool? ?? false,
      usuarioNome: json['usuarioNome'] as String?,
      usuarioId: json['usuarioId'] as int?,
      loteNome: json['loteNome'] as String?,
      loteId: json['loteId'] as int?,
      setorNome: json['setorNome'] as String?,
    );
  }

  /// Calcula os dias de atraso (positivo = atrasado, negativo = ainda não venceu).
  int calcularDiasAtraso() {
    if (data == null) return 0;
    final prazo = DateTime.tryParse(data!);
    if (prazo == null) return 0;
    final hoje = DateTime.now();
    return hoje.difference(prazo).inDays;
  }

  /// Dias restantes até o prazo (positivo = ainda tem tempo, negativo = vencido).
  int calcularDiasRestantes() {
    if (data == null) return 0;
    final prazo = DateTime.tryParse(data!);
    if (prazo == null) return 0;
    final hoje = DateTime.now();
    return prazo.difference(hoje).inDays;
  }

  String get displayTitulo => titulo?.isNotEmpty == true ? titulo! : descricao ?? 'Sem título';
}

class AgendaLoteTaxaConclusao {
  final int loteId;
  final String loteNome;
  final String? setorNome;
  final int totalTarefas;
  final int tarefasConcluidas;
  final int tarefasVencidas;
  final double taxaConclusao;

  const AgendaLoteTaxaConclusao({
    required this.loteId,
    required this.loteNome,
    this.setorNome,
    required this.totalTarefas,
    required this.tarefasConcluidas,
    required this.tarefasVencidas,
    required this.taxaConclusao,
  });

  factory AgendaLoteTaxaConclusao.fromJson(Map<String, dynamic> json) {
    return AgendaLoteTaxaConclusao(
      loteId: json['loteId'] as int,
      loteNome: json['loteNome'] as String? ?? '',
      setorNome: json['setorNome'] as String?,
      totalTarefas: json['totalTarefas'] as int? ?? 0,
      tarefasConcluidas: json['tarefasConcluidas'] as int? ?? 0,
      tarefasVencidas: json['tarefasVencidas'] as int? ?? 0,
      taxaConclusao: _toDouble(json['taxaConclusao']) ?? 0.0,
    );
  }
}

class RelatorioAgendaResult {
  final List<AgendaTarefaItem> tarefasVencidas;
  final List<AgendaTarefaItem> tarefasAVencer;
  final List<AgendaLoteTaxaConclusao> lotesComTaxaConclusao;
  final int diasAVencer;
  final String geradoEm;

  const RelatorioAgendaResult({
    required this.tarefasVencidas,
    required this.tarefasAVencer,
    required this.lotesComTaxaConclusao,
    required this.diasAVencer,
    required this.geradoEm,
  });

  factory RelatorioAgendaResult.fromJson(Map<String, dynamic> json) {
    final vencidasJson = json['tarefasVencidas'] as List<dynamic>? ?? [];
    final aVencerJson = json['tarefasAVencer'] as List<dynamic>? ?? [];
    final lotesJson = json['lotesComTaxaConclusao'] as List<dynamic>? ?? [];

    return RelatorioAgendaResult(
      tarefasVencidas: vencidasJson
          .map((t) => AgendaTarefaItem.fromJson(t as Map<String, dynamic>))
          .toList(),
      tarefasAVencer: aVencerJson
          .map((t) => AgendaTarefaItem.fromJson(t as Map<String, dynamic>))
          .toList(),
      lotesComTaxaConclusao: lotesJson
          .map((l) => AgendaLoteTaxaConclusao.fromJson(l as Map<String, dynamic>))
          .toList(),
      diasAVencer: json['diasAVencer'] as int? ?? 7,
      geradoEm: json['geradoEm'] as String? ?? '',
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
