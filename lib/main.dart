import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

import 'core/inject/inject.dart';
import 'features/presenter/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInject();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Constants.kBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/core/constants/i18n'];
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
      title: 'Osíris Soluções',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: "Montserrat",
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: Routes.splashPage,
      getPages: AppPages.routes,
      // routeInformationParser: , //Modular.routeInformationParser,
      // routerDelegate: , //Modular.routerDelegate,
    );
  }
}
