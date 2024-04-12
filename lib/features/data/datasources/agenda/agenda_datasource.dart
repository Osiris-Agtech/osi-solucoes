import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

import '../../../../core/errors/errors.dart';
import '../../api_source.dart';

abstract class IAgendaDatasource {
  Future<Either<Failure, List<Agenda>>> buscarAtividades(int contaId);
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> deletarAtividade(int id);
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> marcarComoFeito(int id);
  Future<Either<Failure, List<Lote>>> buscarLotesConta(int contaId);
}

class AgendaDatasource implements IAgendaDatasource {
  @override
  Future<Either<Failure, List<Agenda>>> buscarAtividades(int contaId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Agendas($contaId: Int) {
        agendas(contaId: $contaId) {
          id
          titulo
          descricao
          data
          alerta
          finalizado
          lote {
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
          }
          usuario {
            id
            nome
            contas {
              conta {
                id
                nome
              }
              cargo {
                cargo
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
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      if (result.data?['agendas'] == []) return const Right([]);

      List<Agenda>? agendas = (result.data?['agendas'] as List?)
          ?.map((item) => Agenda.fromJson(item as Map<String, dynamic>))
          .toList();
      if (agendas == null) {
        return Left(ErrorAgenda(message: FailureMessage.errorBuscarAgendas));
      }
      return Right(agendas);
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorBuscarAgendas));
    }
  }

  @override
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();
    String queryLote = '';
    if (agenda.lote != null) {
      queryLote = """
        lote: {
          connect: {
            id: ${agenda.lote?.id}
          }
        },
      """;
    }

    String queryUsuario = '';
    if (agenda.usuario != null) {
      queryUsuario = """
        usuario: {
          connect: {
            id: ${agenda.usuario?.id}
          }
        },
      """;
    }

    String readRepositories = """
      mutation CreateOneAgenda {
        createOneAgenda(data: {
          data: "${agenda.data?.toIso8601String()}",
          descricao: "${agenda.descricao}",
          titulo: "${agenda.titulo}",
          $queryLote
          $queryUsuario
          conta: {
            connect: {
              id: ${agenda.conta?.id}
            }
          }
        }) {
          id
          titulo
          descricao
          data
          conta {
            id
            nome
          }
          lote {
            id
            nome
          }
          usuario {
            id
            nome
          }
        }
      }
    """;

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        try {
          Agenda? agenda = Agenda.fromJson(result.data?['createOneAgenda']);
          return Right(agenda);
        } catch (e) {
          return Left(ErrorAgenda(message: FailureMessage.errorCreateAgenda));
        }
      } else {
        return Left(ErrorAgenda(message: FailureMessage.errorCreateAgenda));
      }
    } catch (e) {
      return Left(ErrorAgenda(message: FailureMessage.errorCreateAgenda));
    }
  }

  @override
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation UpdateAgenda($agendaId: Int!, $titulo: String, $descricao: String, $data: DateTime, $usuarioId: Int) {
        updateAgenda(agendaId: $agendaId, titulo: $titulo, descricao: $descricao, data: $data, usuarioId: $usuarioId) {
          id
          titulo
          finalizado
          data
          descricao
          usuario {
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
        "agendaId": agenda.id,
        "titulo": agenda.titulo,
        "descricao": agenda.descricao,
        "data": agenda.data?.toIso8601String(),
        "usuarioId": agenda.usuario?.id,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Agenda? agenda = Agenda.fromJson(result.data?['updateAgenda']);
        return Right(agenda);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.errorEditAgenda));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorEditAgenda));
    }
  }

  @override
  Future<Either<Failure, Agenda>> deletarAtividade(int id) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SoftDeleteAgenda($agendaId: Int!) {
        softDeleteAgenda(agendaId: $agendaId) {
          id
          titulo
        }
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "agendaId": id,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Agenda? agenda = Agenda.fromJson(result.data?['softDeleteAgenda']);
        return Right(agenda);
      } catch (e) {
        return Left(ErrorAgenda(message: FailureMessage.errorDeleteAgenda));
      }
    } else {
      return Left(ErrorAgenda(message: FailureMessage.errorDeleteAgenda));
    }
  }

  @override
  Future<Either<Failure, Agenda>> marcarComoFeito(int id) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation MarkAsDone($agendaId: Int!) {
        markAsDone(agendaId: $agendaId) {
          id
          titulo
          finalizado
        }
      }
    ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "agendaId": id,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        Agenda? agenda = Agenda.fromJson(result.data?['markAsDone']);
        return Right(agenda);
      } catch (e) {
        return Left(
            ErrorAgenda(message: FailureMessage.errorAgendaMarcarComoFeito));
      }
    } else {
      return Left(
          ErrorAgenda(message: FailureMessage.errorAgendaMarcarComoFeito));
    }
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesConta(int contaId) async {
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
          }, 
          orderBy: [
            {
              setor: {
                nome: asc
              }
            }
          ]) {
            id
            nome
            registro_data
            colheita_data
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
      if (result.data?['lotes'] == []) return const Right([]);

      List<Lote>? lotes = (result.data?['lotes'] as List?)
          ?.map((item) => Lote.fromJson(item as Map<String, dynamic>))
          .toList();
      if (lotes == null) {
        return Left(InternalError(message: FailureMessage.emptyListMessage));
      }
      return Right(lotes);
    } else {
      return Left(InternalError(message: FailureMessage.emptyListMessage));
    }
  }
}

List<Agenda> atividadeList = [
  Agenda(
    id: 1,
    descricao: 'Descrição da Atividade 1',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 1)),
    titulo: 'Atividade 1',
    alerta: false,
    ativo: true,
    finalizado: false,
    conta: Conta(),
    lote: Lote(),
    usuario: Usuario(),
  ),
  Agenda(
    id: 2,
    descricao: 'Descrição da Atividade 2',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 2)),
    titulo: 'Atividade 2',
    alerta: false,
    ativo: true,
    finalizado: true,
    conta: Conta(),
    lote: Lote(),
    usuario: Usuario(),
  ),
  Agenda(
    id: 3,
    descricao: 'Descrição da Atividade 3',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 3)),
    titulo: 'Atividade 3',
    alerta: false,
    ativo: true,
    finalizado: false,
    conta: Conta(),
    lote: loteList[1],
    usuario: Usuario(),
  ),
];

List<Lote> loteList = [
  Lote(
    id: 1,
    nome: 'Lote 1',
    semeadura_data: DateTime.now(),
    setor: Setor(
      id: 1,
      nome: 'Setor 1',
    ),
  ),
  Lote(
    id: 3,
    nome: 'Lote 3',
    semeadura_data: DateTime.now(),
    setor: Setor(
      id: 3,
      nome: 'Setor 3',
    ),
  ),
  Lote(
    id: 2,
    nome: 'Lote 2',
    semeadura_data: DateTime.now(),
    setor: Setor(
      id: 2,
      nome: 'Setor 2',
    ),
  ),
];
