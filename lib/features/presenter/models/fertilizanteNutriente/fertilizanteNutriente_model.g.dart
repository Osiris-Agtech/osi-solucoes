// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fertilizanteNutriente_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FertilizanteNutriente _$FertilizanteNutrienteFromJson(
        Map<String, dynamic> json) =>
    FertilizanteNutriente(
      id: json['id'] as int?,
      teor_nutriente: json['teor_nutriente'] as String?,
      fertilizante: json['fertilizante'] == null
          ? null
          : Fertilizante.fromJson(json['fertilizante'] as Map<String, dynamic>),
      nutriente: json['nutriente'] == null
          ? null
          : Nutriente.fromJson(json['nutriente'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FertilizanteNutrienteToJson(
        FertilizanteNutriente instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teor_nutriente': instance.teor_nutriente,
      'fertilizante': instance.fertilizante?.toJson(),
      'nutriente': instance.nutriente?.toJson(),
    };
