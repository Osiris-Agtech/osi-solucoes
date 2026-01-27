// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

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

  HomeDashboard({
    this.resumo,
    this.tarefas,
    this.producao,
    this.culturas,
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

  HomeResumo({
    this.totalLotes,
    this.lotesAtivos,
    this.lotesFinalizados,
    this.taxaConclusao,
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

  HomeTarefas({
    this.pendentesHoje,
    this.pendentesSemana,
    this.atrasadas,
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

  HomeProducao({
    this.totalPlantasColhidas,
    this.totalEmbalagensProduzidas,
    this.lotesComColheitaProxima,
    this.periodoInicio,
    this.periodoFim,
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

  HomeCultura({
    this.nome,
    this.quantidade,
  });

  factory HomeCultura.fromJson(Map<String, dynamic> json) =>
      _$HomeCulturaFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCulturaToJson(this);
}
