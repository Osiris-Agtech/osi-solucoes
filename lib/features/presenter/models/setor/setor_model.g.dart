// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setor _$SetorFromJson(Map<String, dynamic> json) => Setor(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      area: json['area'] == null
          ? null
          : Estufa.fromJson(json['area'] as Map<String, dynamic>),
      reservatorio: json['reservatorio'] == null
          ? null
          : Reservatorio.fromJson(json['reservatorio'] as Map<String, dynamic>),
      lotes: (json['lotes'] as List<dynamic>?)
          ?.map((e) => Lote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SetorToJson(Setor instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'created_at': instance.created_at?.toIso8601String(),
      'area': instance.area?.toJson(),
      'reservatorio': instance.reservatorio?.toJson(),
      'lotes': instance.lotes?.map((e) => e.toJson()).toList(),
    };
