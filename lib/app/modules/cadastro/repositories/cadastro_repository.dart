import 'dart:collection';

import 'package:graphql/client.dart';
import 'package:osi_solucoes/app/models/resultadoCEP/resultadoCEP_model.dart';
import 'package:osi_solucoes/app/models/usuario/usuario_model.dart';
import 'package:http/http.dart' as http;

import 'cadastro_repository_interface.dart';

class CadastroRepository implements ICadastroRepository {
  final HttpLink _httpLink = HttpLink(
    "http://1f6f-2804-d59-425d-7e00-24d8-2d48-20fa-ad97.ngrok.io",
  );

  final _authLink = AuthLink(
    getToken: () async => 'Bearer \$YOUR_PERSONAL_ACCESS_TOKEN',
  );

  @override
  Future cadastraConta({
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
  }) async {
    Link _link = _authLink.concat(_httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

    const String readRepositories = r'''
      mutation CreateUserAccount($nome: String!, $sobrenome: String!, $nivelConta: String!, $email: String!, $senha: String!, $endereco: String, $bairro: String, $cidade: String, $telefone: String, $imagem: String, $cep: String, $estado: String, $pais: String, $complemento: String, $imagemConta: String, $cnpjConta: String) {
        createUserAccount(nome: $nome, sobrenome: $sobrenome, nivelConta: $nivelConta, email: $email, senha: $senha, endereco: $endereco, bairro: $bairro, cidade: $cidade, telefone: $telefone, imagem: $imagem, cep: $cep, estado: $estado, pais: $pais, complemento: $complemento, imagemConta: $imagemConta, cnpjConta: $cnpjConta) {
          email
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
              nome
              nivel
            }
            cargo {
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
        return usuario;
      } catch (e) {
        throw Exception("Erro ao cadastrar");
      }
    } else {
      throw Exception(result.exception);
    }
  }

  @override
  Future verificaUser(String email) async {
    Link _link = _authLink.concat(_httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

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
      List? usuarios = result.data?['usuarios']
          ?.map((item) => Usuario.fromJson(item))
          .toList();
      if (usuarios != null && usuarios.isNotEmpty) {
        throw Exception("Usuário já existe");
      }
      return "Usuário não existe";
    } else {
      throw Exception(result.exception);
    }
  }

  @override
  Future<ResultCep> buscarPorCEP(String cep) async {
    final response =
        await http.get(Uri.https('viacep.com.br', '/ws/$cep/json/'));
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }

  @override
  Future enviarEmail(String codigo, String email, String nome) async {
    Link _link = _authLink.concat(_httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

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
        throw Exception("Erro ao enviar");
      }
      return response;
    } else {
      throw Exception(result.exception);
    }
  }
}
