import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_cycle_preview.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_linked_lots_section.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_operational_summary.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';

class DetalhesProtocolo extends StatefulWidget {
  const DetalhesProtocolo({super.key});

  @override
  State<DetalhesProtocolo> createState() => _DetalhesProtocoloState();
}

class _DetalhesProtocoloState extends State<DetalhesProtocolo> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    store.prepararListaDetalhesFase();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kSecondBackgroundColor,
        body: PrimaryScrollController(
          controller: _scrollController,
          child: Scrollbar(
            radius: const Radius.circular(12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                Observer(builder: (_) {
                  return AppPageHeaderSliver(
                    title: store.protocoloSelecionado?.nome ?? "Detalhes",
                    titleMaxLines: 2,
                    onBack: () => Get.back(),
                    actions: [
                      Align(
                        alignment: const Alignment(0.6, -0.9),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                          child: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Constants.kPrimaryColor,
                            ),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Get.toNamed(Routes.editarProtocoloPage);
                                return;
                              }

                              if (value == 'delete') {
                                final protocolo = store.protocoloSelecionado;
                                if (protocolo == null) return;

                                final confirmed =
                                    await _confirmarExclusao(context);
                                if (confirmed != true) return;

                                final deleted =
                                    await store.deletarProtocolo(protocolo);
                                if (deleted && context.mounted) {
                                  Get.back();
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Observer(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            ProtocolOperationalSummary(
                              protocolo: store.protocoloSelecionado,
                              fases: store.listaFaseDetalhes,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: AppPrimaryButton(
                                label: 'Ver ciclo de produção',
                                icon: Icons.timeline_outlined,
                                onPressed: () => Get.toNamed(
                                  Routes.detalhesAtividadesProtocolo,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ProtocolCyclePreview(
                              fases: store.listaFaseDetalhes,
                            ),
                            const SizedBox(height: 8),
                            ProtocolLinkedLotsSection(
                              lotes: store.protocoloSelecionado?.lotes ?? [],
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmarExclusao(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir protocolo'),
          content: const Text(
            'Esta ação irá remover o protocolo e suas relações vinculadas. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
