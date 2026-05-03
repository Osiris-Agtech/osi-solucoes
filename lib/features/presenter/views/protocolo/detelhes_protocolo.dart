import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/modulos_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';

class DetalhesProtocolo extends StatefulWidget {
  const DetalhesProtocolo({super.key});

  @override
  State<DetalhesProtocolo> createState() => _DetalhesProtocoloState();
}

class _DetalhesProtocoloState extends State<DetalhesProtocolo> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  final ScrollController _scrollController = ScrollController();
  CarouselController carouselController = CarouselController();
  ModulosStore modulosStore = GetIt.I<ModulosStore>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PrimaryScrollController(
          controller: _scrollController,
          child: Scrollbar(
            radius: const Radius.circular(12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                Observer(builder: (_) {
                  return SliverAppBar(
                    toolbarHeight: 88,
                    backgroundColor: Colors.white,
                    floating: false,
                    automaticallyImplyLeading: false,
                    forceElevated: true,
                    elevation: 0,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    flexibleSpace: TopAppBar(
                      path: "",
                      namePage: store.protocoloSelecionado?.nome ?? "---",
                    ),
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
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          bottom: 16,
                        ),
                        child: Text(
                          'Informações',
                          style: TextStyle(
                            color: Constants.kButtonGrey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 30,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Cultura'),
                                ),
                                Text(
                                  store.protocoloSelecionado?.cultura?.nome ??
                                      '---',
                                  style: const TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Sistema de Cultivo'),
                                ),
                                Text(
                                  store.protocoloSelecionado?.sistema_cultivo ??
                                      "---",
                                  style: const TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Forma de Implantação (Inicio)'),
                                ),
                                Text(
                                  store.protocoloSelecionado?.implantacao ??
                                      "---",
                                  style: const TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 12,
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.checklist,
                              color: Constants.kPrimaryColor,
                            ),
                          ),
                          title: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              'Atividades',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          subtitle: const Text(
                              "Atividades planejadas para o cultivo"),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Constants.kPrimaryColor,
                          ),
                          onTap: () {
                            Get.toNamed(Routes.detalhesAtividadesProtocolo);
                          },
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Text(
                          'Cultivos Vinculados',
                          style: TextStyle(
                            fontSize: 12,
                            color: Constants.kButtonGrey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 200,
                            minWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.kCardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Observer(builder: (_) {
                            if ((store.protocoloSelecionado?.lotes ?? [])
                                .isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: Text(
                                    "Não contém lotes vinculados a este reservatório",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  (store.protocoloSelecionado?.lotes ?? [])
                                      .length,
                              separatorBuilder: (context, index) => Container(
                                height: 1,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                color: Constants.kBackgroundColor,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: index == 0 ? 8.0 : 0.0,
                                        bottom: index ==
                                                (store.protocoloSelecionado
                                                            ?.lotes.length ??
                                                        0) -
                                                    1
                                            ? 8.0
                                            : 0.0,
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 24),
                                        title: Text(
                                          store.protocoloSelecionado
                                                  ?.lotes[index].nome ??
                                              '---',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Constants
                                                .kContentColorLightTheme
                                                .withValues(alpha: .8),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Cultura: ${store.protocoloSelecionado?.lotes[index].nome ?? 'Sem Cultura'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Constants
                                                .kContentColorLightTheme
                                                .withValues(alpha: .8),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                      ),
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
