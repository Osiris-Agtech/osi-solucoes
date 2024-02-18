// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/cargo/cargo_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/permissao/permissao_model.dart';

part 'cargo_permissao_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CargoPermissao {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  Cargo? cargo;
  @JsonKey(required: false, disallowNullValue: false)
  Permissao? permissao;
  @JsonKey(required: false, disallowNullValue: false)
  bool? status;

  CargoPermissao({
    this.id,
    this.cargo,
    this.permissao,
    this.status,
  });

  factory CargoPermissao.fromJson(Map<String, dynamic> json) =>
      _$CargoPermissaoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoPermissaoToJson(this);
}
