import '../../../presenter/models/usuario/usuario_model.dart';

abstract class ILoginRepository {
  Future buscaUser(String email);
  Future<List<Usuario>> login(String email, String senha, String codigo);
}
