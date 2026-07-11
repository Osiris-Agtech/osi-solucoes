import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Map<String, dynamic>> _instantMetrics = [];
  bool _loadingInstant = false;

  Map<String, dynamic>? _activeExperiment;
  List<Map<String, dynamic>> _userConfigs = [];

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
      print('📊 [METRICS] globalMetrics payload: $globalMetrics');
      final usersMetrics = await usersFuture;
      print('📊 [METRICS] usersMetrics payload: $usersMetrics');

      // ── INSTANT Metrics from Firestore ──
      try {
        _loadingInstant = true;
        final snap = await FirebaseFirestore.instance
            .collection('instantMetrics')
            .orderBy('createdAt', descending: true)
            .limit(500)
            .get();
        _instantMetrics = snap.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      } catch (e) {
        print('❌ [METRICS] Erro ao carregar instantMetrics: $e');
      } finally {
        _loadingInstant = false;
      }

      print('📊 [METRICS] instantMetrics payload (${_instantMetrics.length} docs): $_instantMetrics');

      // ── Experiment data ──
      try {
        final expSnap = await FirebaseFirestore.instance
            .collection('experimentalGroups')
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();
        _activeExperiment =
            expSnap.docs.isNotEmpty ? expSnap.docs.first.data() : null;

        final configSnap = await FirebaseFirestore.instance
            .collection('userAdaptiveConfig')
            .get();
        _userConfigs = configSnap.docs.map((d) => d.data()).toList();
      } catch (e) {
        print('❌ [METRICS] Erro ao carregar experimento: $e');
      }

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

        // ── Comparação: grupos do experimento ──
        _buildExperimentComparison(),

        // ── Experimento ──
        _experimentSection(),

        // ── INSTANT Metrics Section ──
        _instantMetricsSection(),

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

  // ─────────────────────────────────────────────
  // Experiment Comparison: STATIC vs INSTANT
  // ─────────────────────────────────────────────

  Widget _buildExperimentComparison() {
    if (_activeExperiment == null) {
      return const SizedBox.shrink();
    }

    final exp = _activeExperiment!;
    final groups = (exp['groups'] as List<dynamic>?) ?? [];
    final currentPeriod = exp['currentPeriod'] as int? ?? 1;

    // Group users by testGroup
    final Map<String, List<Map<String, dynamic>>> usersByGroup = {};
    for (final config in _userConfigs) {
      final group = config['testGroup'] as String? ?? 'unknown';
      usersByGroup.putIfAbsent(group, () => []);
      usersByGroup[group]!.add(config);
    }

    String fmtRate(double? rate) =>
        rate != null ? '${(rate * 100).toStringAsFixed(1)}%' : 'N/A';

    final modeColors = <String, Color>{
      'INSTANT': Colors.purple,
      'STATIC': Colors.grey,
      'GRADUAL': Colors.blue,
    };

    // Build comparison cards from experiment groups
    final comparisonCards = groups.map((g) {
      final group = g as Map<String, dynamic>;
      final groupId = group['groupId'] as String? ?? '?';
      final groupName = group['name'] as String? ?? groupId;
      final conditions = (group['conditions'] as List<dynamic>?) ?? [];
      final currentCondition = conditions.firstWhere(
        (c) => (c as Map<String, dynamic>)['period'] == currentPeriod,
        orElse: () => <String, dynamic>{'mode': '?'},
      ) as Map<String, dynamic>;
      final mode = currentCondition['mode'] as String? ?? '?';
      final groupUsers = usersByGroup[groupId] ?? <Map<String, dynamic>>[];
      final groupUserIds = groupUsers
          .map((u) => u['userId'] as String?)
          .whereType<String>()
          .toSet();

      int nextStepShown = 0;
      int nextStepClicked = 0;
      int infoCardShown = 0;
      int infoCardClicked = 0;
      int fallbackEvents = 0;
      int totalEvents = 0;

      for (final metric in _instantMetrics) {
        final uid = metric['userId'] as String?;
        if (uid == null || !groupUserIds.contains(uid)) continue;
        totalEvents++;
        final event = metric['event'] as String?;
        if (event == 'next_step_shown') nextStepShown++;
        if (event == 'next_step_clicked') nextStepClicked++;
        if (event == 'info_card_shown') infoCardShown++;
        if (event == 'info_card_clicked') infoCardClicked++;
        if (event == 'gemini_fallback' || metric['fallbackUsed'] == true) {
          fallbackEvents++;
        }
      }

      final double? ctr = nextStepShown > 0 ? nextStepClicked / nextStepShown : null;
      final double? infoCtr = infoCardShown > 0 ? infoCardClicked / infoCardShown : null;
      final double? fallbackRate = totalEvents > 0 ? fallbackEvents / totalEvents : null;

      return <String, dynamic>{
        'groupId': groupId,
        'groupName': groupName,
        'mode': mode,
        'users': groupUsers.length,
        'events': totalEvents,
        'ctr': ctr,
        'infoCtr': infoCtr,
        'fallbackRate': fallbackRate,
      };
    }).toList();

    final totalUsers = comparisonCards.fold<int>(0, (s, c) => s + (c['users'] as int));
    final modesLabel = comparisonCards.map((c) => c['mode'] as String).join(' vs ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricSectionHeader(
          emoji: '📈',
          title: 'Comparação: $modesLabel',
          description: '${comparisonCards.length} grupos · $totalUsers usuários',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: comparisonCards.map((comp) {
              final color = modeColors[comp['mode'] as String] ?? Colors.grey;
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
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${comp['groupName']} (${comp['mode']})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          Text(
                            '${comp['users']} usuários',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        children: [
                          _buildInlineStat('Next Step CTR', fmtRate(comp['ctr'] as double?), Colors.purple),
                          _buildInlineStat('Info Card CTR', fmtRate(comp['infoCtr'] as double?), Colors.blue),
                          _buildInlineStat('Fallback Rate', fmtRate(comp['fallbackRate'] as double?), Colors.red),
                          _buildInlineStat('Eventos', '${comp['events']}', Colors.teal),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Experiment Section
  // ─────────────────────────────────────────────

  Widget _experimentSection() {
    if (_activeExperiment == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricSectionHeader(
            emoji: '🧪',
            title: 'Experimento',
            description: 'Nenhum experimento ativo',
          ),
        ],
      );
    }

    final exp = _activeExperiment!;
    final groups = (exp['groups'] as List<dynamic>?) ?? [];
    final maxPeriods = exp['totalPeriods'] as int? ?? 1;
    final currentPeriod = exp['currentPeriod'] as int? ?? 1;

    // Group users by testGroup
    final Map<String, List<Map<String, dynamic>>> usersByGroup = {};
    for (final config in _userConfigs) {
      final group = config['testGroup'] as String? ?? 'unknown';
      usersByGroup.putIfAbsent(group, () => []);
      usersByGroup[group]!.add(config);
    }

    // Per-group metrics from _instantMetrics
    String fmtRate(double? rate) =>
        rate != null ? '${(rate * 100).toStringAsFixed(1)}%' : 'N/A';

    Widget groupCard(Map<String, dynamic> group) {
      final groupId = group['groupId'] as String? ?? '?';
      final groupName = group['name'] as String? ?? groupId;
      final condition = group['condition'] as String? ?? '?';
      final groupUsers = usersByGroup[groupId] ?? [];
      final groupUserIds = groupUsers
          .map((u) => u['userId'] as String?)
          .whereType<String>()
          .toSet();

      // Filter instantMetrics for users in this group
      int nextStepShown = 0;
      int nextStepClicked = 0;
      int fallbackEvents = 0;
      int totalEvents = 0;

      for (final metric in _instantMetrics) {
        final uid = metric['userId'] as String?;
        if (uid == null || !groupUserIds.contains(uid)) continue;
        totalEvents++;
        final event = metric['event'] as String?;
        if (event == 'next_step_shown') nextStepShown++;
        if (event == 'next_step_clicked') nextStepClicked++;
        if (event == 'gemini_fallback' || metric['fallbackUsed'] == true) {
          fallbackEvents++;
        }
      }

      final double? ctr =
          nextStepShown > 0 ? nextStepClicked / nextStepShown : null;
      final double? fallbackRate =
          totalEvents > 0 ? fallbackEvents / totalEvents : null;

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
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      groupId,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${groupUsers.length} participantes',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Condição: $condition',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _buildInlineStat(
                      'CTR Next Step', fmtRate(ctr), Colors.purple),
                  _buildInlineStat(
                      'Fallback Rate', fmtRate(fallbackRate), Colors.red),
                  _buildInlineStat(
                      'Eventos', '$totalEvents', Colors.grey),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricSectionHeader(
          emoji: '🧪',
          title: 'Experimento',
          description:
              '${exp['name'] ?? 'Sem nome'} · ${groups.length} grupos',
        ),
        // ── Experiment info card ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exp['name'] ?? 'Sem nome'}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${exp['experimentId'] ?? '?'} · Status: ${exp['status'] ?? '?'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Período $currentPeriod / $maxPeriods',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (maxPeriods > 1)
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: currentPeriod / maxPeriods,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey[200],
                        ),
                        Text(
                          '$currentPeriod/$maxPeriods',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // ── Groups ──
        if (groups.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: groups
                  .map((g) => groupCard(g as Map<String, dynamic>))
                  .toList(),
            ),
          ),
        // ── Distribution ──
        if (groups.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Distribuição: ${usersByGroup.entries.map((e) => '${e.key}: ${e.value.length}').join(' · ')}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // INSTANT Metrics Section
  // ─────────────────────────────────────────────

  Widget _instantMetricsSection() {
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    if (_loadingInstant) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // ── Calculate KPIs ──
    int nextStepShown = 0;
    int nextStepClicked = 0;
    int infoCardShown = 0;
    int infoCardClicked = 0;
    int shortcutClicked = 0;
    int cacheHits = 0;
    int geminiSuccess = 0;
    int geminiFallbacks = 0;
    int geminiError = 0;
    int totalSessions = 0;
    final userIds = <String>{};

    for (final metric in _instantMetrics) {
      final event = metric['event'] as String?;

      switch (event) {
        case 'next_step_shown':
          nextStepShown++;
          break;
        case 'next_step_clicked':
          nextStepClicked++;
          break;
        case 'info_card_shown':
          infoCardShown++;
          break;
        case 'info_card_clicked':
          infoCardClicked++;
          break;
        case 'shortcut_clicked':
          shortcutClicked++;
          break;
        case 'cache_hit':
          cacheHits++;
          break;
        case 'gemini_success':
          geminiSuccess++;
          break;
        case 'gemini_fallback':
          geminiFallbacks++;
          break;
        case 'gemini_error':
          geminiError++;
          break;
        case 'session_start':
          totalSessions++;
          break;
      }

      // fallbackUsed flag (avoid double-count with gemini_fallback event)
      if (metric['fallbackUsed'] == true && event != 'gemini_fallback') {
        geminiFallbacks++;
      }

      final userId = metric['userId'] as String?;
      if (userId != null) userIds.add(userId);
    }

    final totalAdaptations =
        cacheHits + geminiSuccess + geminiFallbacks + geminiError;

    final double? nextStepCtr =
        nextStepShown > 0 ? nextStepClicked / nextStepShown : null;
    final double? infoCardCtr =
        infoCardShown > 0 ? infoCardClicked / infoCardShown : null;
    final double? cacheHitRate =
        totalAdaptations > 0 ? cacheHits / totalAdaptations : null;
    final double? fallbackRate =
        totalAdaptations > 0 ? geminiFallbacks / totalAdaptations : null;

    String fmtRate(double? rate) =>
        rate != null ? '${(rate * 100).toStringAsFixed(1)}%' : 'N/A';

    // ── Group events by userId for timeline ──
    final Map<String, List<Map<String, dynamic>>> eventsByUser = {};
    for (final metric in _instantMetrics) {
      final userId = metric['userId'] as String?;
      if (userId == null) continue;
      eventsByUser.putIfAbsent(userId, () => []);
      eventsByUser[userId]!.add(metric);
    }

    // Sort each user's events by createdAt ascending
    for (final entry in eventsByUser.entries) {
      entry.value.sort((a, b) {
        final aTs = _parseTimestamp(a['createdAt']);
        final bTs = _parseTimestamp(b['createdAt']);
        if (aTs == null && bTs == null) return 0;
        if (aTs == null) return 1;
        if (bTs == null) return -1;
        return aTs.compareTo(bTs);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        _MetricSectionHeader(
          emoji: '🤖',
          title: 'Métricas INSTANT (tempo real)',
          description:
              '${_instantMetrics.length} eventos · ${userIds.length} usuários únicos',
        ),

        // ── KPI Grid ──
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
                icon: Icons.navigate_next,
                label: 'Next Step CTR',
                value: fmtRate(nextStepCtr),
                color: Colors.purple,
              ),
              _buildMetricCard(
                icon: Icons.info_outline,
                label: 'Info Card CTR',
                value: fmtRate(infoCardCtr),
                color: Colors.blue,
              ),
              _buildMetricCard(
                icon: Icons.cached,
                label: 'Cache Hit Rate',
                value: fmtRate(cacheHitRate),
                color: Colors.green,
              ),
              _buildMetricCard(
                icon: Icons.warning,
                label: 'Fallback Rate',
                value: fmtRate(fallbackRate),
                color: Colors.red,
              ),
              _buildMetricCard(
                icon: Icons.smart_toy,
                label: 'Gemini Calls',
                value: '${geminiSuccess + geminiFallbacks + geminiError}',
                color: Colors.indigo,
              ),
              _buildMetricCard(
                icon: Icons.repeat,
                label: 'Total Sessions',
                value: '$totalSessions',
                color: Colors.teal,
              ),
            ],
          ),
        ),

        // ── Unique Users ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            '👤 ${userIds.length} usuários únicos nos eventos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),

        // ── Per-User Event Timeline ──
        if (eventsByUser.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: eventsByUser.entries.map((entry) {
                return _buildUserEventTimeline(entry.key, entry.value);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildUserEventTimeline(
      String userId, List<Map<String, dynamic>> events) {
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
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple.withValues(alpha: 0.1),
            child: Text(
              userId.substring(0, userId.length > 2 ? 2 : userId.length),
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text('Usuário $userId'),
          subtitle: Text('${events.length} eventos'),
          children: events.map((event) {
            final eventName = event['event'] as String? ?? 'unknown';
            final hasFallback = event['fallbackUsed'] == true;
            final stepId = event['stepId'] as String?;
            final targetRoute = event['targetRoute'] as String?;
            final confidence = event['confidence'];

            // Determine icon
            Widget icon;
            if (eventName == 'cache_hit' || eventName == 'gemini_success') {
              icon = const Text('✅', style: TextStyle(fontSize: 16));
            } else if (eventName == 'next_step_clicked' ||
                eventName == 'info_card_clicked' ||
                eventName == 'shortcut_clicked') {
              icon = const Text('👆', style: TextStyle(fontSize: 16));
            } else if (eventName == 'gemini_fallback' ||
                eventName == 'gemini_error' ||
                hasFallback) {
              icon = const Text('❌', style: TextStyle(fontSize: 16));
            } else {
              icon = const Text('📄', style: TextStyle(fontSize: 16));
            }

            // Build details string
            final details = <String>[];
            if (stepId != null && stepId.isNotEmpty) {
              details.add('stepId: $stepId');
            }
            if (targetRoute != null && targetRoute.isNotEmpty) {
              details.add('route: $targetRoute');
            }
            if (confidence != null) {
              details.add('conf: $confidence');
            }

            final ts = _parseTimestamp(event['createdAt']);
            final timeStr = ts != null ? _relativeTime(ts) : '';

            return ListTile(
              leading: icon,
              title: Text(
                eventName,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: details.isNotEmpty
                  ? Text(
                      details.join(' · '),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: Text(
                timeStr,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic ts) {
    if (ts is Timestamp) return ts.toDate();
    if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
    if (ts is double) return DateTime.fromMillisecondsSinceEpoch(ts.toInt());
    return null;
  }

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d atrás';
    if (diff.inHours > 0) return '${diff.inHours}h atrás';
    if (diff.inMinutes > 0) return '${diff.inMinutes}min atrás';
    return 'agora';
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
