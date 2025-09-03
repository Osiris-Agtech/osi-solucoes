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
import 'package:osi_solucoes/features/presenter/views/home/components/daily_tasks_widget.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/field_activities_widget.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/lot_status_metrics_widget_clean.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/productivity_chart_container.dart';
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

  // Variáveis para o carousel do dashboard
  final PageController _dashboardPageController = PageController();
  int _currentDashboardIndex = 0;
  final List<String> _dashboardTitles = [
    'Produtividade',
    'Tarefas Diárias',
    'Atividades do Campo',
    'Status dos Lotes',
  ];

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
  void dispose() {
    _dashboardPageController.dispose();
    super.dispose();
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
              // Seção de Ações Rápidas
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ações Rápidas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Ver todas',
                          style: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        modernQuickActionCard(
                          context,
                          size,
                          "card1Home".i18n(),
                          "assets/icons/gerenciar_icon.svg",
                          const Color(0xFF6366F1),
                          onTap: () => Get.toNamed(Routes.gerenciarEquipePage),
                        ),
                        const SizedBox(width: 12),
                        modernQuickActionCard(
                          context,
                          size,
                          "card2Home".i18n(),
                          "assets/icons/relatorio_icon.svg",
                          const Color(0xFF8B5CF6),
                          onTap: () => Get.toNamed(Routes.historicoPage),
                        ),
                        const SizedBox(width: 12),
                        modernQuickActionCard(
                          context,
                          size,
                          "card3Home".i18n(),
                          "assets/icons/inventario_icon.svg",
                          const Color(0xFF06B6D4),
                          onTap: () => Get.toNamed(Routes.agendaPage),
                        ),
                        const SizedBox(width: 12),
                        modernQuickActionCard(
                          context,
                          size,
                          "card4Home".i18n(),
                          "assets/icons/relatorio_icon.svg",
                          const Color(0xFF10B981),
                          onTap: () => Get.toNamed(Routes.protocoloPage),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Seção do Dashboard
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 30,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dashboardTitles[_currentDashboardIndex],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          _buildCarouselButton(
                            Icons.keyboard_arrow_left,
                            () => _previousDashboard(),
                            _currentDashboardIndex > 0,
                          ),
                          const SizedBox(width: 8),
                          _buildCarouselButton(
                            Icons.keyboard_arrow_right,
                            () => _nextDashboard(),
                            _currentDashboardIndex <
                                _dashboardTitles.length - 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Carousel de Widgets do Dashboard
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 400, // Altura fixa para o carousel
                  child: PageView(
                    controller: _dashboardPageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentDashboardIndex = index;
                      });
                    },
                    children: const [
                      ProductivityChartContainer(),
                      DailyTasksWidget(),
                      FieldActivitiesWidget(),
                      LotStatusMetricsWidget(
                        title: 'Status dos Lotes',
                        subtitle: 'Situação atual',
                      ),
                    ],
                  ),
                ),
              ),

              // Indicadores do Carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _dashboardTitles.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentDashboardIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentDashboardIndex == index
                              ? Constants.kPrimaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Título da seção de módulos
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    top: 10,
                    bottom: 15,
                  ),
                  child: const Text(
                    'Módulos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                sliver: SliverGrid.count(
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 10 / 8,
                  crossAxisCount: 2,
                  children: [
                    modernGridItems(
                      context,
                      size,
                      "card5Home".i18n(),
                      "assets/icons/cultivo_icon.svg",
                      const Color(0xFF059669),
                      path: "Setores",
                      id: 0,
                    ),
                    modernGridItems(
                      context,
                      size,
                      "card6Home".i18n(),
                      "assets/icons/reservatorio_icon.svg",
                      const Color(0xFF2563EB),
                      path: "Reservatorios",
                      id: 1,
                    ),
                    modernGridItems(
                      context,
                      size,
                      "card7Home".i18n(),
                      "assets/icons/caderno_campo_icon.svg",
                      const Color(0xFFDC2626),
                      path: "CadernoCampo",
                      id: 2,
                    ),
                    modernGridItems(
                      context,
                      size,
                      "card8Home".i18n(),
                      "assets/icons/solucoes_nutritivas_icon.svg",
                      const Color(0xFFEA580C),
                      path: "Receitas",
                      id: 3,
                    ),
                    modernGridItems(
                      context,
                      size,
                      "card9Home".i18n(),
                      "assets/icons/ajustes_icon.svg",
                      const Color(0xFF7C3AED),
                      path: "Ajustes",
                      id: 4,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
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

  Widget modernQuickActionCard(
    BuildContext context,
    Size size,
    String title,
    String icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
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

  Widget modernGridItems(
    BuildContext context,
    Size size,
    String title,
    String icon,
    Color color, {
    String? path,
    required int id,
  }) {
    return InkWell(
      onTap: () async {
        modulosStore.setPageViewController(id);
        Get.toNamed(Routes.modulosPage);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 28,
                    height: 28,
                    color: color,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos para controle do carousel do dashboard
  void _nextDashboard() {
    if (_currentDashboardIndex < _dashboardTitles.length - 1) {
      HapticFeedback.lightImpact(); // Feedback tátil
      _dashboardPageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousDashboard() {
    if (_currentDashboardIndex > 0) {
      HapticFeedback.lightImpact(); // Feedback tátil
      _dashboardPageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Widget _buildCarouselButton(IconData icon, VoidCallback onTap, bool enabled) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? Constants.kPrimaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? Colors.white : Colors.grey[600],
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
    HomeStore store = GetIt.I<HomeStore>();
    final progress = shrinkOffset / maxExtent;
    final opacity = (1 - progress).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF134e5e),
            Color(0xFF71b280),
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Glassmorphism overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),

            // Top bar with icons
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModernIconButton(
                    'assets/icons/grid.svg',
                    onTap: () => store.setIsCollaped(),
                  ),
                  _buildNotificationButton(store),
                ],
              ),
            ),

            // User profile section
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: progress < 0.5 ? 60 : 20,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: opacity,
                child: Column(
                  children: [
                    // Avatar with modern styling
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png'),
                        radius: 32,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User name
                    Observer(builder: (_) {
                      return Text(
                        store.authController.usuario.selected_conta?.conta
                                ?.nome ??
                            "...",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),

                    const SizedBox(height: 8),

                    // User role with modern badge
                    Observer(builder: (_) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          store.authController.usuario.selected_conta?.cargo
                                  ?.cargo ??
                              "...",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom accent line
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 12,
              left: MediaQuery.of(context).size.width * 0.35,
              right: MediaQuery.of(context).size.width * 0.35,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: opacity * 0.6,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernIconButton(String iconPath,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(HomeStore store) {
    return Observer(builder: (_) {
      return GestureDetector(
        onTap: () => store.toggleNotified(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/icons/notification_off_icon.svg",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              if (store.isNotified)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4757),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  @override
  double get maxExtent => 240;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
