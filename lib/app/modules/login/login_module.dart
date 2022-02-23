import 'package:graphql/client.dart';
import 'package:osi_solucoes/app//modules/login/login_Page.dart';
import 'package:osi_solucoes/app//modules/login/login_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_store.dart';
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
  ];
}
