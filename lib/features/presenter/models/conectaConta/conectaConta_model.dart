// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

import '../cargo/cargo_model.dart';
import '../conta/conta_model.dart';
import '../usuario/usuario_model.dart';

part 'conectaConta_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConectaConta {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  Cargo? cargo;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  Usuario? usuario;

  ConectaConta({
    this.id,
    this.cargo,
    this.conta,
    this.usuario,
  });

  factory ConectaConta.fromJson(Map<String, dynamic> json) =>
      _$ConectaContaFromJson(json);

  Map<String, dynamic> toJson() => _$ConectaContaToJson(this);
}
