import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_module.dart';
import 'package:osi_solucoes/app/modules/cadastro/confirmseguranca_page.dart';
import 'package:osi_solucoes/app/modules/home/home_module.dart';
import 'package:osi_solucoes/app/modules/login/login_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: LoginModule()),
    ModuleRoute("/Cadastro",
        module: CadastroModule(), transition: TransitionType.rightToLeft),
    ModuleRoute("/Home",
        module: HomeModule(), transition: TransitionType.rightToLeft),
  ];
}
