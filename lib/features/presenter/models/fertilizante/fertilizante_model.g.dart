// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fertilizante_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fertilizante _$FertilizanteFromJson(Map<String, dynamic> json) => Fertilizante(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      c_eletrica: (json['c_eletrica'] as num?)?.toDouble(),
      compatibilidade: json['compatibilidade'] as int?,
      solubilidade: (json['solubilidade'] as num?)?.toDouble(),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      solucoes_fertilizantes_concentradas:
          (json['solucoes_fertilizantes_concentradas'] as List<dynamic>?)
              ?.map((e) => SolucaoFertilizanteConcentrada.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
    )..fertilizantes_nutrientes = (json['fertilizantes_nutrientes']
            as List<dynamic>?)
        ?.map((e) => FertilizanteNutriente.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$FertilizanteToJson(Fertilizante instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'c_eletrica': instance.c_eletrica,
      'compatibilidade': instance.compatibilidade,
      'solubilidade': instance.solubilidade,
      'created_at': instance.created_at?.toIso8601String(),
      'fertilizantes_nutrientes':
          instance.fertilizantes_nutrientes?.map((e) => e.toJson()).toList(),
      'solucoes_fertilizantes_concentradas': instance
          .solucoes_fertilizantes_concentradas
          ?.map((e) => e.toJson())
          .toList(),
    };
