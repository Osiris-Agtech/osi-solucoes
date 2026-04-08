// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_agenda_tarefas/relatorio_agenda_tarefas_model.dart';

abstract class IRelatorioAgendaTarefasDatasource {
  Future<Either<Failure, RelatorioAgendaResult>> buscarRelatorio({
    required int contaId,
    required RelatorioAgendaFiltros filtros,
  });
}

class RelatorioAgendaTarefasDatasource
    implements IRelatorioAgendaTarefasDatasource {
  @override
  Future<Either<Failure, RelatorioAgendaResult>> buscarRelatorio({
    required int contaId,
    required RelatorioAgendaFiltros filtros,
  }) async {
    final GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      query RelatorioAgendaTarefas($contaId: Int!, $filtros: RelatorioAgendaFiltros) {
        relatorioAgendaTarefas(contaId: $contaId, filtros: $filtros) {
          diasAVencer
          geradoEm
          tarefasVencidas {
            id
            titulo
            descricao
            data
            alerta
            usuarioId
            usuarioNome
            loteId
            loteNome
            setorNome
          }
          tarefasAVencer {
            id
            titulo
            descricao
            data
            alerta
            usuarioId
            usuarioNome
            loteId
            loteNome
            setorNome
          }
          lotesComTaxaConclusao {
            loteId
            loteNome
            setorNome
            totalTarefas
            tarefasConcluidas
            tarefasVencidas
            taxaConclusao
          }
        }
      }
    ''';

    final variables = <String, dynamic>{
      'contaId': contaId,
      'filtros': filtros.toVariables(),
    };

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: variables,
    );

    try {
      print('🔍 Buscando relatório de agenda para conta: $contaId (${filtros.diasAVencer} dias à frente)');
      print('📤 Variáveis da query: $variables');
      final QueryResult result = await client.query(options);

      // Log completo do resultado para debug
      print('📥 Resultado GraphQL - hasException: ${result.hasException}');
      if (result.hasException) {
        print('❌ Exception GraphQL: ${result.exception}');
        print('❌ GraphQL Errors: ${result.exception?.graphqlErrors}');
        print('❌ Link Exception: ${result.exception?.linkException}');
      } else {
        print('✅ Dados brutos recebidos: ${result.data}');
      }

      if (!result.hasException) {
        final data = result.data?['relatorioAgendaTarefas'] as Map<String, dynamic>?;

        if (data != null) {
          final resultado = RelatorioAgendaResult.fromJson(data);
          print(
            '✅ Agenda: ${resultado.tarefasVencidas.length} vencidas, '
            '${resultado.tarefasAVencer.length} a vencer, '
            '${resultado.lotesComTaxaConclusao.length} lotes ativos',
          );
          return Right(resultado);
        } else {
          print('⚠️ Campo relatorioAgendaTarefas não encontrado ou nulo');
          return Left(ErrorRelatorioAgenda(message: 'Nenhum dado retornado pela API'));
        }
      } else {
        final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.map((e) => e.message).join('; ')
            : result.exception?.linkException?.toString() ?? 'Erro desconhecido';

        print('❌ Erro GraphQL ao buscar relatório de agenda: $errorMessage');
        return Left(ErrorRelatorioAgenda(message: errorMessage));
      }
    } catch (e, stackTrace) {
      print('❌ Erro inesperado ao buscar relatório de agenda: $e');
      print('📄 Stack trace: $stackTrace');
      return Left(ErrorRelatorioAgenda(message: e.toString()));
    }
  }
}

class ErrorRelatorioAgenda implements Failure {
  @override
  final String message;

  ErrorRelatorioAgenda({required this.message});

  List<Object?> get props => [message];
}
