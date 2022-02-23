
import 'package:modular_test/modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osi_solucoes/app//modules/cadastro/cadastro_module.dart';
 
void main() {

  setUpAll(() {
    initModule(CadastroModule());
  });
}