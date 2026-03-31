// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';

abstract class IRelatorioDesempenhoEquipeDatasource {
  Future<Either<Failure, RelatorioDesempenhoResult>> buscarRelatorio({
    required int contaId,
    required RelatorioDesempenhoFiltros filtros,
  });
}

class RelatorioDesempenhoEquipeDatasource
    implements IRelatorioDesempenhoEquipeDatasource {
  @override
  Future<Either<Failure, RelatorioDesempenhoResult>> buscarRelatorio({
    required int contaId,
    required RelatorioDesempenhoFiltros filtros,
  }) async {
    final GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      query RelatorioDesempenhoEquipe($contaId: Int!, $filtros: RelatorioDesempenhoFiltros) {
        relatorioDesempenhoEquipe(contaId: $contaId, filtros: $filtros) {
          totalUsuarios
          taxaConclusaoMedia
          periodoInicio
          periodoFim
          usuarios {
            usuarioId
            usuarioNome
            totalAtividades
            totalAgendas
            agendasFinalizadas
            agendasNoPrazo
            taxaConclusao
            taxaPrazo
            ultimasAtividades {
              atividadeId
              atividadeNome
              loteId
              loteNome
            }
            agendasPendentes {
              agendaId
              titulo
              data
              finalizado
              vencida
            }
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
      print('🔍 Buscando relatório de desempenho da equipe para conta: $contaId');
      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        final data =
            result.data?['relatorioDesempenhoEquipe'] as Map<String, dynamic>?;

        if (data != null) {
          print(
              '✅ Dados do relatório de desempenho recebidos: ${data['totalUsuarios']} usuários');
          return Right(RelatorioDesempenhoResult.fromJson(data));
        } else {
          return Left(ErrorRelatorioDesempenho(
              message: 'Nenhum dado retornado pela API'));
        }
      } else {
        final errorMessage =
            result.exception?.graphqlErrors.isNotEmpty == true
                ? result.exception!.graphqlErrors.first.message
                : result.exception?.linkException?.toString() ??
                    'Erro desconhecido';

        print('❌ Erro GraphQL ao buscar relatório de desempenho: $errorMessage');
        return Left(ErrorRelatorioDesempenho(message: errorMessage));
      }
    } catch (e) {
      print('❌ Erro inesperado ao buscar relatório de desempenho: $e');
      return Left(ErrorRelatorioDesempenho(message: e.toString()));
    }
  }
}

class ErrorRelatorioDesempenho implements Failure {
  @override
  final String message;

  ErrorRelatorioDesempenho({required this.message});

  List<Object?> get props => [message];
}
