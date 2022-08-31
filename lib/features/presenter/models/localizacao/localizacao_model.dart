// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/estufa/estufa_model.dart';

part 'localizacao_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Localizacao {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? cep;

  @JsonKey(required: false, disallowNullValue: false)
  String? endereco;

  @JsonKey(required: false, disallowNullValue: false)
  String? bairro;

  @JsonKey(required: false, disallowNullValue: false)
  String? cidade;

  @JsonKey(required: false, disallowNullValue: false)
  String? estado;

  @JsonKey(required: false, disallowNullValue: false)
  String? pais;

  @JsonKey(required: false, disallowNullValue: false)
  String? complemento;

  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;

  @JsonKey(required: false, disallowNullValue: false)
  List<Estufa>? areas;

  Localizacao({
    this.id,
    this.cep,
    this.endereco,
    this.created_at,
    this.bairro,
    this.cidade,
    this.estado,
    this.pais,
    this.complemento,
  });

  factory Localizacao.fromJson(Map<String, dynamic> json) =>
      _$LocalizacaoFromJson(json);

  Map<String, dynamic> toJson() => _$LocalizacaoToJson(this);
}
