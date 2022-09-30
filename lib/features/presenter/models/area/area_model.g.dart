// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      descricao: json['descricao'] as String?,
      imagem: json['imagem'] as String?,
      tipo: json['tipo'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      localizacao: json['localizacao'] == null
          ? null
          : Localizacao.fromJson(json['localizacao'] as Map<String, dynamic>),
      setores: (json['setores'] as List<dynamic>?)
          ?.map((e) => Setor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'imagem': instance.imagem,
      'tipo': instance.tipo,
      'created_at': instance.created_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'localizacao': instance.localizacao?.toJson(),
      'setores': instance.setores?.map((e) => e.toJson()).toList(),
    };
