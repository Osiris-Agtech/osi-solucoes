import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

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
  final ModulosStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: Observer(
        builder: (_) {
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
                leadingDistribution: TextLeadingDistribution.proportional),
            fixedColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            onTap: (id) {
              store.pageviewController = id;
              if (id == 0) {
                Modular.to.navigate('/Tab/AreaCultivo/');
              } else if (id == 1) {
                Modular.to.navigate('/Tab/Reservatorios/');
              } else if (id == 2) {
                Modular.to.navigate('/Tab/CadernoCampo/');
              } else if (id == 3) {
                Modular.to.navigate('/Tab/Receitas/');
              } else if (id == 4) {
                Modular.to.navigate('/Tab/Ajustes/');
              }
            },
            currentIndex: store.pageviewController,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.layers_outlined,
                  color: kPrimaryColor,
                ),
                tooltip: "Área de Cultivo",
                label: 'card5Home'.i18n(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.format_align_justify_outlined,
                  color: kPrimaryColor,
                ),
                label: 'card6Home'.i18n(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.filter_none,
                  color: kPrimaryColor,
                ),
                label: 'card7Home'.i18n(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.drive_file_rename_outline_sharp,
                  color: kPrimaryColor,
                ),
                label: 'card8Home'.i18n(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.history_edu_outlined,
                  color: kPrimaryColor,
                ),
                label: 'card9Home'.i18n(),
              ),
            ],
          );
        },
      ),
    );
  }
}
