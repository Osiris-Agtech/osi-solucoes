abstract class ILoginRepository {
  Future buscaUser(String email);
  Future login(String email, String senha, String codigo);
}
