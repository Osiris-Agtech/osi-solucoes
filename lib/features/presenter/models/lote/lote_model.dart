// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/lotesAtividades/lotes_atividades_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../cultura/cultura_model.dart';
import '../protocolo/protocolo_model.dart';

part 'lote_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Lote {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  int? fase_dias;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? fase_data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? registro_data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? semeadura_data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? transplantio_data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? colheita_data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false)
  int? proxima_fase;
  @JsonKey(required: false, disallowNullValue: false)
  bool? ativo;
  @JsonKey(required: false, disallowNullValue: false)
  int? bandeijas_semeadas;
  @JsonKey(required: false, disallowNullValue: false)
  int? mudas_transplantadas;
  @JsonKey(required: false, disallowNullValue: false)
  int? plantas_colhidas;
  @JsonKey(required: false, disallowNullValue: false)
  int? embalagens_produzidas;
  @JsonKey(required: false, disallowNullValue: false)
  Cultura? cultura;
  @JsonKey(required: false, disallowNullValue: false)
  Agenda? agenda;
  // @JsonKey(required: false, disallowNullValue: false)
  // Fase? fase;
  @JsonKey(required: false, disallowNullValue: false)
  Reservatorio? reservatorio;
  @JsonKey(required: false, disallowNullValue: false)
  Setor? setor;
  @JsonKey(required: false, disallowNullValue: false)
  Protocolo? protocolo;
  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<LotesAtividades>? lotes_atividades;

  Lote({
    this.id,
    this.nome,
    this.fase_dias,
    this.fase_data,
    this.registro_data,
    this.semeadura_data,
    this.transplantio_data,
    this.colheita_data,
    this.proxima_fase,
    this.ativo,
    this.bandeijas_semeadas,
    this.mudas_transplantadas,
    this.plantas_colhidas,
    this.embalagens_produzidas,
    this.reservatorio,
    this.setor,
    this.cultura,
    this.protocolo,
    this.lotes_atividades,
    this.agenda,
    this.deleted_at,
  });

  factory Lote.fromJson(Map<String, dynamic> json) => _$LoteFromJson(json);

  Map<String, dynamic> toJson() => _$LoteToJson(this);

  toMap() {
    return {
      'id': id,
      'nome': nome,
      'fase_dias': fase_dias,
      'fase_data': fase_data?.toIso8601String(),
      'registro_data': registro_data?.toIso8601String(),
      'semeadura_data': semeadura_data?.toIso8601String(),
    };
  }
}

class LoteByFilter {
  bool selected;
  String key;
  List<LoteSelection> lotesSelection;

  LoteByFilter({
    required this.selected,
    required this.key,
    required this.lotesSelection,
  });
}

class LoteSelection {
  bool selected;
  Lote lote;

  LoteSelection({
    required this.selected,
    required this.lote,
  });
}
