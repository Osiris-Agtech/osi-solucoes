import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ISetorDatasource {
  Future<Either<Failure, List<Setor>>> buscarSetores({required int areaId});
}

class SetorDatasource implements ISetorDatasource {
  @override
  Future<Either<Failure, List<Setor>>> buscarSetores(
      {required int areaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Setors($areaId: Int) {
          setors(where: {
          area: {
              id: {
                equals: $areaId
              }
            }
          }) {
            id
            nome
            lotes {
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
      List? setores =
          result.data?['setors']?.map((item) => Setor.fromJson(item)).toList();
      if (setores == null || setores.isEmpty) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }

      List<Setor> setorList = setores.cast<Setor>();
      return Right(setorList);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }
}
