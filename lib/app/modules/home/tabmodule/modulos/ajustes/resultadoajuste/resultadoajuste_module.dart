import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/ajustes/resultadoajuste/resultadoajuste_Page.dart';
import 'package:osi_solucoes/app//modules/home/tabmodule/modulos/ajustes/resultadoajuste/resultadoajuste_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ResultadoajusteModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ResultadoajusteStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ResultadoajustePage()),
  ];
}
