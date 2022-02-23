import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/constants.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: kBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
