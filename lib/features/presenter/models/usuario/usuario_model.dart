// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../conectaConta/conectaConta_model.dart';
import '../pessoa/pessoa_model.dart';

part 'usuario_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Usuario {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? email;
  @JsonKey(required: false, disallowNullValue: false)
  String? senha;
  @JsonKey(required: false, disallowNullValue: false)
  String? cod_acesso;
  @JsonKey(required: false, disallowNullValue: false)
  bool? acesso_externo;
  @JsonKey(required: false, disallowNullValue: false)
  bool? ativo;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  Pessoa? pessoa;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<Log>? logs;
  // @JsonKey(required: false, disallowNullValue: false)
  // List<Lotes_Atividades>? atividades;
  @JsonKey(required: false, disallowNullValue: false)
  List<ConectaConta>? contas;
  @JsonKey(required: false, disallowNullValue: false)
  ConectaConta? selected_conta;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.cod_acesso,
    this.acesso_externo,
    this.ativo,
    this.created_at,
    this.pessoa,
    this.contas,
    this.selected_conta,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
