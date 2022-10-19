// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucaoFertilizanteConcentrada_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolucaoFertilizanteConcentrada _$SolucaoFertilizanteConcentradaFromJson(
        Map<String, dynamic> json) =>
    SolucaoFertilizanteConcentrada(
      id: json['id'] as int?,
      quantidade: json['quantidade'] as String?,
      concentrada: json['concentrada'] == null
          ? null
          : SolucaoConcentrada.fromJson(
              json['concentrada'] as Map<String, dynamic>),
      fertilizante: json['fertilizante'] == null
          ? null
          : Fertilizante.fromJson(json['fertilizante'] as Map<String, dynamic>),
      solucao: json['solucao'] == null
          ? null
          : SolucaoNutritiva.fromJson(json['solucao'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SolucaoFertilizanteConcentradaToJson(
        SolucaoFertilizanteConcentrada instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantidade': instance.quantidade,
      'concentrada': instance.concentrada?.toJson(),
      'fertilizante': instance.fertilizante?.toJson(),
      'solucao': instance.solucao?.toJson(),
    };
