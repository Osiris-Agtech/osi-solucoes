import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/app_controller.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_module.dart';
import 'package:osi_solucoes/app/modules/home/home_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/resultadoajuste/resultadoajuste_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/modulos_module.dart';
import 'package:osi_solucoes/app/modules/login/login_module.dart';
import 'package:osi_solucoes/app/splash_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AppController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const SplashPage()),
    ModuleRoute(
      "/Login",
      module: LoginModule(),
      transition: TransitionType.rightToLeftWithFade,
    ),
    ModuleRoute(
      "/Cadastro",
      module: CadastroModule(),
      transition: TransitionType.rightToLeft,
    ),
    ModuleRoute(
      "/Home",
      module: HomeModule(),
      transition: TransitionType.rightToLeft,
    ),
    ModuleRoute(
      "/Tab",
      module: ModulosModule(),
      transition: TransitionType.rightToLeft,
    ),
    ModuleRoute(
      '/resultadoAjuste',
      module: ResultadoajusteModule(),
      transition: TransitionType.rightToLeft,
    ),
  ];
}
