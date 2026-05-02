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
  Future<Either<Failure, Usuario>> buscarPessoa({required String email});
  Future<Either<Failure, Usuario>> registrarUsuario({
    required Usuario usuario,
    required int contaId,
    required int cargoId,
  });
  Future<Either<Failure, String>> descadastrarUsuarioDaConta({
    required int contaId,
    required int userId,
  });
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
      if (result.data?['usuarios'] == []) return const Right([]);

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

  @override
  Future<Either<Failure, Usuario>> buscarPessoa({required String email}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readPessoa = r'''
              query Usuarios ($email: String!) {
              usuarios(where: {
                email: {
                  equals: $email
                }
              }) {
                id
                email
                pessoa {
                  nome
                  sobrenome
                }
              }
            }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readPessoa),
      variables: <String, dynamic>{
        'email': email,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      Usuario usuarioEncontrado = Usuario.fromJson(result.data?['usuarios'][0]);
      return Right(usuarioEncontrado);
    } else {
      return Left(
          ErrorGerenciarEquipe(message: FailureMessage.errorUserEmailNotFound));
    }
  }

  @override
  Future<Either<Failure, Usuario>> registrarUsuario(
      {required Usuario usuario,
      required int contaId,
      required int cargoId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation InviteContributor($nome: String!, $sobrenome: String!, $email: String!, $cargoId: Int!, $contaId: Int!) {
          inviteContributor(nome: $nome, sobrenome: $sobrenome, email: $email, cargoId: $cargoId, contaId: $contaId) {
            id
            email
            nome
            pessoa {
              nome
              sobrenome
            }
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
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "email": usuario.email,
        "nome": usuario.pessoa!.nome!,
        "sobrenome": usuario.pessoa!.sobrenome!,
        "cargoId": cargoId,
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Usuario? novoUsuario =
          Usuario.fromJson(result.data?['inviteContributor']);

      return Right(novoUsuario);
    } else {
      return Left(
        ErrorGerenciarEquipe(message: FailureMessage.errorRegisterMessage),
      );
    }
  }

  @override
  Future<Either<Failure, String>> descadastrarUsuarioDaConta(
      {required int contaId, required int userId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String mutation = r'''
      mutation DescadastrarUsuarioDaConta($userId: Int!, $contaId: Int!) {
        descadastrarUsuarioDaConta(userId: $userId, contaId: $contaId) {
          status
          mensagem
          usuarioId
          contaId
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: <String, dynamic>{
        'userId': userId,
        'contaId': contaId,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        return Left(
          ErrorGerenciarEquipe(
              message: FailureMessage.errorDescadastrarUsuarioMessage),
        );
      }

      final response = result.data?['descadastrarUsuarioDaConta'];
      final status = response?['status'];

      if (status is! String || status.isEmpty) {
        return Left(
          ErrorGerenciarEquipe(
              message: FailureMessage.errorDescadastrarUsuarioMessage),
        );
      }

      return Right(status);
    } catch (_) {
      return Left(
        ErrorGerenciarEquipe(
            message: FailureMessage.errorDescadastrarUsuarioMessage),
      );
    }
  }
}
