import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/views/adaptive_admin/adaptive_admin_support.dart';

class AdaptiveAdminExperimentsSection extends StatelessWidget {
  final List<Map<String, dynamic>> experiments;
  final VoidCallback onCreateExperiment;
  final void Function(Map<String, dynamic> experiment) onAdvanceExperiment;
  final void Function(Map<String, dynamic> experiment) onCompleteExperiment;
  final void Function(Map<String, dynamic> experiment) onDeleteExperiment;

  const AdaptiveAdminExperimentsSection({
    super.key,
    required this.experiments,
    required this.onCreateExperiment,
    required this.onAdvanceExperiment,
    required this.onCompleteExperiment,
    required this.onDeleteExperiment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminSectionHeader(
          emoji: '🧪',
          title: 'Experimentos',
          description:
              '${experiments.length} experimento(s) · sem listener em tempo real',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: onCreateExperiment,
              icon: const Icon(Icons.add),
              label: const Text('Criar experimento A/B roundRobin'),
            ),
          ),
        ),
        if (experiments.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Nenhum experimento cadastrado.'),
          )
        else
          ...experiments.map(
            (experiment) => ExperimentCard(
              experiment: experiment,
              onAdvance: () => onAdvanceExperiment(experiment),
              onComplete: () => onCompleteExperiment(experiment),
              onDelete: () => onDeleteExperiment(experiment),
            ),
          ),
      ],
    );
  }
}
