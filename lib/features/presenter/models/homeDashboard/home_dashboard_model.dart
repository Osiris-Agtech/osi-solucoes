// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'home_dashboard_info_context_model.dart';

part 'home_dashboard_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeDashboard {
  @JsonKey(required: false, disallowNullValue: false)
  HomeResumo? resumo;

  @JsonKey(required: false, disallowNullValue: false)
  HomeTarefas? tarefas;

  @JsonKey(required: false, disallowNullValue: false)
  HomeProducao? producao;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeCultura>? culturas;

  @JsonKey(required: false, disallowNullValue: false)
  HomeEquipeResumo? equipe;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeAlertaCritico>? alertasCritico;

  @JsonKey(required: false, disallowNullValue: false)
  HomeInfoContext? infoContext;

  HomeDashboard({
    this.resumo,
    this.tarefas,
    this.producao,
    this.culturas,
    this.equipe,
    this.alertasCritico,
    this.infoContext,
  });

  factory HomeDashboard.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDashboardToJson(this);
}

@JsonSerializable()
class HomeResumo {
  @JsonKey(required: false, disallowNullValue: false)
  int? totalLotes;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotesAtivos;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotesFinalizados;

  @JsonKey(required: false, disallowNullValue: false)
  double? taxaConclusao;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeLoteStatus>? lotesPorStatus;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotesComColheitaProxima;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeEspecieDetalhe>? especiesEmAndamento;

  HomeResumo({
    this.totalLotes,
    this.lotesAtivos,
    this.lotesFinalizados,
    this.taxaConclusao,
    this.lotesPorStatus,
    this.lotesComColheitaProxima,
    this.especiesEmAndamento,
  });

  factory HomeResumo.fromJson(Map<String, dynamic> json) =>
      _$HomeResumoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResumoToJson(this);
}

@JsonSerializable()
class HomeTarefas {
  @JsonKey(required: false, disallowNullValue: false)
  int? pendentesHoje;

  @JsonKey(required: false, disallowNullValue: false)
  int? pendentesSemana;

  @JsonKey(required: false, disallowNullValue: false)
  int? atrasadas;

  @JsonKey(required: false, disallowNullValue: false)
  HomeTarefasPorVencimento? porVencimento;

  @JsonKey(required: false, disallowNullValue: false)
  HomeTarefasPorPrioridade? porPrioridade;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeTarefaDetalhe>? ultimasTarefas;

  HomeTarefas({
    this.pendentesHoje,
    this.pendentesSemana,
    this.atrasadas,
    this.porVencimento,
    this.porPrioridade,
    this.ultimasTarefas,
  });

  factory HomeTarefas.fromJson(Map<String, dynamic> json) =>
      _$HomeTarefasFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTarefasToJson(this);
}

@JsonSerializable()
class HomeProducao {
  @JsonKey(required: false, disallowNullValue: false)
  int? totalPlantasColhidas;

  @JsonKey(required: false, disallowNullValue: false)
  int? totalEmbalagensProduzidas;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotesComColheitaProxima;

  @JsonKey(required: false, disallowNullValue: false)
  String? periodoInicio;

  @JsonKey(required: false, disallowNullValue: false)
  String? periodoFim;

  @JsonKey(required: false, disallowNullValue: false)
  List<HomeProducaoMensal>? producaoMensal;

  @JsonKey(required: false, disallowNullValue: false)
  HomeTaxasMedia? taxasMedia;

  @JsonKey(required: false, disallowNullValue: false)
  HomeComparativoPeriodo? comparativoPeriodo;

  @JsonKey(required: false, disallowNullValue: false)
  HomeCulturaDestaque? culturaMaisProducao;

  HomeProducao({
    this.totalPlantasColhidas,
    this.totalEmbalagensProduzidas,
    this.lotesComColheitaProxima,
    this.periodoInicio,
    this.periodoFim,
    this.producaoMensal,
    this.taxasMedia,
    this.comparativoPeriodo,
    this.culturaMaisProducao,
  });

  factory HomeProducao.fromJson(Map<String, dynamic> json) =>
      _$HomeProducaoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeProducaoToJson(this);
}

@JsonSerializable()
class HomeCultura {
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  int? quantidade;

  @JsonKey(required: false, disallowNullValue: false)
  String? cor;

  HomeCultura({
    this.nome,
    this.quantidade,
    this.cor,
  });

  factory HomeCultura.fromJson(Map<String, dynamic> json) =>
      _$HomeCulturaFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCulturaToJson(this);
}

// NOVO: Detalhe de status de lote
@JsonSerializable()
class HomeLoteStatus {
  @JsonKey(required: false, disallowNullValue: false)
  String? status;

  @JsonKey(required: false, disallowNullValue: false)
  int? quantidade;

  @JsonKey(required: false, disallowNullValue: false)
  String? cor;

  HomeLoteStatus({this.status, this.quantidade, this.cor});

  factory HomeLoteStatus.fromJson(Map<String, dynamic> json) =>
      _$HomeLoteStatusFromJson(json);

  Map<String, dynamic> toJson() => _$HomeLoteStatusToJson(this);
}

// NOVO: Espécie em detalhe
@JsonSerializable()
class HomeEspecieDetalhe {
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  double? percentual;

  @JsonKey(required: false, disallowNullValue: false)
  String? status;

  HomeEspecieDetalhe({this.nome, this.percentual, this.status});

  factory HomeEspecieDetalhe.fromJson(Map<String, dynamic> json) =>
      _$HomeEspecieDetalheFromJson(json);

  Map<String, dynamic> toJson() => _$HomeEspecieDetalheToJson(this);
}

// NOVO: Produção mensal
@JsonSerializable()
class HomeProducaoMensal {
  @JsonKey(required: false, disallowNullValue: false)
  String? mes;

  @JsonKey(required: false, disallowNullValue: false)
  double? quantidade;

  HomeProducaoMensal({this.mes, this.quantidade});

  factory HomeProducaoMensal.fromJson(Map<String, dynamic> json) =>
      _$HomeProducaoMensalFromJson(json);

  Map<String, dynamic> toJson() => _$HomeProducaoMensalToJson(this);
}

// NOVO: Taxas médias de produtividade
@JsonSerializable()
class HomeTaxasMedia {
  @JsonKey(required: false, disallowNullValue: false)
  double? taxaGerminacao;

  @JsonKey(required: false, disallowNullValue: false)
  double? taxaTransplantio;

  @JsonKey(required: false, disallowNullValue: false)
  double? taxaEmbalagem;

  @JsonKey(required: false, disallowNullValue: false)
  double? taxaGlobal;

  HomeTaxasMedia({
    this.taxaGerminacao,
    this.taxaTransplantio,
    this.taxaEmbalagem,
    this.taxaGlobal,
  });

  factory HomeTaxasMedia.fromJson(Map<String, dynamic> json) =>
      _$HomeTaxasMediaFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTaxasMediaToJson(this);
}

// NOVO: Comparativo com período anterior
@JsonSerializable()
class HomeComparativoPeriodo {
  @JsonKey(required: false, disallowNullValue: false)
  int? plantasColhidas;

  @JsonKey(required: false, disallowNullValue: false)
  double? variacaoPercentual;

  HomeComparativoPeriodo({this.plantasColhidas, this.variacaoPercentual});

  factory HomeComparativoPeriodo.fromJson(Map<String, dynamic> json) =>
      _$HomeComparativoPeriodoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeComparativoPeriodoToJson(this);
}

// NOVO: Cultura em destaque
@JsonSerializable()
class HomeCulturaDestaque {
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  int? quantidade;

  @JsonKey(required: false, disallowNullValue: false)
  double? percentualDoTotal;

  HomeCulturaDestaque({this.nome, this.quantidade, this.percentualDoTotal});

  factory HomeCulturaDestaque.fromJson(Map<String, dynamic> json) =>
      _$HomeCulturaDestaqueFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCulturaDestaqueToJson(this);
}

// NOVO: Resumo da equipe
@JsonSerializable()
class HomeEquipeResumo {
  @JsonKey(required: false, disallowNullValue: false)
  int? membrosAtivos;

  @JsonKey(required: false, disallowNullValue: false)
  double? taxaConclusaoMedia;

  @JsonKey(required: false, disallowNullValue: false)
  int? atividadesNoPrazo;

  @JsonKey(required: false, disallowNullValue: false)
  int? atividadesVencidas;

  HomeEquipeResumo({
    this.membrosAtivos,
    this.taxaConclusaoMedia,
    this.atividadesNoPrazo,
    this.atividadesVencidas,
  });

  factory HomeEquipeResumo.fromJson(Map<String, dynamic> json) =>
      _$HomeEquipeResumoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeEquipeResumoToJson(this);
}

// NOVO: Detalhe de tarefa
@JsonSerializable()
class HomeTarefaDetalhe {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? titulo;

  @JsonKey(required: false, disallowNullValue: false)
  String? loteNome;

  @JsonKey(required: false, disallowNullValue: false)
  String? data;

  @JsonKey(required: false, disallowNullValue: false)
  bool? vencida;

  HomeTarefaDetalhe({this.id, this.titulo, this.loteNome, this.data, this.vencida});

  factory HomeTarefaDetalhe.fromJson(Map<String, dynamic> json) =>
      _$HomeTarefaDetalheFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTarefaDetalheToJson(this);
}

// NOVO: Tarefas por vencimento
@JsonSerializable()
class HomeTarefasPorVencimento {
  @JsonKey(required: false, disallowNullValue: false)
  int? hoje;

  @JsonKey(required: false, disallowNullValue: false)
  int? estaSemana;

  @JsonKey(required: false, disallowNullValue: false)
  int? proximaSemana;

  HomeTarefasPorVencimento({this.hoje, this.estaSemana, this.proximaSemana});

  factory HomeTarefasPorVencimento.fromJson(Map<String, dynamic> json) =>
      _$HomeTarefasPorVencimentoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTarefasPorVencimentoToJson(this);
}

// NOVO: Tarefas por prioridade
@JsonSerializable()
class HomeTarefasPorPrioridade {
  @JsonKey(required: false, disallowNullValue: false)
  int? alta;

  @JsonKey(required: false, disallowNullValue: false)
  int? media;

  @JsonKey(required: false, disallowNullValue: false)
  int? baixa;

  HomeTarefasPorPrioridade({this.alta, this.media, this.baixa});

  factory HomeTarefasPorPrioridade.fromJson(Map<String, dynamic> json) =>
      _$HomeTarefasPorPrioridadeFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTarefasPorPrioridadeToJson(this);
}

// NOVO: Alerta crítico
@JsonSerializable()
class HomeAlertaCritico {
  @JsonKey(required: false, disallowNullValue: false)
  String? tipo;

  @JsonKey(required: false, disallowNullValue: false)
  String? mensagem;

  @JsonKey(required: false, disallowNullValue: false)
  int? loteId;

  @JsonKey(required: false, disallowNullValue: false)
  String? loteNome;

  @JsonKey(required: false, disallowNullValue: false)
  String? gravidade;

  @JsonKey(required: false, disallowNullValue: false)
  String? data;

  HomeAlertaCritico({
    this.tipo,
    this.mensagem,
    this.loteId,
    this.loteNome,
    this.gravidade,
    this.data,
  });

  factory HomeAlertaCritico.fromJson(Map<String, dynamic> json) =>
      _$HomeAlertaCriticoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeAlertaCriticoToJson(this);
}
