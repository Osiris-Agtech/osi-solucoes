import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class RecommendedActionsSection extends StatelessWidget {
  final List<RecommendedActionViewData> actions;
  final bool hasAdaptiveSupport;
  final ValueChanged<RecommendedActionViewData> onActionTap;

  const RecommendedActionsSection({
    super.key,
    required this.actions,
    required this.hasAdaptiveSupport,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    final visibleActions = actions.take(4).toList();
    final hasAdaptive =
        hasAdaptiveSupport || visibleActions.any((action) => action.isAdaptive);

    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: HomeSectionTitle(
                  icon: Icons.bolt_rounded,
                  title: 'Ações recomendadas',
                ),
              ),
              if (hasAdaptive)
                const HomeBadge(icon: Icons.auto_awesome, label: 'Adaptativo'),
            ],
          ),
          if (hasAdaptive) ...[
            const SizedBox(height: 6),
            Text(
              'Apoio adaptativo ativo para priorizar próximos passos.',
              style: homeBodyStyle(Colors.black54),
            ),
          ],
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: visibleActions
                    .map(
                      (action) => _ActionTile(
                        action: action,
                        width: isNarrow
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 10) / 2,
                        onTap: () => onActionTap(action),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final RecommendedActionViewData action;
  final double width;
  final VoidCallback onTap;

  const _ActionTile({
    required this.action,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: _IconTile(
          title: action.label,
          description: action.description,
          iconAsset: action.iconAsset,
          color: action.color,
          onTap: onTap,
          trailing: action.isAdaptive
              ? Icons.auto_awesome
              : Icons.chevron_right_rounded,
        ),
      );
}

class _IconTile extends StatelessWidget {
  final String title;
  final String description;
  final String iconAsset;
  final Color color;
  final VoidCallback onTap;
  final IconData trailing;

  const _IconTile({
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.color,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            HomeAssetIcon(iconAsset: iconAsset, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: homeTitleStyle(13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: homeBodyStyle(Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(trailing, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
