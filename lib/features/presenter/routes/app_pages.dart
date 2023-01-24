import 'package:get/get.dart';
import 'package:osi_solucoes/core/middlewares/area_cultivo_middleware.dart';
import 'package:osi_solucoes/core/middlewares/caderno_middleware.dart';
import 'package:osi_solucoes/core/middlewares/equipe_middleware.dart';
import 'package:osi_solucoes/core/middlewares/reservatorio_middleware.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/alert/permission_denied_view.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/setor_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/detalhes_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/detalhes_caderno_campo_page.dart';
import 'package:osi_solucoes/features/presenter/views/gerenciar_equipe/cadastrar_usuario_page.dart';
import 'package:osi_solucoes/features/presenter/views/gerenciar_equipe/detalhes_usuario_page.dart';
import 'package:osi_solucoes/features/presenter/views/gerenciar_equipe/gerenciar_equipe_page.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/detalhes_reservatorio_page.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/cadastrar_solucao_concentrada_page.dart';

import '../views/ajuste/ajustes_page.dart';
import '../views/ajuste/resultadoajuste_page.dart';
import '../views/area_cultivo/N1/area_cultivo_page.dart';
import '../views/cadastro/cadastro_page.dart';
import '../views/cadastro/confirmseguranca_page.dart';
import '../views/caderno_campo/caderno_campo_page.dart';
import '../views/home/home_page.dart';
import '../views/modulos/modulos_page.dart';
import '../views/login/login_page.dart';
import '../views/login/multi_account_page.dart';
import '../views/onboarding/splash_page.dart';
import '../views/reservatorio/reservatorios_page.dart';
import '../views/solucao/solucao_page.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.ajustesPage,
      page: () => const AjustesPage(),
    ),
    GetPage(
      name: Routes.resultadoajustePage,
      page: () => const ResultadoajustePage(),
    ),
    GetPage(
      name: Routes.areaCultivoPage,
      page: () => const AreaCultivoPage(),
      middlewares: [
        N1ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarAreaCultivoPage,
      page: () => const CadastrarAreaCultivo(),
      middlewares: [
        N1EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.setorPage,
      page: () => const SetorPage(),
      middlewares: [
        N2ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarSetorPage,
      page: () => const CadastrarSetorPage(),
      middlewares: [
        N2EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.lotePage,
      page: () => const LotePage(),
      middlewares: [
        N3ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarLotePage,
      page: () => const CadastrarLotePage(),
      middlewares: [
        N3EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesLotePage,
      page: () => const DetalhesLotePage(),
      middlewares: [
        N3EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastroPage,
      page: () => const CadastroPage(),
    ),
    GetPage(
      name: Routes.confirmsegurancaPage,
      page: () => const ConfirmaSegurancaPage(),
    ),
    GetPage(
      name: Routes.cadernoCampoPage,
      page: () => const CadernoCampoPage(),
      middlewares: [
        CadernoCampoViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesCadernoCampoPage,
      page: () => const DetalhesCadernoCampoPage(),
      middlewares: [
        CadernoCampoViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastroCadernoCampoPage,
      page: () => const CadastroCadernoCampoPage(),
      middlewares: [
        CadernoCampoEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.modulosPage,
      page: () => const ModulosPage(),
    ),
    GetPage(
      name: Routes.loginPage,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.multiAccountsPage,
      page: () => MultiAccountsPage(
        user: Usuario(),
        isLoggedIn: false,
      ),
    ),
    GetPage(
      name: Routes.splashPage,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.reservatoriosPage,
      page: () => const ReservatoriosPage(),
    ),
    GetPage(
      name: Routes.cadastrarReservatoriosPage,
      page: () => const CadastrarReservatorioPage(),
      middlewares: [
        ReservatorioEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesReservatorio,
      page: () => const DetalhesReservatorio(),
      middlewares: [
        ReservatorioViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.solucaoPage,
      page: () => const SolucaoPage(),
    ),
    GetPage(
      name: Routes.gerenciarEquipePage,
      page: () => const GerenciarEquipePage(),
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarUsuarioPage,
      page: () => const CadastrarUsuarioPage(),
      middlewares: [
        EquipeEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesUsuarioPage,
      page: () => const DetalhesUsuarioPage(),
      middlewares: [
        EquipeEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.permissaoNegadaPage,
      page: () => const PermissionDeniedPage(),
    ),
    GetPage(
      name: Routes.cadastrarSolucaoConcentradaPage,
      page: () => const CadastrarSolucaoConcentradaPage(),
    ),
  ];
}
