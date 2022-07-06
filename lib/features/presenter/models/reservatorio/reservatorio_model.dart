// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'reservatorio_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Reservatorio {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? volume;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoNutritiva? solucao;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<Lote>? lotes;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<Setor>? setores;

  Reservatorio({
    this.id,
    this.nome,
    this.volume,
    this.created_at,
    this.conta,
    this.solucao,
  });

  factory Reservatorio.fromJson(Map<String, dynamic> json) =>
      _$ReservatorioFromJson(json);

  Map<String, dynamic> toJson() => _$ReservatorioToJson(this);
}
