import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/routes/routes.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/auth_controller.dart';

class N1ViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N1-view");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class N1EditPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N1-edit");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class N2ViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N2-view");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class N2EditPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N2-edit");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class N3ViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N3-view");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}

class N3EditPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == "area-cultivo-N3-edit");
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}
