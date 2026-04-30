// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';

part 'fertilizante_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Fertilizante {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? origin;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false)
  String? c_eletrica;
  @JsonKey(required: false, disallowNullValue: false)
  int? compatibilidade;
  @JsonKey(required: false, disallowNullValue: false)
  double? solubilidade;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  List<FertilizanteNutriente>? fertilizantes_nutrientes;
  @JsonKey(required: false, disallowNullValue: false)
  List<SolucaoFertilizanteConcentrada>? solucoes_fertilizantes_concentradas;

  Fertilizante({
    this.id,
    this.nome,
    this.origin,
    this.deleted_at,
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

class SelecaoFertilizante {
  bool selected;
  Fertilizante fertilizante;

  SelecaoFertilizante({
    required this.selected,
    required this.fertilizante,
  });
}

class ItemFertilizante {
  Fertilizante fertilizante;
  bool isExpanded;
  String quantidade;
  ItemFertilizante({
    this.isExpanded = false,
    required this.fertilizante,
    required this.quantidade,
  });
}
