import 'package:osi_solucoes/app//modules/login/login_Page.dart';
import 'package:osi_solucoes/app//modules/login/login_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/login/multi_account_page.dart';
import 'package:osi_solucoes/app/modules/login/repositories/login_repository.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginRepository()),
    Bind.lazySingleton((i) => LoginStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const LoginPage()),
    ChildRoute(
      '/MultiAccounts/',
      child: (_, args) => MultiAccountsPage(
        user: args.data['user'],
        isLoggedIn: args.data['isLoggedIn'],
      ),
      transition: TransitionType.rightToLeftWithFade,
    ),
  ];
}
