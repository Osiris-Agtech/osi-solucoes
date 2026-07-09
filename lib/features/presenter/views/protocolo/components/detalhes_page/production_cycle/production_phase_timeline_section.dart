import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/production_activity_timeline_item.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_cycle_metrics.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';

class ProductionPhaseTimelineSection extends StatelessWidget {
  final Fase fase;
  final int index;
  final bool isLast;

  const ProductionPhaseTimelineSection({
    super.key,
    required this.fase,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final activities = fase.acao ?? const <Acao>[];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
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
              if (!isLast)
                Container(
                  width: 2,
                  height: 26,
                  color: Constants.kGreyLight,
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: AppPanelCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fase.nome ?? 'Fase sem nome',
                    style: const TextStyle(
                      color: Constants.kText2,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${protocolDaysLabel(fase.duracao_dias)} • ${protocolActivityCountLabel(activities.length)}',
                    style: const TextStyle(
                      color: Constants.kGreyText2,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (activities.isEmpty)
                    const Text(
                      'Nenhuma atividade cadastrada nesta fase.',
                      style: TextStyle(
                        color: Constants.kGreyText2,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    ...activities.map(
                      (acao) => ProductionActivityTimelineItem(acao: acao),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
