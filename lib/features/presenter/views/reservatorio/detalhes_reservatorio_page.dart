import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/modulos_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';

class DetalhesReservatorio extends StatefulWidget {
  const DetalhesReservatorio({super.key});

  @override
  State<DetalhesReservatorio> createState() => _DetalhesReservatorioState();
}

class _DetalhesReservatorioState extends State<DetalhesReservatorio> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  final ScrollController _scrollController = ScrollController();
  CarouselSliderController carouselController = CarouselSliderController();
  ModulosStore modulosStore = GetIt.I<ModulosStore>();

  @override
  void initState() {
    super.initState();
    store.buscarReservatorioDetalhes();
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
                    backgroundColor: Colors.white,
                    toolbarHeight:
                        120, //MediaQuery.of(context).size.height * 0.17,
                    // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
                    floating: false,
                    automaticallyImplyLeading: false,
                    forceElevated: true,
                    elevation: 0,
                    actions: [
                      Align(
                        alignment: const Alignment(0.6, -0.9),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: PopupMenuButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/settings_icon.svg",
                                  colorFilter: ColorFilter.mode(
                                    Constants.kButtonGrey,
                                    BlendMode.src,
                                  ),
                                  height: 20,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Row(
                                      children: const [
                                        Text('Editar'),
                                      ],
                                    ),
                                    onTap: () async {
                                      store.carregarDadosReservatorio(
                                        store.reservatorioDetalhes,
                                      );
                                      store.setIsEditing(true);
                                      Get.toNamed(
                                        Routes.cadastrarReservatoriosPage,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: TopAppBar(
                      path: "",
                      namePage: store.reservatorioDetalhes.nome ?? "...",
                      subtitle:
                          "Volume: ${store.reservatorioDetalhes.volume ?? "..."} litros",
                    ),
                  );
                }),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 105,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(top: 5),
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () async {
                                modulosStore.setPageViewController(4);
                                Get.toNamed(
                                  Routes.modulosPage,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Material(
                                    elevation: 0.3,
                                    color: Constants.kSecondBackgroundColor,
                                    borderRadius: BorderRadius.circular(80),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Constants.kSecondBackgroundColor,
                                      child: SvgPicture.asset(
                                        "assets/icons/ajustes_icon.svg",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Ajuste',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            // InkWell(
                            //   splashColor: Colors.transparent,
                            //   hoverColor: Colors.transparent,
                            //   onTap: () {},
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Material(
                            //         elevation: 0.3,
                            //         color: Constants.kSecondBackgroundColor,
                            //         borderRadius: BorderRadius.circular(80),
                            //         child: CircleAvatar(
                            //           radius: 25,
                            //           backgroundColor:
                            //               Constants.kSecondBackgroundColor,
                            //           child: SvgPicture.asset(
                            //             "assets/icons/alter_infos_icon.svg",
                            //             height: 25,
                            //             width: 25,
                            //           ),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 10,
                            //       ),
                            //       const Text(
                            //         'Alterar\nInfos',
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //           color: Colors.black87,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //         textAlign: TextAlign.center,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          height: 200,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onPageChanged: (value, carouselReason) =>
                              store.setIndexDotDetalhe(value * 1.0),
                        ),
                        items: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.only(left: 20, right: 5),
                                  decoration: BoxDecoration(
                                    color: Constants.kSecondBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 16.0, 16.0, 16.0),
                                        child: Text(
                                          'Solução Nutritiva',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Constants
                                                .kContentColorLightTheme,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Observer(builder: (_) {
                                          if (store
                                              .solucaoNutritivaList.isEmpty) {
                                            return const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 16.0),
                                              child: Center(
                                                child: Text(
                                                  "Não contém solução nutritiva cadastrada",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: store
                                                .solucaoNutritivaList.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                dense: true,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: 0,
                                                        vertical: -4),
                                                title: Text(store
                                                        .solucaoNutritivaList[
                                                            index]
                                                        .fertilizante
                                                        ?.nome ??
                                                    "..."),
                                                trailing: Text(
                                                    "${store.solucaoNutritivaList[index].quantidade} mg/L"),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                  onTap: () =>
                                      carouselController.animateToPage(1),
                                  child:
                                      const Icon(Icons.chevron_right_rounded),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: InkWell(
                                  onTap: () =>
                                      carouselController.animateToPage(0),
                                  child: const Icon(Icons.chevron_left_rounded),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 20),
                                  decoration: BoxDecoration(
                                    color: Constants.kSecondBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 16.0, 16.0, 16.0),
                                        child: Text(
                                          'Solução Concentrada',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Constants
                                                .kContentColorLightTheme,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Observer(builder: (_) {
                                          if (store
                                              .solucaoConcentradaList.isEmpty) {
                                            return const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 16.0),
                                              child: Center(
                                                child: Text(
                                                  "Não contém solução concentrada cadastrada",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: store
                                                .solucaoConcentradaList.length,
                                            itemBuilder: (context, index) {
                                              return _concentradaItem(index);
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Observer(builder: (_) {
                          return DotsIndicator(
                            dotsCount: 2,
                            position: store.indexDotDetalhe,
                            decorator: DotsDecorator(
                              size: const Size.square(9.0),
                              activeSize: const Size(18.0, 9.0),
                              color: Constants.kSecondBackgroundColor,
                              activeColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: .7),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                        if (store.reservatorioDetalhes.lotes == null ||
                            store.reservatorioDetalhes.lotes!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Não contém lotes vinculados a este reservatório",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              store.reservatorioDetalhes.lotes?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                store.reservatorioDetalhes.lotes![index].nome ??
                                    "...",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.kContentColorLightTheme
                                      .withValues(alpha: .8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Setor: ${store.reservatorioDetalhes.lotes![index].setor?.nome ?? '--'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.kContentColorLightTheme
                                      .withValues(alpha: .7),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: Text(
                                '${store.reservatorioDetalhes.lotes![index].bandeijas_semeadas ?? '--'}\nbandejas',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.kContentColorLightTheme
                                      .withValues(alpha: .7),
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
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

  ListTile _concentradaItem(int index) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Row(
        children: [
          Expanded(
            child: Text(
              store.solucaoConcentradaList[index].concentrada?.nome ?? "...",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${store.solucaoConcentradaList[index].concentrada?.volume ?? 1} Litro(s)",
            style: const TextStyle(
              fontSize: 14,
              color: Constants.kGreyMedium,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 4.0,
          bottom: 8.0,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: store.solucaoConcentradaList[index].concentrada
                  ?.solucoes_fertilizantes_concentradas?.length ??
              0,
          itemBuilder: (_, indexFert) {
            SolucaoFertilizanteConcentrada? fertilizanteConcentrada = store
                .solucaoConcentradaList[index]
                .concentrada
                ?.solucoes_fertilizantes_concentradas?[indexFert];
            return Row(
              children: [
                Expanded(
                  child: Text(
                    fertilizanteConcentrada?.fertilizante?.nome ??
                        'Não informado',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${store.calcularQuantidadeFertilizanteConcentrada(
                    quantidadeOriginal: double.tryParse(
                            fertilizanteConcentrada?.quantidade ?? '0.0') ??
                        0.0,
                    volumeConcentrada: store.solucaoConcentradaList[index]
                            .concentrada?.volume ??
                        1,
                    fator: store.solucaoConcentradaList[index].concentrada
                            ?.fator_concentracao ??
                        1,
                  )} g",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Constants.kGreyMedium,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
