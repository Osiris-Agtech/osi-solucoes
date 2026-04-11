import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço de administração dos modos adaptativos.
///
/// Comunica-se com a Cloud Function `adminAdaptiveMode` no Firebase
/// para gerenciar configurações de usuários de teste sem depender
/// do app Flutter ou do console do Firestore.
///
/// Configuração necessária:
/// - Defina a variável ADMIN_KEY no ambiente da Cloud Function
/// - Atualize [_apiKey] e [_baseUrl] com seus valores
class AdaptiveAdminService {
  // ============================================================
  // CONFIGURAÇÃO — altere antes de usar
  // ============================================================

  /// API key definida na Cloud Function (process.env.ADMIN_KEY)
  static const _apiKey = '3a055de760e0ff4ff74d49b4fbccbaafbe6af3dc1dee4bcf5bd33c18acb67960';

  /// URL base da Cloud Function.
  /// Substitua SEU_PROJECT pela região e project ID corretos.
  /// Exemplo: https://us-central1-meu-projeto.cloudfunctions.net
  static const _baseUrl = 'https://adminadaptivemode-vka4bhxxjq-uc.a.run.app';

  // ============================================================
  // API Methods
  // ============================================================

  /// Lista todas as configurações de modos adaptativos.
  /// Retorna lista de maps com userId, mode, sessionId, etc.
  static Future<List<Map<String, dynamic>>> listAllConfigs() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adminAdaptiveMode'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      try {
        final body = jsonDecode(response.body);
        if (body is List) {
          return List<Map<String, dynamic>>.from(body);
        }
        return [];
      } catch (e) {
        throw Exception('Erro ao processar resposta da Cloud Function: $e');
      }
    }
    throw _parseError(response);
  }

  /// Busca a configuração de um usuário específico.
  /// Retorna null se não houver config.
  static Future<Map<String, dynamic>?> getUserConfig(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adminAdaptiveMode?userId=$userId'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body is Map ? Map<String, dynamic>.from(body) : null;
    }
    throw _parseError(response);
  }

  /// Configura o modo adaptativo de um usuário.
  ///
  /// [userId] — ID do usuário (mesmo usado no Firestore)
  /// [mode] — 'STATIC', 'INSTANT' ou 'GRADUAL'
  /// [sessionId] — obrigatório para modo INSTANT
  /// [testGroup] — identificador do grupo experimental (opcional)
  /// [expiresAt] — data de expiração da config (opcional)
  static Future<void> configureUser({
    required String userId,
    required String mode,
    String? sessionId,
    String? testGroup,
    DateTime? expiresAt,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      'mode': mode,
      if (sessionId != null) 'sessionId': sessionId,
      if (testGroup != null) 'testGroup': testGroup,
      if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/adminAdaptiveMode'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  /// Encerra a sessão de teste de um usuário e remove sua config.
  static Future<void> endSession(String userId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/adminAdaptiveMode?userId=$userId'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  // ============================================================
  // Helpers
  // ============================================================

  static Exception _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      final msg = body['error'] ?? response.body;
      return Exception('[${response.statusCode}] $msg');
    } catch (_) {
      return Exception('[${response.statusCode}] ${response.body}');
    }
  }

}
