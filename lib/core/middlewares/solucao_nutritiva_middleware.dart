import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/routes/routes.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/auth_controller.dart';

class SNViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "solucao-nutritiva-view");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class SNEditPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "solucao-nutritiva-edit");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}
