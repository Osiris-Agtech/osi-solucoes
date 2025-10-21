// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:json_annotation/json_annotation.dart';

import '../conectaConta/conectaConta_model.dart';
import '../pessoa/pessoa_model.dart';

part 'usuario_model.g.dart';

// Função helper mais robusta para converter String para int
int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) return value.toInt();
  return null;
}

// Função helper mais robusta para converter String para bool
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

// Função helper para converter String para DateTime
DateTime? _parseToDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

// Função para limpar dados do GraphQL antes da conversão
Map<String, dynamic> _cleanGraphQLData(Map<String, dynamic> json) {
  final Map<String, dynamic> cleaned = {};

  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;

    // Pular campos do GraphQL
    if (key == '__typename') continue;

    // Processar recursivamente objetos aninhados
    if (value is Map<String, dynamic>) {
      cleaned[key] = _cleanGraphQLData(value);
    }
    // Processar recursivamente listas
    else if (value is List) {
      cleaned[key] = value.map((item) {
        if (item is Map<String, dynamic>) {
          return _cleanGraphQLData(item);
        }
        return item;
      }).toList();
    }
    // Manter outros valores
    else {
      cleaned[key] = value;
    }
  }

  return cleaned;
}

@JsonSerializable(explicitToJson: true)
class Usuario {
  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  String? email;

  @JsonKey(required: false, disallowNullValue: false)
  String? senha;

  @JsonKey(required: false, disallowNullValue: false)
  String? cod_acesso;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToBool,
  )
  bool? acesso_externo;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToBool,
  )
  bool? ativo;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToDateTime,
  )
  DateTime? created_at;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? fk_pessoas_id;

  @JsonKey(required: false, disallowNullValue: false)
  Pessoa? pessoa;

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
    this.fk_pessoas_id,
    this.pessoa,
    this.contas,
    this.selected_conta,
  });

  // Factory method customizado que limpa os dados antes da conversão
  factory Usuario.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 JSON original: $json');
      final cleanedJson = _cleanGraphQLData(json);
      print('🧹 JSON limpo: $cleanedJson');
      return _$UsuarioFromJson(cleanedJson);
    } catch (e) {
      print('❌ Erro na conversão Usuario: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  // Método para debug - mostra os dados do usuário
  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, ativo: $ativo, contas: ${contas?.length}}';
  }

  // Método helper para verificar se tem múltiplas contas
  bool get hasMultipleAccounts => contas != null && contas!.length > 1;

  // Método helper para verificar se está ativo
  bool get isActive => ativo == true;

  // Método helper para validar senha
  bool validatePassword(String inputPassword) {
    return senha != null && senha == inputPassword;
  }
}
