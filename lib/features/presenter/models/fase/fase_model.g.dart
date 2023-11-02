// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fase _$FaseFromJson(Map<String, dynamic> json) => Fase(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
      duracao_dias: json['duracao_dias'] as int?,
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
      acao: (json['acao'] as List<dynamic>?)
          ?.map((e) => Acao.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FaseToJson(Fase instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'duracao_dias': instance.duracao_dias,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'acao': instance.acao?.map((e) => e.toJson()).toList(),
    };
