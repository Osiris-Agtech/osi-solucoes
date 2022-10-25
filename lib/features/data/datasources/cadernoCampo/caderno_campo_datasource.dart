// ignore_for_file: prefer_null_aware_operators

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ICadernoCampoDatasource {
  Future<Either<Failure, List<Lote>>> buscarLotesByConta(
      {required int contaId});
  Future<Either<Failure, List<Lote>>> buscarLotesBySetor(
      {required int setorId});
  Future<Either<Failure, List<Lote>>> buscarLotesByArea({required int areaId});
}

class CadernoCampoDatasource implements ICadernoCampoDatasource {
  @override
  Future<Either<Failure, List<Lote>>> buscarLotesByConta(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Lotes($contaId: Int!) {
          lotes(where: {
            setor: {
              area: {
                conta: {
                  id: {
                    equals: $contaId
                  }
                }
              }
            }
          }) {
            id
            nome
            setor {
              id
              nome
              area {
                id
                nome
                conta {
                  id
                  nome
                }
              }
            }
            cultura {
              id
              nome
            }
            reservatorio {
              id
              nome
            }
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
      List? lotes =
          result.data?['lotes']?.map((item) => Lote.fromJson(item)).toList();
      if (lotes == null || lotes.isEmpty) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }

      List<Lote> setorList = lotes.cast<Lote>();
      return Right(setorList);
    } else {
      return Left(InternalError(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesBySetor(
      {required int setorId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Lotes($setorId: Int!) {
          lotes(where: {
            setor: {
              id: {
                equals: $setorId
              }
            }
          }) {
            id
            nome
            setor {
              id
              nome
              area {
                id
                nome
                conta {
                  id
                  nome
                }
              }
            }
            cultura {
              id
              nome
            }
            reservatorio {
              id
              nome
            }
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'setorId': setorId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? lotes =
          result.data?['lotes']?.map((item) => Lote.fromJson(item)).toList();
      if (lotes == null || lotes.isEmpty) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }

      List<Lote> setorList = lotes.cast<Lote>();
      return Right(setorList);
    } else {
      return Left(InternalError(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesByArea(
      {required int areaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Lotes($areaId: Int!) {
          lotes(where: {
            setor: {
              area: {
                id: {
                  equals: $areaId
                }
              }
            }
          }) {
            id
            nome
            setor {
              id
              nome
              area {
                id
                nome
                conta {
                  id
                  nome
                }
              }
            }
            cultura {
              id
              nome
            }
            reservatorio {
              id
              nome
            }
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'areaId': areaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? lotes =
          result.data?['lotes']?.map((item) => Lote.fromJson(item)).toList();
      if (lotes == null || lotes.isEmpty) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }

      List<Lote> setorList = lotes.cast<Lote>();
      return Right(setorList);
    } else {
      return Left(InternalError(message: FailureMessage.emptyListMessage));
    }
  }
}
