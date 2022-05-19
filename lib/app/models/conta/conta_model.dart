// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/app/models/conectaConta/conectaConta_model.dart';

part 'conta_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Conta {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nivel;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? imagem;
  @JsonKey(required: false, disallowNullValue: false)
  String? cnpj;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<ConectaConta>? usuarios;

  Conta({
    this.id,
    this.nivel,
    this.nome,
    this.imagem,
    this.cnpj,
    this.created_at,
    this.usuarios,
  });

  factory Conta.fromJson(Map<String, dynamic> json) => _$ContaFromJson(json);

  Map<String, dynamic> toJson() => _$ContaToJson(this);
}
