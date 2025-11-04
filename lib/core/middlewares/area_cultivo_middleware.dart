import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/core/constants/permissions.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

class N1ViewPagePermission extends GetMiddleware {
  AuthController authController = GetIt.I<AuthController>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool? validate = authController.usuario.selected_conta?.cargo?.permissoes
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN1View);
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
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN1Edit);
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
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN2View);
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
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN2Edit);
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
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN3View);
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
        ?.any((element) => element.permissao?.nome == Permissions.areaCultivoN3Edit);
    return validate != null && validate
        ? null
        : const RouteSettings(name: Routes.permissaoNegadaPage);
  }
}
