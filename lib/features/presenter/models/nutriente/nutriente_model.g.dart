// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutriente_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nutriente _$NutrienteFromJson(Map<String, dynamic> json) => Nutriente(
      id: (json['id'] as num?)?.toInt(),
      nome: json['nome'] as String?,
      sigla: json['sigla'] as String?,
      fertilizantes_nutrientes: (json['fertilizantes_nutrientes']
              as List<dynamic>?)
          ?.map(
              (e) => FertilizanteNutriente.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NutrienteToJson(Nutriente instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'sigla': instance.sigla,
      'fertilizantes_nutrientes':
          instance.fertilizantes_nutrientes?.map((e) => e.toJson()).toList(),
    };
