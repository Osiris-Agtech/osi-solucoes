import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

import '../../../../core/errors/errors.dart';
import '../../../presenter/models/area/area_model.dart';

abstract class ILoteDatasource {
  Future<Either<Failure, List<Lote>>> buscarLotes({required int setorId});
  Future<Either<Failure, Lote>> buscarDetalhesLote({required int loteId});
  Future<Either<Failure, List<Cultura>>> buscarCulturas({required int contaId});
  Future<Either<Failure, List<Area>>> buscarAreasList({required int contaId});
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      {required int reservatorioId});
  Future<Either<Failure, Lote>> registrarLote({required Lote lote});
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

  @override
  Future<Either<Failure, List<Area>>> buscarAreasList(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Areas ($contaId: Int!){
        areas(where: {
          conta: {
            id: {
              equals: $contaId
            }
          }
        }) {
          id
          nome
          setores {
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
      List areaResult =
          result.data?['areas']?.map((item) => Area.fromJson(item)).toList();

      List<Area> areaList = areaResult.cast<Area>();
      return Right(areaList);
    } else {
      return Left(ErrorArea(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas(
      {required int contaId}) async {
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
      List? culturas = result.data?['culturas']
          ?.map((item) => Cultura.fromJson(item))
          .toList();
      if (culturas == null || culturas.isEmpty) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }

      List<Cultura> culturaList = culturas.cast<Cultura>();
      return Right(culturaList);
    } else {
      return Left(InternalError(message: FailureMessage.emptyListMessage));
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
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      {required int reservatorioId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Reservatorio($reservatorioId: Int) {
          reservatorio(
            where: {
              id: $reservatorioId
            },
          ) {
            id
            nome
            volume
            created_at
            lotes {
              id
              nome
              bandeijas_semeadas
              setor{
                id
                nome
              }
            }
            solucao {
              solucoes_fertilizantes_concentradas {
                id
                fertilizante {
                  nome
                }
                quantidade
                concentrada {
                  id
                  nome
                  fator_concentracao
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
        'reservatorioId': reservatorioId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      Reservatorio reservatorio =
          Reservatorio.fromJson(result.data?['reservatorio']);
      return Right(reservatorio);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, Lote>> registrarLote({required Lote lote}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneLote($nome: String!, $setorId: Int!, $culturaId: Int!, $reservatorioId: Int!, $registro: DateTime, $semeadura: DateTime, $transplantio: DateTime, $colheita: DateTime) {
          createOneLote(data: {
            nome: $nome,
            ativo: true,
            registro_data: $registro,
            semeadura_data: $semeadura,
            transplantio_data: $transplantio,
            colheita_data: $colheita,
            setor: {
              connect: {
                id: $setorId
              }
            },
            cultura: {
              connect: {
                id: $culturaId
              }
            },
            reservatorio: {
              connect: {
                id: $reservatorioId
              }
            }
          }) {
            id
            nome
            registro_data
            semeadura_data
            transplantio_data
            colheita_data
            ativo
            cultura {
              id
              nome
            }
            reservatorio {
              id
              nome
            }
            setor {
              id
              nome
              area {
                id
                nome
              }
            }
          }
        }
      ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "nome": lote.nome,
        "setorId": lote.setor!.id,
        "culturaId": lote.cultura!.id,
        "reservatorioId": lote.reservatorio!.id,
        "registro": lote.registro_data,
        "semeadura": lote.semeadura_data,
        "transplantio": lote.transplantio_data,
        "colheita": lote.colheita_data,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Lote? loteResult = Lote.fromJson(result.data?['createOneLote']);

      return Right(loteResult);
    } else {
      return Left(
          ErrorReservatorio(message: FailureMessage.errorNovoLoteMessage));
    }
  }
}
