import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/services/metrics_service.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class MetricsDashboardPage extends StatefulWidget {
  const MetricsDashboardPage({super.key});

  @override
  State<MetricsDashboardPage> createState() => _MetricsDashboardPageState();
}

class _MetricsDashboardPageState extends State<MetricsDashboardPage> {
  bool _loading = true;
  String? _error;

  Map<String, dynamic> _globalMetrics = {};
  List<Map<String, dynamic>> _usersMetrics = [];

  String _selectedModeFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final globalFuture = MetricsService.getGlobalMetrics();
      final usersFuture = MetricsService.listUsersWithMetrics();

      final globalMetrics = await globalFuture;
      final usersMetrics = await usersFuture;

      setState(() {
        _globalMetrics = globalMetrics;
        _usersMetrics = usersMetrics;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      appBar: AppBar(
        title: const Text('Métricas de Adaptação'),
        backgroundColor: Constants.kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Erro ao carregar métricas:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700])),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    return CustomScrollView(
      slivers: [
        // Cards globais
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visão Geral',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_globalMetrics['totalUsers'] ?? 0} usuários · ${_globalMetrics['totalSessions'] ?? 0} sessões',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 2 : 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isMobile ? 1.5 : 2,
                  children: [
                    _buildMetricCard(
                      icon: Icons.touch_app,
                      label: 'Acceptance Rate',
                      value: MetricsService.formatRate(
                          _globalMetrics['globalAcceptanceRate']),
                      color: Colors.green,
                    ),
                    _buildMetricCard(
                      icon: Icons.swap_horiz,
                      label: 'Pass-Through Rate',
                      value: MetricsService.formatRate(
                          _globalMetrics['globalPassThroughRate']),
                      color: Colors.orange,
                    ),
                    _buildMetricCard(
                      icon: Icons.timer,
                      label: 'Avg Time-to-Task',
                      value: MetricsService.formatTime(
                          _globalMetrics['globalAvgTimeToTask']),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Comparação por modo
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comparação por Modo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildModeCards(),
              ],
            ),
          ),
        ),

        // Lista de usuários
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, 16, isMobile ? 16 : 32, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Por Usuário',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${_usersMetrics.length} usuários',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filtro por modo
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: ['ALL', 'GRADUAL', 'INSTANT', 'STATIC']
                  .map((mode) => ChoiceChip(
                        label: Text(mode),
                        selected: _selectedModeFilter == mode,
                        onSelected: (_) {
                          setState(() => _selectedModeFilter = mode);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),

        // Lista
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final filteredUsers = _selectedModeFilter == 'ALL'
                  ? _usersMetrics
                  : _usersMetrics
                      .where((u) => u['mode'] == _selectedModeFilter)
                      .toList();

              if (index >= filteredUsers.length) return null;
              final user = filteredUsers[index];
              return _buildUserTile(user);
            },
            childCount: _selectedModeFilter == 'ALL'
                ? _usersMetrics.length
                : _usersMetrics
                    .where((u) => u['mode'] == _selectedModeFilter)
                    .length,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildModeCards() {
    final byMode = _globalMetrics['byMode'] as Map<String, dynamic>? ?? {};

    const modeLabels = {
      'GRADUAL': 'Gradual (BigQuery 30d)',
      'INSTANT': 'Instantâneo (Sessão)',
      'STATIC': 'Estático (Controle)',
    };

    const modeColors = {
      'GRADUAL': Colors.blue,
      'INSTANT': Colors.purple,
      'STATIC': Colors.grey,
    };

    return byMode.entries.map((entry) {
      final mode = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final color = modeColors[mode] ?? Colors.grey;

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    modeLabels[mode] ?? mode,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${data['usersCount'] ?? 0} usuários',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _buildInlineStat(
                      'Acceptance',
                      MetricsService.formatRate(data['acceptanceRate']),
                      Colors.green),
                  _buildInlineStat(
                      'Pass-Through',
                      MetricsService.formatRate(data['passThroughRate']),
                      Colors.orange),
                  _buildInlineStat(
                      'Time-to-Task',
                      MetricsService.formatTime(data['avgTimeToTask']),
                      Colors.blue),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildInlineStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final userId = user['userId'] ?? 'unknown';
    final mode = user['mode'] ?? 'GRADUAL';
    final sessions = user['sessionsCount'] ?? 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Constants.kPrimaryColor.withValues(alpha: 0.1),
        child: Text(
          userId.substring(0, userId.length > 2 ? 2 : userId.length),
          style: TextStyle(
            color: Constants.kPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text('Usuário $userId'),
      subtitle: Text(
        'Modo: $mode · $sessions sessões · Acceptance: ${MetricsService.formatRate(user['acceptanceRate'])}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Futuramente: navegar para UserMetricsDetailPage
      },
    );
  }
}
