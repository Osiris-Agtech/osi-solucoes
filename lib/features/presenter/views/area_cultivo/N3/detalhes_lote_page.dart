import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/agenda_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_delete_dialog.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';

import 'components/detalhes_page/horizontal_lista.dart';
import 'components/detalhes_page/producao_section.dart';

class DetalhesLotePage extends StatefulWidget {
  final bool enableEditing;
  const DetalhesLotePage({super.key, this.enableEditing = true});

  @override
  State<DetalhesLotePage> createState() => _DetalhesLotePageState();
}

class _DetalhesLotePageState extends State<DetalhesLotePage> {
  LoteStore store = GetIt.I<LoteStore>();
  ReservatoriosStore reservatorioStore = GetIt.I<ReservatoriosStore>();

  @override
  void initState() {
    super.initState();
    store.buscarDetalhesLote();
    store.buscarAreasList();
  }

  @override
  void dispose() {
    store.limparTudo();
    super.dispose();
  }

  Future<void> _confirmarDelecao(BuildContext context) async {
    final nomeLote = store.loteSelecionado.nome ?? 'lote';
    final confirmou = await AppDeleteDialog.show(
      context: context,
      title: 'Deletar lote?',
      message:
          'O lote "$nomeLote" e todas as agendas vinculadas serão desativados permanentemente.',
      infoText:
          'Agendas com atividades planejadas para este lote também serão removidas.',
    );
    if (confirmou && context.mounted) {
      await store.deletarLoteCascade(store.loteSelecionado.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kSecondBackgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            sliverHeader(),
            SliverToBoxAdapter(
              child: Observer(builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoCard(),
                    if (widget.enableEditing) ...[
                      const SizedBox(height: 8),
                      _navigateTile(
                        icon: Icons.event,
                        title: 'Agenda de Atividades',
                        subtitle: 'Atividades planejadas para o lote',
                        onTap: () {
                          Get.to(() => AgendaPage(
                                loteId: store.loteSelecionado.id,
                              ));
                        },
                      ),
                      _navigateTile(
                        icon: Icons.article_outlined,
                        title: 'Protocolo Base',
                        subtitle: store.loteSelecionado.protocolo?.nome ??
                            'Nenhum Protocolo Selecionado',
                        onTap: () {},
                      ),
                      const SizedBox(height: 8),
                      horizontalList(context, reservatorioStore, store),
                    ],
                    const ProducaoSection(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  AppPageHeaderSliver sliverHeader() {
    return AppPageHeaderSliver(
      title: store.loteSelecionado.nome ?? 'Detalhes do Lote',
      subtitle:
          '${store.loteSelecionado.setor?.area?.nome ?? '-'} / ${store.loteSelecionado.setor?.nome ?? '-'}',
      onBack: () => Get.back(),
      actions: widget.enableEditing
          ? [
              PopupMenuButton<void>(
                icon: SvgPicture.asset(
                  "assets/icons/settings_icon.svg",
                  colorFilter: ColorFilter.mode(
                    Constants.kButtonGrey,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                ),
                itemBuilder: (context) => <PopupMenuEntry<void>>[
                  PopupMenuItem<void>(
                    child: Row(
                      children: const [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar lote'),
                      ],
                    ),
                    onTap: () async {
                      store.setLoteEditing(store.loteSelecionado);
                      Get.toNamed(Routes.cadastrarLotePage);
                    },
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<void>(
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Constants.kErrorColor),
                        const SizedBox(width: 8),
                        Text(
                          'Deletar lote',
                          style: TextStyle(color: Constants.kErrorColor),
                        ),
                      ],
                    ),
                    onTap: () => _confirmarDelecao(context),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ]
          : [],
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: AppPanelCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Cultura', store.loteSelecionado.cultura?.nome ?? '-'),
            const Divider(height: 1),
            _infoRow(
              'Área/Setor',
              '${store.loteSelecionado.setor?.area?.nome ?? "-"} / ${store.loteSelecionado.setor?.nome ?? "-"}',
            ),
          ],
        ),
      ),
    );
  }

  Padding _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Constants.kGreyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Constants.kText2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigateTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: AppPanelCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Constants.kPrimaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Constants.kText2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Constants.kGreyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Constants.kGreyLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

}
