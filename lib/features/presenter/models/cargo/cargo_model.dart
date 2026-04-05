// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/cargoPermissao/cargo_permissao_model.dart';

import '../conectaConta/conectaConta_model.dart';

part 'cargo_model.g.dart';

// Função helper para converter String para int
int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) return value.toInt();
  return null;
}

// Função helper para converter String para bool
bool? _parseToBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) {
    final lowerValue = value.toLowerCase();
    return lowerValue == 'true' || lowerValue == '1';
  }
  if (value is int) return value == 1;
  return null;
}

@JsonSerializable(explicitToJson: true)
class Cargo {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
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

  factory Cargo.fromJson(Map<String, dynamic> json) =>
      _$CargoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoToJson(this);

}

@JsonSerializable(explicitToJson: true)
class ConcatenatedPermission {
  @JsonKey(required: false, disallowNullValue: false)
  String? title;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToBool,
  )
  bool? permissionWrite;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToBool,
  )
  bool? permissionRead;

  ConcatenatedPermission({
    this.title,
    this.permissionRead = false,
    this.permissionWrite = false,
  });

  factory ConcatenatedPermission.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 ConcatenatedPermission JSON: $json');
      return _$ConcatenatedPermissionFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão ConcatenatedPermission: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ConcatenatedPermissionToJson(this);

  @override
  String toString() {
    return 'ConcatenatedPermission{title: $title, read: $permissionRead, write: $permissionWrite}';
  }
}
