// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'solucaoConta_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoConta {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  int? conta_original;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  SolucaoNutritiva? solucao;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<SolucaoFertilizanteConcentrada>? solucoes_fertilizantes_concentradas;

  SolucaoConta({
    this.id,
    this.created_at,
    this.conta_original,
    this.conta,
    this.solucao,
  });

  factory SolucaoConta.fromJson(Map<String, dynamic> json) =>
      _$SolucaoContaFromJson(json);

  Map<String, dynamic> toJson() => _$SolucaoContaToJson(this);
}
