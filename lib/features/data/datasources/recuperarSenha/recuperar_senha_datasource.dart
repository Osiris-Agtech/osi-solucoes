import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:sigma_hort_gestao_producao/features/data/api_source.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/usuario/usuario_model.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/errors/failure.dart';

abstract class IRecuperarSenhaDatasource {
  Future<Either<Failure, Usuario>> buscarUsuario(String email);
  Future<Either<Failure, String>> enviarCodigo(String email, String codigo);
  Future<Either<Failure, Usuario>> alterarSenha(int userId, String senha);
}

class RecuperarSenhaDatasource implements IRecuperarSenhaDatasource {
  @override
  Future<Either<Failure, Usuario>> buscarUsuario(String email) async {
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
      Usuario? usuarioEncontrado;
      try {
        usuarioEncontrado = Usuario.fromJson(result.data?['usuarios'][0]);
      } catch (e) {
        usuarioEncontrado = null;
      }
      if (usuarioEncontrado != null) {
        return Right(usuarioEncontrado);
      } else {
        return Left(ErrorGerenciarEquipe(
            message: FailureMessage.errorUserEmailNotFound));
      }
    } else {
      return Left(
          ErrorGerenciarEquipe(message: FailureMessage.errorUserEmailNotFound));
    }
  }

  @override
  Future<Either<Failure, String>> enviarCodigo(
      String email, String codigo) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SendEmail($email: String!, $subject: String!, $html: String!) {
        sendEmail(email: $email, subject: $subject, html: $html)
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "email": email,
        "subject": "Código de Segurança",
        "html":
            "Olá, insira este código no aplicativo para validar sua recuperação de senha: $codigo",
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      var response = result.data?['sendEmail'];
      if (response == null) {
        return Left(
            ErrorRegister(message: FailureMessage.senEmailErrorMessage));
      }
      return Right(response);
    } else {
      return Left(ErrorRegister(message: FailureMessage.senEmailErrorMessage));
    }
  }

  @override
  Future<Either<Failure, Usuario>> alterarSenha(
      int userId, String senha) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      const String updateUsuario = r'''
        mutation UpdateUsuarioPassword($userId: Int!, $novaSenha: String!) {
          updateUsuarioPassword(userId: $userId, novaSenha: $novaSenha) {
            id
            email
            nome
            senha
          }
        }
      ''';

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(updateUsuario),
        variables: <String, dynamic>{
          "userId": userId,
          "novaSenha": senha,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Usuario? usuario =
            Usuario.fromJson(result.data?['updateUsuarioPassword']);

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
