import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/errors.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/usuario/usuario_model.dart';
import '../../api_source.dart';

abstract class ICadastroConta {
  Future<Either<Failure, Usuario>> cadastraConta({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    String? endereco,
    String? bairro,
    String? cidade,
    required String telefone,
    String? imagem,
    String? cep,
    String? estado,
    String? pais,
    String? complemento,
    String? imagemConta,
    String? cnpjConta,
  });
  Future<Either<Failure, List<Usuario>>> verificaUser(String email);
  Future<Either<Failure, String>> enviarEmail(
      String codigo, String email, String nome);
}

class CadastroConta implements ICadastroConta {
  @override
  Future<Either<Failure, Usuario>> cadastraConta(
      {required String nome,
      required String sobrenome,
      required String email,
      required String senha,
      String? endereco,
      String? bairro,
      String? cidade,
      required String telefone,
      String? imagem,
      String? cep,
      String? estado,
      String? pais,
      String? complemento,
      String? imagemConta,
      String? cnpjConta}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation CreateUserAccount($nome: String!, $sobrenome: String!, $nivelConta: String!, $email: String!, $senha: String!, $endereco: String, $bairro: String, $cidade: String, $telefone: String, $imagem: String, $cep: String, $estado: String, $pais: String, $complemento: String, $imagemConta: String, $cnpjConta: String) {
        createUserAccount(nome: $nome, sobrenome: $sobrenome, nivelConta: $nivelConta, email: $email, senha: $senha, endereco: $endereco, bairro: $bairro, cidade: $cidade, telefone: $telefone, imagem: $imagem, cep: $cep, estado: $estado, pais: $pais, complemento: $complemento, imagemConta: $imagemConta, cnpjConta: $cnpjConta) {
          id
          nome
          email
          senha
          pessoa {
            nome
            sobrenome
            localizacao {
              endereco
              cidade
            }
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

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "nome": nome,
        "sobrenome": sobrenome,
        "endereco": endereco,
        "bairro": bairro,
        "cidade": cidade,
        "nivelConta": "1", // Conta nível 1 por padrão
        "telefone": telefone,
        "imagem": imagem,
        "cep": cep,
        "estado": estado,
        "pais": pais,
        "complemento": complemento,
        "imagemConta": imagemConta,
        "cnpjConta": cnpjConta,
        "email": email,
        "senha": senha,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Map<String, dynamic> map =
            HashMap.from(result.data?['createUserAccount']);
        Usuario? usuario = Usuario.fromJson(map);
        return Right(usuario);
      } catch (e) {
        return Left(
            ErrorRegister(message: FailureMessage.errorRegisterMessage));
      }
    } else {
      return Left(ErrorRegister(message: FailureMessage.errorRegisterMessage));
    }
  }

  @override
  Future<Either<Failure, List<Usuario>>> verificaUser(String email) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query BuscarConta($email: String!) {
        usuarios(where: {
          email: {
            equals: $email,
          },
          ativo: {
            equals: true,
          },
          acesso_externo: {
            equals: false,
          }
        }) {
          nome
          contas {
            conta {
              nome
            }
          }
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "email": email,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      if (result.data?['usuarios'] == []) return const Right([]);

      List<Usuario>? usuarios = (result.data?['usuarios'] as List?)
          ?.map((item) => Usuario.fromJson(item as Map<String, dynamic>))
          .toList();
      if (usuarios == null || usuarios.isEmpty) {
        return Left(ErrorRegister(message: FailureMessage.userNotFoundMessage));
      }
      return Right(usuarios);
    } else {
      return Left(ErrorRegister(message: FailureMessage.userNotFoundMessage));
    }
  }

  @override
  Future<Either<Failure, String>> enviarEmail(
      String codigo, String email, String nome) async {
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
            "Olá $nome, insira este código no aplicativo para validar seu e-mail: $codigo",
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
}
