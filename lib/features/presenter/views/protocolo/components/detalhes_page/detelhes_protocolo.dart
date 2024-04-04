import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/modulos_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/detalhes_ativ.dart';

class DetalhesProtocolo extends StatefulWidget {
  const DetalhesProtocolo({Key? key}) : super(key: key);

  @override
  State<DetalhesProtocolo> createState() => _DetalhesProtocoloState();
}

class _DetalhesProtocoloState extends State<DetalhesProtocolo> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  final ScrollController _scrollController = ScrollController();
  CarouselController carouselController = CarouselController();
  ModulosStore modulosStore = GetIt.I<ModulosStore>();

  @override
  void initState() {
    super.initState();
  }

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
                    toolbarHeight: 80,
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
                      namePage: store.protocoloSelecionado!.nome ?? "---",
                    ),
                  );
                }),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, bottom: 15),
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
                        padding: const EdgeInsets.only(left: 20.0, right: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('Cultura'),
                                ),
                                Text(
                                  store.protocoloSelecionado!.cultura!.length >
                                          1
                                      ? '${store.protocoloSelecionado!.cultura?[0].nome} , ...' ??
                                          "---"
                                      : '${store.protocoloSelecionado!.cultura?[0].nome}' ??
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
                                  child: Text('Tipo'),
                                ),
                                Text(
                                  store.protocoloSelecionado!.tipo_cultura ??
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
                                  child: Text('Sistema de Cultivo'),
                                ),
                                Text(
                                  store.protocoloSelecionado!.sistema_cultivo ??
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
                                  store.protocoloSelecionado!.implantacao ??
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
                      const SizedBox(height: 16),
                      InkWell(
                        child: Observer(builder: (_) {
                          return ListTile(
                            leading: const Icon(
                              Icons.checklist,
                              color: Constants.kPrimaryColor,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text(
                                    'Atividades',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: const Text(
                                "Atividades planejadas para o cultivo"),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: Constants.kPrimaryColor,
                            ),
                            onTap: () {
                              Get.to(() => const DetalhesAtivPage());
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
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
                      Observer(builder: (_) {
                        // if (store.reservatorioDetalhes.lotes == null ||
                        //     store.reservatorioDetalhes.lotes!.isEmpty) {
                        //   return const Padding(
                        //     padding: EdgeInsets.all(16.0),
                        //     child: Center(
                        //       child: Text(
                        //         "Não contém lotes vinculados a este reservatório",
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ),
                        //   );
                        // }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Text(
                                    "Cultivo Teste",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Constants.kContentColorLightTheme
                                          .withOpacity(.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Cultura: Alface',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Constants.kContentColorLightTheme
                                          .withOpacity(.8),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
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
}
