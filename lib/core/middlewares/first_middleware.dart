import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/routes/routes.dart';

class FirstMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    if (isAuthenticated == false) {
      return const RouteSettings(name: Routes.permissaoNegadaPage);
    }
    return null;
  }

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page

  //This function will be called right before the Bindings are initialized.
  // Here we can change Bindings for this page.

  //This function will be called right after the Bindings are initialized.
  // Here we can do something after  bindings created and before creating the page widget.

  // Page build and widgets of page will be shown

  //This function will be called right after disposing all the related objects
  // (Controllers, views, ...) of the page.
}
