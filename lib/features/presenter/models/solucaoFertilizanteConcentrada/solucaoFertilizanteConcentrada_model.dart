// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'solucaoFertilizanteConcentrada_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoFertilizanteConcentrada {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? quantidade;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoConcentrada? concentrada;
  @JsonKey(required: false, disallowNullValue: false)
  Fertilizante? fertilizante;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoNutritiva? solucao;

  SolucaoFertilizanteConcentrada({
    this.id,
    this.quantidade,
    this.concentrada,
    this.fertilizante,
    this.solucao,
  });

  factory SolucaoFertilizanteConcentrada.fromJson(Map<String, dynamic> json) =>
      _$SolucaoFertilizanteConcentradaFromJson(json);

  Map<String, dynamic> toJson() => _$SolucaoFertilizanteConcentradaToJson(this);
}
