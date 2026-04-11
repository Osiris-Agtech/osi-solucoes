import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

/// Modelo leve de informação do usuário para a tela admin.
class UserInfo {
  final int id;
  final String? nome;
  final String? email;
  final bool? ativo;

  UserInfo({
    required this.id,
    this.nome,
    this.email,
    this.ativo,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      ativo: json['ativo'] as bool?,
    );
  }

  /// Nome de exibição — usa nome ou fallback para email/id.
  String get displayName {
    if (nome != null && nome!.isNotEmpty) return nome!;
    if (email != null && email!.isNotEmpty) return email!;
    return 'Usuário $id';
  }
}

/// Serviço para buscar usuários do backend ISIS via GraphQL.
///
/// Usado pela tela secreta de administração adaptativa para
/// exibir a lista de usuários com nome/email ao invés de
/// apenas IDs numéricos.
class AdaptiveUserService {
  /// Query GraphQL para buscar usuários ativos ordenados por nome.
  static const _queryUsuarios = r'''
    query UsuariosAtivos {
      usuarios(where: { ativo: { equals: true } }, orderBy: { nome: asc }) {
        id
        nome
        email
        ativo
      }
    }
  ''';

  /// Cliente GraphQL sem autenticação.
  ///
  /// A API ISIS não valida token JWT nas queries/mutations,
  /// então não precisamos do AuthLink com token.
  static GraphQLClient _getUnauthenticatedClient() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(Constants.stagingUrl),
    );
  }

  /// Busca todos os usuários ativos do sistema.
  ///
  /// Retorna lista ordenada por nome.
  static Future<List<UserInfo>> listAllUsers() async {
    final GraphQLClient client = _getUnauthenticatedClient();

    final QueryOptions options = QueryOptions(
      document: gql(_queryUsuarios),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      final exception = result.exception;
      throw Exception(
        'Erro ao buscar usuários: ${exception?.graphqlErrors.map((e) => e.message).join(', ') ?? exception.toString()}',
      );
    }

    final data = result.data?['usuarios'] as List<dynamic>?;
    if (data == null) return [];

    return data
        .map((json) => UserInfo.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
