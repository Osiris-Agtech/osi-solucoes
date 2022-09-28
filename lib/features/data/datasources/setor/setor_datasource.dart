import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ISetorDatasource {
  Future<Either<Failure, List<Setor>>> buscarSetores({required int areaId});
  Future<Either<Failure, Setor>> cadastrarSetor({required Setor setor});
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
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

  @override
  Future<Either<Failure, Setor>> cadastrarSetor({required Setor setor}) async{
     GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      const String readRepositories = r'''
      mutation CreateOneSetor ($nome: String!, $descricao: String!, $reservatorioId: Int!, $areaId: Int!) {
        createOneSetor(data: {
          area: {
            connect: {
              id: $areaId
            }
          },
          nome: $nome,
          descricao: $descricao,
          reservatorio: {
            connect: {
              id: $reservatorioId
            }
          }
        }) {
          nome
          descricao
          area {
            id
            nome
          }
        }
      }
      ''';

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          'nome': setor.nome,
          'descricao': setor.descricao,
          'reservatorioId': setor.reservatorio!.id,
          'areaId': setor.area!.id,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Setor? setor = Setor.fromJson(result.data?['createOneSetor']);

        return Right(setor);
      } else {
        return Left(ErrorSetor(message: FailureMessage.errorNovoSetorMessage));
      }
    } catch (e) {
      return Left(ErrorSetor(message: FailureMessage.errorNovoSetorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Reservatorios($contaId: Int) {
          reservatorios(
            where: {
              fk_contas_id: {
                equals: $contaId
              }
            },
            orderBy: [
              {
                nome: desc
              }
            ],
          ) {
            id
            nome
            volume
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
      List? reservatorios = result.data?['reservatorios']
          ?.map((item) => Reservatorio.fromJson(item))
          .toList();
      if (reservatorios == null || reservatorios.isEmpty) {
        return Left(
            ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<Reservatorio> reservatoriosList = reservatorios.cast<Reservatorio>();
      return Right(reservatoriosList);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

}
