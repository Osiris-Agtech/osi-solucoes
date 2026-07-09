import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/services/metrics_service.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';

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
      appBar: AppBar(
        title: const Text('📊 Métricas de Adaptação'),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Erro: $_error',
            textAlign: TextAlign.center,
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

    final byMode = _globalMetrics['byMode'] as Map<String, dynamic>? ?? {};
    final filteredUsers = _selectedModeFilter == 'ALL'
        ? _usersMetrics
        : _usersMetrics
            .where((u) => u['mode'] == _selectedModeFilter)
            .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        // ── Visão Geral ──
        _MetricSectionHeader(
          emoji: '📊',
          title: 'Visão Geral',
          description:
              '${_globalMetrics['totalUsers'] ?? 0} usuários · ${_globalMetrics['totalSessions'] ?? 0} sessões',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: GridView.count(
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
        ),

        // ── Comparação por Modo ──
        if (byMode.isNotEmpty) ...[
          _MetricSectionHeader(
            emoji: '📈',
            title: 'Comparação por Modo',
            description: 'Desempenho por modo adaptativo',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: _buildModeCards(byMode),
            ),
          ),
        ],

        // ── Por Usuário ──
        _MetricSectionHeader(
          emoji: '👤',
          title: 'Por Usuário',
          description:
              '${_usersMetrics.length} usuários com métricas individuais',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

        if (filteredUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'Nenhum usuário encontrado',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...filteredUsers.map((user) => _buildUserTile(user)),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
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
    );
  }

  List<Widget> _buildModeCards(Map<String, dynamic> byMode) {
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

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ],
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
                      MetricsService.formatRate(data['avgTimeToTask']),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 8,
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            child: Text(
              userId.substring(0, userId.length > 2 ? 2 : userId.length),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text('Usuário $userId'),
          subtitle: Text(
            'Modo: $mode · $sessions sessões · Acceptance: ${MetricsService.formatRate(user['acceptanceRate'])}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class _MetricSectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _MetricSectionHeader({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji  $title',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
