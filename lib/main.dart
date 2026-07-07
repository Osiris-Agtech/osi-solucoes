import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/services/navigation_analytics.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/services/auth_service.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osi_solucoes/firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/inject/inject.dart';
import 'core/utils/route_observer.dart';
import 'features/presenter/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await _initializeFirebase();

  await Get.putAsync(() => AuthService().init());
  await initInject();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Constants.kBackgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AppWidget());
}

/// Inicializa o Firebase de forma segura
///
/// Para configurar o Firebase completamente:
/// 1. Instale o FlutterFire CLI: dart pub global activate flutterfire_cli
/// 2. Execute: flutterfire configure
/// 3. Descomente a importação de firebase_options.dart no topo do arquivo
/// 4. Descomente as linhas marcadas com "Opção 1" abaixo
Future<void> _initializeFirebase() async {
  print('🔥 [FIREBASE] Inicializando Firebase...');
  try {
    // Inicializa Firebase com as opções geradas pelo FlutterFire CLI
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ [FIREBASE] Firebase inicializado com sucesso');
    print(
        '   └─ Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}');
  } catch (e, stackTrace) {
    // Firebase não disponível ou não configurado, app continua funcionando
    print('⚠️ [FIREBASE] Firebase não inicializado: $e');
    print('   StackTrace: $stackTrace');
    print('   O app continuará funcionando com atalhos padrão');
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/core/constants/i18n'];

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          locale: const Locale("pt", "BR"),
          debugShowCheckedModeBanner: false,
          title: 'Gerenciador de Cultivos',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            fontFamily: "Montserrat",
            useMaterial3: true,
          ),
          initialRoute: Routes.splashPage,
          getPages: AppPages.routes,
          navigatorObservers: [routeObserver],
          routingCallback: NavigationAnalytics.onGetRouting,
          builder: (context, child) {
            return ToastListener(
              child: ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 599, name: MOBILE),
                  const Breakpoint(start: 600, end: 1023, name: TABLET),
                  const Breakpoint(start: 1024, end: 1439, name: DESKTOP),
                  const Breakpoint(
                      start: 1440, end: double.infinity, name: '4K'),
                ],
              ),
            );
          },
          // routeInformationParser: , //Modular.routeInformationParser,
          // routerDelegate: , //Modular.routerDelegate,
        );
      },
    );
  }
}
