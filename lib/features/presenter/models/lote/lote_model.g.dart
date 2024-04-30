// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lote _$LoteFromJson(Map<String, dynamic> json) => Lote(
      id: json['id'] as int?,
      nome: json['nome'] as String?,
      fase_dias: json['fase_dias'] as int?,
      fase_data: json['fase_data'] == null
          ? null
          : DateTime.parse(json['fase_data'] as String),
      registro_data: json['registro_data'] == null
          ? null
          : DateTime.parse(json['registro_data'] as String),
      semeadura_data: json['semeadura_data'] == null
          ? null
          : DateTime.parse(json['semeadura_data'] as String),
      transplantio_data: json['transplantio_data'] == null
          ? null
          : DateTime.parse(json['transplantio_data'] as String),
      colheita_data: json['colheita_data'] == null
          ? null
          : DateTime.parse(json['colheita_data'] as String),
      proxima_fase: json['proxima_fase'] as int?,
      ativo: json['ativo'] as bool?,
      bandeijas_semeadas: json['bandeijas_semeadas'] as int?,
      mudas_transplantadas: json['mudas_transplantadas'] as int?,
      plantas_colhidas: json['plantas_colhidas'] as int?,
      embalagens_produzidas: json['embalagens_produzidas'] as int?,
      reservatorio: json['reservatorio'] == null
          ? null
          : Reservatorio.fromJson(json['reservatorio'] as Map<String, dynamic>),
      setor: json['setor'] == null
          ? null
          : Setor.fromJson(json['setor'] as Map<String, dynamic>),
      cultura: json['cultura'] == null
          ? null
          : Cultura.fromJson(json['cultura'] as Map<String, dynamic>),
      protocolo: json['protocolo'] == null
          ? null
          : Protocolo.fromJson(json['protocolo'] as Map<String, dynamic>),
      lotes_atividades: (json['lotes_atividades'] as List<dynamic>?)
              ?.map((e) => LotesAtividades.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      agenda: json['agenda'] == null
          ? null
          : Agenda.fromJson(json['agenda'] as Map<String, dynamic>),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$LoteToJson(Lote instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'fase_dias': instance.fase_dias,
      'fase_data': instance.fase_data?.toIso8601String(),
      'registro_data': instance.registro_data?.toIso8601String(),
      'semeadura_data': instance.semeadura_data?.toIso8601String(),
      'transplantio_data': instance.transplantio_data?.toIso8601String(),
      'colheita_data': instance.colheita_data?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'proxima_fase': instance.proxima_fase,
      'ativo': instance.ativo,
      'bandeijas_semeadas': instance.bandeijas_semeadas,
      'mudas_transplantadas': instance.mudas_transplantadas,
      'plantas_colhidas': instance.plantas_colhidas,
      'embalagens_produzidas': instance.embalagens_produzidas,
      'cultura': instance.cultura?.toJson(),
      'agenda': instance.agenda?.toJson(),
      'reservatorio': instance.reservatorio?.toJson(),
      'setor': instance.setor?.toJson(),
      'protocolo': instance.protocolo?.toJson(),
      'lotes_atividades':
          instance.lotes_atividades?.map((e) => e.toJson()).toList(),
    };
