// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conta _$ContaFromJson(Map<String, dynamic> json) => Conta(
      id: json['id'] as int?,
      nivel: json['nivel'] as String?,
      nome: json['nome'] as String?,
      imagem: json['imagem'] as String?,
      cnpj: json['cnpj'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      usuarios: (json['usuarios'] as List<dynamic>?)
              ?.map((e) => ConectaConta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ContaToJson(Conta instance) => <String, dynamic>{
      'id': instance.id,
      'nivel': instance.nivel,
      'nome': instance.nome,
      'imagem': instance.imagem,
      'cnpj': instance.cnpj,
      'created_at': instance.created_at?.toIso8601String(),
      'usuarios': instance.usuarios?.map((e) => e.toJson()).toList(),
    };
