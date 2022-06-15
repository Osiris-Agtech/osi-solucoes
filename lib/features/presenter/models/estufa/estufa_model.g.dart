// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estufa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Estufa _$EstufaFromJson(Map<String, dynamic> json) => Estufa(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      endereco: json['endereco'] as String?,
      setores: json['setores'] as int?,
      lotes: json['lotes'] as int?,
    );

Map<String, dynamic> _$EstufaToJson(Estufa instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'endereco': instance.endereco,
      'setores': instance.setores,
      'lotes': instance.lotes,
    };
