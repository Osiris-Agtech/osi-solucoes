import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_cycle_metrics.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_section_header.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class ProtocolCyclePreview extends StatelessWidget {
  final List<Fase> fases;

  const ProtocolCyclePreview({super.key, required this.fases});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Prévia do ciclo',
          subtitle: 'Sequência de fases do protocolo',
          icon: Icons.timeline_outlined,
        ),
        AppPanelCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: fases.isEmpty
              ? const AppStatePanel(
                  stateKind: AppStateKind.empty,
                  icon: Icons.playlist_add_outlined,
                  title: 'Ciclo ainda sem fases',
                  message:
                      'Edite o protocolo para adicionar fases e atividades.',
                  isCompact: true,
                )
              : Column(
                  children: fases.asMap().entries.map((entry) {
                    return _PhasePreviewItem(
                      index: entry.key,
                      fase: entry.value,
                      isLast: entry.key == fases.length - 1,
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _PhasePreviewItem extends StatelessWidget {
  final int index;
  final Fase fase;
  final bool isLast;

  const _PhasePreviewItem({
    required this.index,
    required this.fase,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final activitiesCount = fase.acao?.length ?? 0;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Constants.kPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fase.nome ?? 'Fase sem nome',
                  style: const TextStyle(
                    color: Constants.kText2,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${protocolDaysLabel(fase.duracao_dias)} • ${protocolActivityCountLabel(activitiesCount)}',
                  style: const TextStyle(
                    color: Constants.kGreyText2,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
