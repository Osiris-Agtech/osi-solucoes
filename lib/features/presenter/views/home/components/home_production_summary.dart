import 'package:flutter/material.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeProductionSummary extends StatelessWidget {
  final ProductionSummaryViewData data;
  final VoidCallback? onOpenReport;

  const HomeProductionSummary({
    super.key,
    required this.data,
    this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    final hasHighlight = data.adaptation.hasHighlight;
    final highlightColor = homeToneColor(HomePanelTone.primary);

    return HomePanelCard(
      adaptation: hasHighlight ? data.adaptation : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: HomeSectionTitle(
                  icon: Icons.insights_rounded,
                  title: 'Produção',
                ),
              ),
              if (onOpenReport != null)
                TextButton(
                  onPressed: onOpenReport,
                  child: const Text('Ver relatório'),
                ),
              if (hasHighlight && data.adaptation.label != null) ...[
                const SizedBox(width: 6),
                HomeBadge(
                  icon: Icons.auto_awesome,
                  label: data.adaptation.label!,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: hasHighlight
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: hasHighlight
                  ? highlightColor.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.metricValue,
                  style: homeTitleStyle(34).copyWith(
                    color: hasHighlight ? highlightColor : Colors.black87,
                  ),
                ),
                Text(data.metricLabel, style: homeBodyStyle(Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.trendLabel.isEmpty ? data.periodLabel : data.trendLabel,
            style: homeBodyStyle(Colors.black54),
          ),
          if (hasHighlight && data.adaptation.reason != null) ...[
            const SizedBox(height: 8),
            Text(
              data.adaptation.reason!,
              style: homeBodyStyle(Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
