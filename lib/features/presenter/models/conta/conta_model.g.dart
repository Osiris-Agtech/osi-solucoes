// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conta _$ContaFromJson(Map<String, dynamic> json) => Conta(
      id: _parseToInt(json['id']),
      nivel: _parseIntToString(json['nivel']),
      nome: json['nome'] as String?,
      imagem: json['imagem'] as String?,
      cnpj: json['cnpj'] as String?,
      created_at: _parseToDateTime(json['created_at']),
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
