// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

part 'solucaoNutritiva_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoNutritiva {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? c_eletrica;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  List<Reservatorio>? reservatorios;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<SolucaoConta>? solucoes_contas;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<SolucaoFertilizanteConcentrada>? solucoes_fertilizantes_concentradas;

  SolucaoNutritiva({
    this.id,
    this.nome,
    this.c_eletrica,
    this.created_at,
    this.reservatorios,
  });

  factory SolucaoNutritiva.fromJson(Map<String, dynamic> json) =>
      _$SolucaoNutritivaFromJson(json);

  Map<String, dynamic> toJson() => _$SolucaoNutritivaToJson(this);
}
