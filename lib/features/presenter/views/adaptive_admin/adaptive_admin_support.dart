import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/services/adaptive_user_service.dart';

class UserWithConfig {
  final UserInfo user;
  final Map<String, dynamic> config;

  UserWithConfig({
    required this.user,
    required this.config,
  });

  String? get mode => config['mode'] as String?;
  String? get sessionId => config['sessionId'] as String?;
  String? get testGroup => config['testGroup'] as String?;
  String? get experimentId => config['experimentId'] as String?;
  String? get participantId => config['participantId'] as String?;
  String? get condition => config['condition'] as String?;
  int? get period => config['period'] is int ? config['period'] as int : null;
  bool get hasConfig => mode != null && mode!.isNotEmpty;
}

class AdminSectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const AdminSectionHeader({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji  $title',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}

class ExperimentCard extends StatelessWidget {
  final Map<String, dynamic> experiment;
  final VoidCallback onAdvance;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const ExperimentCard({
    super.key,
    required this.experiment,
    required this.onAdvance,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final id = _stringValue(experiment['id']) ??
        _stringValue(experiment['experimentId']) ??
        'sem_id';
    final name = _stringValue(experiment['name']) ?? id;
    final status = _stringValue(experiment['status']) ?? 'active';
    final period = experiment['currentPeriod']?.toString() ?? '-';
    final maxPeriods = experiment['maxPeriods']?.toString() ?? '-';
    final participants = _listValue(experiment['participants']);
    final groups = _listValue(experiment['groups']);
    final autoAssign = experiment['autoAssign'] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chip(
                    label: Text(status),
                    backgroundColor: status == 'active'
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.18),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('ID: $id'),
              Text(
                  'Período: $period/$maxPeriods · Participantes: ${participants.length}'),
              Text('Autoatribuição: ${autoAssign ? 'ativa' : 'inativa'}'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: groups.map((group) {
                  final map = group is Map
                      ? group
                          .map((key, value) => MapEntry(key.toString(), value))
                      : <String, dynamic>{};
                  final groupName = _stringValue(map['name']) ??
                      _stringValue(map['groupId']) ??
                      'grupo';
                  final conditions = _listValue(map['conditions'])
                      .map((condition) => _conditionLabel(condition))
                      .join(' → ');
                  return Chip(label: Text('$groupName: $conditions'));
                }).toList(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: status == 'active' ? onAdvance : null,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Avançar período'),
                  ),
                  OutlinedButton.icon(
                    onPressed: status == 'active' ? onComplete : null,
                    icon: const Icon(Icons.flag),
                    label: const Text('Encerrar'),
                  ),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<Object?> _listValue(Object? value) {
    if (value is List) return value.cast<Object?>();
    return const <Object?>[];
  }

  static String? _stringValue(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty || text == 'null' ? null : text;
  }

  static String _conditionLabel(Object? value) {
    if (value is! Map) return '-';
    final condition =
        value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    final period = condition['period']?.toString() ?? '?';
    final mode = _stringValue(condition['mode']) ?? '-';
    return 'P$period $mode';
  }
}
