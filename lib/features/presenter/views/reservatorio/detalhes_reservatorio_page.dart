import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';

class DetalhesReservatorio extends StatefulWidget {
  const DetalhesReservatorio({Key? key}) : super(key: key);

  @override
  State<DetalhesReservatorio> createState() => _DetalhesReservatorioState();
}

class _DetalhesReservatorioState extends State<DetalhesReservatorio> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  final ScrollController _scrollController = ScrollController();
  CarouselController carouselController = CarouselController();

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
                const SliverAppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight:
                      120, //MediaQuery.of(context).size.height * 0.17,
                  // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
                  floating: false,
                  automaticallyImplyLeading: false,
                  forceElevated: true,
                  elevation: 0,
                  flexibleSpace: TopAppBar(
                    path: "",
                    namePage: "Reservatório 1",
                    subtitle: "Volume: 2000 litros",
                  ),
                ),
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
                              onTap: () {},
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
                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () {},
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
                                        "assets/icons/alter_infos_icon.svg",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Alterar\nInfos',
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
                                  .withOpacity(.7),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              'Cultivo #$index',
                              style: TextStyle(
                                fontSize: 16,
                                color: Constants.kContentColorLightTheme
                                    .withOpacity(.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Setor #1',
                              style: TextStyle(
                                fontSize: 14,
                                color: Constants.kContentColorLightTheme
                                    .withOpacity(.7),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            trailing: Text(
                              '25\nplantas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Constants.kContentColorLightTheme
                                    .withOpacity(.7),
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
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
}
