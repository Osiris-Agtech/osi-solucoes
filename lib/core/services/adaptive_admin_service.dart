import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço de administração dos modos adaptativos.
///
/// Comunica-se com a Cloud Function `adminAdaptiveMode` no Firebase
/// para gerenciar configurações de usuários de teste sem depender
/// do app Flutter ou do console do Firestore.
///
/// Configuração necessária:
/// - Defina ADMIN_KEY no ambiente da Cloud Function
/// - Compile o app admin com --dart-define=ADAPTIVE_ADMIN_KEY=ADMIN_KEY
class AdaptiveAdminService {
  static const _apiKey =
      '3a055de760e0ff4ff74d49b4fbccbaafbe6af3dc1dee4bcf5bd33c18acb67960';

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
      headers: _authHeaders,
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

  static Future<List<Map<String, dynamic>>> listExperiments() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adminAdaptiveMode?collection=experimentalGroups'),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      try {
        final body = jsonDecode(response.body);
        if (body is List) {
          return List<Map<String, dynamic>>.from(body);
        }
        if (body is Map && body['experiments'] is List) {
          return List<Map<String, dynamic>>.from(body['experiments'] as List);
        }
        return [];
      } catch (e) {
        throw Exception('Erro ao processar experimentos: $e');
      }
    }
    throw _parseError(response);
  }

  static Future<void> createExperiment({
    required String experimentId,
    required String name,
    String? description,
    bool autoAssign = true,
    String assignmentStrategy = 'roundRobin',
    int currentPeriod = 1,
    int maxPeriods = 2,
    String status = 'active',
    required List<Map<String, dynamic>> groups,
  }) async {
    final body = <String, dynamic>{
      'collection': 'experimentalGroups',
      'experimentId': experimentId,
      'id': experimentId,
      'name': name,
      if (description != null && description.isNotEmpty)
        'description': description,
      'autoAssign': autoAssign,
      'assignmentStrategy': assignmentStrategy,
      'assignmentIndex': 0,
      'currentPeriod': currentPeriod,
      'maxPeriods': maxPeriods,
      'status': status,
      'groups': groups,
      'participants': <Map<String, dynamic>>[],
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/adminAdaptiveMode'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  static Future<void> deleteExperiment(String experimentId) async {
    final response = await http.delete(
      Uri.parse(
        '$_baseUrl/adminAdaptiveMode?collection=experimentalGroups&id=$experimentId',
      ),
      headers: _authHeaders,
    );
    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  static Future<Map<String, dynamic>> advanceExperimentPeriod(
    String experimentId,
  ) async {
    return _postExperimentAction(
      action: 'advanceExperimentPeriod',
      experimentId: experimentId,
    );
  }

  static Future<Map<String, dynamic>> completeExperiment(
    String experimentId,
  ) async {
    return _postExperimentAction(
      action: 'completeExperiment',
      experimentId: experimentId,
    );
  }

  static Future<Map<String, dynamic>> assignParticipantToGroup({
    required String userId,
    required String experimentId,
    required String groupId,
    required int period,
  }) async {
    return _postExperimentAction(
      action: 'assignParticipantToGroup',
      experimentId: experimentId,
      extraBody: <String, dynamic>{
        'userId': userId,
        'groupId': groupId,
        'period': period,
      },
    );
  }

  /// Busca a configuração de um usuário específico.
  /// Retorna null se não houver config.
  static Future<Map<String, dynamic>?> getUserConfig(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adminAdaptiveMode?userId=$userId'),
      headers: _authHeaders,
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
      headers: _jsonHeaders,
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
      headers: _authHeaders,
    );
    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  // ============================================================
  // Helpers
  // ============================================================

  static Map<String, String> get _authHeaders => {
        'Authorization': 'Bearer $_requiredApiKey',
      };

  static Map<String, String> get _jsonHeaders => {
        ..._authHeaders,
        'Content-Type': 'application/json',
      };

  static String get _requiredApiKey {
    if (_apiKey.trim().isEmpty) {
      throw StateError(
        'ADAPTIVE_ADMIN_KEY ausente. Compile com --dart-define=ADAPTIVE_ADMIN_KEY=<ADMIN_KEY>.',
      );
    }
    return _apiKey;
  }

  static Future<Map<String, dynamic>> _postExperimentAction({
    required String action,
    required String experimentId,
    Map<String, dynamic>? extraBody,
  }) async {
    final body = <String, dynamic>{
      'collection': 'experimentalGroups',
      'action': action,
      'experimentId': experimentId,
      if (extraBody != null) ...extraBody,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/adminAdaptiveMode'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : <String, dynamic>{};
    }
    throw _parseError(response);
  }

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
