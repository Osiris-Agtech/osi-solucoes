/// Registro de ações do usuário para enriquecer o contexto da API de adaptação.
///
/// Cada store deve chamar [record] após mutações (criar, editar, deletar).
/// O [InstantOperationalContextMapper] consome o trace via [consume] e envia
/// como `recentUserActions` no payload da API.
class UserAction {
  final String entityType;
  final String action;
  final int? entityId;
  final String? entityName;
  final DateTime timestamp;

  UserAction({
    required this.entityType,
    required this.action,
    this.entityId,
    this.entityName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'entityType': entityType,
        'action': action,
        if (entityId != null) 'entityId': entityId,
        if (entityName != null) 'entityName': entityName,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class UserActionTrace {
  static const int _maxLength = 5;
  final List<UserAction> _actions = [];

  void record(UserAction action) {
    _actions.add(action);
    if (_actions.length > _maxLength) {
      _actions.removeAt(0);
    }
  }

  /// Retorna a lista de ações serializáveis e limpa o trace.
  List<Map<String, dynamic>> consume() {
    final snapshot = _actions.map((a) => a.toJson()).toList();
    _actions.clear();
    return snapshot;
  }
}
