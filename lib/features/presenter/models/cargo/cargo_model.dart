// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/cargoPermissao/cargo_permissao_model.dart';

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
  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<ConcatenatedPermission>? concatenatedPermission;

  Cargo({
    this.id,
    this.cargo,
    this.permissoes,
    this.usuarios,
    this.concatenatedPermission,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ConcatenatedPermission {
  @JsonKey(required: false, disallowNullValue: false)
  String? title;
  @JsonKey(required: false, disallowNullValue: false)
  bool? permissionWrite;
  @JsonKey(required: false, disallowNullValue: false)
  bool? permissionRead;

  ConcatenatedPermission({
    this.title,
    this.permissionRead = false,
    this.permissionWrite = false,
  });

  factory ConcatenatedPermission.fromJson(Map<String, dynamic> json) =>
      _$ConcatenatedPermissionFromJson(json);

  Map<String, dynamic> toJson() => _$ConcatenatedPermissionToJson(this);
}
