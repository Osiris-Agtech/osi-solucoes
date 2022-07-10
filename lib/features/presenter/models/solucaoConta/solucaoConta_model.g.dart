// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solucaoConta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolucaoConta _$SolucaoContaFromJson(Map<String, dynamic> json) => SolucaoConta(
      id: json['id'] as int?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      conta_original: json['conta_original'] as int?,
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      solucao: json['solucao'] == null
          ? null
          : SolucaoNutritiva.fromJson(json['solucao'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SolucaoContaToJson(SolucaoConta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at?.toIso8601String(),
      'conta_original': instance.conta_original,
      'conta': instance.conta?.toJson(),
      'solucao': instance.solucao?.toJson(),
    };
