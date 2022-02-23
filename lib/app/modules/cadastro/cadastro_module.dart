import 'package:osi_solucoes/app//modules/cadastro/cadastro_Page.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_store.dart';
import 'package:osi_solucoes/app/modules/cadastro/confirmseguranca_page.dart';
import 'package:osi_solucoes/app/modules/cadastro/repositories/cadastro_repository.dart';

class CadastroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CadastroStore()),
    Bind.lazySingleton((i) => CadastroRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CadastroPage()),
    ChildRoute(
      '/Confirma',
      child: (_, args) => const ConfirmsegurancaPage(),
      transition: TransitionType.rightToLeft,
    ),
  ];
}
