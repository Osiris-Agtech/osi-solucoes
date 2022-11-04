// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotes_atividades_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotesAtividades _$LotesAtividadesFromJson(Map<String, dynamic> json) =>
    LotesAtividades(
      id: json['id'] as int?,
      atividade: json['atividade'] == null
          ? null
          : Atividade.fromJson(json['atividade'] as Map<String, dynamic>),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      lote: json['lote'] == null
          ? null
          : Lote.fromJson(json['lote'] as Map<String, dynamic>),
      usuario: json['usuario'] == null
          ? null
          : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LotesAtividadesToJson(LotesAtividades instance) =>
    <String, dynamic>{
      'id': instance.id,
      'atividade': instance.atividade?.toJson(),
      'conta': instance.conta?.toJson(),
      'lote': instance.lote?.toJson(),
      'usuario': instance.usuario?.toJson(),
    };
