import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/modulos_store.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/constants.dart';

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
            onTap: (id) {
              store.pageviewController = id;
              if (id == 0) {
                Modular.to.navigate('/Tab/Setores');
              } else if (id == 1) {
                Modular.to.navigate('/Tab/Reservatorios');
              } else if (id == 2) {
                Modular.to.navigate('/Tab/CadernoCampo');
              } else if (id == 3) {
                Modular.to.navigate('/Tab/Receitas');
              } else if (id == 4) {
                Modular.to.navigate('/Tab/Ajuste');
              }
            },
            currentIndex: store.pageviewController,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.layers_outlined,
                  color: kPrimaryColor,
                ),
                label: 'Setores',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.format_align_justify_outlined,
                  color: kPrimaryColor,
                ),
                label: 'Reservatorios',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.filter_none,
                  color: kPrimaryColor,
                ),
                label: 'Caderno de Campo',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.drive_file_rename_outline_sharp,
                  color: kPrimaryColor,
                ),
                label: 'Receitas',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history_edu_outlined,
                  color: kPrimaryColor,
                ),
                label: 'Ajustes',
              ),
            ],
          );
        },
      ),
    );
  }
}
