import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/errors.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/acao/acao_model.dart';

abstract class IProtocoloDatasource {
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId);
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId);
  Future<Either<Failure, List<Fase>>> buscarFases(int contaId);
  Future<Either<Failure, Fase>> registrarFase({required Fase fase});
  Future<Either<Failure, Protocolo>> atualizarProtocolo(
      {required Protocolo alterarProtocolo});
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo});
}

class ProtocoloDatasource implements IProtocoloDatasource {
  @override
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Protocolos($contaId: Int!) {
        protocolos(where: {
          conta: {
            id: {
              equals: $contaId
            }
          },
          deleted_at: {
            equals: null
          }
        }) {
          id
          nome
          cultura {
            id
            nome
          }
          lotes {
            id
            nome
            cultura {
              id
              nome
            }
          }
          sistema_cultivo
          tipo_cultura
          implantacao
          acoes {
            id
            titulo
            descricao
            alerta
            duracao_dias
            duracao_dias_real
            fase {
              id
              nome
              duracao_dias
            }
          }
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        if (result.data?['protocolos'] == []) return const Right([]);

        List<Protocolo>? protocolos = (result.data?['protocolos'] as List?)
            ?.map((item) => Protocolo.fromJson(item as Map<String, dynamic>))
            .toList();
        if (protocolos == null) {
          return Left(
              ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
        }
        return Right(protocolos);
      } catch (e) {
        return Left(
            ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
      }
    } else {
      return Left(
          ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
    }
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Culturas($contaId: Int!) {
        culturas(where: {
          OR: [
            {
              privado: {
                equals: false
              },
            },
            {
              conta: {
                id: {
                  equals: $contaId
                }
              }
            }
          ]
        }) {
          id
          nome
        }
      }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        List? culturas = result.data?['culturas']
            ?.map((item) => Cultura.fromJson(item))
            .toList();
        if (culturas == null) {
          return Left(
              InternalError(message: FailureMessage.errorBuscarCulturas));
        }

        List<Cultura> culturaList = culturas.cast<Cultura>();
        return Right(culturaList);
      } catch (e) {
        return Left(InternalError(message: FailureMessage.errorBuscarCulturas));
      }
    } else {
      return Left(InternalError(message: FailureMessage.errorBuscarCulturas));
    }
  }

  @override
  Future<Either<Failure, List<Fase>>> buscarFases(int contaId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Fases($contaId: Int!) {
        fases(where: {
          conta: {
            id: {
              equals: $contaId
            }
          },
          deleted_at: {
            equals: null
          }
        }) {
          id
          nome
          descricao
          duracao_dias
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        if (result.data?['fases'] == []) return const Right([]);

        List<Fase>? fases = (result.data?['fases'] as List?)
            ?.map((item) => Fase.fromJson(item as Map<String, dynamic>))
            .toList();
        if (fases == null) {
          return Left(ErrorProtocolo(message: FailureMessage.errorBuscarFases));
        }
        return Right(fases);
      } catch (e) {
        return Left(ErrorProtocolo(message: FailureMessage.errorBuscarFases));
      }
    } else {
      return Left(ErrorProtocolo(message: FailureMessage.errorBuscarFases));
    }
  }

  @override
  Future<Either<Failure, Fase>> registrarFase({required Fase fase}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation Mutation($nome: String!, $duracao_dias: Int!, $contaId: Int!) {
        createOneFase(data: {
          nome: $nome,
          duracao_dias: $duracao_dias,
          conta: {
            connect: {
              id: $contaId
            }
          }
        }) {
          id
          nome
          descricao
          duracao_dias
        }
      }
      ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'nome': fase.nome,
        'duracao_dias': fase.duracao_dias,
        'contaId': fase.conta!.id,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Fase fase = Fase.fromJson(result.data?['createOneFase']);
        return Right(fase);
      } catch (e) {
        return Left(InternalError(message: FailureMessage.errorCadastrarFase));
      }
    } else {
      return Left(InternalError(message: FailureMessage.errorCadastrarFase));
    }
  }

  @override
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String query = '';
    protocolo.acao = (protocolo.acao ?? []).reversed.toList();
    for (Acao element in protocolo.acao ?? []) {
      if (element ==
          (protocolo.acao ?? [])[(protocolo.acao ?? []).length - 1]) {
        query += """{
          titulo: "${element.titulo}",
          duracao_dias: ${element.duracao_dias},
          duracao_dias_real: ${element.duracao_dias_real},
          descricao: "${element.descricao ?? ''}",
          fase: {
            connect: {
              id: ${element.fase!.id}
            }
          },
          alerta: ${element.alerta ?? true},
        }""";
      } else {
        query += """{
          titulo: "${element.titulo}",
          duracao_dias: ${element.duracao_dias},
          duracao_dias_real: ${element.duracao_dias_real},
          descricao: "${element.descricao ?? ''}",
          fase: {
            connect: {
              id: ${element.fase!.id}
            }
          },
          alerta: ${element.alerta ?? true},
        },""";
      }
    }

    String cultura = '';
    if (protocolo.cultura != null) {
      cultura = """
        cultura: {
          connect: {
            id: ${protocolo.cultura!.id}
          }
        },""";
    }

    String descricao = '';
    if (protocolo.descricao != null) {
      descricao = """
        descricao: "${protocolo.descricao}", """;
    }

    String sistemaCultivo = '';
    if (protocolo.sistema_cultivo != null) {
      sistemaCultivo = """
        sistema_cultivo: "${protocolo.sistema_cultivo}", """;
    }

    String tipoCultura = '';
    if (protocolo.tipo_cultura != null) {
      tipoCultura = """
        tipo_cultura: "${protocolo.tipo_cultura}", """;
    }

    String implantacao = '';
    if (protocolo.implantacao != null) {
      implantacao = """
        implantacao: "${protocolo.implantacao}", """;
    }

    String readRepositories = """
      mutation CreateOneProtocolo {
        createOneProtocolo(data: {
          nome: "${protocolo.nome}",
          $descricao
          conta: {
            connect: {
              id: ${protocolo.conta!.id}
            }
          },
          $cultura
          $sistemaCultivo
          $tipoCultura
          $implantacao
          acoes: {
            create: [
              $query
            ]
          }
        }) {
          id
          nome
          cultura {
            id
            nome
          }
          lotes {
            id
            nome
            cultura {
              id
              nome
            }
          }
          sistema_cultivo
          tipo_cultura
          implantacao
          acoes {
            id
            titulo
            descricao
            alerta
            duracao_dias
            duracao_dias_real
            fase {
              id
              nome
              duracao_dias
            }
          }
        }
      }
      """;

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Protocolo protocolo =
            Protocolo.fromJson(result.data?['createOneProtocolo']);
        return Right(protocolo);
      } catch (e) {
        return Left(
            InternalError(message: FailureMessage.errorCadastrarProtocolo));
      }
    } else {
      return Left(
          InternalError(message: FailureMessage.errorCadastrarProtocolo));
    }
  }

  @override
  Future<Either<Failure, Protocolo>> atualizarProtocolo(
      {required Protocolo alterarProtocolo}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation UpdateProtocolo($input: String!) {
        updateProtocolo(input: $input) {
          id
          nome
        }
      }
      ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'input': json.encode(alterarProtocolo.toMap()),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Protocolo protocolo =
            Protocolo.fromJson(result.data?['updateProtocolo']);
        return Right(protocolo);
      } catch (e) {
        return Left(
            InternalError(message: FailureMessage.errorAtualizarProtocolo));
      }
    } else {
      return Left(
          InternalError(message: FailureMessage.errorAtualizarProtocolo));
    }
  }
}
