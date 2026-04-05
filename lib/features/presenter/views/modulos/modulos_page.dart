import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/ajuste/ajustes_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/caderno_campo_page.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/relatorios_page.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/reservatorios_page.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/solucao_page.dart';

import '../../../../core/utils/responsive_breakpoints.dart';
import '../../viewmodels/modulos_store.dart';

class ModulosPage extends StatefulWidget {
  final String title;
  final int page;
  const ModulosPage({super.key, this.title = 'ModulosPage', this.page = 0});
  @override
  ModulosPageState createState() => ModulosPageState();
}

class ModulosPageState extends State<ModulosPage> {
  ModulosStore store = GetIt.I<ModulosStore>();

  Widget _getBody() {
    List<Widget> pages = [
      const AreaCultivoPage(),
      const ReservatoriosPage(),
      const CadernoCampoPage(),
      const SolucaoPage(),
      const RelatoriosPage(),
      const AjustesPage(),
    ];
    return Observer(builder: (_) {
      return IndexedStack(
        index: store.pageviewController,
        children: pages,
      );
    });
  }

  // Widget _buildBottomBar() {
  //   return CustomAnimatedBottomBar(
  //     containerHeight: 70,
  //     backgroundColor: Colors.black,
  //     selectedIndex: store.pageviewController,
  //     showElevation: true,
  //     itemCornerRadius: 24,
  //     curve: Curves.easeIn,
  //     onItemSelected: (index) => store.setPageViewController(index),
  //     items: <BottomNavyBarItem>[
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.apps),
  //         title: const Text('Área de Cultivo'),
  //         activeColor: Constants.kPrimaryColor,
  //         inactiveColor: Constants.kSecondaryColor,
  //         textAlign: TextAlign.center,
  //       ),
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.people),
  //         title: const Text('Reservatórios'),
  //         activeColor: Constants.kPrimaryColor,
  //         inactiveColor: Constants.kSecondaryColor,
  //         textAlign: TextAlign.center,
  //       ),
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.message),
  //         title: const Text(
  //           'Caderno de Campo ',
  //         ),
  //         activeColor: Constants.kPrimaryColor,
  //         inactiveColor: Constants.kSecondaryColor,
  //         textAlign: TextAlign.center,
  //       ),
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.settings),
  //         title: const Text('Soluções'),
  //         activeColor: Constants.kPrimaryColor,
  //         inactiveColor: Constants.kSecondaryColor,
  //         textAlign: TextAlign.center,
  //       ),
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.settings),
  //         title: const Text('Ajustes'),
  //         activeColor: Constants.kPrimaryColor,
  //         inactiveColor: Constants.kSecondaryColor,
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.isDesktop(context);
    final isTablet = ResponsiveBreakpoints.isTablet(context);
    
    return Scaffold(
      body: isDesktop || isTablet
          ? _buildDesktopLayout(context)
          : _getBody(),
      bottomNavigationBar: ResponsiveBreakpoints.isMobile(context)
          ? _buildBottomBar()
          : null,
    );
  }

  /// Layout para desktop/tablet com NavigationRail
  Widget _buildDesktopLayout(BuildContext context) {
    return Observer(
      builder: (_) {
        return Row(
          children: [
            NavigationRail(
              selectedIndex: store.pageviewController,
              onDestinationSelected: (index) => store.setPageViewController(index),
              labelType: NavigationRailLabelType.all,
              minWidth: 80,
              minExtendedWidth: 200,
              extended: ResponsiveBreakpoints.isDesktop(context),
              elevation: 4,
              destinations: _buildRailDestinations(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: _getBody(),
            ),
          ],
        );
      },
    );
  }

  /// Constrói destinos do NavigationRail
  List<NavigationRailDestination> _buildRailDestinations() {
    return [
      NavigationRailDestination(
        icon: SvgPicture.asset(
          "assets/icons/cultivo_icon.svg",
          height: 24,
          width: 24,
        ),
        label: Text('Cultivos'),
      ),
      NavigationRailDestination(
        icon: SvgPicture.asset(
          "assets/icons/reservatorio_icon.svg",
          height: 24,
          width: 24,
        ),
        label: Text('Reservatórios'),
      ),
      NavigationRailDestination(
        icon: SvgPicture.asset(
          "assets/icons/caderno_campo_icon.svg",
          height: 24,
          width: 24,
        ),
        label: Text('Caderno Campo'),
      ),
      NavigationRailDestination(
        icon: SvgPicture.asset(
          "assets/icons/solucoes_nutritivas_icon.svg",
          height: 24,
          width: 24,
        ),
        label: Text('Soluções'),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.bar_chart_outlined, size: 24),
        selectedIcon: const Icon(Icons.bar_chart, size: 24),
        label: Text('Relatórios'),
      ),
      NavigationRailDestination(
        icon: SvgPicture.asset(
          "assets/icons/ajustes_icon.svg",
          height: 24,
          width: 24,
        ),
        label: Text('Ajustes'),
      ),
    ];
  }

  /// BottomNavigationBar para mobile (otimizado)
  Widget _buildBottomBar() {
    return Observer(
      builder: (_) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Constants.kContentColorLightTheme,
          unselectedItemColor: Constants.kGreyMedium,
          backgroundColor: Colors.white,
          elevation: 8,
          selectedFontSize: 10,
          unselectedFontSize: 9,
          currentIndex: store.pageviewController,
          onTap: (int index) => store.setPageViewController(index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/cultivo_icon.svg",
                height: 24,
                width: 24,
              ),
              label: 'Cultivos',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/reservatorio_icon.svg",
                height: 24,
                width: 24,
              ),
              label: 'Reservatórios',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/caderno_campo_icon.svg",
                height: 24,
                width: 24,
              ),
              label: 'Caderno',  // Removido "de Campo" para evitar overflow
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/solucoes_nutritivas_icon.svg",
                height: 24,
                width: 24,
              ),
              label: 'Soluções',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined, size: 24),
              activeIcon: const Icon(Icons.bar_chart, size: 24),
              label: 'Relatórios',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/ajustes_icon.svg",
                height: 24,
                width: 24,
              ),
              label: 'Ajustes',
            ),
          ],
        );
      },
    );
  }
}
