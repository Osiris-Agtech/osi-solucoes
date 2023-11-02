// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

part 'agenda_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Agenda {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? titulo;
  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;
  @JsonKey(required: false, disallowNullValue: false)
  bool? ativo;
  @JsonKey(required: false, disallowNullValue: false)
  bool? alerta;
  @JsonKey(required: false, disallowNullValue: false)
  bool? finalizado;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? data;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? updated_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  Lote? lote;
  @JsonKey(required: false, disallowNullValue: false)
  Usuario? usuario;

  Agenda({
    this.id,
    this.titulo,
    this.descricao,
    this.ativo,
    this.alerta,
    this.finalizado,
    this.data,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.conta,
    this.lote,
    this.usuario,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) => _$AgendaFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaToJson(this);
}
