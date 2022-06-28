import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'solucaoFertilizanteConcentrada_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoFertilizanteConcentrada {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoConcentrada? concentrada;
  @JsonKey(required: false, disallowNullValue: false)
  Fertilizante? fertilizante;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoNutritiva? solucao;

  SolucaoFertilizanteConcentrada({
    this.id,
    this.concentrada,
    this.fertilizante,
    this.solucao,
  });

  factory SolucaoFertilizanteConcentrada.fromJson(Map<String, dynamic> json) =>
      _$SolucaoFertilizanteConcentradaFromJson(json);

  Map<String, dynamic> toJson() => _$SolucaoFertilizanteConcentradaToJson(this);
}
