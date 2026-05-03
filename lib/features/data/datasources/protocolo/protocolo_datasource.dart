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
  Future<Either<Failure, List<Fase>>> buscarFases(
      {required int contaId, required int protocoloId});
  Future<Either<Failure, bool>> deletarProtocolo(int protocoloId);
  Future<Either<Failure, Fase>> registrarFase({required Fase fase});
  Future<Either<Failure, Protocolo>> atualizarProtocolo(
      {required Protocolo alterarProtocolo});
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo});
}

class ProtocoloDatasource implements IProtocoloDatasource {
  Map<String, dynamic> _buildStructuredPayload(Protocolo protocolo) {
    final faseById = <int, Fase>{};
    for (final acao in protocolo.acao ?? <Acao>[]) {
      final fase = acao.fase;
      if (fase?.id == null) {
        continue;
      }
      faseById[fase!.id!] = fase;
    }

    final fases = faseById.values.toList();
    final keyByFaseId = <int, String>{};
    for (var i = 0; i < fases.length; i++) {
      final id = fases[i].id!;
      keyByFaseId[id] = 'phase-$id-$i';
    }

    return {
      if (protocolo.id != null) 'id': protocolo.id,
      'nome': protocolo.nome,
      'descricao': protocolo.descricao,
      'contaId': protocolo.conta?.id,
      'culturaId': protocolo.cultura?.id,
      'tipo_cultura': protocolo.tipo_cultura,
      'sistema_cultivo': protocolo.sistema_cultivo,
      'implantacao': protocolo.implantacao,
      'fases': fases
          .map((fase) => {
                'key': keyByFaseId[fase.id!],
                'nome': fase.nome,
                'descricao': fase.descricao,
                'duracao_dias': fase.duracao_dias,
              })
          .toList(),
      'acoes': (protocolo.acao ?? <Acao>[])
          .map((acao) => {
                'titulo': acao.titulo,
                'descricao': acao.descricao,
                'alerta': acao.alerta ?? true,
                'duracao_dias': acao.duracao_dias,
                'duracao_dias_real': acao.duracao_dias_real,
                'phaseKey': keyByFaseId[acao.fase?.id ?? -1],
              })
          .toList(),
    };
  }

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
  Future<Either<Failure, List<Fase>>> buscarFases(
      {required int contaId, required int protocoloId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query FasesPorProtocolo($contaId: Int!, $protocoloId: Int!) {
        fasesPorProtocolo(contaId: $contaId, protocoloId: $protocoloId) {
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
        "protocoloId": protocoloId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        if (result.data?['fasesPorProtocolo'] == []) return const Right([]);

        List<Fase>? fases = (result.data?['fasesPorProtocolo'] as List?)
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
  Future<Either<Failure, bool>> deletarProtocolo(int protocoloId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SoftDeleteProtocoloCascade($protocoloId: Int!) {
        softDeleteProtocoloCascade(protocoloId: $protocoloId) {
          id
          deleted_at
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'protocoloId': protocoloId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        final response = result.data?['softDeleteProtocoloCascade'];
        if (response is bool) {
          return Right(response);
        }
        if (response is int) {
          return Right(response > 0);
        }
        if (response is Map<String, dynamic>) {
          final id = response['id'];
          return Right(id is int && id > 0);
        }
        return const Right(true);
      } catch (e) {
        return Left(
          ErrorProtocolo(message: FailureMessage.errorDeleteProtocolo),
        );
      }
    }

    return Left(
      ErrorProtocolo(message: FailureMessage.errorDeleteProtocolo),
    );
  }

  @override
  Future<Either<Failure, Fase>> registrarFase({required Fase fase}) async {
    return Left(InternalError(message: FailureMessage.errorCadastrarFase));
  }

  @override
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation CreateProtocoloEstruturado($input: String!) {
        createProtocoloEstruturado(input: $input) {
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

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'input': json.encode(_buildStructuredPayload(protocolo)),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Protocolo protocolo =
            Protocolo.fromJson(result.data?['createProtocoloEstruturado']);
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
        'input': json.encode(_buildStructuredPayload(alterarProtocolo)),
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
