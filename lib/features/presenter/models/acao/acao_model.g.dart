// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Acao _$AcaoFromJson(Map<String, dynamic> json) => Acao(
      id: json['id'] as int?,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String?,
      duracao_dias: json['duracao_dias'] as int?,
      alerta: json['alerta'] as bool?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      protocolo: json['protocolo'] == null
          ? null
          : Protocolo.fromJson(json['protocolo'] as Map<String, dynamic>),
      fase: json['fase'] == null
          ? null
          : Fase.fromJson(json['fase'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AcaoToJson(Acao instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'duracao_dias': instance.duracao_dias,
      'alerta': instance.alerta,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'protocolo': instance.protocolo?.toJson(),
      'fase': instance.fase?.toJson(),
    };
