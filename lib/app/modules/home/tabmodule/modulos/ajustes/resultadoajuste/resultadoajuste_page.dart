import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/home/components/top_app_bar.dart';
import 'package:rive/rive.dart';

class ResultadoajustePage extends StatefulWidget {
  final String title;
  const ResultadoajustePage({Key? key, this.title = 'ResultadoajustePage'})
      : super(key: key);
  @override
  ResultadoajustePageState createState() => ResultadoajustePageState();
}

class ResultadoajustePageState extends State<ResultadoajustePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController1;
  late ScrollController scrollController2;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    scrollController1 = ScrollController();
    scrollController2 = ScrollController();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController1.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        primary: false,
        body: DefaultTabController(
          length: tabController.length,
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, bool innerBoxIsScrolled) {
              return [
                AppBarCustom(tabController: tabController),
              ];
            },
            body: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.24),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        TabFertilizantes(scrollController1: scrollController1),
                        TabSolucaoConcentrada(
                            scrollController1: scrollController2),
                      ],
                    ),
                  ),
                  const ButtonCompleted(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showConfirmDialog(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        alignment: Alignment.bottomCenter,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.040,
              left: MediaQuery.of(context).size.width * 0.08,
              right: MediaQuery.of(context).size.width * 0.08,
            ),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Deseja ',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'registrar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor)),
                      TextSpan(
                        text: ' o ajuste?',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.033,
                  ),
                  child: const Text(
                    'Caso registre, o ajuste ficará salvo no caderno de campo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xB2333333)),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .03,
                        bottom: MediaQuery.of(context).size.width * 0.01),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .69,
                        height: 30,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          child: const Text(
                            "Sim",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            showDoneAnimation(context);
                            await Future.delayed(
                                const Duration(milliseconds: 1400));
                            Navigator.pop(context);
                            Modular.to.popUntil(ModalRoute.withName('/Home'));
                            Modular.to.pushReplacementNamed("/Tab/Ajustes/");
                          },
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .001,
                        bottom: MediaQuery.of(context).size.width * 0.01),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .69,
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Não",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff767676)),
                          ),
                        ),
                      ),
                    )),
              ],
            )),
      );
    },
  );
}

showDoneAnimation(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return const Center(
          child: SizedBox(
              height: 250,
              width: 250,
              child:
                  RiveAnimation.asset("assets/animation/doneAnimation.riv")));
    },
  );
}

class TabSolucaoConcentrada extends StatelessWidget {
  const TabSolucaoConcentrada({
    Key? key,
    required this.scrollController1,
  }) : super(key: key);

  final ScrollController scrollController1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.024,
        left: MediaQuery.of(context).size.width * 0.069,
        right: MediaQuery.of(context).size.width * 0.069,
        bottom: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Fator de concentração",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007),
            child: const Text(
              "300x",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.018),
            child: const Text(
              "Volume para reposição.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xB2333333),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007),
            child: Row(
              children: [
                const Text(
                  "500 Litros",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.050),
                  child: const Text(
                    "(Água)",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Color(0x54333333),
                    ),
                  ),
                ),
                const Icon(
                  Icons.opacity_outlined,
                  color: Color(0xff1C5EC1),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.009),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: Card(
                  color: const Color(0xffF5F5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Volume total do reservatório",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Color(0x54333333),
                        ),
                      ),
                      Text(
                        "  5000 L",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Color(0x54333333),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .030),
            child: const Text(
              "Volume necessário para ajuste",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.018,
              left: MediaQuery.of(context).size.width * 0.032,
              right: MediaQuery.of(context).size.width * 0.032,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Solução A ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "431,94 ml",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          const Divider(
            height: 15,
            thickness: 0.5,
            color: Color(0xFFC4C4C4),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.width * 0.032,
              right: MediaQuery.of(context).size.width * 0.032,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Solução B ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "431,94 ml",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCompleted extends StatelessWidget {
  const ButtonCompleted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .03,
            bottom: MediaQuery.of(context).size.width * 0.043),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .69,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              child: const Text(
                "Concluir",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                showConfirmDialog(context);
              },
            ),
          ),
        ));
  }
}

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          backgroundColor: Colors.white,
          toolbarHeight: MediaQuery.of(context).size.height * 0.17,
          collapsedHeight: MediaQuery.of(context).size.height * 0.17,
          pinned: true,
          forceElevated: true,
          elevation: 1,
          flexibleSpace: const TopAppBar(
            path: "/Tab/Ajustes/",
            namePage: "Resultado\n Ajuste",
          ),
          bottom: TabBar(
              controller: tabController,
              unselectedLabelColor: const Color(0xFF929292),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              labelColor: kPrimaryColor,
              tabs: const [
                Tab(text: "Fertilizantes"),
                Tab(
                  child: Text(
                    "Solução \n Concentrada",
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
        ));
  }
}

class TabFertilizantes extends StatelessWidget {
  const TabFertilizantes({
    Key? key,
    required this.scrollController1,
  }) : super(key: key);

  final ScrollController scrollController1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.024,
        left: MediaQuery.of(context).size.width * 0.069,
        right: MediaQuery.of(context).size.width * 0.069,
        bottom: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Volume para reposição",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007),
            child: Row(
              children: [
                const Text(
                  "500 Litros",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.050),
                  child: const Text(
                    "(Água)",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Color(0x54333333),
                    ),
                  ),
                ),
                const Icon(
                  Icons.opacity_outlined,
                  color: Color(0xff1C5EC1),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.028),
            child: const Text(
              "Quant. de fertilizantes para \n reposisição de nutrientes.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xB2333333),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.009),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Card(
                  color: const Color(0xffF5F5F5),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: scrollController1,
                    radius: const Radius.circular(12),
                    child: ListView.builder(
                      primary: false,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.089,
                        vertical: MediaQuery.of(context).size.height * 0.018,
                      ),
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController1,
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: index != 0
                                  ? MediaQuery.of(context).size.height * 0.018
                                  : 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: Text(
                                    "Fertilizante #$index",
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${27 * index}",
                                    textAlign: TextAlign.end,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: const Text("g"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
