// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'permissao_model.g.dart';

// Função helper para converter int ou String para String
String? _parseToString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  return value.toString();
}

@JsonSerializable(explicitToJson: true)
class Permissao {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToString,
  )
  String? id;
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
