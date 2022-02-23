import 'package:json_annotation/json_annotation.dart';

part 'usuario_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Usuario {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? sobrenome;
  @JsonKey(required: false, disallowNullValue: false)
  String? logradouro;
  @JsonKey(required: false, disallowNullValue: false)
  String? complemento;
  @JsonKey(required: false, disallowNullValue: false)
  String? bairro;
  @JsonKey(required: false, disallowNullValue: false)
  String? cidade;

  @JsonKey(required: false, disallowNullValue: false)
  String? estado;
  @JsonKey(required: false, disallowNullValue: false)
  String? pais;
  @JsonKey(required: false, disallowNullValue: false)
  String? email;

  Usuario(
      {this.id,
      this.nome,
      this.sobrenome,
      this.logradouro,
      this.complemento,
      this.bairro,
      this.cidade,
      this.estado,
      this.pais,
      this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
