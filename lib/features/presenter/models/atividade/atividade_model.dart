// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lotesAtividades/lotes_atividades_model.dart';

part 'atividade_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Atividade {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;
  @JsonKey(required: false, disallowNullValue: false)
  bool? privado;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  List<LotesAtividades>? lotes_atividades;

  Atividade({
    this.id,
    this.nome,
    this.descricao,
    this.privado,
    this.created_at,
    this.conta,
    this.lotes_atividades,
  });

  factory Atividade.fromJson(Map<String, dynamic> json) =>
      _$AtividadeFromJson(json);

  Map<String, dynamic> toJson() => _$AtividadeToJson(this);
}
