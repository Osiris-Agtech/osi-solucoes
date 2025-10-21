// ignore_for_file: unused_local_variable, unused_element

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
    super.key,
    this.title = 'Produção por Cultura',
    this.subtitle = 'Últimos 6 meses',
    this.totalUnit = 'plantas',
    this.cultureData = const [
      CultureData(
        name: 'Alface',
        value: 0,
        color: Color(0xFF059669),
      ),
      CultureData(
        name: 'Rúcula',
        value: 0,
        color: Color(0xFF8B5CF6),
      ),
    ],
    this.months = const ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'],
  });

  @override
  State<ProductivityChartWidget> createState() =>
      _ProductivityChartWidgetState();
}

class _ProductivityChartWidgetState extends State<ProductivityChartWidget> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeBarGroups();
  }

  @override
  void didUpdateWidget(ProductivityChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reconstroi os dados quando o widget é atualizado com novos dados
    if (oldWidget.cultureData != widget.cultureData ||
        oldWidget.months != widget.months) {
      _initializeBarGroups();
    }
  }

  void _initializeBarGroups() {
    // Gera dados baseados nos valores reais de cultureData
    // Distribui os valores ao longo dos meses com variações realistas
    rawBarGroups = widget.months.asMap().entries.map((entry) {
      final index = entry.key;
      final monthValues = _generateMonthlyValues(index);
      return _makeGroupData(
        index,
        monthValues.isNotEmpty ? monthValues[0] : 0.0,
        monthValues.length > 1 ? monthValues[1] : 0.0,
      );
    }).toList();

    showingBarGroups = rawBarGroups;
  }

  List<double> _generateMonthlyValues(int monthIndex) {
    // Se não há dados de cultura, retorna zeros
    if (widget.cultureData.isEmpty) {
      return List.filled(2, 0.0); // Default para 2 culturas
    }

    // Gera valores mensais baseados no total de cada cultura
    // Simula uma distribuição ao longo dos meses com variações
    return widget.cultureData.map((culture) {
      // Se o valor total é 0, retorna 0 para o mês
      if (culture.value == 0) return 0.0;

      // Distribui o valor total ao longo dos meses com variações
      final baseValue = culture.value / widget.months.length;
      final variation = baseValue * 0.3; // 30% de variação
      // Cria uma variação baseada no índice do mês
      final monthMultiplier = 0.8 + (monthIndex * 0.4 / widget.months.length);
      final monthValue = baseValue * monthMultiplier;

      return monthValue.clamp(0.0, culture.value);
    }).toList();
  }

  double _getYAxisInterval() {
    // Calcula um intervalo adequado para o eixo Y baseado nos dados
    if (widget.cultureData.isEmpty) return 50;

    final maxCultureValue =
        widget.cultureData.map((c) => c.value).reduce((a, b) => a > b ? a : b);

    final maxMonthlyValue = maxCultureValue / widget.months.length;

    if (maxMonthlyValue <= 50) return 10;
    if (maxMonthlyValue <= 100) return 25;
    if (maxMonthlyValue <= 200) return 50;
    if (maxMonthlyValue <= 500) return 100;
    return 200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isVerySmallScreen = constraints.maxWidth < 400;

        final totalProduction = widget.cultureData.fold<double>(
          0,
          (sum, culture) => sum + culture.value,
        );

        // Calcula altura baseada no conteúdo para evitar RenderBox sem tamanho
        final chartHeight =
            isVerySmallScreen ? 180.0 : (isSmallScreen ? 220.0 : 260.0);
        final headerHeight = isVerySmallScreen
            ? 80.0
            : 100.0; // Aumentado para acomodar header + legenda
        final padding = isSmallScreen ? 32.0 : 48.0; // padding interno
        final margin = constraints.maxWidth * 0.06; // padding externo

        final totalHeight = headerHeight + chartHeight + padding + margin;

        // Criar um Size a partir de constraints para manter compatibilidade
        final size = Size(constraints.maxWidth, totalHeight);

        return SizedBox(
          height: totalHeight,
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.03),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderWithLegend(totalProduction, size),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Expanded(child: _buildChart(size)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderWithLegend(double totalProduction, Size screenSize) {
    final isSmallScreen = screenSize.width < 600;
    final isVerySmallScreen = screenSize.width < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Título + Total)
        isVerySmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(isSmallScreen, isVerySmallScreen),
                  const SizedBox(height: 8),
                  _buildTotalSection(
                      totalProduction, isSmallScreen, isVerySmallScreen),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTitleSection(isSmallScreen, isVerySmallScreen),
                  ),
                  const SizedBox(width: 8),
                  _buildTotalSection(
                      totalProduction, isSmallScreen, isVerySmallScreen),
                ],
              ),

        // Espaçamento reduzido entre header e legenda
        SizedBox(height: isVerySmallScreen ? 8 : 12),

        // Legenda logo abaixo do header
        _buildLegend(screenSize),
      ],
    );
  }

  Widget _buildHeader(double totalProduction, Size screenSize) {
    final isSmallScreen = screenSize.width < 600;
    final isVerySmallScreen = screenSize.width < 400;

    return Flexible(
      child: isVerySmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(isSmallScreen, isVerySmallScreen),
                const SizedBox(height: 8),
                _buildTotalSection(
                    totalProduction, isSmallScreen, isVerySmallScreen),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTitleSection(isSmallScreen, isVerySmallScreen),
                ),
                const SizedBox(width: 8),
                _buildTotalSection(
                    totalProduction, isSmallScreen, isVerySmallScreen),
              ],
            ),
    );
  }

  Widget _buildTitleSection(bool isSmallScreen, bool isVerySmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 22),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          maxLines: isVerySmallScreen ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.subtitle,
          style: TextStyle(
            fontSize: isVerySmallScreen ? 11 : (isSmallScreen ? 12 : 14),
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTotalSection(
      double totalProduction, bool isSmallScreen, bool isVerySmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Constants.kPrimaryColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${totalProduction.toInt()}',
            style: TextStyle(
              color: Constants.kPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 18),
            ),
          ),
          Text(
            widget.totalUnit,
            style: TextStyle(
              color: Constants.kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: isVerySmallScreen ? 8 : (isSmallScreen ? 9 : 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Size screenSize) {
    final isSmallScreen = screenSize.width < 600;
    final isVerySmallScreen = screenSize.width < 400;

    if (isVerySmallScreen && widget.cultureData.length > 2) {
      // Para telas muito pequenas com muitas culturas, usa scroll horizontal
      return SizedBox(
        height: 30, // Altura reduzida para mais compacidade
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildLegendItems(isSmallScreen, isVerySmallScreen),
          ),
        ),
      );
    } else if (isSmallScreen) {
      // Para telas pequenas, organiza em Wrap mais compacto
      return Wrap(
        runSpacing: 6, // Espaçamento vertical reduzido
        spacing:
            isVerySmallScreen ? 8 : 12, // Espaçamento horizontal adaptativo
        alignment: WrapAlignment.start,
        children: _buildLegendItems(isSmallScreen, isVerySmallScreen),
      );
    } else {
      // Para telas grandes, mantém em linha com espaçamento otimizado
      return Wrap(
        spacing: 16,
        runSpacing: 6,
        alignment: WrapAlignment.start,
        children: _buildLegendItems(isSmallScreen, isVerySmallScreen),
      );
    }
  }

  List<Widget> _buildLegendItems(bool isSmallScreen, bool isVerySmallScreen) {
    return widget.cultureData.asMap().entries.map((entry) {
      final culture = entry.value;
      final isLast = entry.key == widget.cultureData.length - 1;

      return Container(
        margin: EdgeInsets.only(
          right: isLast ? 0 : (isVerySmallScreen ? 8 : 12),
          bottom: 2, // Pequena margem inferior para evitar cortes
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12),
              height: isVerySmallScreen ? 8 : (isSmallScreen ? 10 : 12),
              decoration: BoxDecoration(
                color: culture.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 4 : 6),
            Text(
              '${culture.name} (${culture.value.toInt()} ${widget.totalUnit})',
              style: TextStyle(
                fontSize: isVerySmallScreen ? 9 : (isSmallScreen ? 10 : 11),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildChart(Size screenSize) {
    final isSmallScreen = screenSize.width < 600;
    final isVerySmallScreen = screenSize.width < 400;

    // Calcula o valor máximo dinamicamente baseado nos dados reais
    double maxValue = 250; // valor padrão
    if (widget.cultureData.isNotEmpty) {
      final maxCultureValue = widget.cultureData
          .map((c) => c.value)
          .reduce((a, b) => a > b ? a : b);
      // Define maxY como 25% maior que o maior valor para melhor visualização
      maxValue = (maxCultureValue * 1.25).clamp(50, double.infinity);
    }

    // Largura mínima adaptativa para scroll horizontal
    final minChartWidth = widget.months.length * 60.0; // 60px por mês
    final availableWidth =
        screenSize.width - (isSmallScreen ? 64 : 96); // padding total

    // Verificação de segurança: se não há dados, retorna widget vazio
    if (showingBarGroups.isEmpty) {
      return const Center(
        child: Text(
          'Carregando dados...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    Widget chartWidget = BarChart(
      BarChartData(
        maxY: maxValue,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.grey[800]!,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String cultureName;
              if (rodIndex < widget.cultureData.length) {
                cultureName = widget.cultureData[rodIndex].name;
              } else {
                cultureName = rodIndex == 0 ? 'Cultura 1' : 'Cultura 2';
              }
              return BarTooltipItem(
                '$cultureName\n${rod.toY.toInt()} ${widget.totalUnit}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 10 : 12,
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
              getTitlesWidget: (value, meta) =>
                  _bottomTitles(value, meta, isSmallScreen),
              reservedSize: isSmallScreen ? 28 : 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isSmallScreen ? 28 : 35,
              interval: _getYAxisInterval(),
              getTitlesWidget: (value, meta) =>
                  _leftTitles(value, meta, isSmallScreen),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showingBarGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _getYAxisInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: .1),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );

    // Se o gráfico precisa de mais espaço, adiciona scroll horizontal
    if (minChartWidth > availableWidth) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: minChartWidth,
          child: chartWidget,
        ),
      );
    }

    return chartWidget;
  }

  Widget _leftTitles(double value, TitleMeta meta,
      [bool isSmallScreen = false]) {
    final style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: isSmallScreen ? 10 : 11,
    );

    final interval = _getYAxisInterval();

    // Mostra títulos em intervalos baseados no intervalo calculado
    if (value % interval == 0) {
      return Text(
        '${value.toInt()}',
        style: style,
      );
    }
    return Container();
  }

  Widget _bottomTitles(double value, TitleMeta meta,
      [bool isSmallScreen = false]) {
    final style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: isSmallScreen ? 10 : 11,
    );

    if (value.toInt() < widget.months.length) {
      return Padding(
        padding: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
        child: Text(
          widget.months[value.toInt()],
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return Container();
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    final isSelected = x == touchedGroupIndex;

    // Cria as barras dinamicamente baseado no cultureData
    List<BarChartRodData> barRods = [];

    // Primeira cultura (ou padrão se não existir)
    barRods.add(BarChartRodData(
      toY: y1,
      color: isSelected
          ? (widget.cultureData.isNotEmpty
              ? widget.cultureData[0].color.withValues(alpha: .8)
              : const Color(0xFF059669).withValues(alpha: .8))
          : (widget.cultureData.isNotEmpty
              ? widget.cultureData[0].color
              : const Color(0xFF059669)),
      width: 8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ));

    // Segunda cultura (ou padrão se não existir)
    barRods.add(BarChartRodData(
      toY: y2,
      color: isSelected
          ? (widget.cultureData.length > 1
              ? widget.cultureData[1].color.withValues(alpha: .8)
              : const Color(0xFF8B5CF6).withValues(alpha: .8))
          : (widget.cultureData.length > 1
              ? widget.cultureData[1].color
              : const Color(0xFF8B5CF6)),
      width: 8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ));

    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: barRods,
    );
  }
}
