// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/nutriente/nutriente_model.dart';

part 'fertilizanteNutriente_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FertilizanteNutriente {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? teor_nutriente;
  @JsonKey(required: false, disallowNullValue: false)
  Fertilizante? fertilizante;
  @JsonKey(required: false, disallowNullValue: false)
  Nutriente? nutriente;

  FertilizanteNutriente({
    this.id,
    this.teor_nutriente,
    this.fertilizante,
    this.nutriente,
  });

  factory FertilizanteNutriente.fromJson(Map<String, dynamic> json) =>
      _$FertilizanteNutrienteFromJson(json);

  Map<String, dynamic> toJson() => _$FertilizanteNutrienteToJson(this);
}
