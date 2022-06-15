import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/home_page.dart';
import 'package:osi_solucoes/features/presenter/views/login/login_page.dart';

import '../../../../core/services/local_storage.dart';
import '../../viewmodels/auth_controller.dart';
import '../login/multi_account_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController authController = GetIt.I<AuthController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      var usuario = await LocalStorage().getUser();

      if (usuario != null) {
        authController.setUser(usuario);

        if (usuario.contas!.length > 1) {
          Get.to(
            () => MultiAccountsPage(
              user: usuario,
              isLoggedIn: false,
            ),
          );
        } else {
          authController.usuario.selected_conta = usuario.contas![0];
          Get.off(() => const HomePage());
        }
      } else {
        Get.to(() => const LoginPage());
      }
      // Modular.to.pushReplacementNamed("/Login/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Constants.kBackgroundColor,
      child: Center(
        child: Image.asset(
          "assets/images/osiris-logo.png",
          width: MediaQuery.of(context).size.width * .5,
        ),
      ),
    );
  }
}
