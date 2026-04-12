import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço para consumir a API de métricas de eficácia da adaptação.
class MetricsService {
  static const _apiKey = '3a055de760e0ff4ff74d49b4fbccbaafbe6af3dc1dee4bcf5bd33c18acb67960';
  static const _baseUrl = 'https://metricsapi-vka4bhxxjq-uc.a.run.app';

  // ============================================================
  // Models
  // ============================================================

  static Map<String, dynamic>? _globalMetrics;

  // ============================================================
  // API Methods
  // ============================================================

  /// Busca métricas globais agregadas.
  static Future<Map<String, dynamic>> getGlobalMetrics() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/metrics'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      _globalMetrics = jsonDecode(response.body);
      return _globalMetrics!;
    }
    throw _parseError(response);
  }

  /// Busca métricas de um usuário específico.
  static Future<Map<String, dynamic>> getUserMetrics(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/metrics?userId=$userId'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw _parseError(response);
  }

  /// Lista resumida de todos os usuários com métricas.
  static Future<List<Map<String, dynamic>>> listUsersWithMetrics() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/metrics/users'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return List<Map<String, dynamic>>.from(body);
      }
      return [];
    }
    throw _parseError(response);
  }

  /// Compara dois modos de adaptação.
  static Future<Map<String, dynamic>> compareModes({
    required String modeA,
    required String modeB,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/metrics/compare?modeA=$modeA&modeB=$modeB'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw _parseError(response);
  }

  /// Busca todos os modos disponíveis para comparação.
  static Future<Map<String, dynamic>> getAllModesComparison() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/metrics/compare'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw _parseError(response);
  }

  /// Exporta dados em JSON.
  static Future<Map<String, dynamic>> exportJson({
    String? userId,
    String? mode,
    int limit = 1000,
    int offset = 0,
  }) async {
    final params = {
      'format': 'json',
      if (userId != null) 'userId': userId,
      if (mode != null) 'mode': mode,
      'limit': limit.toString(),
      'offset': offset.toString(),
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/metrics/export').replace(queryParameters: params),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw _parseError(response);
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

  /// Formata taxa para exibição (ex: 0.345 → "34.5%")
  static String formatRate(double? value) {
    if (value == null) return 'N/A';
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  /// Formata tempo em ms para legível (ex: 45000 → "45s")
  static String formatTime(int? ms) {
    if (ms == null || ms < 0) return 'N/A';
    final seconds = ms ~/ 1000;
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes}m ${remainingSecs}s';
  }
}
