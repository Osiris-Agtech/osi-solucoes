// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
      id: _parseToInt(json['id']),
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      senha: json['senha'] as String?,
      cod_acesso: json['cod_acesso'] as String?,
      acesso_externo: _parseToBool(json['acesso_externo']),
      ativo: _parseToBool(json['ativo']),
      created_at: _parseToDateTime(json['created_at']),
      fk_pessoas_id: _parseToInt(json['fk_pessoas_id']),
      pessoa: json['pessoa'] == null
          ? null
          : Pessoa.fromJson(json['pessoa'] as Map<String, dynamic>),
      contas: (json['contas'] as List<dynamic>?)
          ?.map((e) => ConectaConta.fromJson(e as Map<String, dynamic>))
          .toList(),
      selected_conta: json['selected_conta'] == null
          ? null
          : ConectaConta.fromJson(
              json['selected_conta'] as Map<String, dynamic>),
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
      'fk_pessoas_id': instance.fk_pessoas_id,
      'pessoa': instance.pessoa?.toJson(),
      'contas': instance.contas?.map((e) => e.toJson()).toList(),
      'selected_conta': instance.selected_conta?.toJson(),
    };
