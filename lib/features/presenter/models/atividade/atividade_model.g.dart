// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atividade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Atividade _$AtividadeFromJson(Map<String, dynamic> json) => Atividade(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
      privado: json['privado'] as bool?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      lotes_atividades: (json['lotes_atividades'] as List<dynamic>?)
          ?.map((e) => LotesAtividades.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AtividadeToJson(Atividade instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'privado': instance.privado,
      'created_at': instance.created_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'lotes_atividades':
          instance.lotes_atividades?.map((e) => e.toJson()).toList(),
    };
