import 'package:flutter/material.dart';

import '../models/home_panel_view_data.dart';
import 'home_empty_state.dart';
import 'home_panel_shared.dart';

class TodayCultivationPanel extends StatelessWidget {
  final TodayCultivationViewData data;
  final VoidCallback? onOpenTasks;

  const TodayCultivationPanel({
    super.key,
    required this.data,
    this.onOpenTasks,
  });

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeSectionTitle(
            icon: Icons.eco_rounded,
            title: 'Hoje no cultivo',
            subtitle: 'Pendências, lotes e alertas fora do carousel',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricPill(
                label: 'Tarefas hoje',
                value: data.tasksToday,
                tone: HomePanelTone.primary,
              ),
              _MetricPill(
                label: 'Atrasadas',
                value: data.overdueTasks,
                tone: HomePanelTone.danger,
              ),
              _MetricPill(
                label: 'Lotes ativos',
                value: data.activeLots,
                tone: HomePanelTone.success,
              ),
              _MetricPill(
                label: 'Colheitas próximas',
                value: data.upcomingHarvests,
                tone: HomePanelTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (data.isEmpty)
            HomeEmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Nenhuma pendência crítica para hoje',
              message:
                  'Use a agenda para revisar ou cadastrar próximas atividades.',
              actionLabel: onOpenTasks == null ? null : 'Abrir agenda',
              onAction: onOpenTasks,
            )
          else ...[
            ...data.criticalAlerts.map(_ListItem.new),
            if (data.criticalAlerts.isNotEmpty && data.tasks.isNotEmpty)
              const SizedBox(height: 8),
            ...data.tasks.map(_ListItem.new),
          ],
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final HomePanelListItemViewData item;

  const _ListItem(this.item);

  @override
  Widget build(BuildContext context) {
    final color = homeToneColor(item.tone);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(item.icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: homeTitleStyle(13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: homeBodyStyle(Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final int value;
  final HomePanelTone tone;

  const _MetricPill({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final color = homeToneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$value $label',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
