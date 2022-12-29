import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/errors/failure.dart';

abstract class IGerenciarEquipeDatasource {
  Future<Either<Failure, List<Usuario>>> buscarUsuarios({required int contaId});
}

class GerenciarEquipeDatasource implements IGerenciarEquipeDatasource {
  @override
  Future<Either<Failure, List<Usuario>>> buscarUsuarios(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readUsuarios = r'''
              query Usuarios($contaId: Int) {
                usuarios(where: {
                  contas: {
                    some: {
                      fk_contas_id: {
                        equals: $contaId
                      }
                    }
                  }
                }) {
                  id
                  nome
                  email
                  ativo
                  contas {
                    id
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
                        status
                        id
                      }
                    }
                  }
                  logs {
                    id
                    descricao
                    data
                  }
                }
              }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readUsuarios),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? usuarios = result.data?['usuarios']
          ?.map((item) => Usuario.fromJson(item))
          .toList();
      if (usuarios == null || usuarios.isEmpty) {
        return Left(
            ErrorGerenciarEquipe(message: FailureMessage.emptyListMessage));
      }

      List<Usuario> usuariosList = usuarios.cast<Usuario>();
      return Right(usuariosList);
    } else {
      return Left(
          ErrorGerenciarEquipe(message: FailureMessage.emptyListMessage));
    }
  }
}
