import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/adaptive_focus_banner.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/activity_feed_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/instant_recommended_actions_panel.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/contextual_onboarding_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/adaptive/operational_onboarding_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_info_card.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_info_view_data.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final _now = DateTime.now();

const _focusBannerData = AdaptiveFocusBannerViewData(
  message: 'Você tem 3 tarefas atrasadas no Setor A. Que tal revisar a agenda?',
  targetRoute: '/agendaPage',
  ctaLabel: 'Ver agenda',
);

final _activityFeedItems = [
  ActivityFeedItemViewData(
    title: 'Tarefa concluída',
    subtitle: 'Lote A-07 — Irrigação finalizada',
    targetRoute: '/lotePage',
    timestamp: _now,
  ),
  ActivityFeedItemViewData(
    title: 'Aplicação de fungicida',
    subtitle: 'Lote B-12 concluído',
    targetRoute: '/detalhesLotePage',
    timestamp: _now.subtract(const Duration(hours: 2)),
  ),
  ActivityFeedItemViewData(
    title: 'Caderno de campo atualizado',
    subtitle: 'Anotação sobre pragas no lote C-03',
    targetRoute: '/cadernoCampoPage',
    timestamp: _now.subtract(const Duration(hours: 5)),
  ),
  ActivityFeedItemViewData(
    title: 'Colheita registrada',
    subtitle: 'Lote D-01 — 120 kg de tomate',
    targetRoute: '/lotePage',
    timestamp: _now.subtract(const Duration(days: 1)),
  ),
];

const _nextStep = NextStepViewData(
  title: 'Preparar solução nutritiva',
  description: 'Reservatório R-03 precisa de reposição de nutrientes',
  ctaLabel: 'Iniciar',
  targetRoute: '/reservatoriosPage',
  isProminent: true,
);

const _recommendedActions = [
  AdaptiveRecommendedActionViewData(
    label: 'Verificar reservatórios',
    description: 'R-05 com nível baixo — programar reposição',
    targetRoute: '/reservatoriosPage',
    confidence: 0.92,
  ),
  AdaptiveRecommendedActionViewData(
    label: 'Revisar agenda do dia',
    description: '3 tarefas pendentes para hoje',
    targetRoute: '/agendaPage',
    confidence: 0.85,
  ),
  AdaptiveRecommendedActionViewData(
    label: 'Atualizar equipe',
    description: 'Escala da semana não publicada',
    targetRoute: '/gerenciarEquipePage',
    confidence: 0.73,
  ),
];

const _reasonSummary =
    'Baseado no seu histórico de atividades e tarefas pendentes';

const _onboardingData = ContextualOnboardingViewData(
  title: 'Novo: Relatório de Produtividade',
  message:
      'Acompanhe o desempenho dos seus setores em tempo real com gráficos e métricas atualizadas.',
  ctaLabel: 'Conhecer',
  targetRoute: '/relatorioProdutividadeSetorPage',
  illustrationHint: 'chart',
);

const _operationalOnboardingSteps = [
  'Crie um lote',
  'Vincule um protocolo de cultivo',
  'Acompanhe as atividades pela Agenda',
];

const _todayCultivationData = HomeInfoViewData(
  type: HomeInfoType.todayCultivation,
  title: 'Hoje no cultivo',
  subtitle: 'Resumo das atividades do dia',
  metrics: [
    HomeInfoMetric(
        label: 'Tarefas hoje', value: '8', tone: HomeInfoMetricTone.positive),
    HomeInfoMetric(
        label: 'Atrasadas', value: '2', tone: HomeInfoMetricTone.danger),
    HomeInfoMetric(
        label: 'Lotes ativos', value: '12', tone: HomeInfoMetricTone.neutral),
    HomeInfoMetric(
        label: 'Colheitas próximas',
        value: '3',
        tone: HomeInfoMetricTone.warning),
  ],
  items: [
    HomeInfoListItem(
      title: 'Irrigação Lote A-07',
      subtitle: 'Aplicar 20mm',
      lotName: 'A-07',
      date: 'Hoje',
    ),
    HomeInfoListItem(
      title: 'Aplicação de fungicida',
      subtitle: 'Lote B-12 - Atrasado 2 dias',
      date: 'Ontem',
      tone: HomeInfoItemTone.danger,
    ),
  ],
);

const _reservoirReportData = HomeInfoViewData(
  type: HomeInfoType.reservoirReport,
  title: 'Reservatórios',
  subtitle: 'Volume total: 25.000 L',
  metrics: [
    HomeInfoMetric(
        label: 'Reservatórios', value: '6', tone: HomeInfoMetricTone.neutral),
    HomeInfoMetric(
        label: 'Com solução', value: '4', tone: HomeInfoMetricTone.positive),
    HomeInfoMetric(
        label: 'Sem solução', value: '2', tone: HomeInfoMetricTone.warning),
    HomeInfoMetric(
        label: 'Lotes vinculados',
        value: '8',
        tone: HomeInfoMetricTone.neutral),
  ],
  items: [
    HomeInfoListItem(
      title: 'R-03 (Tanque Principal)',
      subtitle: 'Solução NPK 12-12-12 — 2.1 mS/cm',
    ),
    HomeInfoListItem(
      title: 'R-07 (Apoio)',
      subtitle: 'Sem solução cadastrada',
    ),
  ],
  ctaLabel: 'Ver reservatórios',
  ctaRoute: '/reservatoriosPage',
);

const _fieldNotesData = HomeInfoViewData(
  type: HomeInfoType.fieldNotesSummary,
  title: 'Caderno de Campo',
  subtitle: '3 anotações recentes',
  metrics: [],
  items: [
    HomeInfoListItem(
      title: 'Observação de pragas',
      subtitle: 'Detectado início de cochonilha no lote C-03',
      lotName: 'C-03',
      date: 'Hoje',
    ),
    HomeInfoListItem(
      title: 'Fertirrigação concluída',
      subtitle: 'Lote A-07 recebeu 15mm de solução',
      lotName: 'A-07',
      date: 'Ontem',
    ),
  ],
  ctaLabel: 'Ver caderno de campo',
  ctaRoute: '/cadernoCampoPage',
);

const _basicTipData = HomeInfoViewData(
  type: HomeInfoType.basicTip,
  title: 'Dica de cultivo',
  tipText:
      'A aplicação de silício tem se mostrado eficaz no fortalecimento da parede celular das plantas, reduzindo a incidência de pragas e doenças.',
  sourceCategory: 'cultivo',
);

// ---------------------------------------------------------------------------
// InstantComponentGalleryPage
// ---------------------------------------------------------------------------

class InstantComponentGalleryPage extends StatelessWidget {
  const InstantComponentGalleryPage({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📦 Componentes Instant')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // ---- Section 1: Focus Banner ----
          _SectionHeader(
            emoji: '🎯',
            title: 'Focus Banner',
            description:
                'Banner de foco adaptativo — mensagem curta com CTA opcional',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: AdaptiveFocusBanner(
              data: _focusBannerData,
              onCtaTap: () => _showSnackBar(context,
                  'CTA: ${_focusBannerData.ctaLabel} → ${_focusBannerData.targetRoute}'),
            ),
          ),

          // ---- Section 2: Activity Feed ----
          _SectionHeader(
            emoji: '📋',
            title: 'Activity Feed',
            description:
                'Feed de atividades recentes — até 5 itens com timestamp relativo',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ActivityFeedCard(
              items: _activityFeedItems,
              onItemTap: (route) => _showSnackBar(context, 'Item → $route'),
            ),
          ),

          // ---- Section 3: Ações Recomendadas ----
          _SectionHeader(
            emoji: '⚡',
            title: 'Ações Recomendadas (with NextStep)',
            description:
                'Painel unificado de próximo passo + ações recomendadas com badge adaptativo',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: InstantRecommendedActionsPanel(
              nextStep: _nextStep,
              recommendedActions: _recommendedActions,
              reasonSummary: _reasonSummary,
              onActionTap: (route) => _showSnackBar(context, 'Ação → $route'),
            ),
          ),

          // ---- Section 4: Onboarding Contextual ----
          _SectionHeader(
            emoji: '🚀',
            title: 'Onboarding Contextual',
            description:
                'Card de onboarding contextual com borda tracejada — para apresentar novas funcionalidades',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ContextualOnboardingCard(
              data: _onboardingData,
              onCtaTap: () => _showSnackBar(
                context,
                'CTA: Conhecer → ${_onboardingData.targetRoute}',
              ),
            ),
          ),

          // ---- Section 5: Onboarding Operacional ----
          _SectionHeader(
            emoji: '🌱',
            title: 'Onboarding Operacional',
            description:
                'Card de orientação inicial — guia o usuário nos primeiros passos do cultivo',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: OperationalOnboardingCard(
              title: 'Como começar',
              message:
                  'Crie seu primeiro lote com protocolo para iniciar o acompanhamento automático do cultivo.',
              steps: _operationalOnboardingSteps,
              ctaLabel: 'Criar primeiro lote',
              onCtaTap: () => _showSnackBar(
                context,
                'CTA: Criar primeiro lote → /lotePage',
              ),
            ),
          ),

          // ---- Section 6: InfoCard — Today Cultivation ----
          _SectionHeader(
            emoji: '🌱',
            title: 'InfoCard — Today Cultivation',
            description:
                'Card informativo de cultivo do dia — métricas de tarefas, lotes ativos, colheitas',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: HomeInfoCard(
              data: _todayCultivationData,
              onTap: () => _showSnackBar(context, 'Tap em Today Cultivation'),
            ),
          ),

          // ---- Section 7: InfoCard — Reservoir Report ----
          _SectionHeader(
            emoji: '💧',
            title: 'InfoCard — Reservoir Report',
            description:
                'Card informativo de reservatórios — métricas de volume, soluções, lotes vinculados',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: HomeInfoCard(
              data: _reservoirReportData,
              onCtaTap: () => _showSnackBar(
                context,
                'CTA: Ver reservatórios → ${_reservoirReportData.ctaRoute}',
              ),
            ),
          ),

          // ---- Section 8: InfoCard — Field Notes Summary ----
          _SectionHeader(
            emoji: '📝',
            title: 'InfoCard — Field Notes Summary',
            description:
                'Card informativo de caderno de campo — anotações recentes dos lotes',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: HomeInfoCard(
              data: _fieldNotesData,
              onCtaTap: () => _showSnackBar(
                context,
                'CTA: Ver caderno de campo → ${_fieldNotesData.ctaRoute}',
              ),
            ),
          ),

          // ---- Section 9: InfoCard — Basic Tip ----
          _SectionHeader(
            emoji: '💡',
            title: 'InfoCard — Basic Tip',
            description:
                'Card de dica básica — conteúdo educativo aleatório por categoria',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: HomeInfoCard(data: _basicTipData),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SectionHeader
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _SectionHeader({
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
