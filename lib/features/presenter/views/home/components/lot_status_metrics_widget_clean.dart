import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/relatorio_status_lote_store.dart';

class LotStatusData {
  final String label;
  final int value;
  final Color color;
  final List<SpeciesInfo>? speciesDetails;
  final IconData icon;
  final String description;

  const LotStatusData({
    required this.label,
    required this.value,
    required this.color,
    this.speciesDetails,
    this.icon = Icons.circle,
    this.description = '',
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

class LotStatusMetricsWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onViewAll;

  const LotStatusMetricsWidget({
    super.key,
    this.title = 'Status dos Lotes',
    this.subtitle = 'Situação atual',
    this.onViewAll,
  });

  @override
  LotStatusMetricsWidgetState createState() => LotStatusMetricsWidgetState();
}

class LotStatusMetricsWidgetState extends State<LotStatusMetricsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int? _selectedIndex;

  final RelatorioStatusLoteStore store = GetIt.I<RelatorioStatusLoteStore>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _loadData();
  }

  void _loadData() {
    store.buscarRelatorioStatusLotes();
  }

  List<LotStatusData> get _getStatusData {
    if (store.lotStatusData.isNotEmpty) {
      return _convertData(store.lotStatusData);
    }

    // Dados fallback
    return const [
      LotStatusData(
        label: 'Ativos',
        value: 12,
        color: Color(0xFF059669),
        icon: Icons.eco,
        description: 'Em produção',
      ),
      LotStatusData(
        label: 'Finalizados',
        value: 8,
        color: Color(0xFF6B7280),
        icon: Icons.check_circle,
        description: 'Colhidos',
      ),
      LotStatusData(
        label: 'Em Preparo',
        value: 5,
        color: Color(0xFFF59E0B),
        icon: Icons.schedule,
        description: 'Preparando',
      ),
    ];
  }

  List<LotStatusData> _convertData(List<LotStatusData> sourceData) {
    return sourceData
        .map((item) => LotStatusData(
              label: item.label,
              value: item.value,
              color: item.color,
              description: '${item.value} lotes',
              speciesDetails: item.speciesDetails
                  ?.map((spec) => SpeciesInfo(
                        name: spec.name,
                        lotCount: spec.lotCount,
                        percentage: spec.percentage,
                      ))
                  .toList(),
            ))
        .toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.isLoading) {
          return _buildLoadingState();
        }

        if (store.hasError) {
          return _buildErrorState();
        }

        final statusData = _getStatusData;
        if (statusData.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContent(statusData);
      },
    );
  }

  Widget _buildContent(List<LotStatusData> statusData) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 400;
        final isVerySmall = constraints.maxWidth < 300;

        // Altura dinâmica baseada no número de items e largura
        final minCardWidth = isVerySmall ? 140.0 : 160.0;
        final maxColumns =
            (constraints.maxWidth / minCardWidth).floor().clamp(1, 3);
        final rows = (statusData.length / maxColumns).ceil();
        final estimatedGridHeight =
            rows * (isVerySmall ? 100 : 120) + (rows - 1) * 8;
        final dynamicHeight = (200.0 + estimatedGridHeight).clamp(300.0, 500.0);

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            height: dynamicHeight,
            margin: EdgeInsets.symmetric(
              horizontal: isVerySmall ? 8 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isVerySmall),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isVerySmall ? 12 : 16),
                    child: Column(
                      children: [
                        _buildSummary(statusData, isVerySmall),
                        SizedBox(height: isVerySmall ? 8 : 12),
                        Expanded(
                          child: _buildMetricsGrid(
                              statusData, isSmall, isVerySmall),
                        ),
                        if (_selectedIndex != null &&
                            _selectedIndex! < statusData.length)
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: isVerySmall ? 60 : 80,
                            ),
                            child: SingleChildScrollView(
                              child: _buildSpeciesBreakdown(
                                  statusData[_selectedIndex!], isVerySmall),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isVerySmall) {
    return Container(
      padding: EdgeInsets.all(isVerySmall ? 12 : 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: isVerySmall ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: isVerySmall ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: isVerySmall ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (widget.onViewAll != null)
            TextButton(
              onPressed: widget.onViewAll,
              child: Text(
                'Ver Todos',
                style: TextStyle(
                  fontSize: isVerySmall ? 11 : 12,
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<LotStatusData> statusData, bool isVerySmall) {
    final totalLots = statusData.fold<int>(0, (sum, item) => sum + item.value);

    return Container(
      padding: EdgeInsets.all(isVerySmall ? 12 : 16),
      decoration: BoxDecoration(
        color: Constants.kPrimaryColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kPrimaryColor.withValues(alpha: .1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: Constants.kPrimaryColor,
            size: isVerySmall ? 20 : 24,
          ),
          SizedBox(width: isVerySmall ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total de Lotes',
                style: TextStyle(
                  fontSize: isVerySmall ? 11 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$totalLots',
                style: TextStyle(
                  fontSize: isVerySmall ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${statusData.length} categorias',
            style: TextStyle(
              fontSize: isVerySmall ? 10 : 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
      List<LotStatusData> statusData, bool isSmall, bool isVerySmall) {
    final totalLots = statusData.fold<int>(0, (sum, item) => sum + item.value);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar quantas colunas cabem baseado na largura
        final availableWidth = constraints.maxWidth;
        final minCardWidth = isVerySmall ? 140.0 : 160.0;
        final maxColumns = (availableWidth / minCardWidth).floor().clamp(1, 3);

        // Usar ListView com Wrap para melhor controle
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statusData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final percentage =
                  totalLots > 0 ? (data.value / totalLots) * 100 : 0.0;
              final isSelected = _selectedIndex == index;

              // Calcular largura do card baseado no número de colunas
              final cardWidth = maxColumns == 1
                  ? availableWidth - 16 // Margem
                  : (availableWidth - (maxColumns - 1) * 8 - 16) / maxColumns;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = _selectedIndex == index ? null : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: cardWidth,
                  constraints: BoxConstraints(
                    minHeight: isVerySmall ? 80 : 100,
                    maxHeight: isVerySmall ? 120 : 140,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? data.color.withValues(alpha: .1)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? data.color
                          : Colors.grey.withValues(alpha: .2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header com ícone
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: data.color.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                data.icon,
                                color: data.color,
                                size: 16,
                              ),
                            ),
                            const Spacer(),
                            if (data.speciesDetails != null &&
                                data.speciesDetails!.isNotEmpty)
                              Icon(
                                Icons.expand_more,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Label
                        Text(
                          data.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Valor principal
                        Row(
                          children: [
                            Text(
                              '${data.value}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: data.color,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${percentage.toStringAsFixed(1)}%)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),

                        // Descrição opcional
                        if (data.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              data.description,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSpeciesBreakdown(LotStatusData selectedData, bool isVerySmall) {
    if (selectedData.speciesDetails == null ||
        selectedData.speciesDetails!.isEmpty) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(top: isVerySmall ? 4 : 8),
      padding: EdgeInsets.all(isVerySmall ? 8 : 10),
      decoration: BoxDecoration(
        color: selectedData.color.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selectedData.color.withValues(alpha: .2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Detalhamento - ${selectedData.label}',
            style: TextStyle(
              fontSize: isVerySmall ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: isVerySmall ? 4 : 6),
          Wrap(
            spacing: isVerySmall ? 4 : 6,
            runSpacing: 2,
            children: selectedData.speciesDetails!
                .take(isVerySmall ? 3 : 5)
                .map((species) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isVerySmall ? 4 : 6,
                  vertical: isVerySmall ? 1 : 2,
                ),
                decoration: BoxDecoration(
                  color: selectedData.color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${species.name}: ${species.lotCount}',
                  style: TextStyle(
                    fontSize: isVerySmall ? 8 : 9,
                    color: selectedData.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedData.speciesDetails!.length > (isVerySmall ? 3 : 5))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+${selectedData.speciesDetails!.length - (isVerySmall ? 3 : 5)} mais',
                style: TextStyle(
                  fontSize: isVerySmall ? 7 : 8,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[300],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar dados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              store.errorMessage.isNotEmpty
                  ? store.errorMessage
                  : 'Tente novamente',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              color: Colors.grey[300],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum dado encontrado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há dados de status dos lotes para exibir',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
