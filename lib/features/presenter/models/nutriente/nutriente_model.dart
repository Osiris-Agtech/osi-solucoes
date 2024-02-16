// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';

part 'nutriente_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Nutriente {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? sigla;
  @JsonKey(required: false, disallowNullValue: false)
  List<FertilizanteNutriente>? fertilizantes_nutrientes;

  Nutriente({
    this.id,
    this.nome,
    this.sigla,
    this.fertilizantes_nutrientes,
  });

  factory Nutriente.fromJson(Map<String, dynamic> json) =>
      _$NutrienteFromJson(json);

  Map<String, dynamic> toJson() => _$NutrienteToJson(this);
}
