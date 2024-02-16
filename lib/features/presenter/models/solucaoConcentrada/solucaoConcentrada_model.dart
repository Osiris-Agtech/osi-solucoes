// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';

part 'solucaoConcentrada_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoConcentrada {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  double? volume;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  double? fator_concentracao;
  @JsonKey(required: false, disallowNullValue: false)
  List<SolucaoFertilizanteConcentrada>? solucoes_fertilizantes_concentradas;

  SolucaoConcentrada({
    this.id,
    this.nome,
    this.volume,
    this.created_at,
    this.fator_concentracao,
    this.solucoes_fertilizantes_concentradas,
  });

  factory SolucaoConcentrada.fromJson(Map<String, dynamic> json) =>
      _$SolucaoConcentradaFromJson(json);

  Map<String, dynamic> toJson() => _$SolucaoConcentradaToJson(this);
}
