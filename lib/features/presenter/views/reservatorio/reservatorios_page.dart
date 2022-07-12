import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/detalhes_reservatorio_page.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/reservatorios_store.dart';
import '../home/components/top_app_bar.dart';

class ReservatoriosPage extends StatefulWidget {
  final String title;
  const ReservatoriosPage({Key? key, this.title = 'ReservatoriosPage'})
      : super(key: key);
  @override
  ReservatoriosPageState createState() => ReservatoriosPageState();
}

class ReservatoriosPageState extends State<ReservatoriosPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.kSecondBackgroundColor,
          body: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    toolbarHeight:
                        120, //MediaQuery.of(context).size.height * 0.17,
                    // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
                    floating: true,
                    automaticallyImplyLeading: false,
                    forceElevated: true,
                    elevation: 1,
                    flexibleSpace: const TopAppBar(
                      path: "/Home/",
                      namePage: "Meus Reservatórios",
                      subtitle: "Lista de reservatórios cadastrados",
                    ),
                    bottom: PreferredSize(
                      child: Container(
                        height: 50,
                        color: const Color(0xFFF8F8F6),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical:
                              5, //MediaQuery.of(context).size.height * 0.007,
                        ),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: InputBorder.none,
                            prefixIcon: const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                            labelText: "Buscar...",
                            labelStyle: const TextStyle(fontSize: 18),
                            suffixIcon: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                primary: Constants.kPrimaryColor,
                              ),
                              child: const Text(
                                "data",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      preferredSize: const Size(
                        double.infinity,
                        60, //MediaQuery.of(context).size.height * 0.06,
                      ),
                    ),
                  ),
                  Observer(builder: (_) {
                    if (store.isReservatorioListLoading) {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 120.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (store.reservatorioList.isEmpty) {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 120.0),
                                child: Text(
                                  'Não há reservatórios\ncadastrados em sua conta',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff6F6464),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                            ),
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => const DetalhesReservatorio(),
                                transition: Transition.rightToLeft,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                bottom: 5.0,
                                              ),
                                              child: SvgPicture.asset(
                                                  'assets/icons/reservatorio_icon.svg'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                bottom: 5.0,
                                              ),
                                              child: Text(
                                                store.reservatorioList[index]
                                                        .nome ??
                                                    "---",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "Cultivos:",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "0 Ativos",
                                                      style: TextStyle(
                                                        color: Constants
                                                            .kPrimaryColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: Constants.kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: store.reservatorioList.length,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "Novo Reservatório",
            onPressed: () => Get.to(
              () => const CadastrarReservatorioPage(),
              transition: Transition.rightToLeft,
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            backgroundColor: Constants.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
