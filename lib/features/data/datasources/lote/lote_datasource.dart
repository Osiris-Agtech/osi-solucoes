// ignore_for_file: prefer_null_aware_operators

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

import '../../../../core/errors/errors.dart';
import '../../../presenter/models/area/area_model.dart';

abstract class ILoteDatasource {
  Future<Either<Failure, List<Lote>>> buscarLotes({
    required int setorId,
    required String orderBy,
    required String order,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, Lote>> buscarDetalhesLote({required int loteId});
  Future<Either<Failure, List<Cultura>>> buscarCulturas({required int contaId});
  Future<Either<Failure, List<Area>>> buscarAreasList({required int contaId});
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      {required int reservatorioId});
  Future<Either<Failure, Lote>> registrarLote({
    required Lote lote,
    required int contaId,
  });
  Future<Either<Failure, Lote>> migrarLote(
      {required int loteId, required int setorId, required int reservatorioId});
  Future<Either<Failure, Lote>> alterarLote({required Lote alterarLote});
  Future<Either<Failure, Cultura>> registrarCultura(
      {required Cultura cultura, required int contaId});
  Future<Either<Failure, List<Agenda>>> verificarAtividades(
      {required List<int> lotesIds});
  Future<Either<Failure, bool>> deletarAtividades(
      {required List<int> agendaIds});
  Future<Either<Failure, bool>> finalizarAtividades(
      {required List<int> agendaIds});
  Future<Either<Failure, bool>> finalizarLotes({required List<Lote> lotes});
  Future<Either<Failure, List<Lote>>> buscarLotesFinalizados(
      {required List<int> setoresId});
  Future<Either<Failure, List<int>>> buscarTodosSetoresId(
      {required List<int> areasId});
  Future<Either<Failure, List<int>>> buscarTodasAreasId({required int contaId});
}

class LoteDatasource implements ILoteDatasource {
  @override
  Future<Either<Failure, List<Lote>>> buscarLotes({
    required int setorId,
    required String orderBy,
    required String order,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = '';
    Map<String, dynamic> variables = <String, dynamic>{
      'setorId': setorId,
      'order': order,
    };

    if (orderBy == 'Data') {
      variables['startDate'] = startDate?.toIso8601String();
      variables['endDate'] = endDate?.toIso8601String();

      readRepositories = r'''
        query Lotes($setorId: Int!, $order: SortOrder!, $startDate: DateTime, $endDate: DateTime) {
          lotes(where: {
            AND: [
              {
                setor: {
                  id: {
                    equals: $setorId
                  }
                }
              },
              {
                ativo: {
                  equals: true
                }
              },
              {
                registro_data: {
                  gte: $startDate
                  lte: $endDate
                }
              },
            ],
          }, orderBy: [
            {
              registro_data: $order,
            }
          ]) {
            id
            nome
            cultura {
              id
              nome
            }
            protocolo {
              id
              nome
            }
            registro_data
            colheita_data
            bandeijas_semeadas
          }
        }
      ''';
    } else {
      readRepositories = r'''
        query Lotes($setorId: Int!, $order: SortOrder!) {
          lotes(where: {
            AND: [
              {
                setor: {
                  id: {
                    equals: $setorId
                  }
                }
              },
              {
                ativo: {
                  equals: true
                }
              },
            ],
          }, orderBy: [
            {
              nome: $order,
            }
          ]) {
            id
            nome
            cultura {
              id
              nome
            }
            protocolo {
              id
              nome
            }
            registro_data
            colheita_data
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
              reservatorio {
                id
                nome
              }
            }
            cultura {
              id
              nome
            }
            protocolo {
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
            reservatorio {
              id
              nome
            }
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
              setor {
                id
                nome
                reservatorio {
                  id
                  nome
                }
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
  Future<Either<Failure, Lote>> registrarLote({
    required Lote lote,
    required int contaId,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneLote($nome: String!, $contaId: Int!, $setorId: Int!, $culturaId: Int!, $protocoloId: Int, $reservatorioId: Int, $registroData: DateTime!, $semeaduraData: DateTime, $transplantioData: DateTime, $colheitaData: DateTime) {
          createOneLote(
            nome: $nome,
            registroData: $registroData,
            semeaduraData: $semeaduraData,
            transplantioData: $transplantioData,
            colheitaData: $colheitaData,
            setorId: $setorId,
            culturaId: $culturaId,
            protocoloId: $protocoloId,
            reservatorioId: $reservatorioId,
            contaId: $contaId,
          ) {
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
              reservatorio {
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
        "contaId": contaId,
        "setorId": lote.setor!.id,
        "culturaId": lote.cultura!.id,
        "protocoloId": lote.protocolo?.id,
        "reservatorioId": lote.reservatorio?.id,
        "registroData": lote.registro_data != null
            ? lote.registro_data?.toIso8601String()
            : null,
        "semeaduraData": lote.semeadura_data != null
            ? lote.semeadura_data?.toIso8601String()
            : null,
        "transplantioData": lote.transplantio_data != null
            ? lote.transplantio_data?.toIso8601String()
            : null,
        "colheitaData": lote.colheita_data != null
            ? lote.colheita_data?.toIso8601String()
            : null,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Lote? loteResult = Lote.fromJson(result.data?['createOneLote']);

      return Right(loteResult);
    } else {
      return Left(ErrorLote(message: FailureMessage.errorNovoLoteMessage));
    }
  }

  @override
  Future<Either<Failure, Lote>> alterarLote({required Lote alterarLote}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      const String readRepositories = r'''
        mutation UpdateLote(
          $loteId: Int!, 
          $loteNome: String!, 
          $setorId: Int!, 
          $culturaId: Int!,
          $reservatorioId: Int, 
          $bandeijaSemeadas: Int, 
          $mudasTransplantadas: Int, 
          $plantasColhidas: Int, 
          $embalagensProduzidas: Int, 
          $registroData: DateTime!,
          $semeaduraData: DateTime, 
          $transplantioData: DateTime, 
          $colheitaData: DateTime
        ) {
          updateLote(
            loteId: $loteId, 
            loteNome: $loteNome, 
            setorId: $setorId, 
            culturaId: $culturaId, 
            reservatorioId: $reservatorioId, 
            bandeijaSemeadas: $bandeijaSemeadas, 
            mudasTransplantadas: $mudasTransplantadas, 
            plantasColhidas: $plantasColhidas, 
            embalagensProduzidas: $embalagensProduzidas,
            registroData: $registroData,
            semeaduraData: $semeaduraData,
            transplantioData: $transplantioData,
            colheitaData: $colheitaData
          ) {
            id
            nome
            cultura {
              id
              nome
            }
            reservatorio {
              id
              nome
            }
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

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          "loteId": alterarLote.id,
          "loteNome": alterarLote.nome,
          "setorId": alterarLote.setor!.id,
          "culturaId": alterarLote.cultura!.id,
          "reservatorioId": alterarLote.reservatorio?.id,
          "plantasColhidas": alterarLote.plantas_colhidas,
          "mudasTransplantadas": alterarLote.mudas_transplantadas,
          "bandeijaSemeadas": alterarLote.bandeijas_semeadas,
          "embalagensProduzidas": alterarLote.embalagens_produzidas,
          "registroData": alterarLote.registro_data?.toIso8601String(),
          "semeaduraData": alterarLote.semeadura_data?.toIso8601String(),
          "transplantioData": alterarLote.transplantio_data?.toIso8601String(),
          "colheitaData": alterarLote.colheita_data?.toIso8601String(),
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Lote? lote = Lote.fromJson(result.data?['updateLote']);

        return Right(lote);
      } else {
        return Left(
            ErrorSetor(message: FailureMessage.errorAlterarLoteMessage));
      }
    } catch (e) {
      return Left(ErrorSetor(message: FailureMessage.errorAlterarLoteMessage));
    }
  }

  @override
  Future<Either<Failure, Lote>> migrarLote(
      {required int loteId,
      required int setorId,
      required int reservatorioId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation MigrarLote($loteId: Int!, $setorId: Int!, $novoReservatorioId: Int!) {
          migrarLote(loteId: $loteId, setorId: $setorId, novoReservatorioId: $novoReservatorioId) {
            id
            nome
            setor {
              id
              nome
              reservatorio {
                id
                nome
              }
            }
            reservatorio {
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
        "loteId": loteId,
        "setorId": setorId,
        "novoReservatorioId": reservatorioId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Lote? loteResult = Lote.fromJson(result.data?['migrarLote']);

      return Right(loteResult);
    } else {
      return Left(ErrorLote(message: FailureMessage.errorMigrarLoteMessage));
    }
  }

  @override
  Future<Either<Failure, Cultura>> registrarCultura(
      {required Cultura cultura, required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneCultura($nome: String!, $contaId: Int!) {
          createOneCultura(data: {
            nome: $nome,
            privado: true,
            conta: {
              connect: {
                id: $contaId
              }
            }
          }) {
            id
            nome
            privado
            created_at
            conta {
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
        "nome": cultura.nome,
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Cultura? culturaResult =
          Cultura.fromJson(result.data?['createOneCultura']);

      return Right(culturaResult);
    } else {
      return Left(
          ErrorLote(message: FailureMessage.errorCadastrarCulturaMessage));
    }
  }

  @override
  Future<Either<Failure, List<Agenda>>> verificarAtividades(
      {required List<int> lotesIds}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query AgendasByLoteId($lotesId: [Int!]) {
          agendasAbertasPorLoteId(lotesId: $lotesId) {
            id
            titulo
            descricao
            ativo
            alerta
            finalizado
            data
            usuario {
              id
              nome
            }
            lote {
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
        'lotesId': lotesIds,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      if (result.data?['agendasAbertasPorLoteId'] == []) return const Right([]);

      List<Agenda>? agendas = (result.data?['agendasAbertasPorLoteId'] as List?)
          ?.map((item) => Agenda.fromJson(item as Map<String, dynamic>))
          .toList();
      if (agendas == null) {
        return Left(
            ErrorAgenda(message: FailureMessage.errorBuscarAgendasEmAberto));
      }
      return Right(agendas);
    } else {
      return Left(
          ErrorAgenda(message: FailureMessage.errorBuscarAgendasEmAberto));
    }
  }

  @override
  Future<Either<Failure, bool>> deletarAtividades(
      {required List<int> agendaIds}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SoftDeleteAgendaList($agendasId: [Int!]) {
        softDeleteAgendaList(agendasId: $agendasId)
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "agendasId": agendaIds,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        int? agendaCount = result.data?['softDeleteAgendaList'];
        return Right(agendaCount == agendaIds.length);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.errorFinalizacaoLote));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorFinalizacaoLote));
    }
  }

  @override
  Future<Either<Failure, bool>> finalizarAtividades(
      {required List<int> agendaIds}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation FinalizarAgendas($agendasId: [Int!]) {
        finalizarAgendas(agendasId: $agendasId)
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "agendasId": agendaIds,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        int? agendaCount = result.data?['finalizarAgendas'];
        return Right(agendaCount == agendaIds.length);
      } catch (e) {
        return Left(
            ErrorAgenda(message: FailureMessage.errorFinalizacaoAgenda));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorFinalizacaoAgenda));
    }
  }

  @override
  Future<Either<Failure, bool>> finalizarLotes(
      {required List<Lote> lotes}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation FinalizarLotes($lotesId: [Int!], $plantasColhidas: [Int!], $embalagensProduzidas: [Int!]) {
        finalizarLotes(lotesId: $lotesId, plantasColhidas: $plantasColhidas, embalagensProduzidas: $embalagensProduzidas)
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "lotesId": lotes.map((e) => e.id).toList(),
        "plantasColhidas": lotes.map((e) => e.plantas_colhidas).toList(),
        "embalagensProduzidas":
            lotes.map((e) => e.embalagens_produzidas).toList(),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        int? agendaCount = result.data?['finalizarLotes'];
        return Right(agendaCount == lotes.length);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.errorFinalizacaoLote));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorFinalizacaoLote));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesFinalizados(
      {required List<int> setoresId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = r'''
        query Lotes($setorId: [Int!]) {
          lotes(where: {
            AND: [
              {
                setor: {
                  id: {
                    in: $setorId
                  }
                }
              },
              {
                ativo: {
                  equals: false
                }
              },
            ],
          }, orderBy: [
            {
              colheita_data: asc,
            }
          ]) {
            id
            nome
            cultura {
              id
              nome
            }
            registro_data
            colheita_data
            bandeijas_semeadas
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'setorId': setoresId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? lotes =
          result.data?['lotes']?.map((item) => Lote.fromJson(item)).toList();
      if (lotes == null || lotes.isEmpty) {
        return const Right([]);
      }

      List<Lote> loteList = lotes.cast<Lote>();
      return Right(loteList);
    } else {
      return Left(InternalError(message: FailureMessage.internalErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<int>>> buscarTodosSetoresId(
      {required List<int> areasId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Setors($areasId: [Int!]) {
        setors(where: {
          area: {
            id: {
              in: $areasId
            }
          }
        }) {
          id
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "areasId": areasId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        List<Map>? setorList = (result.data?['setors'] as List?)
            ?.whereType<Map>()
            .map((item) => item)
            .toList();
        List<int>? setoresId = setorList?.map((e) => e['id'] as int).toList();
        return Right(setoresId ?? []);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.internalErrorMessage));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.internalErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<int>>> buscarTodasAreasId(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Areas($contaId: Int!) {
        areas(where: {
          conta: {
            id: {
              equals: $contaId
            }
          }
        }) {
          id
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
        List<Map>? areaList = (result.data?['areas'] as List?)
            ?.whereType<Map>()
            .map((item) => item)
            .toList();
        List<int>? areasId = areaList?.map((e) => e['id'] as int).toList();
        return Right(areasId ?? []);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.internalErrorMessage));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.internalErrorMessage));
    }
  }
}
