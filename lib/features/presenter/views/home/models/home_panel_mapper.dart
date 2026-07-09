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
    required String adaptiveMode,
    required String adaptiveSource,
    required String adaptiveVisualPriority,
    required String? adaptiveReason,
    required double adaptiveConfidence,
  }) {
    final adaptation = _resolveAdaptation(
      dashboard: dashboard,
      cardType: adaptiveCardType,
      mode: adaptiveMode,
      source: adaptiveSource,
      visualPriority: adaptiveVisualPriority,
      reason: adaptiveReason,
      confidence: adaptiveConfidence,
    );

    return HomePanelViewData(
      header: HomeHeaderViewData(
        greeting: _greeting(userName),
        accountContext: _safeText(accountName, 'Conta não selecionada'),
        roleLabel: _safeText(roleName, 'Perfil operacional'),
        canOpenTasks: true,
        canSwitchAccount: accountCount >= 2,
      ),
      today: _mapToday(dashboard, adaptation),
      actions: _mapActions(recommendedShortcuts),
      production: _mapProduction(dashboard?.producao, adaptation),
      modules: _defaultModules(),
      hasDashboardSupport:
          hasAdaptiveDashboardRecommendation || adaptation.hasHighlight,
      adaptation: adaptation,
    );
  }

  static HomeAdaptationViewData _resolveAdaptation({
    required HomeDashboard? dashboard,
    required String? cardType,
    required String mode,
    required String source,
    required String visualPriority,
    required String? reason,
    required double confidence,
  }) {
    final resolvedMode = _adaptationMode(mode);
    final resolvedSource = _adaptationSource(source);
    final focus = _adaptationFocus(cardType);
    final hasCriticalAlerts = dashboard?.alertasCritico?.isNotEmpty == true;

    if (resolvedMode == HomeAdaptationMode.static ||
        resolvedSource != HomeAdaptationSource.adaptive ||
        focus == null) {
      return HomeAdaptationViewData.none;
    }

    if (!_hasDataForFocus(dashboard, focus)) {
      return HomeAdaptationViewData.none;
    }

    final matrixStrength = _matrixStrength(resolvedMode, confidence);
    final hasVisualPriority = visualPriority.trim().isNotEmpty;
    final baseStrength = hasVisualPriority
        ? _minStrength(_adaptationStrength(visualPriority), matrixStrength)
        : matrixStrength;
    final strength = hasCriticalAlerts && focus != HomeAdaptationFocus.saude
        ? HomeAdaptationStrength.none
        : baseStrength;

    if (strength == HomeAdaptationStrength.none) {
      return HomeAdaptationViewData.none;
    }

    return HomeAdaptationViewData(
      mode: resolvedMode,
      confidence: _clampConfidence(confidence),
      strength: resolvedMode == HomeAdaptationMode.instant
          ? _minStrength(strength, HomeAdaptationStrength.weak)
          : strength,
      source: resolvedSource,
      reason: reason,
      isTemporary: resolvedMode == HomeAdaptationMode.instant,
      highlightedFocus: focus,
      label: _adaptationLabel(resolvedMode, focus),
    );
  }

  static HomeAdaptationMode _adaptationMode(String value) {
    switch (value.trim().toUpperCase()) {
      case 'STATIC':
        return HomeAdaptationMode.static;
      case 'INSTANT':
        return HomeAdaptationMode.instant;
      case 'GRADUAL':
        return HomeAdaptationMode.gradual;
      default:
        return HomeAdaptationMode.static;
    }
  }

  static HomeAdaptationSource _adaptationSource(String value) {
    switch (value.trim().toLowerCase()) {
      case 'adaptive':
        return HomeAdaptationSource.adaptive;
      case 'fallback':
        return HomeAdaptationSource.fallback;
      case 'insufficient_data':
        return HomeAdaptationSource.insufficientData;
      case 'system':
      default:
        return HomeAdaptationSource.system;
    }
  }

  static HomeAdaptationStrength _adaptationStrength(String value) {
    switch (value.trim().toLowerCase()) {
      case 'weak':
        return HomeAdaptationStrength.weak;
      case 'moderate':
        return HomeAdaptationStrength.moderate;
      case 'strong':
        return HomeAdaptationStrength.strong;
      case 'none':
      default:
        return HomeAdaptationStrength.none;
    }
  }

  static HomeAdaptationFocus? _adaptationFocus(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'tarefas':
        return HomeAdaptationFocus.tarefas;
      case 'lotes':
        return HomeAdaptationFocus.lotes;
      case 'producao':
        return HomeAdaptationFocus.producao;
      case 'saude':
        return HomeAdaptationFocus.saude;
      default:
        return null;
    }
  }

  static HomeAdaptationStrength _matrixStrength(
    HomeAdaptationMode mode,
    double confidence,
  ) {
    if (mode == HomeAdaptationMode.instant) return HomeAdaptationStrength.weak;
    if (mode == HomeAdaptationMode.static) return HomeAdaptationStrength.none;
    if (confidence >= 0.85) return HomeAdaptationStrength.strong;
    if (confidence >= 0.7) return HomeAdaptationStrength.moderate;
    if (confidence >= 0.4) return HomeAdaptationStrength.weak;
    return HomeAdaptationStrength.none;
  }

  static double _clampConfidence(double confidence) {
    if (confidence < 0) return 0;
    if (confidence > 1) return 1;
    return confidence;
  }

  static HomeAdaptationStrength _minStrength(
    HomeAdaptationStrength first,
    HomeAdaptationStrength second,
  ) {
    final firstIndex = HomeAdaptationStrength.values.indexOf(first);
    final secondIndex = HomeAdaptationStrength.values.indexOf(second);
    return firstIndex <= secondIndex ? first : second;
  }

  static String _adaptationLabel(
    HomeAdaptationMode mode,
    HomeAdaptationFocus focus,
  ) {
    if (mode == HomeAdaptationMode.instant) return 'Nesta sessão';
    switch (focus) {
      case HomeAdaptationFocus.tarefas:
        return 'Foco em tarefas';
      case HomeAdaptationFocus.lotes:
        return 'Foco no cultivo';
      case HomeAdaptationFocus.producao:
        return 'Foco em produção';
      case HomeAdaptationFocus.saude:
        return 'Foco em atenção';
    }
  }

  static bool _hasDataForFocus(
    HomeDashboard? dashboard,
    HomeAdaptationFocus focus,
  ) {
    if (dashboard == null) return false;
    switch (focus) {
      case HomeAdaptationFocus.tarefas:
        final tarefas = dashboard.tarefas;
        return (tarefas?.pendentesHoje ?? tarefas?.porVencimento?.hoje ?? 0) >
                0 ||
            (tarefas?.atrasadas ?? 0) > 0 ||
            (tarefas?.ultimasTarefas?.isNotEmpty == true);
      case HomeAdaptationFocus.lotes:
        final resumo = dashboard.resumo;
        return (resumo?.lotesAtivos ?? 0) > 0 ||
            (resumo?.lotesComColheitaProxima ??
                    dashboard.producao?.lotesComColheitaProxima ??
                    0) >
                0;
      case HomeAdaptationFocus.producao:
        final producao = dashboard.producao;
        return (producao?.totalPlantasColhidas ?? 0) > 0 ||
            (producao?.totalEmbalagensProduzidas ?? 0) > 0 ||
            producao?.comparativoPeriodo?.variacaoPercentual != null;
      case HomeAdaptationFocus.saude:
        return (dashboard.alertasCritico?.isNotEmpty == true) ||
            (dashboard.tarefas?.atrasadas ?? 0) > 0;
    }
  }

  static TodayCultivationViewData _mapToday(
    HomeDashboard? dashboard,
    HomeAdaptationViewData adaptation,
  ) {
    final tarefas = dashboard?.tarefas;
    final resumo = dashboard?.resumo;
    final alerts = dashboard?.alertasCritico ?? const <HomeAlertaCritico>[];
    final latestTasks = tarefas?.ultimasTarefas ?? const <HomeTarefaDetalhe>[];

    final tasksToday =
        tarefas?.pendentesHoje ?? tarefas?.porVencimento?.hoje ?? 0;
    final overdueTasks = tarefas?.atrasadas ?? 0;
    final activeLots = resumo?.lotesAtivos ?? 0;
    final upcomingHarvests = resumo?.lotesComColheitaProxima ??
        dashboard?.producao?.lotesComColheitaProxima ??
        0;
    final todayAdaptation = _todayAdaptation(
      adaptation: adaptation,
      tasksToday: tasksToday,
      overdueTasks: overdueTasks,
      activeLots: activeLots,
      upcomingHarvests: upcomingHarvests,
      tasks: latestTasks,
      criticalAlerts: alerts,
    );

    return TodayCultivationViewData(
      tasksToday: tasksToday,
      overdueTasks: overdueTasks,
      activeLots: activeLots,
      upcomingHarvests: upcomingHarvests,
      tasks: latestTasks.take(3).map(_taskItem).toList(),
      criticalAlerts: alerts.take(3).map(_alertItem).toList(),
      adaptation: todayAdaptation,
      highlightedMetric: _todayHighlightedMetric(todayAdaptation),
    );
  }

  static HomeAdaptationViewData _todayAdaptation({
    required HomeAdaptationViewData adaptation,
    required int tasksToday,
    required int overdueTasks,
    required int activeLots,
    required int upcomingHarvests,
    required List<HomeTarefaDetalhe> tasks,
    required List<HomeAlertaCritico> criticalAlerts,
  }) {
    if (!adaptation.hasHighlight) return HomeAdaptationViewData.none;

    switch (adaptation.highlightedFocus) {
      case HomeAdaptationFocus.tarefas:
        return tasksToday > 0 || overdueTasks > 0 || tasks.isNotEmpty
            ? adaptation
            : HomeAdaptationViewData.none;
      case HomeAdaptationFocus.lotes:
        return activeLots > 0 || upcomingHarvests > 0
            ? adaptation
            : HomeAdaptationViewData.none;
      case HomeAdaptationFocus.saude:
        return criticalAlerts.isNotEmpty || overdueTasks > 0
            ? adaptation
            : HomeAdaptationViewData.none;
      case HomeAdaptationFocus.producao:
      case null:
        return HomeAdaptationViewData.none;
    }
  }

  static HomeAdaptationFocus? _todayHighlightedMetric(
    HomeAdaptationViewData adaptation,
  ) {
    if (!adaptation.hasHighlight) return null;
    final focus = adaptation.highlightedFocus;
    if (focus == HomeAdaptationFocus.tarefas ||
        focus == HomeAdaptationFocus.lotes ||
        focus == HomeAdaptationFocus.saude) {
      return focus;
    }
    return null;
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
    final actions = <RecommendedActionViewData>[];

    for (final shortcut in shortcuts) {
      final resolvedRoute = _resolvedRoute(shortcut.route);
      if (resolvedRoute == null || !_isValidRoute(resolvedRoute)) continue;

      actions.add(
        RecommendedActionViewData(
          label: _actionLabel(shortcut, resolvedRoute),
          description: shortcut.isAdaptiveRecommendation
              ? _adaptiveDescription(shortcut)
              : 'Acesso rápido operacional',
          route: resolvedRoute,
          iconAsset: shortcut.icon,
          color: shortcut.color,
          isAdaptive: shortcut.isAdaptiveRecommendation,
          confidence: shortcut.confidence,
          resourceId: shortcut.resourceId,
          resourceType: shortcut.resourceType,
          resourceName: shortcut.resourceName,
        ),
      );

      if (actions.length == maxRecommendedActions) break;
    }

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

  static ProductionSummaryViewData _mapProduction(
    HomeProducao? production,
    HomeAdaptationViewData adaptation,
  ) {
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
      adaptation: adaptation.highlightedFocus == HomeAdaptationFocus.producao &&
              (hasPlants || packages > 0 || variation != null)
          ? adaptation
          : HomeAdaptationViewData.none,
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

  static bool _isValidRoute(String route) {
    final resolvedRoute = _resolvedRoute(route);
    return resolvedRoute != null && _validRoutes.contains(resolvedRoute);
  }

  static String? _resolvedRoute(String route) {
    final cleanRoute = route.trim();
    if (_validRoutes.contains(cleanRoute)) return cleanRoute;

    return _routeAliases[_routeKey(cleanRoute)];
  }

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
    Routes.relatorioCircoCulturaPage,
    Routes.relatorioProdutividadeSetorPage,
    Routes.relatorioDesempenhoEquipePage,
    Routes.relatorioAgendaTarefasPage,
  };

  static const Map<String, String> _routeAliases = {
    'areacultivo': Routes.areaCultivoPage,
    'setor': Routes.setorPage,
    'lote': Routes.lotePage,
    'reservatorio': Routes.reservatoriosPage,
    'reservatorios': Routes.reservatoriosPage,
    'cadernocampo': Routes.cadernoCampoPage,
    'solucao': Routes.solucaoPage,
    'relatorios': Routes.relatoriosPage,
    'ajustes': Routes.ajustesPage,
    'gerenciarequipe': Routes.gerenciarEquipePage,
    'agenda': Routes.agendaPage,
    'protocolo': Routes.protocoloPage,
    'historico': Routes.historicoPage,
    'relatoriocircocultura': Routes.relatorioCircoCulturaPage,
    'relatoriociclocultura': Routes.relatorioCircoCulturaPage,
    'relatorioprodutividadesetor': Routes.relatorioProdutividadeSetorPage,
    'relatoriodesempenhoequipe': Routes.relatorioDesempenhoEquipePage,
    'relatorioagendatarefas': Routes.relatorioAgendaTarefasPage,
  };

  static const Map<String, String> _friendlyRouteLabels = {
    'areacultivo': 'Cultivos/Áreas',
    'setor': 'Setores',
    'lote': 'Lotes',
    'reservatorios': 'Reservatórios',
    'cadernocampo': 'Caderno de Campo',
    'solucao': 'Soluções Nutritivas',
    'relatorios': 'Relatórios',
    'relatoriocircocultura': 'Relatório Ciclo de Cultura',
    'relatoriociclocultura': 'Relatório Ciclo de Cultura',
    'relatorioprodutividadesetor': 'Relatório de Produtividade por Setor',
    'relatoriodesempenhoequipe': 'Relatório de Desempenho da Equipe',
    'relatorioagendatarefas': 'Relatório de Agenda de Tarefas',
    'ajustes': 'Ajustes',
    'gerenciarequipe': 'Gestão de equipe',
    'agenda': 'Agenda',
    'protocolo': 'Protocolos',
    'historico': 'Histórico',
  };

  static String _actionLabel(ShortcutModel shortcut, String resolvedRoute) {
    if (shortcut.resourceName != null && shortcut.resourceType != null) {
      return shortcut.displayTitle;
    }

    final routeLabel = _friendlyRouteLabels[_routeKey(resolvedRoute)];
    if (routeLabel != null) return routeLabel;

    final cleanTitle = shortcut.title.trim();
    if (cleanTitle.isNotEmpty && !cleanTitle.startsWith('/')) {
      return cleanTitle;
    }

    return _readableRouteLabel(resolvedRoute);
  }

  static String _routeKey(String route) {
    final cleanRoute = route.trim().replaceFirst(RegExp(r'^/+'), '');
    final routeWithoutPage = cleanRoute.replaceFirst(RegExp(r'Page$'), '');
    return routeWithoutPage
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toLowerCase();
  }

  static String _readableRouteLabel(String route) {
    final cleanRoute = route.trim().replaceFirst(RegExp(r'^/+'), '');
    final routeWithoutPage = cleanRoute.replaceFirst(RegExp(r'Page$'), '');
    final separated = routeWithoutPage
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).trim();

    if (separated.isEmpty) return 'Acesso rápido';
    return separated[0].toUpperCase() + separated.substring(1);
  }

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
    final hour = DateTime.now().hour;
    final period = hour < 12 ? 'Bom dia' : (hour < 18 ? 'Boa tarde' : 'Boa noite');
    final cleanName = name?.trim();
    if (cleanName == null || cleanName.isEmpty) return period;
    return '$period, $cleanName';
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
