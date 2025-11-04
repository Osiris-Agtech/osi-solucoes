import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';

import '../../../../core/errors/errors.dart';
import '../../../presenter/models/usuario/usuario_model.dart';

abstract class ILoginDatasource {
  Future<Either<Failure, Usuario>> login({
    required String password,
    String? email,
    String? code,
  });
}

class LoginDatasource implements ILoginDatasource {
  @override
  Future<Either<Failure, Usuario>> login({
    required String password,
    String? email,
    String? code,
  }) async {
    try {
      GraphQLClient client = GraphQLAPI().getGraphQLClient();

      const String loginMutation = r'''
        mutation Login($email: String, $senha: String!, $codigo: String) {
          login(data: {email: $email, senha: $senha, codigo: $codigo}) {
            token
            usuario {
              id
              nome
              email
              ativo
              cod_acesso
              acesso_externo
              fk_pessoas_id
              pessoa {
                id
                nome
              }
              contas {
                conta {
                  id
                  nome
                  nivel
                }
                cargo {
                  id
                  cargo
                  permissoes {
                    permissao {
                      id
                      nome
                    }
                  }
                }
              }
            }
          }
        }
      ''';

      final MutationOptions options = MutationOptions(
        document: gql(loginMutation),
        variables: <String, dynamic>{
          'email': email,
          'senha': password,
          'codigo': code,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        final exception = result.exception;
        if (exception != null && exception.linkException != null) {
          return Left(
              ErrorLogin(message: FailureMessage.connectionErrorMessage));
        }
        return Left(ErrorLogin(message: FailureMessage.errorLoginMessage));
      }

      final data = result.data?['login']['usuario'];

      if (data == null || data.isEmpty) {
        return Left(ErrorLogin(message: FailureMessage.userNotFoundMessage));
      }

      final user = Usuario.fromJson(data);

      return Right(user);
    } catch (e) {
      return Left(ErrorLogin(message: FailureMessage.errorLoginMessage));
    }
  }
}
