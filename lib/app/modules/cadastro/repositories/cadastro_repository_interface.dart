import 'package:osi_solucoes/app/models/usuario_model.dart';

abstract class ICadastroRepository {
  Future verificaUser(String email);
  Future cadastraUser(Usuario user);
}
