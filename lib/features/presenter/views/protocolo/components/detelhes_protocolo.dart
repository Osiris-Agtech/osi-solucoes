import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/modulos_store.dart';
import '../../../viewmodels/protocolo_store.dart';
import '../../home/components/top_app_bar.dart';

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
    // store.buscarReservatorioDetalhes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Constants.kPrimaryColor,
            label: const Text(
              'Vincular',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: PrimaryScrollController(
          controller: _scrollController,
          child: Scrollbar(
            radius: const Radius.circular(12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                Observer(builder: (_) {
                  return const SliverAppBar(
                    toolbarHeight: 80,
                    backgroundColor: Colors.white,
                    floating: false,
                    automaticallyImplyLeading: false,
                    forceElevated: true,
                    elevation: 0,
                    flexibleSpace: TopAppBar(
                      path: "",
                      namePage: "Detalhes do Protocolo",
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
                              children: const [
                                Text('Cultura'),
                                Text(
                                  'Alface',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Tipo'),
                                Text(
                                  'Lista',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Sistema de Cultivo'),
                                Text(
                                  'Hidroponia',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                  child: Text('Forma de Implantação (Inicio)'),
                                ),
                                Text(
                                  'Semeadura',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
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
                                        fontWeight: FontWeight.normal),
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
                            onTap: () {},
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Cultivos Vinculados',
                          style: TextStyle(
                            fontSize: 18,
                            color: Constants.kContentColorLightTheme,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                "Cultivo 1",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.kContentColorLightTheme
                                      .withOpacity(.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Cultura: Alface',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.kContentColorLightTheme
                                      .withOpacity(.7),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
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
