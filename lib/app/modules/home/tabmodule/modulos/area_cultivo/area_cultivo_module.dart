import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/area_cultivo/area_cultivo_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/area_cultivo/area_cultivo_store.dart';

class AreaCultivoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AreaCultivoStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const AreaCultivoPage()),
  ];
}
