import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class LotStatusData {
  final String label;
  final int value;
  final Color color;
  final List<SpeciesInfo>? speciesDetails; // Detalhes das espécies

  const LotStatusData({
    required this.label,
    required this.value,
    required this.color,
    this.speciesDetails,
  });
}

class SpeciesInfo {
  final String name;
  final int lotCount;
  final double percentage;

  const SpeciesInfo({
    required this.name,
    required this.lotCount,
    required this.percentage,
  });
}

class LotStatusPieChartWidget extends StatefulWidget {
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
        speciesDetails: [
          SpeciesInfo(name: 'Alface', lotCount: 5, percentage: 41.7),
          SpeciesInfo(name: 'Rúcula', lotCount: 4, percentage: 33.3),
          SpeciesInfo(name: 'Espinafre', lotCount: 2, percentage: 16.7),
          SpeciesInfo(name: 'Agrião', lotCount: 1, percentage: 8.3),
        ],
      ),
      LotStatusData(
        label: 'Finalizados',
        value: 8,
        color: Color(0xFF6B7280),
        speciesDetails: [
          SpeciesInfo(name: 'Alface', lotCount: 3, percentage: 37.5),
          SpeciesInfo(name: 'Rúcula', lotCount: 3, percentage: 37.5),
          SpeciesInfo(name: 'Couve', lotCount: 2, percentage: 25.0),
        ],
      )
    ],
    this.onViewAll,
  }) : super(key: key);

  @override
  State<LotStatusPieChartWidget> createState() =>
      _LotStatusPieChartWidgetState();
}

class _LotStatusPieChartWidgetState extends State<LotStatusPieChartWidget> {
  int? selectedSectionIndex;

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
              if (selectedSectionIndex != null)
                _buildSpeciesDetails()
              else
                _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesDetails() {
    if (selectedSectionIndex == null ||
        selectedSectionIndex! < 0 ||
        selectedSectionIndex! >= widget.statusData.length) {
      return _buildLegend();
    }

    final selectedData = widget.statusData[selectedSectionIndex!];
    final speciesDetails = selectedData.speciesDetails;

    if (speciesDetails == null || speciesDetails.isEmpty) {
      return _buildLegend();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedData.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedData.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: selectedData.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Detalhes - ${selectedData.label}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSectionIndex = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Distribuição por Espécie:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ...speciesDetails.map((species) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectedData.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      species.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '${species.lotCount} lotes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: selectedData.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${species.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selectedData.color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selectedData.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Toque no gráfico novamente para voltar à visão geral',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selectedData.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final totalLots =
        widget.statusData.fold<int>(0, (sum, item) => sum + item.value);
    final activeLots = widget.statusData
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
    final total =
        widget.statusData.fold<int>(0, (sum, item) => sum + item.value);

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
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        selectedSectionIndex = null;
                        return;
                      }
                      final touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;

                      // Validar se o índice está dentro do range válido
                      if (touchedIndex >= 0 &&
                          touchedIndex < widget.statusData.length) {
                        selectedSectionIndex = touchedIndex;
                      } else {
                        selectedSectionIndex = null;
                      }
                    });
                  },
                ),
                sections: widget.statusData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final percentage = total > 0 ? (data.value / total * 100) : 0;
                  final isSelected = index == selectedSectionIndex;

                  return PieChartSectionData(
                    color: data.color,
                    value: data.value.toDouble(),
                    title: '${percentage.round()}%',
                    radius: isSelected ? 70 : 60, // Expande quando selecionado
                    titleStyle: TextStyle(
                      fontSize: isSelected ? 16 : 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    badgeWidget: isSelected && data.speciesDetails != null
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.info_outline,
                              size: 10,
                              color: data.color,
                            ),
                          )
                        : null,
                    badgePositionPercentageOffset: 1.3,
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.touch_app,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Toque nas seções do gráfico para ver detalhes das espécies',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...widget.statusData.map((data) {
          final total =
              widget.statusData.fold<int>(0, (sum, item) => sum + item.value);
          final percentage = total > 0 ? (data.value / total * 100).round() : 0;
          final hasDetails =
              data.speciesDetails != null && data.speciesDetails!.isNotEmpty;

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
                  child: Row(
                    children: [
                      Text(
                        data.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (hasDetails) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'detalhes',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: data.color,
                            ),
                          ),
                        ),
                      ],
                    ],
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
        if (widget.onViewAll != null) _buildViewAllButton(),
      ],
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: widget.onViewAll,
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
