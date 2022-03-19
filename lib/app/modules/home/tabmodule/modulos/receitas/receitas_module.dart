
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/receitas/receitas_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/receitas/receitas_store.dart';

class ReceitasModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ReceitasStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ReceitasPage()),
  ];
}
