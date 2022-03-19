
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/reservatorios/reservatorios_page.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/reservatorios/reservatorios_store.dart';

class ReservatoriosModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ReservatoriosStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ReservatoriosPage()),
  ];
}
