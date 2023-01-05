import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/cargo/cargo_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/errors/failure.dart';

abstract class IGerenciarEquipeDatasource {
  Future<Either<Failure, List<Usuario>>> buscarUsuarios({required int contaId});
  Future<Either<Failure, List<Cargo>>> buscarCargos();
  Future<Either<Failure, Usuario>> alterarUsuario(
      {required int contaId, required Usuario usuario, required int cargoId});
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

  @override
  Future<Either<Failure, List<Cargo>>> buscarCargos() async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readCargos = r'''
              query Cargos {
                cargos {
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
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readCargos),
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? cargos =
          result.data?['cargos']?.map((item) => Cargo.fromJson(item)).toList();
      if (cargos == null || cargos.isEmpty) {
        return Left(
            ErrorGerenciarEquipe(message: FailureMessage.emptyListMessage));
      }

      List<Cargo> cargosList = cargos.cast<Cargo>();
      return Right(cargosList);
    } else {
      return Left(
          ErrorGerenciarEquipe(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, Usuario>> alterarUsuario(
      {required int contaId,
      required Usuario usuario,
      required int cargoId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      const String updateUsuario = r'''
        mutation UpdateUsuario($userId: Int!, $cargoId: Int!, $ativo: Boolean!, $contaId: Int!) {
          updateUsuario(userId: $userId, cargoId: $cargoId, ativo: $ativo, contaId: $contaId) {
            id
            nome
            email
            cod_acesso
            ativo
            contas {
              conta {
                id
                nome
              }
              cargo {
                id
                cargo
              }
            }
          }
        }
      ''';

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(updateUsuario),
        variables: <String, dynamic>{
          "userId": usuario.id,
          "cargoId": cargoId,
          "ativo": usuario.ativo,
          "contaId": contaId,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Usuario? usuario = Usuario.fromJson(result.data?['updateUsuario']);

        return Right(usuario);
      } else {
        return Left(
            ErrorArea(message: FailureMessage.errorUpdateUsuarioMessage));
      }
    } catch (e) {
      return Left(ErrorArea(message: FailureMessage.errorUpdateUsuarioMessage));
    }
  }
}
