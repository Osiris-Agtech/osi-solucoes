// ignore_for_file: file_names, avoid_print

import 'package:json_annotation/json_annotation.dart';

import '../cargo/cargo_model.dart';
import '../conta/conta_model.dart';
import '../usuario/usuario_model.dart';

part 'conectaConta_model.g.dart';

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

@JsonSerializable(explicitToJson: true)
class ConectaConta {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  Cargo? cargo;

  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;

  @JsonKey(required: false, disallowNullValue: false)
  Usuario? usuario;

  ConectaConta({
    this.id,
    this.cargo,
    this.conta,
    this.usuario,
  });

  factory ConectaConta.fromJson(Map<String, dynamic> json) {
    try {
      // Criar uma cópia para não modificar o original
      final jsonCopy = Map<String, dynamic>.from(json);
      // Remove __typename se existir
      jsonCopy.remove('__typename');
      print('🔍 ConectaConta JSON: $jsonCopy');
      return _$ConectaContaFromJson(jsonCopy);
    } catch (e) {
      print('❌ Erro na conversão ConectaConta: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ConectaContaToJson(this);

  @override
  String toString() {
    return 'ConectaConta{id: $id, conta: ${conta?.nome}, cargo: ${cargo?.cargo}}';
  }
}
