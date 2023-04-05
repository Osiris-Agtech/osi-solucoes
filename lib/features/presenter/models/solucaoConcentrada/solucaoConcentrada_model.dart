// ignore_for_file: non_constant_identifier_names, file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';

part 'solucaoConcentrada_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SolucaoConcentrada {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false, fromJson: _stringFromJson)
  double? volume;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false, fromJson: _stringFromJson)
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

  static double? _stringFromJson(Object? json) {
    if (json == null) return 1.0;

    if (json is String) {
      return double.tryParse(json) ?? 0.0;
    }

    return (json as num) * 1.0;
  }
}
