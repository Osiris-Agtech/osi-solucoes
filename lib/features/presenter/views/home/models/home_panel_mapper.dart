import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';
import 'package:osi_solucoes/features/presenter/models/shortcut/shortcut_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

import 'home_panel_view_data.dart';

class HomePanelMapper {
  static const int maxRecommendedActions = 4;

  static HomePanelViewData map({
    required HomeDashboard? dashboard,
    required List<ShortcutModel> recommendedShortcuts,
    required String? userName,
    required String? accountName,
    required String? roleName,
    required int accountCount,
    required bool hasAdaptiveDashboardRecommendation,
    required String? adaptiveCardType,
    required List<String> cardOrder,
  }) {
    return HomePanelViewData(
      header: HomeHeaderViewData(
        greeting: _greeting(userName),
        accountContext: _safeText(accountName, 'Conta não selecionada'),
        roleLabel: _safeText(roleName, 'Perfil operacional'),
        canOpenTasks: true,
        canSwitchAccount: accountCount >= 2,
      ),
      today: _mapToday(dashboard),
      actions: _mapActions(recommendedShortcuts),
      production: _mapProduction(dashboard?.producao),
      modules: _defaultModules(),
      hasDashboardSupport: hasAdaptiveDashboardRecommendation ||
          adaptiveCardType != null ||
          cardOrder.isNotEmpty,
    );
  }

  static TodayCultivationViewData _mapToday(HomeDashboard? dashboard) {
    final tarefas = dashboard?.tarefas;
    final resumo = dashboard?.resumo;
    final alerts = dashboard?.alertasCritico ?? const <HomeAlertaCritico>[];
    final latestTasks = tarefas?.ultimasTarefas ?? const <HomeTarefaDetalhe>[];

    return TodayCultivationViewData(
      tasksToday: tarefas?.pendentesHoje ?? tarefas?.porVencimento?.hoje ?? 0,
      overdueTasks: tarefas?.atrasadas ?? 0,
      activeLots: resumo?.lotesAtivos ?? 0,
      upcomingHarvests: resumo?.lotesComColheitaProxima ??
          dashboard?.producao?.lotesComColheitaProxima ??
          0,
      tasks: latestTasks.take(3).map(_taskItem).toList(),
      criticalAlerts: alerts.take(3).map(_alertItem).toList(),
    );
  }

  static HomePanelListItemViewData _taskItem(HomeTarefaDetalhe task) {
    final isOverdue = task.vencida == true;
    return HomePanelListItemViewData(
      title: _safeText(task.titulo, 'Tarefa sem título'),
      description: _joinNonEmpty([
        task.loteNome,
        isOverdue ? 'Vencida' : task.data,
      ]),
      tone: isOverdue ? HomePanelTone.danger : HomePanelTone.warning,
      icon: isOverdue ? Icons.warning_rounded : Icons.task_alt_rounded,
    );
  }

  static HomePanelListItemViewData _alertItem(HomeAlertaCritico alert) {
    final tone = _alertTone(alert.gravidade);
    return HomePanelListItemViewData(
      title: _safeText(alert.mensagem, 'Alerta do cultivo'),
      description: _joinNonEmpty([alert.loteNome, alert.tipo, alert.data]),
      tone: tone,
      icon: tone == HomePanelTone.danger
          ? Icons.error_rounded
          : Icons.warning_amber_rounded,
    );
  }

  static HomePanelTone _alertTone(String? severity) {
    final value = severity?.toLowerCase().trim() ?? '';
    if (value.contains('crit') ||
        value.contains('alta') ||
        value.contains('erro')) {
      return HomePanelTone.danger;
    }
    if (value.contains('media') ||
        value.contains('média') ||
        value.contains('aten')) {
      return HomePanelTone.warning;
    }
    return HomePanelTone.neutral;
  }

  static List<RecommendedActionViewData> _mapActions(
    List<ShortcutModel> shortcuts,
  ) {
    final actions = shortcuts
        .where((shortcut) => _isValidRoute(shortcut.route))
        .map(
          (shortcut) => RecommendedActionViewData(
            label: shortcut.displayTitle,
            description: shortcut.isAdaptiveRecommendation
                ? _adaptiveDescription(shortcut)
                : 'Acesso rápido operacional',
            route: shortcut.route,
            iconAsset: shortcut.icon,
            color: shortcut.color,
            isAdaptive: shortcut.isAdaptiveRecommendation,
            confidence: shortcut.confidence,
            resourceId: shortcut.resourceId,
            resourceType: shortcut.resourceType,
            resourceName: shortcut.resourceName,
          ),
        )
        .take(maxRecommendedActions)
        .toList();

    if (actions.isNotEmpty) return actions;

    return const [
      RecommendedActionViewData(
        label: 'Ver agenda',
        description: 'Revisar tarefas e atividades',
        route: Routes.agendaPage,
        iconAsset: 'assets/icons/inventario_icon.svg',
        color: Color(0xFF06B6D4),
        isAdaptive: false,
        confidence: 0,
      ),
      RecommendedActionViewData(
        label: 'Lotes',
        description: 'Acompanhar produção ativa',
        route: Routes.lotePage,
        iconAsset: 'assets/icons/cultivo_icon.svg',
        color: Color(0xFF059669),
        isAdaptive: false,
        confidence: 0,
      ),
      RecommendedActionViewData(
        label: 'Relatórios',
        description: 'Consultar indicadores',
        route: Routes.relatoriosPage,
        iconAsset: 'assets/icons/relatorio_icon.svg',
        color: Color(0xFF8B5CF6),
        isAdaptive: false,
        confidence: 0,
      ),
    ];
  }

  static ProductionSummaryViewData _mapProduction(HomeProducao? production) {
    final plants = production?.totalPlantasColhidas ?? 0;
    final packages = production?.totalEmbalagensProduzidas ?? 0;
    final variation = production?.comparativoPeriodo?.variacaoPercentual;
    final hasPlants = plants > 0;

    return ProductionSummaryViewData(
      metricLabel: hasPlants ? 'Plantas colhidas' : 'Embalagens produzidas',
      metricValue: _formatNumber(hasPlants ? plants : packages),
      trendLabel: variation == null ? '' : _formatVariation(variation),
      periodLabel: _formatPeriod(production),
      reportRoute: Routes.relatoriosPage,
    );
  }

  static List<HomeModuleShortcutViewData> _defaultModules() {
    return const [
      HomeModuleShortcutViewData(
          label: 'Cultivos/Áreas',
          description: 'Áreas de cultivo',
          iconAsset: 'assets/icons/cultivo_icon.svg',
          color: Color(0xFF059669),
          route: Routes.areaCultivoPage),
      HomeModuleShortcutViewData(
          label: 'Reservatórios',
          description: 'Solução nutritiva',
          iconAsset: 'assets/icons/reservatorio_icon.svg',
          color: Color(0xFF2563EB),
          route: Routes.reservatoriosPage),
      HomeModuleShortcutViewData(
          label: 'Caderno de Campo',
          description: 'Registros de campo',
          iconAsset: 'assets/icons/caderno_campo_icon.svg',
          color: Color(0xFFDC2626),
          route: Routes.cadernoCampoPage),
      HomeModuleShortcutViewData(
          label: 'Soluções Nutritivas',
          description: 'Formulação de nutrientes',
          iconAsset: 'assets/icons/solucoes_nutritivas_icon.svg',
          color: Color(0xFFEA580C),
          route: Routes.solucaoPage),
      HomeModuleShortcutViewData(
          label: 'Relatórios',
          description: 'Análises e métricas',
          iconAsset: 'assets/icons/relatorio_icon.svg',
          color: Color(0xFF8B5CF6),
          route: Routes.relatoriosPage),
      HomeModuleShortcutViewData(
          label: 'Ajustes',
          description: 'Parâmetros de cultivo',
          iconAsset: 'assets/icons/ajustes_icon.svg',
          color: Color(0xFF7C3AED),
          route: Routes.ajustesPage),
      HomeModuleShortcutViewData(
          label: 'Gestão de equipe',
          description: 'Usuários e permissões',
          iconAsset: 'assets/icons/gerenciar_icon.svg',
          color: Color(0xFF6366F1),
          route: Routes.gerenciarEquipePage),
      HomeModuleShortcutViewData(
          label: 'Agenda',
          description: 'Tarefas e atividades',
          iconAsset: 'assets/icons/inventario_icon.svg',
          color: Color(0xFF06B6D4),
          route: Routes.agendaPage),
      HomeModuleShortcutViewData(
          label: 'Protocolos',
          description: 'Templates de cultivo',
          iconAsset: 'assets/icons/etapa.svg',
          color: Color(0xFF10B981),
          route: Routes.protocoloPage),
      HomeModuleShortcutViewData(
          label: 'Histórico',
          description: 'Registros finalizados',
          iconAsset: 'assets/icons/relatorio_icon.svg',
          color: Color(0xFF8B5CF6),
          route: Routes.historicoPage),
    ];
  }

  static bool _isValidRoute(String route) => _validRoutes.contains(route);

  static const Set<String> _validRoutes = {
    Routes.gerenciarEquipePage,
    Routes.historicoPage,
    Routes.ajustesPage,
    Routes.agendaPage,
    Routes.protocoloPage,
    Routes.relatoriosPage,
    Routes.lotePage,
    Routes.cadernoCampoPage,
    Routes.reservatoriosPage,
    Routes.solucaoPage,
    Routes.areaCultivoPage,
    Routes.setorPage,
  };

  static String _adaptiveDescription(ShortcutModel shortcut) {
    if (shortcut.resourceName != null) {
      return 'Recomendado para ${shortcut.resourceName}';
    }
    if (shortcut.context != null) {
      return 'Recomendado pelo uso ${shortcut.context}';
    }
    return 'Recomendação adaptativa';
  }

  static String _greeting(String? name) {
    final cleanName = name?.trim();
    if (cleanName == null || cleanName.isEmpty) return 'Olá';
    return 'Olá, $cleanName';
  }

  static String _safeText(String? value, String fallback) {
    final cleanValue = value?.trim();
    return cleanValue == null || cleanValue.isEmpty ? fallback : cleanValue;
  }

  static String _joinNonEmpty(List<String?> values) {
    return values
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' • ');
  }

  static String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }

  static String _formatVariation(double variation) {
    final prefix = variation >= 0 ? '+' : '';
    return '$prefix${variation.toStringAsFixed(1)}% vs período anterior';
  }

  static String _formatPeriod(HomeProducao? production) {
    if (production?.periodoInicio == null || production?.periodoFim == null) {
      return 'Período atual';
    }
    return 'De ${production!.periodoInicio} a ${production.periodoFim}';
  }
}
