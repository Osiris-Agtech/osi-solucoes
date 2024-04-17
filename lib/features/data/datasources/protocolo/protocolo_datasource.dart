import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/errors.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

import '../../../../core/errors/failure.dart';

abstract class IProtocoloDatasource {
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId);
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId);
  Future<Either<Failure, Fase>> registrarFase({required Fase fase});
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
  Future<Either<Failure, Fase>> registrarFase({required Fase fase}) async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(Right(fase));
  }

  @override
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo}) async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(Right(protocolo));
  }
}
