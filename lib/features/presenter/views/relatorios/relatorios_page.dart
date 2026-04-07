import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/spacing.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: _RelatoriosAppBar(),
          ),
          // Análise de Ciclo
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Spacing.md, 12, Spacing.md, 8),
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
                    badge: 'Disponível',
                    badgeColor: const Color(0xFF059669),
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
                        'Taxas de conversão em cada etapa — semeadura, transplantio, colheita e embalagem por setor.',
                    icon: Icons.area_chart_outlined,
                    iconColor: const Color(0xFF0891B2),
                    badge: 'Disponível',
                    badgeColor: const Color(0xFF059669),
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
              padding: EdgeInsets.fromLTRB(
                  Spacing.md, 20, Spacing.md, 8),
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
                    badge: 'Disponível',
                    badgeColor: const Color(0xFF059669),
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
                    badge: 'Disponível',
                    badgeColor: const Color(0xFF059669),
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

class _RelatoriosAppBar extends StatelessWidget {
  const _RelatoriosAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () => Get.close(1),
                icon: const Icon(Icons.arrow_back),
                color: Constants.kPrimaryColor,
              ),
              const SizedBox(height: 4),
              const Text(
                'Relatórios',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Análises e métricas da produção',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
  final String badge;
  final Color badgeColor;
  final bool disabled;
  final VoidCallback onTap;

  const _RelatorioCard({
    required this.titulo,
    required this.descricao,
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              titulo,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descricao,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9F9F9F),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!disabled)
                  const Icon(Icons.chevron_right,
                      color: Color(0xFFD9D9D9), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
