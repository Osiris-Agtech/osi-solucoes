// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocolo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Protocolo _$ProtocoloFromJson(Map<String, dynamic> json) => Protocolo(
      id: (json['id'] as num?)?.toInt(),
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
      implantacao: json['implantacao'] as String?,
      sistema_cultivo: json['sistema_cultivo'] as String?,
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
      acao: (json['acoes'] as List<dynamic>?)
          ?.map((e) => Acao.fromJson(e as Map<String, dynamic>))
          .toList(),
      cultura: json['cultura'] == null
          ? null
          : Cultura.fromJson(json['cultura'] as Map<String, dynamic>),
      lotes: (json['lotes'] as List<dynamic>?)
              ?.map((e) => Lote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProtocoloToJson(Protocolo instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'sistema_cultivo': instance.sistema_cultivo,
      'implantacao': instance.implantacao,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'acoes': instance.acao?.map((e) => e.toJson()).toList(),
      'cultura': instance.cultura?.toJson(),
      'conta': instance.conta?.toJson(),
      'lotes': instance.lotes.map((e) => e.toJson()).toList(),
    };
