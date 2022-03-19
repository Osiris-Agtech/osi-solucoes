
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/caderno_campo/caderno_campo_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/caderno_campo/caderno_campo_store.dart';

class CadernoCampoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CadernoCampoStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CadernoCampoPage()),
  ];
}
