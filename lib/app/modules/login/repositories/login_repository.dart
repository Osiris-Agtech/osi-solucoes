import 'package:graphql/client.dart';
import 'package:osi_solucoes/app/models/usuario_model.dart';

import 'login_repository_interface.dart';

class LoginRepository implements ILoginRepository {
  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(""),
  );

  // LoginRepository(this.client);

  @override
  Future<Usuario> buscaUser(String email) async {
    Usuario user = Usuario();
    // return "sucesso";
    // return "sucesso";
    
    AuthLink _authLink =
        AuthLink(getToken: () async => "authController.usuario.token");
    Link _link = _authLink.concat(_authLink);

    const String readRepositories = r'''
      query BuscarCulturaByUser($userID: Int!) {
        filtrarCulturaByUser(userID: $userID) {
          cultura_ID
          nome
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'email': email,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      return result.data!['login'].map((item) => Usuario.fromJson(item))
          as Usuario;
    } else {
      throw Exception(result.exception);
    }
  }
}
