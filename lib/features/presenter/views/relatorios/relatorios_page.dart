import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'Relatórios',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Análise de Ciclo
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, 20, size.width * 0.05, 8),
              child: const _SectionLabel(label: 'ANÁLISE DE CICLO'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _RelatorioCard(
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
                const SizedBox(height: 10),
                _RelatorioCard(
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
              ]),
            ),
          ),
          // Visão Geral
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, 20, size.width * 0.05, 8),
              child: const _SectionLabel(label: 'VISÃO GERAL'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _RelatorioCard(
                  titulo: 'Produção por Cultura',
                  descricao:
                      'Quantidade produzida por cultura ao longo dos meses.',
                  icon: Icons.agriculture_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  badge: 'Home',
                  badgeColor: const Color(0xFF6B7280),
                  onTap: () => Get.offAllNamed(Routes.homePage),
                ),
                const SizedBox(height: 10),
                _RelatorioCard(
                  titulo: 'Status de Lotes',
                  descricao:
                      'Distribuição dos lotes por status (ativo, finalizado, cancelado).',
                  icon: Icons.pie_chart_outline,
                  iconColor: const Color(0xFF3B82F6),
                  badge: 'Home',
                  badgeColor: const Color(0xFF6B7280),
                  onTap: () => Get.offAllNamed(Routes.homePage),
                ),
              ]),
            ),
          ),
          // Gestão de equipe
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, 20, size.width * 0.05, 8),
              child: const _SectionLabel(label: 'GESTÃO DE EQUIPE'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _RelatorioCard(
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
                const SizedBox(height: 10),
                _RelatorioCard(
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
              ]),
            ),
          ),
          // Em breve
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, 20, size.width * 0.05, 8),
              child: const _SectionLabel(label: 'EM BREVE'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _RelatorioCard(
                  titulo: 'Qualidade / Nutrição',
                  descricao:
                      'Análise de soluções nutritivas e correlação com ciclos de produção.',
                  icon: Icons.science_outlined,
                  iconColor: const Color(0xFFEA580C),
                  badge: 'Em breve',
                  badgeColor: const Color(0xFFD9D9D9),
                  disabled: true,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _RelatorioCard(
                  titulo: 'Comparação entre Períodos',
                  descricao:
                      'Compare produtividade e desvios entre dois períodos distintos.',
                  icon: Icons.compare_arrows_outlined,
                  iconColor: const Color(0xFF7C3AED),
                  badge: 'Em breve',
                  badgeColor: const Color(0xFFD9D9D9),
                  disabled: true,
                  onTap: () {},
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
