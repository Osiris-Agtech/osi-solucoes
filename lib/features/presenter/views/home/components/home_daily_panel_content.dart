import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';

import '../models/home_panel_view_data.dart';
import 'home_daily_panel_sections.dart';
import 'home_panel_shared.dart';

class HomeDailyPanelContent extends StatelessWidget {
  final HomePanelViewData? data;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback? onOpenTodayTasks;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;
  final ValueChanged<RecommendedActionViewData> onRecommendedActionTap;
  final VoidCallback? onOpenProductionReport;
  final ValueChanged<HomeModuleShortcutViewData> onModuleTap;

  const HomeDailyPanelContent({
    super.key,
    required this.data,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    required this.onOpenTodayTasks,
    required this.onSwitchAccount,
    required this.onLogout,
    required this.onRecommendedActionTap,
    required this.onOpenProductionReport,
    required this.onModuleTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveBreakpoints.responsivePadding(
      context,
      mobile: 16,
      tablet: 32,
      desktop: 48,
    );
    final maxContentWidth =
        ResponsiveBreakpoints.isDesktop(context) ? 1120.0 : double.infinity;

    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading && data == null) return const HomeDailyPanelSkeleton();
    if (hasError && data == null) {
      return HomeErrorState(message: errorMessage, onRetry: onRetry);
    }

    final viewData = data;
    if (viewData == null || viewData.isEmpty) {
      return HomePanelCard(
        child: HomeEmptyState(
          icon: Icons.event_note_rounded,
          title: 'Home vazia',
          message:
              'Revise a agenda ou os módulos disponíveis e tente recarregar.',
          actionLabel: 'Tentar recarregar',
          onAction: onRetry,
        ),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeDayHeader(
          data: viewData.header,
          onOpenTodayTasks: onOpenTodayTasks,
          onSwitchAccount: onSwitchAccount,
          onLogout: onLogout,
        ),
        const SizedBox(height: 14),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 6,
                  child: TodayCultivationPanel(
                      data: viewData.today, onOpenTasks: onOpenTodayTasks)),
              const SizedBox(width: 14),
              Expanded(
                  flex: 4,
                  child: HomeProductionSummary(
                      data: viewData.production,
                      onOpenReport: onOpenProductionReport)),
            ],
          )
        else ...[
          TodayCultivationPanel(
              data: viewData.today, onOpenTasks: onOpenTodayTasks),
          const SizedBox(height: 14),
          HomeProductionSummary(
              data: viewData.production, onOpenReport: onOpenProductionReport),
        ],
        const SizedBox(height: 14),
        RecommendedActionsSection(
          actions: viewData.actions,
          hasAdaptiveSupport: viewData.hasDashboardSupport,
          onActionTap: onRecommendedActionTap,
        ),
        const SizedBox(height: 14),
        HomeModulesSection(
          modules: viewData.modules,
          onModuleTap: onModuleTap,
        ),
      ],
    );
  }
}
