import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/login/multi_account_page.dart';
import 'package:osi_solucoes/features/presenter/views/onboarding/splash_page.dart';

import '../../../../core/services/local_storage.dart';
import '../../viewmodels/auth_controller.dart';
import '../../viewmodels/home_store.dart';
import '../../viewmodels/modulos_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = GetIt.I<AuthController>();
  ModulosStore modulosStore = GetIt.I<ModulosStore>();
  HomeStore store = GetIt.I<HomeStore>();
  final Duration duration = const Duration(milliseconds: 300);

  Future<bool> exitApp() async {
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        // title: const Text(
        //   'Warning',
        //   textAlign: TextAlign.center,
        // ),
        content: Text(
          'Tem certeza que deseja fechar o APP ?',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(.75),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.grey),
            onPressed: () async {
              exit(0); // kill app
            },
            child: const Text(
              'Sim',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(
              'Não',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () => exitApp(),
          child: Scaffold(
            backgroundColor: Constants.kSecondBackgroundColor,
            body: Stack(
              children: [
                menu(context, size),
                home(context, size),
              ],
            ),
          ),
        ),
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
              // Expanded(flex: 1, child: Container()),
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: sizeWidth * 0.02,
                ),
                child: IconButton(
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    store.setIsCollaped();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Constants.kBackgroundColor,
                    size: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: (sizeWidth * 0.33),
                  bottom: 10,
                ),
                child: const Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png'),
                    radius: 32.5,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.24),
                    child: Observer(builder: (_) {
                      return Text(
                        store.authController.usuario.selected_conta?.conta
                                ?.nome ??
                            "...",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.003,
                      right: size.width * 0.24,
                      bottom: 10,
                    ),
                    child: Observer(builder: (_) {
                      return Text(
                        store.authController.usuario.selected_conta?.cargo
                                ?.cargo ??
                            "...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(.8),
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              // Expanded(flex: 1, child: Container()),
              Divider(
                color: const Color(0xFF9F9F9F).withOpacity(.4),
              ),
              // Expanded(flex: 1, child: Container()),
              Padding(
                padding: EdgeInsets.only(
                    // top: size.height * 0.05,
                    left: sizeWidth * 0.122),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/settings_icon.svg",
                          color: Constants.kBackgroundColor.withOpacity(.8),
                        ),
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Text(
                          "itemMenu1".i18n(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.122, top: size.height * 0.02),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/hexagon_icon.svg",
                          color: Constants.kBackgroundColor.withOpacity(.8),
                        ),
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Text(
                          "itemMenu2".i18n(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Observer(builder: (_) {
                if (store.authController.usuario.contas!.length < 2) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.only(
                      left: sizeWidth * 0.122, top: size.height * 0.02),
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      store.setIsCollaped();
                      Get.to(
                        () => MultiAccountsPage(
                          isLoggedIn: true,
                          user: store.authController.usuario,
                        ),
                      );
                      // Modular.to.pushNamed(
                      //   "/Login/MultiAccounts/",
                      //   arguments: {
                      //     "user": store.appController.usuario,
                      //     "isLoggedIn": true,
                      //   },
                      // );
                    },
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.published_with_changes,
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.02),
                          child: const Text(
                            "Trocar Conta",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Divider(
                color: const Color(0xFF9F9F9F).withOpacity(.4),
              ),
              Padding(
                padding: EdgeInsets.only(left: sizeWidth * 0.122
                    // , top: size.height * 0.05
                    ),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/info_icon.svg",
                          color: Constants.kBackgroundColor.withOpacity(.8),
                        ),
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Text(
                          "itemMenu3".i18n(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sizeWidth * 0.122, top: size.height * 0.02),
                child: InkWell(
                  onTap: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    await LocalStorage().deleteUser();
                    await Future.delayed(const Duration(seconds: 2));
                    store.setIsCollaped();
                    Get.offAll(() => const SplashPage());
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/external_link_icon.svg",
                          color: Constants.kBackgroundColor.withOpacity(.8),
                        ),
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Text(
                          "itemMenu4".i18n(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  left: sizeWidth * 0.14,
                ),
                child: Text(
                  "versao".i18n(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Expanded(flex: 1, child: Container()),
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
        bottom: store.isCollapsed ? 0 : 0.1 * size.height,
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
            color: Constants.kSecondBackgroundColor,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // sliverAppBarWidget(size),
              const SliverPersistentHeader(
                pinned: true,
                delegate: MyHeaderDelegate(),
              ),
              SliverFixedExtentList(
                itemExtent: 120, //size.height * 0.17,
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: size.width * 0.098),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        firstItems(
                          context,
                          size,
                          "card1Home".i18n(),
                          "assets/icons/gerenciar_icon.svg",
                          onTap: () => Get.toNamed(Routes.gerenciarEquipePage),
                        ),
                        firstItems(
                          context,
                          size,
                          "card2Home".i18n(),
                          "assets/icons/relatorio_icon.svg",
                          onTap: () => Get.toNamed(Routes.historicoPage),
                        ),
                        firstItems(
                          context,
                          size,
                          "card3Home".i18n(),
                          "assets/icons/inventario_icon.svg",
                          onTap: () => Get.toNamed(Routes.agendaPage),
                        ),
                        firstItems(
                          context,
                          size,
                          "card4Home".i18n(),
                          "assets/icons/relatorio_icon.svg",
                          onTap: () => Get.toNamed(Routes.protocoloPage),
                        ),
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
                    context,
                    size,
                    "card5Home".i18n(),
                    "assets/icons/cultivo_icon.svg",
                    true,
                    path: "Setores",
                    id: 0,
                  ),
                  gridItems(
                    context,
                    size,
                    "card6Home".i18n(),
                    "assets/icons/reservatorio_icon.svg",
                    false,
                    path: "Reservatorios",
                    id: 1,
                  ),
                  gridItems(
                    context,
                    size,
                    "card7Home".i18n(),
                    "assets/icons/caderno_campo_icon.svg",
                    true,
                    path: "CadernoCampo",
                    id: 2,
                  ),
                  gridItems(
                    context,
                    size,
                    "card8Home".i18n(),
                    "assets/icons/solucoes_nutritivas_icon.svg",
                    false,
                    path: "Receitas",
                    id: 3,
                  ),
                  gridItems(
                    context,
                    size,
                    "card9Home".i18n(),
                    "assets/icons/ajustes_icon.svg",
                    true,
                    path: "Ajustes",
                    id: 4,
                  ),
                  // gridItems(
                  //   context,
                  //   size,
                  //   "card10Home".i18n(),
                  //   "assets/icons/chat_icon.svg",
                  //   false,
                  //   id: 5,
                  // ),
                  // const SizedBox(),
                ],
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      );
    });
  }

  SliverAppBar sliverAppBarWidget(Size size) {
    return SliverAppBar(
      backgroundColor: Constants.kBackgroundColor,
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
          child: Observer(builder: (_) {
            return InkWell(
              onTap: () => store.toggleNotified(),
              child: Stack(
                children: [
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
                ],
              ),
            );
          }),
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
                  backgroundColor: Constants.kPrimaryColor,
                  child: Icon(
                    Icons.person,
                    color: Constants.kBackgroundColor,
                    size: 25,
                  ),
                  minRadius: 25,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.014),
                child: Observer(
                  builder: (_) {
                    return Text(
                      store.authController.usuario.selected_conta?.conta
                              ?.nome ??
                          "...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.003),
                child: Observer(
                  builder: (_) {
                    return Text(
                      store.authController.usuario.selected_conta?.cargo
                              ?.cargo ??
                          "...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstItems(BuildContext context, Size size, String title, String icon,
      {VoidCallback? onTap}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(icon),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.009),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget gridItems(
      BuildContext context, Size size, String title, String icon, bool isLeft,
      {String? path, required int id}) {
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
            modulosStore.setPageViewController(id);
            Get.toNamed(
              Routes.modulosPage,
              // () => const ModulosPage(),
              // transition: Transition.rightToLeft,
            );
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
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        icon,
                        height: 25,
                        width: 25,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      bottom: 20,
                      right: 16,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const MyHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // final HomeStore store = Modular.get<HomeStore>();
    HomeStore store = GetIt.I<HomeStore>();
    final progress = shrinkOffset / maxExtent;

    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(45),
        bottomRight: Radius.circular(45),
        topLeft: Radius.zero,
        topRight: Radius.zero,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
          topLeft: Radius.zero,
          topRight: Radius.zero,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/grid.svg'),
                  onPressed: () {
                    store.setIsCollaped();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                          "assets/icons/notification_off_icon.svg"),
                      onPressed: () {},
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
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.lerp(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                const EdgeInsets.only(bottom: 16),
                progress,
              ),
              alignment: Alignment.lerp(
                const Alignment(0, -0.5),
                Alignment.bottomCenter,
                progress,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: (1 - progress * 1.5) < 0 ? 0 : 1 - progress * 1.5,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png'),
                  radius: 30,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.lerp(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                const EdgeInsets.only(bottom: 16),
                progress,
              ),
              alignment: Alignment.lerp(
                const Alignment(0, 0.45),
                const Alignment(0, 0.5),
                progress,
              ),
              child: Observer(builder: (_) {
                return Text(
                  store.authController.usuario.selected_conta?.conta?.nome ??
                      "...",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.lerp(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                const EdgeInsets.only(bottom: 16),
                progress,
              ),
              alignment: Alignment.lerp(
                const Alignment(0, 0.8),
                Alignment.bottomCenter,
                progress,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: (1 - progress * 2) < 0 ? 0 : 1 - progress * 2,
                child: Observer(builder: (_) {
                  return Text(
                    store.authController.usuario.selected_conta?.cargo?.cargo ??
                        "...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.7),
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.lerp(
                const Alignment(0, 0.85),
                const Alignment(0, 0.7),
                progress,
              ),
              child: Container(
                height: 3,
                width: 80,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  color: Color(0xFF767676),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
