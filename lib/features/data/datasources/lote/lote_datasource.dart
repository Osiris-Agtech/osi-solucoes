import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ILoteDatasource {
  Future<Either<Failure, List<Lote>>> buscarLotes({required int setorId});
  Future<Either<Failure, Lote>> buscarDetalhesLote({required int loteId});
}

class LoteDatasource implements ILoteDatasource {
  @override
  Future<Either<Failure, List<Lote>>> buscarLotes(
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
            cultura {
              id
              nome
            }
            registro_data
            colheita_data
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
  Future<Either<Failure, Lote>> buscarDetalhesLote(
      {required int loteId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Lote($loteId: Int!) {
          lote(where: {
            id: $loteId
          }) {
            id
            nome
            setor {
              id
              nome
              area {
                id
                nome
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
            ativo
            registro_data
            semeadura_data
            transplantio_data
            colheita_data
            bandeijas_semeadas
            mudas_transplantadas
            plantas_colhidas
            embalagens_produzidas
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'loteId': loteId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      Lote lote = Lote.fromJson(result.data?['lote']);
      return Right(lote);
    } else {
      return Left(InternalError(message: FailureMessage.internalErrorMessage));
    }
  }
}
