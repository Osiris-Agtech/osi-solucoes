import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/modulos_Page.dart';
import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/modulos_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/caderno_campo/caderno_campo_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/receitas/receitas_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/reservatorios/reservatorios_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/setores/setores_module.dart';

class ModulosModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ModulosStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => const ModulosPage(),
      children: [
        ModuleRoute('/Ajustes', module: AjustesModule()),
        ModuleRoute('/CadernoCampo', module: CadernoCampoModule()),
        ModuleRoute('/Receitas', module: ReceitasModule()),
        ModuleRoute('/Reservatorios', module: ReservatoriosModule()),
        ModuleRoute('/Setores', module: SetoresModule()),
      ],
    ),
  ];
}
