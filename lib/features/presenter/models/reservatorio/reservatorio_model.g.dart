// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservatorio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservatorio _$ReservatorioFromJson(Map<String, dynamic> json) => Reservatorio(
      id: (json['id'] as num?)?.toInt(),
      nome: json['nome'] as String?,
      volume: json['volume'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      solucao: json['solucao'] == null
          ? null
          : SolucaoNutritiva.fromJson(json['solucao'] as Map<String, dynamic>),
    )..lotes = (json['lotes'] as List<dynamic>?)
        ?.map((e) => Lote.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ReservatorioToJson(Reservatorio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'volume': instance.volume,
      'created_at': instance.created_at?.toIso8601String(),
      'conta': instance.conta?.toJson(),
      'solucao': instance.solucao?.toJson(),
      'lotes': instance.lotes?.map((e) => e.toJson()).toList(),
    };
