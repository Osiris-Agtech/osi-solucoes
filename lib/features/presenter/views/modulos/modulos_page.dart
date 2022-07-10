import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/ajuste/ajustes_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/caderno_campo_page.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/reservatorios_page.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/solucao_page.dart';

import '../../viewmodels/modulos_store.dart';

class ModulosPage extends StatefulWidget {
  final String title;
  final int page;
  const ModulosPage({Key? key, this.title = 'ModulosPage', this.page = 0})
      : super(key: key);
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
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: Observer(
        builder: (_) {
          return BottomNavigationBar(
            selectedItemColor: Constants.kContentColorLightTheme,
            unselectedItemColor: Constants.kContentColorLightTheme,
            backgroundColor: Colors.white,
            // fixedColor: Colors.white,
            elevation: 8,
            currentIndex: store.pageviewController,
            onTap: (int index) => store.setPageViewController(index),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/cultivo_icon.svg",
                  // color: store.pageviewController == 0
                  //     ? null
                  //     : const Color.fromRGBO(51, 51, 51, 0.8),
                  height: 25,
                  width: 25,
                ),
                label: 'Cultivos',
              ),
              BottomNavigationBarItem(
                // "assets/icons/cultivo_icon.svg"
                icon: SvgPicture.asset(
                  "assets/icons/reservatorio_icon.svg",
                  // color: store.pageviewController == 1
                  //     ? null
                  //     : const Color.fromRGBO(51, 51, 51, 0.8),
                  height: 25,
                  width: 25,
                ),
                label: 'Reservatórios',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/caderno_campo_icon.svg",
                  // color: store.pageviewController == 2
                  //     ? null
                  //     : const Color.fromRGBO(51, 51, 51, 0.8),
                  height: 25,
                  width: 25,
                ),
                label: 'Cadernos de\n     Campo',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/solucoes_nutritivas_icon.svg",
                  // color: store.pageviewController == 3
                  //     ? null
                  //     : const Color.fromRGBO(51, 51, 51, 0.8),
                  height: 25,
                  width: 25,
                ),
                label: 'Soluções',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/ajustes_icon.svg",
                  // color: store.pageviewController == 4
                  //     ? null
                  //     : const Color.fromRGBO(51, 51, 51, 0.8),
                  height: 25,
                  width: 25,
                ),
                label: 'Ajustes',
              ),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBar bottomNavigatorBar2() {
    return BottomNavigationBar(
      selectedLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        overflow: TextOverflow.clip,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 8,
        overflow: TextOverflow.ellipsis,
        leadingDistribution: TextLeadingDistribution.proportional,
      ),
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      onTap: (id) {
        store.pageviewController = id;
        if (id == 0) {
          store.setPageViewController(id);
          // Modular.to.navigate('/Tab/AreaCultivo/');
        } else if (id == 1) {
          store.setPageViewController(id);
          // Modular.to.navigate('/Tab/Reservatorios/');
        } else if (id == 2) {
          store.setPageViewController(id);
          // Modular.to.navigate('/Tab/CadernoCampo/');
        } else if (id == 3) {
          store.setPageViewController(id);
          // Modular.to.navigate('/Tab/Receitas/');
        } else if (id == 4) {
          store.setPageViewController(id);
          // Modular.to.navigate('/Tab/Ajustes/');
        }
      },
      currentIndex: store.pageviewController,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.layers_outlined,
            color: Constants.kPrimaryColor,
          ),
          tooltip: "Área de Cultivo",
          label: 'card5Home'.i18n(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.format_align_justify_outlined,
            color: Constants.kPrimaryColor,
          ),
          label: 'card6Home'.i18n(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.filter_none,
            color: Constants.kPrimaryColor,
          ),
          label: 'card7Home'.i18n(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.drive_file_rename_outline_sharp,
            color: Constants.kPrimaryColor,
          ),
          label: 'card8Home'.i18n(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.history_edu_outlined,
            color: Constants.kPrimaryColor,
          ),
          label: 'card9Home'.i18n(),
        ),
      ],
    );
  }
}
