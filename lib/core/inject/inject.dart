import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/data/datasources/ajuste/ajuste_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/cadernoCampo/caderno_campo_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/gerenciarEquipe/gerenciar_equipe_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/login/login_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/lote/lote_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/protocolo/protocolo_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/recuperarSenha/recuperar_senha_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/setor/setor_datasource.dart';
import 'package:osi_solucoes/features/data/datasources/solucoes/solucoes_nutritivas_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/ajuste/ajuste_repository.dart';
import 'package:osi_solucoes/features/data/repositories/cadernoCampo/cadeno_campo_repository.dart';
import 'package:osi_solucoes/features/data/repositories/gerenciarEquipe/gerenciar_equipe_repository.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository.dart';
import 'package:osi_solucoes/features/data/repositories/recuperarSenha/recuperar_senha_repository.dart';
import 'package:osi_solucoes/features/data/repositories/reservatorio/reservatorio_repository.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository.dart';
import 'package:osi_solucoes/features/data/repositories/solucoes/solucoes_repository.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/gerenciar_equipe_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/recuperar_senha_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';

import '../../features/data/datasources/area/area_datasource.dart';
import '../../features/data/datasources/cadastro/cadastro_datasource.dart';
import '../../features/data/datasources/reservatorio/reservatorio_datasource.dart';
import '../../features/data/repositories/area/area_repository.dart';
import '../../features/data/repositories/cadastro/cadastro_repository.dart';
import '../../features/data/repositories/login/login_repository.dart';
import '../../features/presenter/viewmodels/ajustes_store.dart';
import '../../features/presenter/viewmodels/area_cultivo_store.dart';
import '../../features/presenter/viewmodels/auth_controller.dart';
import '../../features/presenter/viewmodels/cadastro_store.dart';
import '../../features/presenter/viewmodels/caderno_campo_store.dart';
import '../../features/presenter/viewmodels/home_store.dart';
import '../../features/presenter/viewmodels/login_store.dart';
import '../../features/presenter/viewmodels/modulos_store.dart';
import '../../features/presenter/viewmodels/reservatorios_store.dart';
import '../../features/presenter/viewmodels/resultadoajuste_store.dart';
import '../../features/presenter/viewmodels/solucao_store.dart';
import '../../features/presenter/views/login/multi_account_page.dart';
import '../domain/connectivity_service.dart';

final sl = GetIt.I;

Future<void> initInject() async {
  //core
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ConnectivityService>(
      () => ConnectivityServiceImpl(connectivity: sl()));

  //datasource
  sl.registerLazySingleton<ICadastroConta>(() => CadastroConta());
  sl.registerLazySingleton<ILoginDatasource>(() => LoginDatasource());
  sl.registerLazySingleton<IProtocoloDatasource>(() => ProtocoloDatasource());
  sl.registerLazySingleton<ISetorDatasource>(() => SetorDatasource());
  sl.registerLazySingleton<IAreaDatasource>(() => AreaDatasource());
  sl.registerLazySingleton<ILoteDatasource>(() => LoteDatasource());
  sl.registerLazySingleton<IAjusteDatasource>(() => AjusteDatasource());
  sl.registerLazySingleton<IReservatorioDatasource>(
      () => ReservatorioDatasource());
  sl.registerLazySingleton<ICadernoCampoDatasource>(
      () => CadernoCampoDatasource());
  sl.registerLazySingleton<ISolucaoDatasource>(() => SolucaoDatasource());
  sl.registerLazySingleton<IGerenciarEquipeDatasource>(
      () => GerenciarEquipeDatasource());
  sl.registerLazySingleton<IRecuperarSenhaDatasource>(
      () => RecuperarSenhaDatasource());

  //repositories
  sl.registerLazySingleton<CadastroRepository>(
      () => CadastroRepository(datasource: sl()));
  sl.registerLazySingleton<LoginRepository>(
      () => LoginRepository(datasource: sl()));
  sl.registerLazySingleton<ReservatorioRepository>(
      () => ReservatorioRepository(datasource: sl()));
  sl.registerLazySingleton<SetorRepository>(
      () => SetorRepository(datasource: sl()));
  sl.registerLazySingleton<AreaRepository>(
      () => AreaRepository(datasource: sl()));
  sl.registerLazySingleton<LoteRepository>(
      () => LoteRepository(datasource: sl()));
  sl.registerLazySingleton<AjusteRepository>(
      () => AjusteRepository(datasource: sl()));
  sl.registerLazySingleton<CadernoCampoRepository>(
      () => CadernoCampoRepository(datasource: sl()));
  sl.registerLazySingleton<SolucaoRepository>(
      () => SolucaoRepository(datasource: sl()));
  sl.registerLazySingleton<GerenciarEquipeRepository>(
      () => GerenciarEquipeRepository(datasource: sl()));
  sl.registerLazySingleton<RecuperarSenhaRepository>(
      () => RecuperarSenhaRepository(datasource: sl()));
  sl.registerLazySingleton<ProtocoloRepository>(
      () => ProtocoloRepository(datasource: sl()));

  //viewmodels
  sl.registerLazySingleton<AjustesStore>(() => AjustesStore());
  sl.registerLazySingleton<AreaCultivoStore>(() => AreaCultivoStore());
  sl.registerLazySingleton<SetorStore>(() => SetorStore());
  sl.registerLazySingleton<LoteStore>(() => LoteStore());
  sl.registerLazySingleton<AuthController>(() => AuthController());
  sl.registerLazySingleton<CadastroStore>(() => CadastroStore());
  sl.registerLazySingleton<RecuperarSenhaStore>(() => RecuperarSenhaStore());
  sl.registerLazySingleton<CadernoCampoStore>(() => CadernoCampoStore());
  sl.registerLazySingleton<HomeStore>(() => HomeStore());
  sl.registerLazySingleton<LoginStore>(() => LoginStore());
  sl.registerLazySingleton<ModulosStore>(() => ModulosStore());
  sl.registerLazySingleton<ReservatoriosStore>(() => ReservatoriosStore());
  sl.registerLazySingleton<ResultadoajusteStore>(() => ResultadoajusteStore());
  sl.registerLazySingleton<SolucaoStore>(() => SolucaoStore());
  sl.registerLazySingleton<GerenciarEquipeStore>(() => GerenciarEquipeStore());
  sl.registerLazySingleton<ProtocoloStore>(() => ProtocoloStore());

  sl.registerFactoryParam<MultiAccountsPage, Usuario, bool>(
    (param1, param2) => MultiAccountsPage(
      user: param1,
      isLoggedIn: param2,
    ),
  );
}
