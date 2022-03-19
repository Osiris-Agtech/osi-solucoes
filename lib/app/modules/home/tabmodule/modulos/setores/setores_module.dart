

import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/setores/setores_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/setores/setores_store.dart';

class SetoresModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SetoresStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SetoresPage()),
  ];
}
