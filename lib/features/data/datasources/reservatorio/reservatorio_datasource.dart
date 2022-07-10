import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/errors.dart';

abstract class IReservatorioDatasource {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      {required int contaId});
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      {required int solucaoId});
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
  Future<Either<Failure, Reservatorio>> registrarReservatorio(
      {required Reservatorio novoReservatorio});
}

class ReservatorioDatasource implements IReservatorioDatasource {
  @override
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query SNutritivas($contaId: Int) {
          sNutritivas(where: {
            solucoes_contas: {
              every: {
                fk_contas_id: {
                  equals: $contaId
                }
              }
            }
          }) {
            id
            c_eletrica
            nome
            reservatorios {
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
      List? solucoes = result.data?['sNutritivas']
          ?.map((item) => SolucaoNutritiva.fromJson(item))
          .toList();
      if (solucoes == null || solucoes.isEmpty) {
        return Left(
            ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<SolucaoNutritiva> solucoesList = solucoes.cast<SolucaoNutritiva>();
      return Right(solucoesList);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      {required int solucaoId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query SNutritiva($id: Int!) {
          sNutritiva(where: {
            id: $id
          }) {
            nome
            c_eletrica
            solucoes_contas {
              conta {
                nome
              }
            }
            solucoes_fertilizantes_concentradas {
              quantidade
              fertilizante {
                nome
                fertilizantes_nutrientes {
                  teor_nutriente
                  nutriente {
                    nome
                  }
                }
              }
            }
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'id': solucaoId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      SolucaoNutritiva? solucao =
          SolucaoNutritiva.fromJson(result.data?['sNutritiva']);

      return Right(solucao);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.errorInfoMessage));
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
                created_at: desc
              }
            ],
          ) {
            id
            nome
            volume
            lotes {
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
  Future<Either<Failure, Reservatorio>> registrarReservatorio(
      {required Reservatorio novoReservatorio}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneReservatorio($nome: String, $volume: Decimal, $contaId: Int, $solucaoId: Int) {
          createOneReservatorio(data: {
            nome: $nome,
            volume: $volume,
            conta: {
              connect: {
                id: $contaId
              }
            },
            solucao: {
              connect: {
                id: $solucaoId
              }
            }
          }) {
            id
            nome
            volume
            created_at
            conta {
              id
              nome
            }
            solucao {
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
        "nome": novoReservatorio.nome,
        "volume": novoReservatorio.volume,
        "contaId": novoReservatorio.conta!.id,
        "solucaoId": novoReservatorio.solucao!.id
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Reservatorio? reservatorio =
          Reservatorio.fromJson(result.data?['createOneReservatorio']);

      return Right(reservatorio);
    } else {
      return Left(ErrorReservatorio(
          message: FailureMessage.errorNovoReservatorioMessage));
    }
  }
}
