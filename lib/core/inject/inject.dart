import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../features/presenter/viewmodels/ajustes_store.dart';
import '../../features/presenter/viewmodels/area_cultivo_store.dart';
import '../../features/presenter/viewmodels/auth_controller.dart';
import '../../features/presenter/viewmodels/cadastro_store.dart';
import '../../features/presenter/viewmodels/caderno_campo_store.dart';
import '../../features/presenter/viewmodels/home_store.dart';
import '../../features/presenter/viewmodels/login_store.dart';
import '../../features/presenter/viewmodels/reservatorios_store.dart';
import '../../features/presenter/viewmodels/resultadoajuste_store.dart';
import '../../features/presenter/viewmodels/solucao_store.dart';
import '../domain/connectivity_service.dart';

final sl = GetIt.I;

Future<void> initInject() async {
  //core
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ConnectivityService>(
      () => ConnectivityServiceImpl(connectivity: sl()));

  //viewmodels
  sl.registerLazySingleton<AjustesStore>(() => AjustesStore());
  sl.registerLazySingleton<AreaCultivoStore>(() => AreaCultivoStore());
  sl.registerLazySingleton<AuthController>(() => AuthController());
  sl.registerLazySingleton<CadastroStore>(() => CadastroStore());
  sl.registerLazySingleton<CadernoCampoStore>(() => CadernoCampoStore());
  sl.registerLazySingleton<HomeStore>(() => HomeStore());
  sl.registerLazySingleton<LoginStore>(() => LoginStore());
  sl.registerLazySingleton<ReservatoriosStore>(() => ReservatoriosStore());
  sl.registerLazySingleton<ResultadoajusteStore>(() => ResultadoajusteStore());
  sl.registerLazySingleton<SolucaoStore>(() => SolucaoStore());
}
