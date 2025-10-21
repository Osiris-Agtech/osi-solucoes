import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/login_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/home_page.dart';
import 'package:osi_solucoes/features/presenter/views/login/login_page.dart';

import '../../../../core/services/local_storage.dart';
import '../../viewmodels/auth_controller.dart';
import '../login/multi_account_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController authController = GetIt.I<AuthController>();
  final LoginStore loginStore = GetIt.I<LoginStore>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      var usuario = await LocalStorage().getUser();

      if (usuario != null) {
        loginStore.setEmailController(usuario.email ?? '');
        loginStore.setSenhaController(usuario.senha ?? '');
        String response = await loginStore.login();
        if (response == "sucesso") {
          Get.to(() => const HomePage());
          // Modular.to.pushReplacementNamed("/Home/");
        } else if (response == "multiple") {
          Get.to(
            () => MultiAccountsPage(
              user: loginStore.userList[0],
              isLoggedIn: false,
            ),
          );
        } else {
          LocalStorage().deleteUser();
          Get.to(() => const LoginPage());
        }

        // authController.setUser(usuario);

        // if (usuario.contas!.length > 1) {
        //   Get.to(
        //     () => MultiAccountsPage(
        //       user: usuario,
        //       isLoggedIn: false,
        //     ),
        //   );
        // } else {
        //   authController.usuario.selected_conta = usuario.contas![0];
        //   Get.off(() => const HomePage());
        // }
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
          "assets/images/logo_ufmt.png",
          width: MediaQuery.of(context).size.width * .6,
        ),
      ),
    );
  }
}
