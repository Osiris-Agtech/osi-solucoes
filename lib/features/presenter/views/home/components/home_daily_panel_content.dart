import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/services/metrics_tracking_service.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/adaptive_focus_banner.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/activity_feed_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/instant_recommended_actions_panel.dart';

import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_info_context_model.dart';

import '../models/home_panel_view_data.dart';
import 'home_daily_panel_sections.dart';
import 'home_panel_shared.dart';
import 'instant_section_skeleton.dart';

class HomeDailyPanelContent extends StatelessWidget {
  final HomePanelViewData? data;
  final bool isLoading;
  final bool isLoadingInstantAdaptation;
  final bool hasInstantError;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback? onSecretTriggered;
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
    this.hasInstantError = false,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    this.onSecretTriggered,
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
            EdgeInsets.fromLTRB(horizontalPadding, 68, horizontalPadding, 40),
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
        adaptiveMode == 'INSTANT' && !hasInstantData && !hasInstantError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── FIXO: Cabeçalho de saudação ──
        HomeDayHeader(
          data: viewData.header,
          onSecretTriggered: onSecretTriggered,
        ),
        const SizedBox(height: 14),

        // ── SEÇÃO ADAPTATIVA INSTANT: skeleton ou conteúdo real ──
        if (showInstantSkeleton)
          const InstantSectionSkeleton()
        else if (hasInstantData) ...[
          if (instant.focusBanner != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AdaptiveFocusBanner(
                data: instant.focusBanner!,
                onCtaTap: instant.focusBanner!.targetRoute != null
                    ? () => _handleAdaptiveNavigation(
                        instant.focusBanner!.targetRoute!)
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

        // ── INSTANT: Painel unificado de ações recomendadas ──
        if (hasInstantData &&
            (instant.nextStep != null || instant.recommendedActions.isNotEmpty))
          InstantRecommendedActionsPanel(
            nextStep: instant.nextStep,
            recommendedActions: instant.recommendedActions,
            reasonSummary: instant.reasonSummary,
            onActionTap: (route) => _handleAdaptiveNavigation(route),
          )
        else if (!hasInstantData &&
            viewData.actions.isNotEmpty &&
            !showInstantSkeleton &&
            !isLoading &&
            adaptiveMode != 'INSTANT')
          RecommendedActionsSection(
            actions: viewData.actions,
            hasAdaptiveSupport: viewData.hasDashboardSupport,
            onActionTap: onRecommendedActionTap,
          ),

        if (showInstantSkeleton ||
            hasInstantData &&
                (instant.nextStep != null ||
                    instant.recommendedActions.isNotEmpty) ||
            !hasInstantData &&
                viewData.actions.isNotEmpty &&
                !showInstantSkeleton &&
                !isLoading &&
                adaptiveMode != 'INSTANT')
          const SizedBox(height: 14),

        // ── INFO CONTEXT CARD ──
        if (!showInstantSkeleton)
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
                  onTap: infoData.type == HomeInfoType.basicTip
                      ? null
                      : () => _handleCardTap(infoData),
                  onCtaTap: infoData.ctaRoute != null
                      ? () => _handleInfoCardCta(infoData)
                      : null,
                  isLoading: false,
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

  // ── Navegação e tracking ──

  void _handleAdaptiveNavigation(String targetRoute) {
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

  void _handleCardTap(HomeInfoViewData infoData) {
    final route = _cardRouteForType(infoData.type);
    if (route == null) return;

    MetricsTrackingService.instance.trackInfoCardClicked(
      infoType: infoData.type.name,
      targetRoute: route,
      mode: adaptiveMode,
      sessionId: currentSessionId,
    );
    Get.toNamed(route);
  }

  String? _cardRouteForType(HomeInfoType type) {
    switch (type) {
      case HomeInfoType.todayCultivation:
        return '/agendaPage';
      case HomeInfoType.reservoirReport:
        return '/reservatoriosPage';
      case HomeInfoType.fieldNotesSummary:
        return '/cadernoCampoPage';
      case HomeInfoType.basicTip:
        return null;
    }
  }
}
