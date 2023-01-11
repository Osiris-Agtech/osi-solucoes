import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

class CadernoCampoViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "caderno-campo-view");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class CadernoCampoEditPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "caderno-campo-edit");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}
