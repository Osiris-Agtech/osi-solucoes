import 'package:get/get.dart';
import 'package:osi_solucoes/core/middlewares/area_cultivo_middleware.dart';
import 'package:osi_solucoes/core/middlewares/caderno_middleware.dart';
import 'package:osi_solucoes/core/middlewares/equipe_middleware.dart';
import 'package:osi_solucoes/core/middlewares/reservatorio_middleware.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/agenda_page.dart';
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
import 'package:osi_solucoes/features/presenter/views/historico/historico_page.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/detalhes_ativ.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/detelhes_protocolo.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/editar_protocolo_page.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/protocolo_page.dart';
import 'package:osi_solucoes/features/presenter/views/recuperar_senha/codigo_seguranca_page.dart';
import 'package:osi_solucoes/features/presenter/views/recuperar_senha/nova_senha_page.dart';
import 'package:osi_solucoes/features/presenter/views/recuperar_senha/recuperacao_page.dart';
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
import '../views/protocolo/cadastrar_protocolo_page.dart';
import '../views/reservatorio/reservatorios_page.dart';
import '../views/solucao/solucao_page.dart';
import '../views/relatorios/ciclo_cultura/relatorio_ciclo_cultura_page.dart';
import '../views/relatorios/relatorios_page.dart';
import '../views/relatorios/produtividade_setor/relatorio_produtividade_setor_page.dart';
import '../views/relatorios/desempenho_equipe/relatorio_desempenho_equipe_page.dart';
import '../views/relatorios/agenda_tarefas/relatorio_agenda_tarefas_page.dart';
import '../views/adaptive_admin/adaptive_admin_page.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.ajustesPage,
      page: () => const AjustesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.resultadoajustePage,
      page: () => const ResultadoajustePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.areaCultivoPage,
      page: () => const AreaCultivoPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N1ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarAreaCultivoPage,
      page: () => const CadastrarAreaCultivo(),
      transition: Transition.rightToLeft,
      middlewares: [
        N1EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.setorPage,
      page: () => const SetorPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N2ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarSetorPage,
      page: () => const CadastrarSetorPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N2EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.lotePage,
      page: () => const LotePage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N3ViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarLotePage,
      page: () => const CadastrarLotePage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N3EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesLotePage,
      page: () => const DetalhesLotePage(),
      transition: Transition.rightToLeft,
      middlewares: [
        N3EditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastroPage,
      page: () => const CadastroPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.confirmsegurancaPage,
      page: () => const ConfirmaSegurancaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cadernoCampoPage,
      page: () => const CadernoCampoPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        CadernoCampoViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesCadernoCampoPage,
      page: () => const DetalhesCadernoCampoPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        CadernoCampoViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastroCadernoCampoPage,
      page: () => const CadastroCadernoCampoPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        CadernoCampoEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.modulosPage,
      page: () => const ModulosPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.loginPage,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.multiAccountsPage,
      page: () => MultiAccountsPage(
        user: Usuario(),
        isLoggedIn: false,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.splashPage,
      page: () => const SplashPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reservatoriosPage,
      page: () => const ReservatoriosPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cadastrarReservatoriosPage,
      page: () => const CadastrarReservatorioPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        ReservatorioEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesReservatorio,
      page: () => const DetalhesReservatorio(),
      transition: Transition.rightToLeft,
      middlewares: [
        ReservatorioViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.solucaoPage,
      page: () => const SolucaoPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.gerenciarEquipePage,
      page: () => const GerenciarEquipePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.protocoloPage,
      page: () => const ProtocoloPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarProtocoloPage,
      page: () => const CadastrarProtocoloPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesProtocoloPage,
      page: () => const DetalhesProtocolo(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.editarProtocoloPage,
      page: () => const EditarProtocoloPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesAtividadesProtocolo,
      page: () => const DetalhesAtivPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.agendaPage,
      page: () => const AgendaPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeViewPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.cadastrarUsuarioPage,
      page: () => const CadastrarUsuarioPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.detalhesUsuarioPage,
      page: () => const DetalhesUsuarioPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        EquipeEditPagePermission(),
      ],
    ),
    GetPage(
      name: Routes.permissaoNegadaPage,
      page: () => const PermissionDeniedPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cadastrarSolucaoConcentradaPage,
      page: () => const CadastrarSolucaoConcentradaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.recuperarSenha,
      page: () => const RecuperarSenhaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.codigoSeguranca,
      page: () => const CodigoSegurancaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.novaSenha,
      page: () => const NovaSenhaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.historicoPage,
      page: () => const HistoricoPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.relatorioCircoCulturaPage,
      page: () => const RelatorioCicloCulturaPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.relatoriosPage,
      page: () => const RelatoriosPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.relatorioProdutividadeSetorPage,
      page: () => const RelatorioProdutividadeSetorPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.relatorioDesempenhoEquipePage,
      page: () => const RelatorioDesempenhoEquipePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.relatorioAgendaTarefasPage,
      page: () => const RelatorioAgendaTarefasPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.adaptiveAdminPage,
      page: () => const AdaptiveAdminPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
