import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/home/home_store.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/modulos_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  final ModulosStore modulosStore = Modular.get();
  final Duration duration = const Duration(milliseconds: 200);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: kSecondBackgroundColor,
            body: Stack(
              children: [
                menu(context, size),
                home(context, size),
              ],
            )),
      ),
    );
  }

  Widget menu(BuildContext context, Size size) {
    double sizeWidth = size.width * 0.76;
    double sizeHeight = size.height;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: sizeHeight,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF333333), Color(0xFF2F6947)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.7, 3]),
        ),
        child: SizedBox(
          height: sizeHeight,
          width: sizeWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: sizeHeight * .088, left: sizeWidth * 0.02),
                child: IconButton(
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      store.setIsCollaped();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(right: (sizeWidth * 0.33)),
                child: const CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  child: Icon(
                    Icons.person,
                    color: kBackgroundColor,
                    size: 25,
                  ),
                  minRadius: 32.5,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.24),
                    child: const Text(
                      "Hidrogood",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.003, right: size.width * 0.24),
                      child: const Text(
                        "Administrador",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.04),
                child: const Divider(
                  color: Color(0xFF9F9F9F),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.05, left: sizeWidth * 0.122),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: const Text(
                          "Minha Conta",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.122, top: size.height * 0.05),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_outline_outlined,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: const Text(
                          "Tornar Premium",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: const Divider(
                  color: Color(0xFF9F9F9F),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.122, top: size.height * 0.05),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: const Text(
                          "Sobre",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.122, top: size.height * 0.046),
                child: InkWell(
                  onTap: () {
                    Modular.to.pushReplacementNamed(Modular.initialRoute);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.open_in_new_outlined,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: const Text(
                          "Sair",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.14,
                    bottom: size.height * 0.02,
                    top: size.height * 0.11),
                child: const Text(
                  "Versão 2.0.0",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget home(BuildContext context, Size size) {
    size = MediaQuery.of(context).size;
    return Observer(builder: (_) {
      return AnimatedPositioned(
        duration: duration,
        top: store.isCollapsed ? 0 : size.height * 0.1,
        bottom: store.isCollapsed ? 0 : 0.2 * size.width,
        left: store.isCollapsed ? 0 : 0.76 * size.width,
        right: store.isCollapsed ? 0 : -.8 * size.width,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 256,
            minHeight: 600,
          ),
          height: store.isCollapsed ? size.height : size.height * 0.8,
          width: store.isCollapsed ? size.width : size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: store.isCollapsed
                ? BorderRadius.circular(0)
                : BorderRadius.circular(30),
            color: kSecondBackgroundColor,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                forceElevated: true,
                elevation: 1,
                pinned: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: const Radius.circular(30),
                    top: Radius.circular(store.isCollapsed ? 0 : 30),
                  ),
                ),
                expandedHeight: size.height * 0.28,
                collapsedHeight: 65,
                toolbarHeight: 50,
                bottom: PreferredSize(
                  child: Divider(
                    color: Colors.black,
                    height: 21,
                    thickness: 1.5,
                    indent: size.width * 0.39,
                    endIndent: size.width * 0.39,
                  ),
                  preferredSize: const Size(double.infinity, 3),
                ),
                title: Image.asset(
                  "assets/images/osiris-logo.png",
                  height: 30,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => store.setIsCollaped(),
                  icon: const Icon(Icons.grid_view_outlined),
                  color: Colors.black,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 25),
                    child: Stack(children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      store.isNotified
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                ),
                                height: 12,
                                width: 12,
                              ),
                            )
                          : Container()
                    ]),
                  )
                ],
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.03),
                          child: const CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            child: Icon(
                              Icons.person,
                              color: kBackgroundColor,
                              size: 25,
                            ),
                            minRadius: 25,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: size.height * 0.014),
                            child: const Text(
                              "Hidrogood",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: size.height * 0.003),
                            child: const Text(
                              "Administrador",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFixedExtentList(
                itemExtent: size.height * 0.17,
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.035,
                        horizontal: size.width * 0.098),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        firstItems(context, size, "Gerenciar",
                            Icons.business_center_outlined),
                        firstItems(context, size, "Relatório",
                            Icons.content_paste_outlined),
                        firstItems(context, size, "Inventário",
                            Icons.inventory_2_outlined),
                        firstItems(
                            context, size, "Mais", Icons.more_horiz_outlined),
                      ],
                    ),
                  ),
                ]),
              ),
              SliverGrid.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                childAspectRatio: 10 / 8,
                crossAxisCount: 2,
                children: [
                  gridItems(
                      context, size, "Setores", Icons.layers_outlined, true,
                      path: "Setores"),
                  gridItems(context, size, "Reservatórios",
                      Icons.layers_outlined, false,
                      path: "Reservatorios"),
                  gridItems(context, size, "Caderno de Campo",
                      Icons.layers_outlined, true,
                      path: "CadernoCampo"),
                  gridItems(
                      context, size, "Receitas", Icons.layers_outlined, false,
                      path: "Receitas"),
                  gridItems(
                      context, size, "Ajustes", Icons.layers_outlined, true,
                      path: "Ajuste", id: 4),
                  gridItems(
                      context, size, "Chat", Icons.layers_outlined, false),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget firstItems(
      BuildContext context, Size size, String title, IconData icon) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [Color(0xFF707070), Color(0xFF53916C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0.2, 1]),
          ),
          height: 50,
          width: 50,
          child: Icon(icon, color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.009),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget gridItems(
      BuildContext context, Size size, String title, IconData icon, bool isLeft,
      {String? path, int? id}) {
    return Padding(
      padding: isLeft
          ? EdgeInsets.only(left: size.width * 0.07)
          : EdgeInsets.only(right: size.width * 0.07),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              color: Color.fromARGB(15, 0, 0, 0),
              blurRadius: 15,
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            await modulosStore.setPageViewController(id!);
            Modular.to.pushNamed("/Tab/$path/");
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 22, top: 22),
                        child: Icon(
                          icon,
                          size: 25,
                        ))),
                const Spacer(),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 20),
                      child: Text(title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


