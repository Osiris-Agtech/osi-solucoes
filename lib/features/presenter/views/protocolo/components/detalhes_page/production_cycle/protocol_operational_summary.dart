import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_cycle_metrics.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';

class ProtocolOperationalSummary extends StatelessWidget {
  final Protocolo? protocolo;
  final List<Fase> fases;
  final EdgeInsetsGeometry margin;

  const ProtocolOperationalSummary({
    super.key,
    required this.protocolo,
    required this.fases,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final metrics = ProtocolCycleMetrics.fromProtocol(
      protocolo: protocolo,
      fases: fases,
    );

    return AppPanelCard(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            protocolo?.nome ?? 'Protocolo sem nome',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Constants.kText2,
            ),
          ),
          const SizedBox(height: 16),
          _MetadataRow(label: 'Cultura', value: protocolo?.cultura?.nome),
          _MetadataRow(
            label: 'Sistema de cultivo',
            value: protocolo?.sistema_cultivo,
          ),
          _MetadataRow(
            label: 'Forma de implantação',
            value: protocolo?.implantacao,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(label: 'Fases', value: '${metrics.phaseCount}'),
              _MetricChip(
                label: 'Atividades',
                value: '${metrics.activityCount}',
              ),
              _MetricChip(label: 'Alertas', value: '${metrics.alertCount}'),
              _MetricChip(
                label: 'Duração',
                value: protocolDaysLabel(metrics.totalDurationDays),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String? value;

  const _MetadataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Constants.kGreyText2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              (value == null || value!.isEmpty) ? '---' : value!,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Constants.kText2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Constants.kSecondBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Constants.kText2,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Constants.kGreyText2,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
