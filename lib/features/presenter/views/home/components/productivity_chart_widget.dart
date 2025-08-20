import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class CultureData {
  final String name;
  final double value;
  final Color color;

  const CultureData({
    required this.name,
    required this.value,
    required this.color,
  });
}

class ProductivityChartWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String totalUnit;
  final List<CultureData> cultureData;
  final List<String> months;

  const ProductivityChartWidget({
    Key? key,
    this.title = 'Produção por Cultura',
    this.subtitle = 'Últimos 6 meses',
    this.totalUnit = 'plantas',
    this.cultureData = const [
      CultureData(
        name: 'Alface',
        value: 920, // Total de 6 meses: 920 plantas
        color: Color(0xFF059669),
      ),
      CultureData(
        name: 'Rúcula',
        value: 1230, // Total de 6 meses: 1230 plantas
        color: Color(0xFF8B5CF6),
      ),
    ],
    this.months = const ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'],
  }) : super(key: key);

  @override
  State<ProductivityChartWidget> createState() =>
      _ProductivityChartWidgetState();
}

class _ProductivityChartWidgetState extends State<ProductivityChartWidget> {
  final double barWidth = 8;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeBarGroups();
  }

  void _initializeBarGroups() {
    // Dados simulados para cada mês - plantas colhidas (Total: 2050 plantas)
    final monthlyData = [
      [120, 180], // Jan: Alface 120 plantas, Rúcula 180 plantas = 300
      [140, 190], // Fev: Alface 140 plantas, Rúcula 190 plantas = 330
      [160, 200], // Mar: Alface 160 plantas, Rúcula 200 plantas = 360
      [150, 210], // Abr: Alface 150 plantas, Rúcula 210 plantas = 360
      [170, 220], // Mai: Alface 170 plantas, Rúcula 220 plantas = 390
      [180, 230], // Jun: Alface 180 plantas, Rúcula 230 plantas = 410
    ];

    rawBarGroups = monthlyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return _makeGroupData(index, data[0].toDouble(), data[1].toDouble());
    }).toList();

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totalProduction = widget.cultureData.fold<double>(
      0,
      (sum, culture) => sum + culture.value,
    );

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
              _buildHeader(totalProduction),
              const SizedBox(height: 20),
              _buildLegend(),
              const SizedBox(height: 20),
              _buildChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double totalProduction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
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
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '${totalProduction.toInt()}',
                style: const TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.totalUnit,
                style: const TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: widget.cultureData.map((culture) {
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: culture.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${culture.name} (${culture.value.toInt()} ${widget.totalUnit})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: 250,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey[800]!,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final cultureName = widget.cultureData[rodIndex].name;
                return BarTooltipItem(
                  '$cultureName\n${rod.toY.toInt()} ${widget.totalUnit}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.spot == null) {
                  touchedGroupIndex = -1;
                  showingBarGroups = List.of(rawBarGroups);
                  return;
                }
                touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                showingBarGroups = List.of(rawBarGroups);
              });
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
                getTitlesWidget: _bottomTitles,
                reservedSize: 32,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 50,
                getTitlesWidget: _leftTitles,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: showingBarGroups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );

    if (value == 0 ||
        value == 50 ||
        value == 100 ||
        value == 150 ||
        value == 200 ||
        value == 250) {
      return Text(
        '${value.toInt()}',
        style: style,
      );
    }
    return Container();
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );

    if (value.toInt() < widget.months.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          widget.months[value.toInt()],
          style: style,
        ),
      );
    }
    return Container();
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    final isSelected = x == touchedGroupIndex;

    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: isSelected
              ? widget.cultureData[0].color.withOpacity(0.8)
              : widget.cultureData[0].color,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: isSelected
              ? widget.cultureData[1].color.withOpacity(0.8)
              : widget.cultureData[1].color,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
