// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localizacao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Localizacao _$LocalizacaoFromJson(Map<String, dynamic> json) => Localizacao(
      id: (json['id'] as num?)?.toInt(),
      cep: json['cep'] as String?,
      endereco: json['endereco'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      bairro: json['bairro'] as String?,
      cidade: json['cidade'] as String?,
      numero: json['numero'] as String?,
      estado: json['estado'] as String?,
      pais: json['pais'] as String?,
      complemento: json['complemento'] as String?,
    )..areas = (json['areas'] as List<dynamic>?)
        ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$LocalizacaoToJson(Localizacao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cep': instance.cep,
      'endereco': instance.endereco,
      'bairro': instance.bairro,
      'cidade': instance.cidade,
      'numero': instance.numero,
      'estado': instance.estado,
      'pais': instance.pais,
      'complemento': instance.complemento,
      'created_at': instance.created_at?.toIso8601String(),
      'areas': instance.areas?.map((e) => e.toJson()).toList(),
    };
