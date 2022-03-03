import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_store.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/modulos_store.dart';

class AjustesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AjustesStore()),
    // Bind.lazySingleton((i) => ModulosStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const AjustesPage()),
  ];
}
