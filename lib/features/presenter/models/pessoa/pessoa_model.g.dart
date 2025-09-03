// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pessoa _$PessoaFromJson(Map<String, dynamic> json) => Pessoa(
      id: _parseToInt(json['id']),
      nome: json['nome'] as String?,
      sobrenome: json['sobrenome'] as String?,
      telefone: json['telefone'] as String?,
      imagem: json['imagem'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      pais: json['pais'] as String?,
      created_at: _parseToDateTime(json['created_at']),
      usuarios: (json['usuarios'] as List<dynamic>?)
              ?.map((e) => Usuario.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PessoaToJson(Pessoa instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'sobrenome': instance.sobrenome,
      'telefone': instance.telefone,
      'imagem': instance.imagem,
      'cidade': instance.cidade,
      'estado': instance.estado,
      'pais': instance.pais,
      'created_at': instance.created_at?.toIso8601String(),
      'usuarios': instance.usuarios?.map((e) => e.toJson()).toList(),
    };
