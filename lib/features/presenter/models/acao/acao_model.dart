// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

part 'acao_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Acao {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? titulo;
  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;
  @JsonKey(required: false, disallowNullValue: false)
  int? duracao_dias;
  @JsonKey(required: false, disallowNullValue: false)
  bool? alerta;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? updated_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false)
  Protocolo? protocolo;
  @JsonKey(required: false, disallowNullValue: false)
  Fase? fase;
  @JsonKey(required: false, disallowNullValue: false)
  int? duracao_dias_real;

  Acao({
    this.id,
    this.titulo,
    this.descricao,
    this.duracao_dias,
    this.alerta,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.protocolo,
    this.fase,
    this.duracao_dias_real,
  });

  factory Acao.fromJson(Map<String, dynamic> json) => _$AcaoFromJson(json);

  Map<String, dynamic> toJson() => _$AcaoToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'duracao_dias': duracao_dias,
      'duracao_dias_real': duracao_dias_real,
      'alerta': alerta,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
      'deleted_at': deleted_at?.toIso8601String(),
      'fase': fase?.toMap(),
    };
  }
}
