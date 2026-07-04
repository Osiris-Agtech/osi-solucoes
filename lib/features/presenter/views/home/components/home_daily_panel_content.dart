import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/services/metrics_tracking_service.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/adaptive_focus_banner.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/adaptive_reason_chip.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/adaptive_recommended_action_tile.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/activity_feed_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/next_step_card.dart';

import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_info_context_model.dart';

import '../models/home_panel_view_data.dart';
import 'home_daily_panel_sections.dart';
import 'home_panel_shared.dart';
import 'instant_section_skeleton.dart';

class HomeDailyPanelContent extends StatelessWidget {
  final HomePanelViewData? data;
  final bool isLoading;
  final bool isLoadingInstantAdaptation;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback? onOpenTodayTasks;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;
  final ValueChanged<RecommendedActionViewData> onRecommendedActionTap;
  final ValueChanged<HomeModuleShortcutViewData> onModuleTap;

  // Adaptive instant data (optional — only in INSTANT mode)
  final InstantAdaptiveHomeViewData? instantViewData;
  final String adaptiveMode;
  final String? currentSessionId;

  // Info context data from ISIS
  final HomeInfoContext? infoContext;

  const HomeDailyPanelContent({
    super.key,
    required this.data,
    required this.isLoading,
    this.isLoadingInstantAdaptation = false,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    required this.onOpenTodayTasks,
    required this.onSwitchAccount,
    required this.onLogout,
    required this.onRecommendedActionTap,
    required this.onModuleTap,
    this.instantViewData,
    this.adaptiveMode = 'GRADUAL',
    this.currentSessionId,
    this.infoContext,
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
    // ── Fase 1: nada carregado → skeleton full-page ──
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

    // ── Conteúdo base sempre visível a partir daqui ──
    final instant = instantViewData;
    final hasInstantData = instant != null;
    final showInstantSkeleton =
        isLoadingInstantAdaptation && !hasInstantData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── FIXO: Cabeçalho de saudação ──
        HomeDayHeader(
          data: viewData.header,
          onOpenTodayTasks: onOpenTodayTasks,
          onSwitchAccount: onSwitchAccount,
          onLogout: onLogout,
        ),
        const SizedBox(height: 14),

        // ── SEÇÃO ADAPTATIVA INSTANT: skeleton ou conteúdo real ──
        if (showInstantSkeleton)
          const InstantSectionSkeleton()
        else if (hasInstantData) ...[
          if (instant!.nextStep != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NextStepCard(
                data: instant.nextStep!,
                onCtaTap: () => _handleNextStepCta(instant.nextStep!.targetRoute),
                onInfoTap: instant.nextStep!.infoExplanation != null
                    ? () => _showInfoExplanation(context, instant.nextStep!.infoExplanation!)
                    : null,
              ),
            ),

          if (instant.focusBanner != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AdaptiveFocusBanner(
                data: instant.focusBanner!,
                onCtaTap: instant.focusBanner!.targetRoute != null
                    ? () => _handleAdaptiveNavigation(instant.focusBanner!.targetRoute!)
                    : null,
              ),
            ),

          if (instant.activityFeedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ActivityFeedCard(
                items: instant.activityFeedItems,
                onItemTap: (route) {
                  if (route.isNotEmpty) _handleAdaptiveNavigation(route);
                },
              ),
            ),
        ],

        // ── ATALHOS RELACIONADOS ──
        if (hasInstantData && instant!.recommendedActions.isNotEmpty)
          _buildInstantActions(instant.recommendedActions, instant.nextStep?.targetRoute)
        else if (!hasInstantData && viewData.actions.isNotEmpty && !showInstantSkeleton && !isLoading && adaptiveMode != 'INSTANT')
          RecommendedActionsSection(
            actions: viewData.actions,
            hasAdaptiveSupport: viewData.hasDashboardSupport,
            onActionTap: onRecommendedActionTap,
          ),

        if (hasInstantData && instant!.recommendedActions.isNotEmpty ||
            !hasInstantData && viewData.actions.isNotEmpty && !showInstantSkeleton && !isLoading && adaptiveMode != 'INSTANT')
          const SizedBox(height: 14),

        // ── Reason chip (INSTANT, discreto) ──
        if (hasInstantData && instant!.reasonSummary != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AdaptiveReasonChip(reason: instant.reasonSummary!),
          ),

        // ── INFO CONTEXT CARD ──
        Builder(
          builder: (context) {
            final infoData = HomeInfoMapper.resolve(
              infoContext: infoContext,
              infoRecommendation: instant?.infoRecommendation,
              adaptiveMode: adaptiveMode,
            );

            // Track shown (once per build — acceptable for this use case)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              MetricsTrackingService.instance.trackInfoCardShown(
                infoType: infoData.type.name,
                source: infoContext != null ? 'isis' : 'local',
                mode: adaptiveMode,
                sessionId: currentSessionId,
              );
            });

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: HomeInfoCard(
                data: infoData,
                onCtaTap: infoData.ctaRoute != null
                    ? () => _handleInfoCardCta(infoData)
                    : null,
                isLoading: isLoading,
              ),
            );
          },
        ),

        // ── FIXO: Módulos principais ──
        HomeModulesSection(
          modules: viewData.modules,
          onModuleTap: onModuleTap,
        ),
      ],
    );
  }

  /// Exibe os atalhos recomendados em modo INSTANT.
  /// Mostra todos os atalhos retornados pelo backend — o nextStep
  /// já é o destaque principal com justificativa acima.
  Widget _buildInstantActions(
    List<AdaptiveRecommendedActionViewData> actions,
    String? nextStepRoute,
  ) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            nextStepRoute != null ? 'Relacionados' : 'Ações recomendadas',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AdaptiveRecommendedActionTile(
                action: action,
                onTap: () => _handleAdaptiveNavigation(action.targetRoute),
              ),
            )),
      ],
    );
  }

  // ── Navegação e tracking ──

  void _handleAdaptiveNavigation(String targetRoute) {
    MetricsTrackingService.instance.trackNextStepClicked(
      targetRoute: targetRoute,
      mode: adaptiveMode,
      sessionId: currentSessionId,
    );
    Get.toNamed(targetRoute);
  }

  void _handleNextStepCta(String targetRoute) {
    MetricsTrackingService.instance.trackNextStepClicked(
      targetRoute: targetRoute,
      mode: adaptiveMode,
      sessionId: currentSessionId,
    );
    Get.toNamed(targetRoute);
  }

  void _handleInfoCardCta(HomeInfoViewData infoData) {
    if (infoData.ctaRoute == null) return;

    MetricsTrackingService.instance.trackInfoCardClicked(
      infoType: infoData.type.name,
      targetRoute: infoData.ctaRoute!,
      mode: adaptiveMode,
      sessionId: currentSessionId,
    );
    Get.toNamed(infoData.ctaRoute!);
  }

  void _showInfoExplanation(BuildContext context, String explanation) {
    MetricsTrackingService.instance.trackInfoIconOpened(
      componentId: 'next_step',
      mode: adaptiveMode,
      sessionId: currentSessionId,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
