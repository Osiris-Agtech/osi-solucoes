// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../usuario/usuario_model.dart';

part 'pessoa_model.g.dart';

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

// Função helper para converter String para DateTime
DateTime? _parseToDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class Pessoa {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
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

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToDateTime,
  )
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

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 Pessoa JSON: $json');
      return _$PessoaFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão Pessoa: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$PessoaToJson(this);

  @override
  String toString() {
    return 'Pessoa{id: $id, nome: $nome}';
  }
}
