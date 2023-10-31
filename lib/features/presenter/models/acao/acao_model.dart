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
  });

  factory Acao.fromJson(Map<String, dynamic> json) => _$AcaoFromJson(json);

  Map<String, dynamic> toJson() => _$AcaoToJson(this);
}
