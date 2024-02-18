// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucaoConcentrada_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolucaoConcentrada _$SolucaoConcentradaFromJson(Map<String, dynamic> json) =>
    SolucaoConcentrada(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      volume: (json['volume'] as num?)?.toDouble(),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      fator_concentracao: double.tryParse(json['fator_concentracao']),
      solucoes_fertilizantes_concentradas:
          (json['solucoes_fertilizantes_concentradas'] as List<dynamic>?)
              ?.map((e) => SolucaoFertilizanteConcentrada.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SolucaoConcentradaToJson(SolucaoConcentrada instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'volume': instance.volume,
      'created_at': instance.created_at?.toIso8601String(),
      'fator_concentracao': instance.fator_concentracao,
      'solucoes_fertilizantes_concentradas': instance
          .solucoes_fertilizantes_concentradas
          ?.map((e) => e.toJson())
          .toList(),
    };
