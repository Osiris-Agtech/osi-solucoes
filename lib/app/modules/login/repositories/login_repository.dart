import 'package:graphql/client.dart';
import 'package:osi_solucoes/app/models/usuario/usuario_model.dart';

import 'login_repository_interface.dart';

class LoginRepository implements ILoginRepository {
  final HttpLink _httpLink = HttpLink(
    "http://7ad9-2804-d59-42d7-9900-1ce4-3250-890f-bc75.ngrok.io",
  );

  final _authLink = AuthLink(
    getToken: () async => 'Bearer \$YOUR_PERSONAL_ACCESS_TOKEN',
  );
  // LoginRepository(this.client);

  @override
  Future<Usuario> buscaUser(String email) async {
    Link _link = _authLink.concat(_httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

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

  @override
  Future<List<Usuario>> login(String email, String senha, String codigo) async {
    Link _link = _authLink.concat(_httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

    const String readRepositories = r'''
      query BuscarUsuarios($senha: String!, $email: String, $codigo: String) {
        usuarios(where: {
          OR: [
            {
              AND: [
                {
                  email: {
                    equals: $email
                  },
                  senha: {
                    equals: $senha
                  }
                }
              ]
            },
            {
              AND: [
                {
                  cod_acesso: {
                    equals: $codigo
                  },
                  senha: {
                    equals: $senha
                  }
                }
              ]
            }
          ] 
        }) {
          nome
            contas {
              conta {
                nome
              }
              cargo {
                cargo
              }
            }
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'email': email,
        'codigo': codigo,
        'senha': senha,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? usuario = result.data?['usuarios']
          ?.map((item) => Usuario.fromJson(item))
          .toList();
      if (usuario == null || usuario.isEmpty) {
        throw Exception("Usuário não encontrado");
      }

      List<Usuario> users = usuario.cast<Usuario>();
      return users;
    } else {
      throw Exception(result.exception);
    }
  }
}
