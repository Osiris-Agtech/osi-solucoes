// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';

part 'fase_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Fase {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;
  @JsonKey(required: false, disallowNullValue: false)
  int? duracao_dias;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? updated_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  List<Acao>? acao;

  Fase({
    this.id,
    this.nome,
    this.descricao,
    this.duracao_dias,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.conta,
    this.acao,
  });

  factory Fase.fromJson(Map<String, dynamic> json) => _$FaseFromJson(json);

  Map<String, dynamic> toJson() => _$FaseToJson(this);
}
