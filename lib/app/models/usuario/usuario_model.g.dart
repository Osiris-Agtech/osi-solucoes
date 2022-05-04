// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      senha: json['senha'] as String?,
      cod_acesso: json['cod_acesso'] as String?,
      acesso_externo: json['acesso_externo'] as bool?,
      ativo: json['ativo'] as bool?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      pessoa: json['pessoa'] == null
          ? null
          : Pessoa.fromJson(json['pessoa'] as Map<String, dynamic>),
      contas: (json['contas'] as List<dynamic>?)
          ?.map((e) => ConectaConta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      'senha': instance.senha,
      'cod_acesso': instance.cod_acesso,
      'acesso_externo': instance.acesso_externo,
      'ativo': instance.ativo,
      'created_at': instance.created_at?.toIso8601String(),
      'pessoa': instance.pessoa?.toJson(),
      'contas': instance.contas?.map((e) => e.toJson()).toList(),
    };
