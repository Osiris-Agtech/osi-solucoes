import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';

import '../../../../core/errors/errors.dart';
import '../../../presenter/models/usuario/usuario_model.dart';

abstract class ILoginDatasource {
  Future<Either<Failure, List<Usuario>>> login(
      {required String email, required String password, required String code});
}

class LoginDatasource implements ILoginDatasource {
  @override
  Future<Either<Failure, List<Usuario>>> login(
      {required String email,
      required String password,
      required String code}) async {
    try {
      GraphQLClient client = GraphQLAPI().getGraphQLClient();

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
            id
            nome
            email
            senha
            contas {
              conta {
                id
                nome
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
      ''';

      final QueryOptions? options;

      options = QueryOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          'email': email,
          'codigo': code,
          'senha': password,
        },
      );

      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        List? usuario = result.data?['usuarios']
            ?.map((item) => Usuario.fromJson(item))
            .toList();
        if (usuario == null || usuario.isEmpty) {
          return Left(ErrorLogin(message: FailureMessage.userNotFoundMessage));
        }

        List<Usuario> users = usuario.cast<Usuario>();
        return Right(users);
      } else {
        return Left(ErrorLogin(message: FailureMessage.errorLoginMessage));
      }
    } catch (e) {
      return Left(ErrorLogin(message: FailureMessage.errorLoginMessage));
    }
  }
}
