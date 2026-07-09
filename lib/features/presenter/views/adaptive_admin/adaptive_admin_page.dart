import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/services/adaptive_admin_service.dart';
import 'package:osi_solucoes/core/services/adaptive_user_service.dart';
import 'package:osi_solucoes/core/services/navigation_analytics.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

class _UserWithConfig {
  final UserInfo user;
  final String? mode;
  final String? sessionId;
  final String? testGroup;

  _UserWithConfig({
    required this.user,
    this.mode,
    this.sessionId,
    this.testGroup,
  });

  bool get hasConfig => mode != null && mode!.isNotEmpty;
}

class AdaptiveAdminPage extends StatefulWidget {
  const AdaptiveAdminPage({super.key});

  @override
  State<AdaptiveAdminPage> createState() => _AdaptiveAdminPageState();
}

class _AdaptiveAdminPageState extends State<AdaptiveAdminPage> {
  List<UserInfo> _allUsers = [];
  Map<String, Map<String, dynamic>> _configsMap = {};
  bool _loading = true;
  String? _error;

  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final Set<String> _activeModeFilters = {'ALL'};

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
      final usersFuture = AdaptiveUserService.listAllUsers()
          .catchError((e) {
            debugPrint('Erro ao buscar usuários do ISIS: $e');
            return <UserInfo>[];
          });

      final configsFuture = AdaptiveAdminService.listAllConfigs()
          .catchError((e) {
            debugPrint('Erro ao buscar configs da Cloud Function: $e');
            return <Map<String, dynamic>>[];
          });

      final futures = await Future.wait([usersFuture, configsFuture]);

      _allUsers = futures[0] as List<UserInfo>;
      final configs = futures[1] as List<Map<String, dynamic>>;

      _configsMap = {
        for (final config in configs)
          (config['userId'] as String).toString(): config,
      };
    } catch (e) {
      debugPrint('Erro inesperado ao carregar dados: $e');
      _error = 'Erro ao carregar dados: $e';
    } finally {
      setState(() => _loading = false);
    }
  }

  List<_UserWithConfig> get _filteredUsers {
    var users = _allUsers.map((user) {
      final userId = user.id.toString();
      final config = _configsMap[userId] ?? {};
      return _UserWithConfig(
        user: user,
        mode: config['mode'] as String?,
        sessionId: config['sessionId'] as String?,
        testGroup: config['testGroup'] as String?,
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

  void _showModePicker(_UserWithConfig userWithConfig) {
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
                      backgroundColor:
                          _modeColor(userWithConfig.mode!).withValues(alpha: 0.1),
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
      _UserWithConfig userWithConfig, String mode, String label, Color color) {
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
                    // ── Buscar ──
                    _AdminSectionHeader(
                      emoji: '🔍',
                      title: 'Buscar',
                      description: 'Localize usuários por nome, email ou ID',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

                    // ── Usuários ──
                    _AdminSectionHeader(
                      emoji: '👥',
                      title: 'Usuários',
                      description: '${_allUsers.length} usuários · $totalConfigured configurados',
                    ),

                    if (filteredUsers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔍',
                                  style: TextStyle(fontSize: 48)),
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
                      ...filteredUsers.map((userWithConfig) =>
                          _buildUserTile(userWithConfig)),
                  ],
                ),
    );
  }

  Widget _buildUserTile(_UserWithConfig userWithConfig) {
    final user = userWithConfig.user;
    final mode = userWithConfig.mode;
    final testGroup = userWithConfig.testGroup;
    final sessionId = userWithConfig.sessionId;

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
                  '$_modeIcon(mode) $mode',
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

class _AdminSectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _AdminSectionHeader({
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
