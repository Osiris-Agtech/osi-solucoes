import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';

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
  // final ReservatoriosStore store = Modular.get();
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kSecondBackgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 120, //MediaQuery.of(context).size.height * 0.17,
              // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
              floating: true,
              automaticallyImplyLeading: true,
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
                    vertical: 5, //MediaQuery.of(context).size.height * 0.007,
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      primary: false,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      physics: const BouncingScrollPhysics(),
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: index != 0
                                  ? MediaQuery.of(context).size.height * 0.018
                                  : 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                          'assets/icons/reservatorio_icon.svg'),
                                      onPressed: null,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Reservatório 1",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Cultivos:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "9 Ativos",
                                              style: TextStyle(
                                                color: Constants.kPrimaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Constants.kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: 1000, // 1000 list items
              ),
            ),
          ],
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
    );
  }
}
