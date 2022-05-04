import 'package:osi_solucoes/app/models/usuario/usuario_model.dart';

import 'cadastro_repository_interface.dart';

class CadastroRepository implements ICadastroRepository {
  @override
  Future cadastraUser(Usuario user) async {
    return "sucesso";
    // return throw "erro de cadastro";
  }

  @override
  Future verificaUser(String email) async {
    return "Sucesso";
    //  return throw Exception("Error");
    //   if (response.isNotEmpty) {
    //     return "sucesso";
    //   } else {
    //     return throw Exception("Error");
    //   }
  }
}
