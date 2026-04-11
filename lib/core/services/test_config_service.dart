import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum AdaptiveMode {
  staticMode,
  instant,
  gradual,
}

class TestConfigService {
  static Future<void> configureTestUser({
    required String userId,
    required AdaptiveMode mode,
    String? testGroup,
    String? sessionId,
    DateTime? expires,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      Firebase.app();

      final modeString = mode.toString().split('.').last.toUpperCase();

      final configData = <String, dynamic>{
        'userId': userId,
        'mode': modeString,
        'createdAt': FieldValue.serverTimestamp(),
        if (testGroup != null) 'testGroup': testGroup,
        if (sessionId != null) 'sessionId': sessionId,
        if (expires != null) 'expiresAt': Timestamp.fromDate(expires),
        if (metadata != null) 'metadata': metadata,
      };

      await FirebaseFirestore.instance
          .collection('userAdaptiveConfig')
          .doc(userId)
          .set(configData);

      if (mode == AdaptiveMode.instant && sessionId != null) {
        await FirebaseFirestore.instance
            .collection('sessionNavigations')
            .doc(sessionId)
            .set({
          'sessionId': sessionId,
          'userId': userId,
          'startedAt': FieldValue.serverTimestamp(),
          'status': 'active',
        });
      }

      print('📊 [TEST_CONFIG] Usuário configurado: $userId, modo: $modeString');
    } catch (e) {
      print('📊 [TEST_CONFIG] Erro ao configurar usuário: $e');
      rethrow;
    }
  }

  static Future<void> endTestSession({
    required String userId,
    String? sessionId,
  }) async {
    try {
      Firebase.app();

      await FirebaseFirestore.instance
          .collection('userAdaptiveConfig')
          .doc(userId)
          .delete();

      final effectiveSessionId =
          sessionId ?? await _getSessionIdFromConfig(userId);

      if (effectiveSessionId != null) {
        await FirebaseFirestore.instance
            .collection('sessionNavigations')
            .doc(effectiveSessionId)
            .update({
          'status': 'completed',
          'endedAt': FieldValue.serverTimestamp(),
        });
      }

      print(
          '📊 [TEST_CONFIG] Sessão de teste finalizada para usuário: $userId');
    } catch (e) {
      print('📊 [TEST_CONFIG] Erro ao finalizar sessão: $e');
      rethrow;
    }
  }

  static Future<String?> _getSessionIdFromConfig(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userAdaptiveConfig')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['sessionId'] as String?;
      }
      return null;
    } catch (e) {
      print('📊 [TEST_CONFIG] Erro ao buscar sessionId: $e');
      return null;
    }
  }
}
