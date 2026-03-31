// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';

abstract class IRelatorioCicloCulturaDatasource {
  Future<Either<Failure, RelatorioCicloResult>> buscarRelatorio({
    required int contaId,
    required RelatorioCicloFiltros filtros,
  });
}

class RelatorioCicloCulturaDatasource implements IRelatorioCicloCulturaDatasource {
  @override
  Future<Either<Failure, RelatorioCicloResult>> buscarRelatorio({
    required int contaId,
    required RelatorioCicloFiltros filtros,
  }) async {
    final GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      query RelatorioCircoCultura($contaId: Int!, $filtros: RelatorioCicloFiltros) {
        relatorioCircoCultura(contaId: $contaId, filtros: $filtros) {
          totalLotes
          desvioMedioGeral
          periodoInicio
          periodoFim
          culturas {
            culturaId
            culturaNome
            totalLotes
            duracaoRealMedia
            duracaoPlanejadaMedia
            desvioMedioDias
            desvioMedioPercentual
            desvioMaxDias
            desvioMinDias
            lotes {
              loteId
              loteNome
              semeaduraData
              transplantioData
              colheitaData
              duracaoRealDias
              duracaoPlanejadaDias
              desvioDias
              desvioPercentual
              setorNome
              areaNome
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
      print('🔍 Buscando relatório de ciclo por cultura para conta: $contaId');
      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        final data = result.data?['relatorioCircoCultura'] as Map<String, dynamic>?;

        if (data != null) {
          print('✅ Dados do relatório de ciclo recebidos: ${data['totalLotes']} lotes');
          return Right(RelatorioCicloResult.fromJson(data));
        } else {
          return Left(ErrorRelatorioCiclo(message: 'Nenhum dado retornado pela API'));
        }
      } else {
        final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : result.exception?.linkException?.toString() ?? 'Erro desconhecido';

        print('❌ Erro GraphQL ao buscar relatório de ciclo: $errorMessage');
        return Left(ErrorRelatorioCiclo(message: errorMessage));
      }
    } catch (e) {
      print('❌ Erro inesperado ao buscar relatório de ciclo: $e');
      return Left(ErrorRelatorioCiclo(message: e.toString()));
    }
  }
}

class ErrorRelatorioCiclo implements Failure {
  @override
  final String message;

  ErrorRelatorioCiclo({required this.message});

  List<Object?> get props => [message];
}
