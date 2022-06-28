// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';

part 'fertilizante_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Fertilizante {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  double? c_eletrica;
  @JsonKey(required: false, disallowNullValue: false)
  int? compatibilidade;
  @JsonKey(required: false, disallowNullValue: false)
  double? solubilidade;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<FertilizanteNutriente>? fertilizantes_nutrientes;
  @JsonKey(required: false, disallowNullValue: false)
  List<SolucaoFertilizanteConcentrada>? solucoes_fertilizantes_concentradas;

  Fertilizante({
    this.id,
    this.nome,
    this.c_eletrica,
    this.compatibilidade,
    this.solubilidade,
    this.created_at,
    this.solucoes_fertilizantes_concentradas,
  });

  factory Fertilizante.fromJson(Map<String, dynamic> json) =>
      _$FertilizanteFromJson(json);

  Map<String, dynamic> toJson() => _$FertilizanteToJson(this);
}
