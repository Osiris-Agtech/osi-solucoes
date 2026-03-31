// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart';

abstract class IRelatorioProdutividadeSetorDatasource {
  Future<Either<Failure, RelatorioProdutividadeResult>> buscarRelatorio({
    required int contaId,
    required RelatorioProdutividadeFiltros filtros,
  });
}

class RelatorioProdutividadeSetorDatasource
    implements IRelatorioProdutividadeSetorDatasource {
  @override
  Future<Either<Failure, RelatorioProdutividadeResult>> buscarRelatorio({
    required int contaId,
    required RelatorioProdutividadeFiltros filtros,
  }) async {
    final GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      query RelatorioProdutividadeSetor($contaId: Int!, $filtros: RelatorioProdutividadeFiltros) {
        relatorioProdutividadeSetor(contaId: $contaId, filtros: $filtros) {
          totalLotes
          taxaGlobalMedia
          periodoInicio
          periodoFim
          setores {
            setorId
            setorNome
            areaNome
            totalLotes
            totalBandejasSemeadas
            totalMudasTransplantadas
            totalPlantasColhidas
            totalEmbalagensProduzidas
            taxaGerminacao
            taxaTransplantio
            taxaEmbalagem
            taxaGlobal
            areas {
              areaId
              areaNome
              totalLotes
              totalBandejasSemeadas
              totalMudasTransplantadas
              totalPlantasColhidas
              totalEmbalagensProduzidas
              taxaGerminacao
              taxaTransplantio
              taxaEmbalagem
              taxaGlobal
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
      print('🔍 Buscando relatório de produtividade por setor para conta: $contaId');
      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        final data = result.data?['relatorioProdutividadeSetor'] as Map<String, dynamic>?;

        if (data != null) {
          print('✅ Dados do relatório de produtividade recebidos: ${data['totalLotes']} lotes');
          return Right(RelatorioProdutividadeResult.fromJson(data));
        } else {
          return Left(ErrorRelatorioProdutividade(message: 'Nenhum dado retornado pela API'));
        }
      } else {
        final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : result.exception?.linkException?.toString() ?? 'Erro desconhecido';

        print('❌ Erro GraphQL ao buscar relatório de produtividade: $errorMessage');
        return Left(ErrorRelatorioProdutividade(message: errorMessage));
      }
    } catch (e) {
      print('❌ Erro inesperado ao buscar relatório de produtividade: $e');
      return Left(ErrorRelatorioProdutividade(message: e.toString()));
    }
  }
}

class ErrorRelatorioProdutividade implements Failure {
  @override
  final String message;

  ErrorRelatorioProdutividade({required this.message});

  List<Object?> get props => [message];
}
