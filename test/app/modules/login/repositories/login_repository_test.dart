import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';
import 'package:osi_solucoes/app//modules/login/repositories/login_repository.dart';
import 'package:osi_solucoes/app/models/usuario_model.dart';

class GraphQLClientMock extends Mock implements GraphQLClient {}

class MockRepository extends Mock implements LoginRepository {}

Future<void> main() async {
  // final client = GraphQLClientMock();

  final repository = MockRepository();
  test('Deve retornar um Usuario', () async {
    // final data = {
    //   "login": {"status": 200, "token": "qwerty123321"}
    // };
    const String readRepositories = r'''
      query LoginByEmail($email: String!) {
        login(email: $email) {
          status
          token
        }
      }
    ''';

    Future<Usuario> data() async {
     final Usuario usuario = Usuario(nome: "Gustavo");
      return usuario;
    }

    when(repository.buscaUser("gustavo.alecio2@live.com")).thenReturn(data());

    final user = await repository.buscaUser("gustavo.alecio@live.com");

    expect(user, true);
  });
}
