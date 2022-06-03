import 'package:get/get.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

import '../views/ajuste/ajustes_page.dart';
import '../views/ajuste/resultadoajuste_page.dart';
import '../views/area_cultivo/area_cultivo_page.dart';
import '../views/cadastro/cadastro_page.dart';
import '../views/cadastro/confirmseguranca_page.dart';
import '../views/caderno_campo/caderno_campo_page.dart';
import '../views/home/home_page.dart';
import '../views/home/modulos_page.dart';
import '../views/login/login_page.dart';
import '../views/login/multi_account_page.dart';
import '../views/onboarding/splash_page.dart';
import '../views/reservatorio/reservatorios_page.dart';
import '../views/solucao/solucao_page.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: Routes.ajustesPage, page: () => const AjustesPage()),
    GetPage(
        name: Routes.resultadoajustePage,
        page: () => const ResultadoajustePage()),
    GetPage(name: Routes.areaCultivoPage, page: () => const AreaCultivoPage()),
    GetPage(name: Routes.cadastroPage, page: () => const CadastroPage()),
    GetPage(
        name: Routes.confirmsegurancaPage,
        page: () => const ConfirmaSegurancaPage()),
    GetPage(
        name: Routes.cadernoCampoPage, page: () => const CadernoCampoPage()),
    GetPage(name: Routes.homePage, page: () => const HomePage()),
    GetPage(name: Routes.modulosPage, page: () => const ModulosPage()),
    GetPage(name: Routes.loginPage, page: () => const LoginPage()),
    GetPage(
      name: Routes.multiAccountsPage,
      page: () => MultiAccountsPage(
        user: Usuario(),
        isLoggedIn: false,
      ),
    ),
    GetPage(name: Routes.splashPage, page: () => const SplashPage()),
    GetPage(
        name: Routes.reservatoriosPage, page: () => const ReservatoriosPage()),
    GetPage(name: Routes.solucaoPage, page: () => const SolucaoPage()),
  ];
}
