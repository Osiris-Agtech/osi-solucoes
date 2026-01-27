// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'permissao_model.g.dart';

int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

@JsonSerializable(explicitToJson: true)
class Permissao {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;

  Permissao({
    this.id,
    this.nome,
    this.created_at,
  });

  factory Permissao.fromJson(Map<String, dynamic> json) =>
      _$PermissaoFromJson(json);

  Map<String, dynamic> toJson() => _$PermissaoToJson(this);
}
