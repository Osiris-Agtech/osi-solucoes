import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class ProductivityChartWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String changePercentage;
  final List<FlSpot> chartData;
  final Color chartColor;
  final bool showTrendingUp;

  const ProductivityChartWidget({
    Key? key,
    this.title = 'Produtividade',
    this.subtitle = 'Últimos 7 meses',
    this.changePercentage = '+12%',
    this.chartData = const [
      FlSpot(0, 3),
      FlSpot(1, 1),
      FlSpot(2, 4),
      FlSpot(3, 5),
      FlSpot(4, 3),
      FlSpot(5, 7),
      FlSpot(6, 4),
    ],
    this.chartColor = Constants.kPrimaryColor,
    this.showTrendingUp = true,
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
              _buildChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            color: showTrendingUp ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                showTrendingUp ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: showTrendingUp ? Colors.green[600] : Colors.red[600],
              ),
              const SizedBox(width: 4),
              Text(
                changePercentage,
                style: TextStyle(
                  color: showTrendingUp ? Colors.green[600] : Colors.red[600],
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

  Widget _buildChart() {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = const Text('Jan', style: style);
                      break;
                    case 1:
                      text = const Text('Fev', style: style);
                      break;
                    case 2:
                      text = const Text('Mar', style: style);
                      break;
                    case 3:
                      text = const Text('Abr', style: style);
                      break;
                    case 4:
                      text = const Text('Mai', style: style);
                      break;
                    case 5:
                      text = const Text('Jun', style: style);
                      break;
                    case 6:
                      text = const Text('Jul', style: style);
                      break;
                    default:
                      text = const Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  );
                  return Text(
                    '${value.toInt()}',
                    style: style,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              curveSmoothness: 0.35,
              color: chartColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: chartColor,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    chartColor.withOpacity(0.2),
                    chartColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
