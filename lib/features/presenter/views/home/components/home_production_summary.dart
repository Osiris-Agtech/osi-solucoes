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
    return HomePanelCard(
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
            ],
          ),
          const SizedBox(height: 12),
          Text(data.metricValue, style: homeTitleStyle(34)),
          Text(data.metricLabel, style: homeBodyStyle(Colors.black87)),
          const SizedBox(height: 8),
          Text(
            data.trendLabel.isEmpty ? data.periodLabel : data.trendLabel,
            style: homeBodyStyle(Colors.black54),
          ),
        ],
      ),
    );
  }
}
