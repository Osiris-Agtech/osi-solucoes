// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../usuario/usuario_model.dart';

part 'pessoa_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Pessoa {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? sobrenome;
  @JsonKey(required: false, disallowNullValue: false)
  String? telefone;
  @JsonKey(required: false, disallowNullValue: false)
  String? imagem;
  @JsonKey(required: false, disallowNullValue: false)
  String? cidade;
  @JsonKey(required: false, disallowNullValue: false)
  String? estado;
  @JsonKey(required: false, disallowNullValue: false)
  String? pais;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<Usuario>? usuarios;

  Pessoa({
    this.id,
    this.nome,
    this.sobrenome,
    this.telefone,
    this.imagem,
    this.cidade,
    this.estado,
    this.pais,
    this.created_at,
    this.usuarios,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) => _$PessoaFromJson(json);

  Map<String, dynamic> toJson() => _$PessoaToJson(this);
}
