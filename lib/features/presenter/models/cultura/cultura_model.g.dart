// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultura_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cultura _$CulturaFromJson(Map<String, dynamic> json) => Cultura(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      privado: json['privado'] as bool?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      lotes: (json['lotes'] as List<dynamic>?)
          ?.map((e) => Lote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CulturaToJson(Cultura instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'privado': instance.privado,
      'created_at': instance.created_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'lotes': instance.lotes?.map((e) => e.toJson()).toList(),
    };
