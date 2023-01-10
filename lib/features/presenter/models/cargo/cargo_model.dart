// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/cargoPermissao/cargo_permissao_model.dart';

import '../conectaConta/conectaConta_model.dart';

part 'cargo_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Cargo {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? cargo;
  @JsonKey(required: false, disallowNullValue: false)
  List<CargoPermissao>? permissoes;
  @JsonKey(required: false, disallowNullValue: false)
  List<ConectaConta>? usuarios;

  Cargo({
    this.id,
    this.cargo,
    this.permissoes,
    this.usuarios,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoToJson(this);
}
