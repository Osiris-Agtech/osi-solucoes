import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/services/adaptive_admin_service.dart';
import 'package:osi_solucoes/core/services/adaptive_user_service.dart';
import 'package:osi_solucoes/core/services/navigation_analytics.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/adaptive_admin/adaptive_admin_experiments_section.dart';
import 'package:osi_solucoes/features/presenter/views/adaptive_admin/adaptive_admin_support.dart';

class AdaptiveAdminPage extends StatefulWidget {
  const AdaptiveAdminPage({super.key});

  @override
  State<AdaptiveAdminPage> createState() => _AdaptiveAdminPageState();
}

class _AdaptiveAdminPageState extends State<AdaptiveAdminPage> {
  List<UserInfo> _allUsers = [];
  Map<String, Map<String, dynamic>> _configsMap = {};
  List<Map<String, dynamic>> _experiments = [];
  bool _loading = true;
  String? _error;

  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final Set<String> _activeModeFilters = {'ALL'};
  String _experimentFilter = 'ALL';
  String _groupFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final usersFuture = AdaptiveUserService.listAllUsers().catchError((e) {
        debugPrint('Erro ao buscar usuários do ISIS: $e');
        return <UserInfo>[];
      });

      final configsFuture =
          AdaptiveAdminService.listAllConfigs().catchError((e) {
        debugPrint('Erro ao buscar configs da Cloud Function: $e');
        return <Map<String, dynamic>>[];
      });

      final experimentsFuture =
          AdaptiveAdminService.listExperiments().catchError((e) {
        debugPrint('Erro ao buscar experimentos: $e');
        return <Map<String, dynamic>>[];
      });

      final futures = await Future.wait([
        usersFuture,
        configsFuture,
        experimentsFuture,
      ]);

      _allUsers = futures[0] as List<UserInfo>;
      final configs = futures[1] as List<Map<String, dynamic>>;
      _experiments = futures[2] as List<Map<String, dynamic>>;

      final experimentIds =
          _experiments.map(_experimentId).whereType<String>().toSet();
      if (_experimentFilter != 'ALL' &&
          !experimentIds.contains(_experimentFilter)) {
        _experimentFilter = 'ALL';
      }

      _configsMap = {
        for (final config in configs)
          if (config['userId'] != null) config['userId'].toString(): config,
      };
    } catch (e) {
      debugPrint('Erro inesperado ao carregar dados: $e');
      _error = 'Erro ao carregar dados: $e';
    } finally {
      setState(() => _loading = false);
    }
  }

  List<UserWithConfig> get _filteredUsers {
    var users = _allUsers.map((user) {
      final userId = user.id.toString();
      final config = _configsMap[userId] ?? {};
      return UserWithConfig(
        user: user,
        config: config,
      );
    }).toList();

    final query = _searchQuery.toLowerCase().trim();
    if (query.isNotEmpty) {
      users = users.where((u) {
        final nome = (u.user.nome ?? '').toLowerCase();
        final email = (u.user.email ?? '').toLowerCase();
        final id = u.user.id.toString();
        return nome.contains(query) ||
            email.contains(query) ||
            id.contains(query);
      }).toList();
    }

    if (!_activeModeFilters.contains('ALL')) {
      users = users
          .where((u) => u.hasConfig && _activeModeFilters.contains(u.mode))
          .toList();
    }

    if (_experimentFilter != 'ALL') {
      users = users.where((u) => u.experimentId == _experimentFilter).toList();
    }

    if (_groupFilter != 'ALL') {
      users = users.where((u) => u.testGroup == _groupFilter).toList();
    }

    return users;
  }

  Future<void> _configureUser(
    String userId,
    String mode,
  ) async {
    final sessionId = mode == 'INSTANT'
        ? 'session_${userId}_${DateTime.now().millisecondsSinceEpoch}'
        : null;

    try {
      await AdaptiveAdminService.configureUser(
        userId: userId,
        mode: mode,
        sessionId: sessionId,
      );

      if (mode == 'INSTANT' && sessionId != null) {
        await NavigationAnalytics.startTestSession(sessionId);
        if (!mounted) return;
        _showSuccess('Usuário $userId → $mode (sessão iniciada)');
      } else {
        if (!mounted) return;
        _showSuccess('Usuário $userId → $mode (sem sessão)');
      }

      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _endSession(String userId) async {
    final userIdStr = userId.toString();
    final config = _configsMap[userIdStr];
    final currentMode = config?['mode'] as String?;

    if (currentMode != 'INSTANT') {
      _showError('Usuário não está em modo INSTANT (modo atual: $currentMode)');
      return;
    }

    final confirmed = await _confirmDialog(
      'Encerrar Sessão INSTANT',
      'Encerrar a sessão de teste do usuário $userId?\n\nIsso irá:\n• Remover a configuração de modo INSTANT\n• Marcar a sessão como concluída\n• Usuário voltará ao modo GRADUAL (padrão)',
    );
    if (!confirmed) return;

    try {
      await NavigationAnalytics.endTestSession();
      await AdaptiveAdminService.endSession(userId);
      if (!mounted) return;
      _showSuccess('Sessão INSTANT encerrada: $userId (voltou para GRADUAL)');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _createBasicExperiment() async {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final experimentId =
        'experimento_${now.year}$month${day}_${now.millisecondsSinceEpoch}';

    try {
      await AdaptiveAdminService.createExperiment(
        experimentId: experimentId,
        name: 'Experimento A/B ${now.day}/${now.month}/${now.year}',
        description: 'Experimento contrabalanceado criado pelo app admin',
        groups: const [
          {
            'groupId': 'group_a',
            'name': 'Grupo A — STATIC primeiro',
            'conditions': [
              {'period': 1, 'mode': 'STATIC', 'label': 'Controle'},
              {'period': 2, 'mode': 'INSTANT', 'label': 'Experimental'},
            ],
          },
          {
            'groupId': 'group_b',
            'name': 'Grupo B — INSTANT primeiro',
            'conditions': [
              {'period': 1, 'mode': 'INSTANT', 'label': 'Experimental'},
              {'period': 2, 'mode': 'STATIC', 'label': 'Controle'},
            ],
          },
        ],
      );
      if (!mounted) return;
      _showSuccess('Experimento criado: $experimentId');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _advanceExperiment(Map<String, dynamic> experiment) async {
    final id = _experimentId(experiment);
    if (id == null) return;

    final confirmed = await _confirmDialog(
      'Avançar período',
      'Avançar o experimento $id para o próximo período? Esta ação é unidirecional.',
    );
    if (!confirmed) return;

    try {
      final result = await AdaptiveAdminService.advanceExperimentPeriod(id);
      if (!mounted) return;
      _showSuccess('Período avançado: ${result.isEmpty ? id : result}');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _completeExperiment(Map<String, dynamic> experiment) async {
    final id = _experimentId(experiment);
    if (id == null) return;

    final confirmed = await _confirmDialog(
      'Encerrar experimento',
      'Encerrar $id? Novos usuários não serão autoatribuídos a este experimento.',
    );
    if (!confirmed) return;

    try {
      await AdaptiveAdminService.completeExperiment(id);
      if (!mounted) return;
      _showSuccess('Experimento encerrado: $id');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _deleteExperiment(Map<String, dynamic> experiment) async {
    final id = _experimentId(experiment);
    if (id == null) return;

    final confirmed = await _confirmDialog(
      'Excluir experimento',
      'Excluir o documento $id? As configs históricas de usuários não serão apagadas pelo app.',
    );
    if (!confirmed) return;

    try {
      await AdaptiveAdminService.deleteExperiment(id);
      if (!mounted) return;
      _showSuccess('Experimento excluído: $id');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  Future<void> _assignUserToGroup(UserWithConfig userWithConfig) async {
    final experimentId = userWithConfig.experimentId ?? _activeExperimentId;
    if (experimentId == null) {
      _showError('Nenhum experimento ativo encontrado para ajuste');
      return;
    }

    final selectedGroup = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Trocar grupo experimental'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'group_a'),
            child: const Text('Grupo A'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'group_b'),
            child: const Text('Grupo B'),
          ),
        ],
      ),
    );
    if (selectedGroup == null) return;

    final period = _currentPeriodForExperiment(experimentId);
    if (period == null) {
      _showError('Experimento $experimentId não possui currentPeriod válido');
      return;
    }

    try {
      await AdaptiveAdminService.assignParticipantToGroup(
        userId: userWithConfig.user.id.toString(),
        experimentId: experimentId,
        groupId: selectedGroup,
        period: period,
      );
      if (!mounted) return;
      _showSuccess(
        'Usuário ${userWithConfig.user.id} movido para $selectedGroup',
      );
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  String? get _activeExperimentId {
    for (final experiment in _experiments) {
      final status = experiment['status']?.toString();
      if (status == null || status == 'active') {
        return _experimentId(experiment);
      }
    }
    return null;
  }

  int? _currentPeriodForExperiment(String experimentId) {
    for (final experiment in _experiments) {
      if (_experimentId(experiment) != experimentId) continue;
      final currentPeriod = experiment['currentPeriod'];
      if (currentPeriod is int && currentPeriod > 0) return currentPeriod;
      final parsed = int.tryParse(currentPeriod?.toString() ?? '');
      return parsed != null && parsed > 0 ? parsed : null;
    }
    return null;
  }

  String? _experimentId(Map<String, dynamic> experiment) {
    final value = experiment['id'] ?? experiment['experimentId'];
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  void _showModePicker(UserWithConfig userWithConfig) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(userWithConfig.user.displayName),
                subtitle: Text('ID: ${userWithConfig.user.id}'),
              ),
              const Divider(height: 1),
              if (userWithConfig.hasConfig) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Modo atual:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      label: Text(
                        _modeLabel(userWithConfig.mode!),
                        style: TextStyle(
                          color: _modeColor(userWithConfig.mode!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _modeColor(userWithConfig.mode!)
                          .withValues(alpha: 0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alterar para:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              _modeOptionTile(
                userWithConfig,
                'INSTANT',
                '🟢 INSTANT — tempo real',
                Colors.green,
              ),
              _modeOptionTile(
                userWithConfig,
                'STATIC',
                '🟠 STATIC — grupo controle',
                Colors.orange,
              ),
              _modeOptionTile(
                userWithConfig,
                'GRADUAL',
                '⚪ GRADUAL — padrão (BigQuery)',
                Colors.grey,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _modeOptionTile(
      UserWithConfig userWithConfig, String mode, String label, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(Icons.circle, size: 16, color: color),
      ),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        _configureUser(userWithConfig.user.id.toString(), mode);
      },
    );
  }

  Future<bool> _confirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ $message'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ $message'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _modeColor(String mode) {
    switch (mode) {
      case 'INSTANT':
        return Colors.green;
      case 'STATIC':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _modeIcon(String mode) {
    switch (mode) {
      case 'INSTANT':
        return '🟢';
      case 'STATIC':
        return '🟠';
      default:
        return '⚪';
    }
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'INSTANT':
        return 'INSTANT — tempo real';
      case 'STATIC':
        return 'STATIC — grupo controle';
      default:
        return 'GRADUAL — padrão';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filteredUsers;
    final totalConfigured = _configsMap.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Modos Adaptativos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.widgets_rounded),
            onPressed: () => Get.toNamed(Routes.instantComponentGalleryPage),
            tooltip: 'Componentes Instant',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.toNamed(Routes.metricsDashboardPage),
            tooltip: 'Métricas de Adaptação',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Chip(
                label: Text(
                  '$totalConfigured ativos',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue.withValues(alpha: 0.15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: _createBasicExperiment,
            tooltip: 'Criar experimento A/B',
          ),
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
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
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
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    AdaptiveAdminExperimentsSection(
                      experiments: _experiments,
                      onCreateExperiment: _createBasicExperiment,
                      onAdvanceExperiment: _advanceExperiment,
                      onCompleteExperiment: _completeExperiment,
                      onDeleteExperiment: _deleteExperiment,
                    ),

                    // ── Buscar ──
                    AdminSectionHeader(
                      emoji: '🔍',
                      title: 'Buscar',
                      description: 'Localize usuários por nome, email ou ID',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nome, email ou ID...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip('ALL', 'Todos'),
                            _filterChip('INSTANT', '🟢 INSTANT'),
                            _filterChip('STATIC', '🟠 STATIC'),
                            _filterChip('GRADUAL', '⚪ GRADUAL'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          DropdownButton<String>(
                            value: _experimentFilter,
                            items: [
                              const DropdownMenuItem(
                                value: 'ALL',
                                child: Text('Todos experimentos'),
                              ),
                              ..._experiments.map((experiment) {
                                final id =
                                    _experimentId(experiment) ?? 'sem_id';
                                return DropdownMenuItem(
                                  value: id,
                                  child: Text(id),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _experimentFilter = value);
                            },
                          ),
                          DropdownButton<String>(
                            value: _groupFilter,
                            items: const [
                              DropdownMenuItem(
                                  value: 'ALL', child: Text('Todos grupos')),
                              DropdownMenuItem(
                                  value: 'group_a', child: Text('Grupo A')),
                              DropdownMenuItem(
                                  value: 'group_b', child: Text('Grupo B')),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _groupFilter = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    // ── Usuários ──
                    AdminSectionHeader(
                      emoji: '👥',
                      title: 'Usuários',
                      description:
                          '${_allUsers.length} usuários · $totalConfigured configurados',
                    ),

                    if (filteredUsers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔍', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Nenhum resultado para "$_searchQuery"'
                                    : 'Nenhum usuário encontrado',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...filteredUsers.map(
                          (userWithConfig) => _buildUserTile(userWithConfig)),
                  ],
                ),
    );
  }

  Widget _buildUserTile(UserWithConfig userWithConfig) {
    final user = userWithConfig.user;
    final mode = userWithConfig.mode;
    final testGroup = userWithConfig.testGroup;
    final sessionId = userWithConfig.sessionId;
    final experimentId = userWithConfig.experimentId;
    final participantId = userWithConfig.participantId;
    final period = userWithConfig.period;
    final condition = userWithConfig.condition;

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
            backgroundColor: mode != null
                ? _modeColor(mode).withValues(alpha: 0.15)
                : Colors.blue.withValues(alpha: 0.1),
            child: Text(
              mode != null ? _modeIcon(mode) : '👤',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          title: Text(
            user.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${user.id}',
                style: const TextStyle(fontSize: 12),
              ),
              if (mode != null)
                Text(
                  '${_modeIcon(mode)} $mode',
                  style: TextStyle(
                    color: _modeColor(mode),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (testGroup != null && testGroup.isNotEmpty)
                Text(
                  'Grupo: $testGroup',
                  style: const TextStyle(fontSize: 12),
                ),
              if (experimentId != null && experimentId.isNotEmpty)
                Text(
                  'Experimento: $experimentId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              if (participantId != null || period != null || condition != null)
                Text(
                  'Participante: ${participantId ?? '-'} · P${period ?? '-'} · ${condition ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),
              if (sessionId != null && sessionId.isNotEmpty)
                Text(
                  'Sessão: $sessionId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
                onPressed: () => _assignUserToGroup(userWithConfig),
                tooltip: 'Trocar grupo experimental',
              ),
              IconButton(
                icon: Icon(
                  mode != null ? Icons.edit : Icons.add_circle_outline,
                  color: mode != null ? _modeColor(mode) : Colors.blue,
                ),
                onPressed: () => _showModePicker(userWithConfig),
                tooltip: mode != null ? 'Alterar modo' : 'Configurar modo',
              ),
              if (mode == 'INSTANT')
                IconButton(
                  icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                  onPressed: () => _endSession(user.id.toString()),
                  tooltip: 'Encerrar sessão INSTANT',
                ),
            ],
          ),
          onTap: () => _showModePicker(userWithConfig),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _filterChip(String mode, String label) {
    final isActive = _activeModeFilters.contains(mode);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isActive,
        onSelected: (selected) {
          setState(() {
            if (mode == 'ALL') {
              _activeModeFilters.clear();
              _activeModeFilters.add('ALL');
            } else {
              _activeModeFilters.remove('ALL');
              if (selected) {
                _activeModeFilters.add(mode);
              } else {
                _activeModeFilters.remove(mode);
                if (_activeModeFilters.isEmpty) {
                  _activeModeFilters.add('ALL');
                }
              }
            }
          });
        },
      ),
    );
  }
}
