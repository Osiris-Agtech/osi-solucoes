import 'package:json_annotation/json_annotation.dart';

import '../usuario/usuario_model.dart';

part 'authentication_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Authentication {
  @JsonKey(required: false, disallowNullValue: false)
  Usuario? usuario;

  @JsonKey(required: false, disallowNullValue: false)
  String? token;

  @JsonKey(required: false, disallowNullValue: false)
  String? hierarquia;

  Authentication({
    this.usuario,
    this.token,
    this.hierarquia,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);
}
