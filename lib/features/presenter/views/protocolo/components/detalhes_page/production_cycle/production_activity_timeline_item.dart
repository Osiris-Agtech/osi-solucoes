import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_badge.dart';

class ProductionActivityTimelineItem extends StatelessWidget {
  final Acao acao;

  const ProductionActivityTimelineItem({super.key, required this.acao});

  @override
  Widget build(BuildContext context) {
    final dayLabel = acao.duracao_dias == null
        ? 'Dia não informado'
        : 'Dia ${acao.duracao_dias} da fase';
    final realDay = acao.duracao_dias_real;
    final showRealDay = realDay != null && realDay != acao.duracao_dias;
    final hasAlert = acao.alerta == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Constants.kSecondBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              acao.titulo ?? 'Atividade sem título',
              style: const TextStyle(
                color: Constants.kText2,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppBadge(
                  label: dayLabel,
                  icon: Icons.calendar_today_outlined,
                  tone: AppBadgeTone.neutral,
                ),
                if (showRealDay)
                  AppBadge(
                    label: 'Dia real $realDay do cultivo',
                    icon: Icons.event_available_outlined,
                    tone: AppBadgeTone.primary,
                  ),
                AppBadge(
                  label: hasAlert ? 'Com alerta' : 'Sem alerta',
                  icon: hasAlert
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  tone: hasAlert ? AppBadgeTone.primary : AppBadgeTone.neutral,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
