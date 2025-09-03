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

      List<Usuario> usuarios = [];

      // Strategy 1: Tentar login por email primeiro
      if (email.isNotEmpty) {
        const String loginPorEmail = r'''
          query BuscarUsuarioPorEmail($email: String!) {
            usuarios(where: {
              email: $email
            }) {
              id
              nome
              email
              senha
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
        ''';

        final QueryOptions optionsEmail = QueryOptions(
          document: gql(loginPorEmail),
          variables: <String, dynamic>{
            'email': email,
          },
        );

        final QueryResult resultEmail = await client.query(optionsEmail);

        if (!resultEmail.hasException &&
            resultEmail.data?['usuarios'] != null) {
          List? usuariosPorEmail = resultEmail.data?['usuarios'] as List?;

          if (usuariosPorEmail != null && usuariosPorEmail.isNotEmpty) {
            // Validar senha manualmente no código
            for (var usuarioData in usuariosPorEmail) {
              Usuario usuario = Usuario.fromJson(usuarioData);

              // Verificar se a senha confere e se o usuário está ativo
              if (usuario.senha == password && (usuario.ativo ?? false)) {
                usuarios.add(usuario);
                break; // Encontrou o usuário correto
              }
            }
          }
        }
      }

      // Strategy 2: Se não encontrou por email, tentar por código de acesso
      if (usuarios.isEmpty && code.isNotEmpty) {
        const String loginPorCodigo = r'''
          query BuscarUsuarioPorCodigo($cod_acesso: String!) {
            usuarios(where: {
              cod_acesso: $cod_acesso
            }) {
              id
              nome
              email
              senha
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
        ''';

        final QueryOptions optionsCodigo = QueryOptions(
          document: gql(loginPorCodigo),
          variables: <String, dynamic>{
            'cod_acesso': code,
          },
        );

        final QueryResult resultCodigo = await client.query(optionsCodigo);

        if (!resultCodigo.hasException &&
            resultCodigo.data?['usuarios'] != null) {
          List? usuariosPorCodigo = resultCodigo.data?['usuarios'] as List?;

          if (usuariosPorCodigo != null && usuariosPorCodigo.isNotEmpty) {
            // Validar senha manualmente no código
            for (var usuarioData in usuariosPorCodigo) {
              Usuario usuario = Usuario.fromJson(usuarioData);

              // Verificar se a senha confere e se o usuário está ativo
              if (usuario.senha == password && (usuario.ativo ?? false)) {
                usuarios.add(usuario);
                break; // Encontrou o usuário correto
              }
            }
          }
        }
      }

      // Strategy 3: Se ainda não encontrou e temos email, usar a query específica
      if (usuarios.isEmpty && email.isNotEmpty) {
        const String usuarioPorEmailQuery = r'''
          query UsuarioPorEmail($email: String!) {
            usuarioPorEmail(email: $email) {
              id
              nome
              email
              senha
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
        ''';

        final QueryOptions optionsEspecifica = QueryOptions(
          document: gql(usuarioPorEmailQuery),
          variables: <String, dynamic>{
            'email': email,
          },
        );

        final QueryResult resultEspecifica =
            await client.query(optionsEspecifica);

        if (!resultEspecifica.hasException &&
            resultEspecifica.data?['usuarioPorEmail'] != null) {
          var usuarioData = resultEspecifica.data?['usuarioPorEmail'];

          if (usuarioData != null) {
            Usuario usuario = Usuario.fromJson(usuarioData);

            // Verificar se a senha confere e se o usuário está ativo
            if (usuario.senha == password && (usuario.ativo ?? false)) {
              usuarios.add(usuario);
            }
          }
        }
      }

      if (usuarios.isEmpty) {
        return Left(ErrorLogin(message: FailureMessage.userNotFoundMessage));
      }

      return Right(usuarios);
    } catch (e) {
      return Left(ErrorLogin(message: FailureMessage.errorLoginMessage));
    }
  }
}
