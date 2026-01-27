// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:json_annotation/json_annotation.dart';

import '../conectaConta/conectaConta_model.dart';

part 'conta_model.g.dart';

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

// Função helper para converter int ou String para String
String? _parseIntToString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toInt().toString();
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
class Conta {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? id;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseIntToString,
  )
  String? nivel;

  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  String? imagem;

  @JsonKey(required: false, disallowNullValue: false)
  String? cnpj;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToDateTime,
  )
  DateTime? created_at;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<ConectaConta>? usuarios;

  Conta({
    this.id,
    this.nivel,
    this.nome,
    this.imagem,
    this.cnpj,
    this.created_at,
    this.usuarios,
  });

  factory Conta.fromJson(Map<String, dynamic> json) {
    try {
      // Criar uma cópia para não modificar o original
      final jsonCopy = Map<String, dynamic>.from(json);
      // Remove __typename se existir
      jsonCopy.remove('__typename');
      print('🔍 Conta JSON: $jsonCopy');
      return _$ContaFromJson(jsonCopy);
    } catch (e) {
      print('❌ Erro na conversão Conta: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ContaToJson(this);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nivel': nivel,
      'nome': nome,
      'imagem': imagem,
      'cnpj': cnpj,
      'created_at': created_at?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Conta{id: $id, nome: $nome, nivel: $nivel}';
  }
}
