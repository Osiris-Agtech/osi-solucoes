import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/production_phase_timeline_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class ProductionCycleTimeline extends StatelessWidget {
  final List<Fase> fases;
  final List<Acao> actions;
  final String emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  const ProductionCycleTimeline({
    super.key,
    required this.fases,
    this.actions = const <Acao>[],
    this.emptyMessage =
        'Ainda não há fases ou atividades registradas para este ciclo.',
    this.emptyActionLabel,
    this.onEmptyAction,
  });

  @override
  Widget build(BuildContext context) {
    final actionsWithoutPhase =
        actions.where((acao) => acao.fase == null).toList();
    final timelineSectionsCount =
        fases.length + (actionsWithoutPhase.isEmpty ? 0 : 1);

    if (fases.isEmpty && actionsWithoutPhase.isEmpty) {
      return AppStatePanel(
        stateKind: AppStateKind.empty,
        icon: Icons.playlist_add_outlined,
        title: 'Ciclo sem atividades registradas',
        message: emptyMessage,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Linha do tempo do ciclo',
            style: TextStyle(
              color: Constants.kText2,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fases e atividades planejadas em ordem operacional.',
            style: TextStyle(
              color: Constants.kGreyText2,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          ...fases.asMap().entries.map(
                (entry) => ProductionPhaseTimelineSection(
                  fase: entry.value,
                  index: entry.key,
                  isLast: entry.key == timelineSectionsCount - 1,
                ),
              ),
          if (actionsWithoutPhase.isNotEmpty)
            ProductionPhaseTimelineSection(
              fase: Fase(
                nome: 'Sem fase definida',
                acao: actionsWithoutPhase,
              ),
              index: fases.length,
              isLast: true,
            ),
        ],
      ),
    );
  }
}
