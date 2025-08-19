import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class LotStatusData {
  final String label;
  final int value;
  final Color color;

  const LotStatusData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class LotStatusPieChartWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<LotStatusData> statusData;
  final VoidCallback? onViewAll;

  const LotStatusPieChartWidget({
    Key? key,
    this.title = 'Status dos Lotes',
    this.subtitle = 'Situação atual',
    this.statusData = const [
      LotStatusData(
        label: 'Ativos',
        value: 12,
        color: Color(0xFF059669),
      ),
      LotStatusData(
        label: 'Finalizados',
        value: 8,
        color: Color(0xFF6B7280),
      )
    ],
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPieChart(),
              const SizedBox(height: 20),
              _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final totalLots = statusData.fold<int>(0, (sum, item) => sum + item.value);
    final activeLots = statusData
        .firstWhere(
          (item) => item.label == 'Ativos',
          orElse: () => const LotStatusData(
              label: 'Ativos', value: 0, color: Colors.grey),
        )
        .value;
    final completionPercentage = totalLots > 0
        ? ((totalLots - activeLots) / totalLots * 100).round()
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pie_chart,
                size: 16,
                color: Constants.kPrimaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '$totalLots lotes',
                style: const TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final total = statusData.fold<int>(0, (sum, item) => sum + item.value);

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Pie Chart
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: statusData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final percentage = total > 0 ? (data.value / total * 100) : 0;

                  return PieChartSectionData(
                    color: data.color,
                    value: data.value.toDouble(),
                    title: '${percentage.round()}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    badgeWidget: null,
                  );
                }).toList(),
              ),
            ),
          ),

          // Center Info
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$total',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total de\nLotes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        ...statusData.map((data) {
          final total =
              statusData.fold<int>(0, (sum, item) => sum + item.value);
          final percentage = total > 0 ? (data.value / total * 100).round() : 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${data.value} ($percentage%)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        if (onViewAll != null) _buildViewAllButton(),
      ],
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Constants.kPrimaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Ver todos os lotes',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.kPrimaryColor,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
