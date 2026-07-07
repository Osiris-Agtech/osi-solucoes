import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class InstantRecommendedActionsPanel extends StatelessWidget {
  final List<AdaptiveRecommendedActionViewData> recommendedActions;
  final NextStepViewData? nextStep;
  final String? reasonSummary;
  final ValueChanged<String> onActionTap;

  const InstantRecommendedActionsPanel({
    super.key,
    required this.recommendedActions,
    this.nextStep,
    this.reasonSummary,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (nextStep == null && recommendedActions.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = _buildItems();

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
              const HomeBadge(icon: Icons.auto_awesome, label: 'Adaptativo'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Apoio adaptativo ativo para priorizar próximos passos.',
            style: homeBodyStyle(Colors.black.withValues(alpha: 0.60)),
          ),
          const SizedBox(height: 12),
          ...List.generate(items.length, (index) {
            final entry = items[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 6 : 0,
              ),
              child: _RecommendedTile(
                entry: entry,
                onTap: () => onActionTap(entry.data.targetRoute),
              ),
            );
          }),
          if (reasonSummary != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: Constants.kPrimaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      reasonSummary!,
                      style: homeBodyStyle(Colors.black.withValues(alpha: 0.60)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<_ItemEntry> _buildItems() {
    final items = <_ItemEntry>[];

    if (nextStep != null) {
      items.add(_ItemEntry(
        isNextStep: true,
        isProminent: nextStep!.isProminent,
        data: AdaptiveRecommendedActionViewData(
          label: nextStep!.title,
          description: nextStep!.description,
          targetRoute: nextStep!.targetRoute,
          confidence: 1.0,
          resourceId: nextStep!.resourceId,
          reason: null,
        ),
      ));
    }

    final remainingCount = 6 - items.length;
    if (remainingCount > 0) {
      for (var i = 0; i < recommendedActions.length && i < remainingCount; i++) {
        items.add(_ItemEntry(
          isNextStep: false,
          isProminent: false,
          data: recommendedActions[i],
        ));
      }
    }

    return items;
  }
}

class _ItemEntry {
  final bool isNextStep;
  final bool isProminent;
  final AdaptiveRecommendedActionViewData data;

  const _ItemEntry({
    required this.isNextStep,
    required this.isProminent,
    required this.data,
  });
}

class _RecommendedTile extends StatelessWidget {
  final _ItemEntry entry;
  final VoidCallback onTap;

  const _RecommendedTile({
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  entry.isNextStep
                      ? Icons.flag_rounded
                      : Icons.lightbulb_outline_rounded,
                  size: 20,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.data.label,
                          style: homeTitleStyle(13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (entry.data.confidence > 0.7)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Constants.kPrimaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${(entry.data.confidence * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Constants.kPrimaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (entry.isNextStep && entry.isProminent)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Constants.kPrimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'Prioritário',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Constants.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.data.description,
                          style:
                              homeBodyStyle(Colors.black.withValues(alpha: 0.60)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Constants.kGreyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
