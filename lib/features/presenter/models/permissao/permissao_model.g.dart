// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permissao _$PermissaoFromJson(Map<String, dynamic> json) => Permissao(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PermissaoToJson(Permissao instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'created_at': instance.created_at?.toIso8601String(),
    };
