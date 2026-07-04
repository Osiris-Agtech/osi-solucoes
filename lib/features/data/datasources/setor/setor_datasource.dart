import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ISetorDatasource {
  Future<Either<Failure, List<Setor>>> buscarSetores({
    required int areaId,
    required String orderBy,
    required String order,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, Setor>> cadastrarSetor({required Setor setor});
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
  Future<Either<Failure, Setor>> alterarSetor({required Setor alterarSetor});
  Future<Either<Failure, bool>> deletarSetorCascade({required int setorId});
}

class SetorDatasource implements ISetorDatasource {
  @override
  Future<Either<Failure, List<Setor>>> buscarSetores({
    required int areaId,
    required String orderBy,
    required String order,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = '';
    Map<String, dynamic> variables = <String, dynamic>{
      'areaId': areaId,
      'order': order,
    };

    if (orderBy == 'Data') {
      variables['startDate'] = startDate?.toIso8601String();
      variables['endDate'] = endDate?.toIso8601String();

      readRepositories = r'''
        query Setors($areaId: Int, $order: SortOrder!, $startDate: DateTime, $endDate: DateTime) {
          setors(where: {
            area: {
              id: {
                equals: $areaId
              }
            },
            created_at: {
              gt: $startDate,
              lte: $endDate
            }
          }, orderBy: [
            {
              created_at: $order,
            }
          ]) {
            id
            nome
            descricao
            area {
              id
              nome
            }
            reservatorio {
              id
              nome
              volume
            }
            lotes {
              id
              nome
              ativo
            }
          }
        }
      ''';
    } else {
      readRepositories = r'''
        query Setors($areaId: Int, $order: SortOrder!) {
          setors(where: {
            area: {
              id: {
                equals: $areaId
              }
            }
          }, orderBy: [
            {
              nome: $order,
            }
          ]) {
            id
            nome
            descricao
            area {
              id
              nome
            }
            reservatorio {
              id
              nome
              volume
            }
            lotes {
              id
              nome
              ativo
            }
          }
        }
      ''';
    }

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: variables,
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
  Future<Either<Failure, Setor>> cadastrarSetor({required Setor setor}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      String readRepositories;
      if (setor.reservatorio?.id != null) {
        readRepositories = r'''
          mutation CreateOneSetor ($nome: String!, $descricao: String!, $reservatorioId: Int, $areaId: Int!) {
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
              id
              nome
              descricao
              area {
                id
                nome
              }
              reservatorio {
                id
                nome
                volume
              }
              lotes {
                id
                nome
              }
            }
          }
          ''';
      } else {
        readRepositories = r'''
          mutation CreateOneSetor ($nome: String!, $descricao: String!, $areaId: Int!) {
            createOneSetor(data: {
              area: {
                connect: {
                  id: $areaId
                }
              },
              nome: $nome,
              descricao: $descricao,
            }) {
              id
              nome
              descricao
              area {
                id
                nome
              }
              reservatorio {
                id
                nome
                volume
              }
              lotes {
                id
                nome
              }
            }
          }
          ''';
      }

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: setor.reservatorio?.id != null
            ? <String, dynamic>{
                'nome': setor.nome,
                'descricao': setor.descricao,
                'reservatorioId': setor.reservatorio?.id,
                'areaId': setor.area!.id,
              }
            : <String, dynamic>{
                'nome': setor.nome,
                'descricao': setor.descricao,
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
  Future<Either<Failure, Setor>> alterarSetor(
      {required Setor alterarSetor}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      String readRepositories;

      if (alterarSetor.reservatorio?.id != null) {
        readRepositories = r'''
          mutation UpdateSetor($setorId: Int!, $setorNome: String!, $setorDescricao: String!, $areaId: Int!, $reservatorioId: Int) {
            updateSetor(setorId: $setorId, setorNome: $setorNome, setorDescricao: $setorDescricao, areaId: $areaId, reservatorioId: $reservatorioId) {
              id
              nome
              descricao
              area {
                id
                nome
              }
              reservatorio {
                id
                nome
                volume
              }
            }
          }
        ''';
      } else {
        readRepositories = r'''
          mutation UpdateSetor($setorId: Int!, $setorNome: String!, $setorDescricao: String!, $areaId: Int!) {
            updateSetor(setorId: $setorId, setorNome: $setorNome, setorDescricao: $setorDescricao, areaId: $areaId) {
              id
              nome
              descricao
              area {
                id
                nome
              }
              reservatorio {
                id
                nome
                volume
              }
            }
          }
        ''';
      }

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: alterarSetor.reservatorio?.id != null
            ? <String, dynamic>{
                "setorId": alterarSetor.id,
                "setorNome": alterarSetor.nome,
                "setorDescricao": alterarSetor.descricao,
                "reservatorioId": alterarSetor.reservatorio!.id,
                "areaId": alterarSetor.area!.id,
              }
            : <String, dynamic>{
                "setorId": alterarSetor.id,
                "setorNome": alterarSetor.nome,
                "setorDescricao": alterarSetor.descricao,
                "areaId": alterarSetor.area!.id,
              },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Setor? setor = Setor.fromJson(result.data?['updateSetor']);

        return Right(setor);
      } else {
        return Left(
            ErrorSetor(message: FailureMessage.errorAlterarSetorMessage));
      }
    } catch (e) {
      return Left(ErrorSetor(message: FailureMessage.errorAlterarAreaMessage));
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

  @override
  Future<Either<Failure, bool>> deletarSetorCascade(
      {required int setorId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SoftDeleteSetorCascade($setorId: Int!) {
        softDeleteSetorCascade(setorId: $setorId) {
          id
          deleted_at
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'setorId': setorId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        final response = result.data?['softDeleteSetorCascade'];
        if (response is bool) return Right(response);
        if (response is Map<String, dynamic>) {
          final id = response['id'];
          return Right(id is int && id > 0);
        }
        return const Right(true);
      } catch (e) {
        return Left(ErrorSetor(message: FailureMessage.errorDeleteSetor));
      }
    }

    return Left(ErrorSetor(message: FailureMessage.errorDeleteSetor));
  }
}
