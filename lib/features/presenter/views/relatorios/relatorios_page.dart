import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/spacing.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_badge.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_icon_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      body: CustomScrollView(
        slivers: [
          AppPageHeaderSliver(
            title: 'Relatórios',
            subtitle: 'Análises e métricas da produção',
            onBack: () => Get.close(1),
            expandedHeight: 120,
          ),
          // Análise de Ciclo
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(Spacing.md, 12, Spacing.md, 8),
              child: const _SectionLabel(label: 'ANÁLISE DE CICLO'),
            ),
          ),
          SliverPadding(
            padding: Spacing.horizontal(context),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _RelatorioCard(
                    titulo: 'Ciclo de Produção por Cultura',
                    descricao:
                        'Compare duração real vs. planejada dos ciclos e identifique culturas com desvios crônicos.',
                    icon: Icons.loop_outlined,
                    iconColor: Constants.kPrimaryColor,
                    badgeTone: AppBadgeTone.success,
                    onTap: () => Get.toNamed(
                      Routes.relatorioCircoCulturaPage,
                      arguments: {'mock': true},
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _RelatorioCard(
                    titulo: 'Produtividade por Setor/Área',
                    descricao:
                        'Taxas de conversão em cada etapa: semeadura, transplantio, colheita e embalagem por setor.',
                    icon: Icons.area_chart_outlined,
                    iconColor: const Color(0xFF0891B2),
                    badgeTone: AppBadgeTone.success,
                    onTap: () => Get.toNamed(
                      Routes.relatorioProdutividadeSetorPage,
                      arguments: {'mock': true},
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // Gestão de equipe
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(Spacing.md, 20, Spacing.md, 8),
              child: const _SectionLabel(label: 'GESTÃO DE EQUIPE'),
            ),
          ),
          SliverPadding(
            padding: Spacing.horizontal(context),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _RelatorioCard(
                    titulo: 'Desempenho da Equipe',
                    descricao:
                        'Atividades registradas, tarefas de agenda cumpridas no prazo e taxa de conclusão por membro.',
                    icon: Icons.people_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    badgeTone: AppBadgeTone.success,
                    onTap: () => Get.toNamed(
                      Routes.relatorioDesempenhoEquipePage,
                      arguments: {'mock': true},
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _RelatorioCard(
                    titulo: 'Agenda e Tarefas Pendentes',
                    descricao:
                        'Tarefas vencidas, a vencer nos próximos N dias e taxa de conclusão por lote ativo.',
                    icon: Icons.event_note_outlined,
                    iconColor: const Color(0xFFEA580C),
                    badgeTone: AppBadgeTone.success,
                    onTap: () => Get.toNamed(
                      Routes.relatorioAgendaTarefasPage,
                      arguments: {'mock': true},
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        color: Color(0xFF9F9F9F),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _RelatorioCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final IconData icon;
  final Color iconColor;
  final AppBadgeTone badgeTone;
  final VoidCallback onTap;

  const _RelatorioCard({
    required this.titulo,
    required this.descricao,
    required this.icon,
    required this.iconColor,
    required this.badgeTone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppEntityCard(
      title: titulo,
      description: descricao,
      leading: AppIconTile(icon: icon, color: iconColor),
      badges: [
        AppBadge(
          label: 'Disponível',
          tone: badgeTone,
        ),
      ],
      onTap: onTap,
    );
  }
}
