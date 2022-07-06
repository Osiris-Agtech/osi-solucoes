// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucaoNutritiva_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolucaoNutritiva _$SolucaoNutritivaFromJson(Map<String, dynamic> json) =>
    SolucaoNutritiva(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      c_eletrica: json['c_eletrica'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      reservatorios: (json['reservatorios'] as List<dynamic>?)
          ?.map((e) => Reservatorio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SolucaoNutritivaToJson(SolucaoNutritiva instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'c_eletrica': instance.c_eletrica,
      'created_at': instance.created_at?.toIso8601String(),
      'reservatorios': instance.reservatorios?.map((e) => e.toJson()).toList(),
    };
