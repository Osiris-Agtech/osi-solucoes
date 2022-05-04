import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_store.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/resultadoajuste/resultadoajuste_module.dart';

class AjustesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AjustesStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const AjustesPage()),
    ModuleRoute('/resultadoAjuste',
        module: ResultadoajusteModule(),
        transition: TransitionType.leftToRight),
  ];
}
