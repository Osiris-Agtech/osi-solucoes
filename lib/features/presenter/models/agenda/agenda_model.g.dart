// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agenda _$AgendaFromJson(Map<String, dynamic> json) => Agenda(
      id: json['id'] as int?,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String?,
      ativo: json['ativo'] as bool?,
      alerta: json['alerta'] as bool?,
      finalizado: json['finalizado'] as bool?,
      data:
          json['data'] == null ? null : DateTime.parse(json['data'] as String),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      lote: json['lote'] == null
          ? null
          : Lote.fromJson(json['lote'] as Map<String, dynamic>),
      usuario: json['usuario'] == null
          ? null
          : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgendaToJson(Agenda instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'ativo': instance.ativo,
      'alerta': instance.alerta,
      'finalizado': instance.finalizado,
      'data': instance.data?.toIso8601String(),
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'lote': instance.lote?.toJson(),
      'usuario': instance.usuario?.toJson(),
    };
