import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AdaptiveExperimentAssignmentResult {
  final bool assigned;
  final bool skippedNoActiveExperiment;
  final String? reason;
  final Map<String, Object?> data;

  const AdaptiveExperimentAssignmentResult({
    required this.assigned,
    required this.skippedNoActiveExperiment,
    required this.data,
    this.reason,
  });

  factory AdaptiveExperimentAssignmentResult.fromCallableData(Object? value) {
    final data = _normalizeMap(value);
    final success = data['success'] == true;
    final reason = _asString(data['reason']);

    return AdaptiveExperimentAssignmentResult(
      assigned: success,
      skippedNoActiveExperiment: !success && reason == 'no_active_experiment',
      reason: reason,
      data: data,
    );
  }

  static Map<String, Object?> _normalizeMap(Object? value) {
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    return const <String, Object?>{};
  }

  static String? _asString(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty || text == 'null' ? null : text;
  }
}

class AdaptiveExperimentService {
  FirebaseFunctions? _functions;

  FirebaseFunctions? get _functionsInstance {
    try {
      Firebase.app();
      _functions ??= FirebaseFunctions.instance;
      return _functions;
    } catch (e) {
      debugPrint('AdaptiveExperimentService: Firebase não inicializado: $e');
      return null;
    }
  }

  Future<AdaptiveExperimentAssignmentResult> autoAssignAfterLogin({
    required String userId,
    required String isisToken,
  }) async {
    final functions = _functionsInstance;
    if (functions == null) {
      return const AdaptiveExperimentAssignmentResult(
        assigned: false,
        skippedNoActiveExperiment: false,
        reason: 'firebase_not_initialized',
        data: <String, Object?>{},
      );
    }

    final callable = functions.httpsCallable('autoAssignAdaptiveExperiment');
    final result = await callable.call(<String, Object?>{
      'userId': userId,
      'isisToken': isisToken,
    });

    final assignment =
        AdaptiveExperimentAssignmentResult.fromCallableData(result.data);

    if (assignment.skippedNoActiveExperiment) {
      debugPrint(
          'AdaptiveExperimentService: sem experimento ativo para $userId');
    }

    return assignment;
  }
}
