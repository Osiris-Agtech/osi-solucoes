import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_badge.dart';

import '../area_cultivo/N3/detalhes_lote_page.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  LoteStore loteStore = GetIt.I<LoteStore>();

  @override
  void initState() {
    loteStore.buscarLotesFinalizados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          body: CustomScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppPageHeaderSliver(
                title: 'Histórico',
                subtitle: 'Lotes finalizados',
                onBack: () => Get.back(),
                expandedHeight: 120,
                pinned: true,
              ),
              Observer(builder: (_) {
                if (loteStore.isLoteListLoading) {
                  return const SliverToBoxAdapter(
                    child: AppStatePanel(
                      stateKind: AppStateKind.loading,
                      title: 'Carregando histórico',
                      message: 'Aguarde enquanto buscamos os lotes finalizados.',
                    ),
                  );
                }
                if (loteStore.lotesFinalizados.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: AppStatePanel(
                      stateKind: AppStateKind.empty,
                      title: 'Nenhum lote finalizado',
                      message: 'Os lotes finalizados aparecerão aqui.',
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Observer(builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 10),
                          child: AppEntityCard(
                            leading: const Icon(Icons.eco,
                                color: Color(0xFF26C165), size: 26),
                            title: loteStore
                                    .lotesFinalizados[index].nome ??
                                '',
                            subtitle:
                                '# ${loteStore.lotesFinalizados[index].id}',
                            description:
                                'Cultura: ${loteStore.lotesFinalizados[index].cultura?.nome ?? ""}',
                            badges: const [
                              AppBadge(
                                  label: 'FINALIZADO',
                                  tone: AppBadgeTone.neutral),
                            ],
                            onTap: () {
                              loteStore.selecionarLote(
                                  loteStore.lotesFinalizados[index]);
                              Get.to(() =>
                                  const DetalhesLotePage(
                                      enableEditing: false));
                            },
                          ),
                        );
                      });
                    },
                    childCount: loteStore.lotesFinalizados.length,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


