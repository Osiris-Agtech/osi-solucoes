// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDashboard _$HomeDashboardFromJson(Map<String, dynamic> json) =>
    HomeDashboard(
      resumo: json['resumo'] == null
          ? null
          : HomeResumo.fromJson(json['resumo'] as Map<String, dynamic>),
      tarefas: json['tarefas'] == null
          ? null
          : HomeTarefas.fromJson(json['tarefas'] as Map<String, dynamic>),
      producao: json['producao'] == null
          ? null
          : HomeProducao.fromJson(json['producao'] as Map<String, dynamic>),
      culturas: (json['culturas'] as List<dynamic>?)
          ?.map((e) => HomeCultura.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDashboardToJson(HomeDashboard instance) =>
    <String, dynamic>{
      'resumo': instance.resumo?.toJson(),
      'tarefas': instance.tarefas?.toJson(),
      'producao': instance.producao?.toJson(),
      'culturas': instance.culturas?.map((e) => e.toJson()).toList(),
    };

HomeResumo _$HomeResumoFromJson(Map<String, dynamic> json) => HomeResumo(
      totalLotes: (json['totalLotes'] as num?)?.toInt(),
      lotesAtivos: (json['lotesAtivos'] as num?)?.toInt(),
      lotesFinalizados: (json['lotesFinalizados'] as num?)?.toInt(),
      taxaConclusao: (json['taxaConclusao'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeResumoToJson(HomeResumo instance) =>
    <String, dynamic>{
      'totalLotes': instance.totalLotes,
      'lotesAtivos': instance.lotesAtivos,
      'lotesFinalizados': instance.lotesFinalizados,
      'taxaConclusao': instance.taxaConclusao,
    };

HomeTarefas _$HomeTarefasFromJson(Map<String, dynamic> json) => HomeTarefas(
      pendentesHoje: (json['pendentesHoje'] as num?)?.toInt(),
      pendentesSemana: (json['pendentesSemana'] as num?)?.toInt(),
      atrasadas: (json['atrasadas'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeTarefasToJson(HomeTarefas instance) =>
    <String, dynamic>{
      'pendentesHoje': instance.pendentesHoje,
      'pendentesSemana': instance.pendentesSemana,
      'atrasadas': instance.atrasadas,
    };

HomeProducao _$HomeProducaoFromJson(Map<String, dynamic> json) => HomeProducao(
      totalPlantasColhidas: (json['totalPlantasColhidas'] as num?)?.toInt(),
      totalEmbalagensProduzidas:
          (json['totalEmbalagensProduzidas'] as num?)?.toInt(),
      lotesComColheitaProxima:
          (json['lotesComColheitaProxima'] as num?)?.toInt(),
      periodoInicio: json['periodoInicio'] as String?,
      periodoFim: json['periodoFim'] as String?,
    );

Map<String, dynamic> _$HomeProducaoToJson(HomeProducao instance) =>
    <String, dynamic>{
      'totalPlantasColhidas': instance.totalPlantasColhidas,
      'totalEmbalagensProduzidas': instance.totalEmbalagensProduzidas,
      'lotesComColheitaProxima': instance.lotesComColheitaProxima,
      'periodoInicio': instance.periodoInicio,
      'periodoFim': instance.periodoFim,
    };

HomeCultura _$HomeCulturaFromJson(Map<String, dynamic> json) => HomeCultura(
      nome: json['nome'] as String?,
      quantidade: (json['quantidade'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeCulturaToJson(HomeCultura instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'quantidade': instance.quantidade,
    };
