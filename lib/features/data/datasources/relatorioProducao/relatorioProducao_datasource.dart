import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioProducao/relatorioProducao_model.dart';

abstract class IRelatorioProducaoDatasource {
  Future<Either<Failure, RelatorioProducao>> buscarRelatorioProducao({
    required int contaId,
  });
}

class RelatorioProducaoDatasource implements IRelatorioProducaoDatasource {
  @override
  Future<Either<Failure, RelatorioProducao>> buscarRelatorioProducao({
    required int contaId,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String relatorioProducaoQuery = r'''
      query RelatorioProducao($contaId: Int!) {
        relatorioProducao(contaId: $contaId) {
          cultureData {
            color
            name
            value
          }
          monthlyData
          months
          subtitle
          title
          totalUnit
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(relatorioProducaoQuery),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    try {
      print('🔍 Buscando relatório de produção para conta: $contaId');

      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        final Map<String, dynamic>? data = result.data?['relatorioProducao'];

        if (data != null) {
          print('✅ Dados do relatório de produção recebidos: $data');

          RelatorioProducao relatorio = RelatorioProducao.fromJson(data);

          print('✅ Relatório de produção convertido com sucesso');
          print('📊 Título: ${relatorio.title}');
          print('📊 Meses: ${relatorio.months?.length}');
          print('📊 Dados mensais: ${relatorio.monthlyData?.length}');
          print('📊 Culturas: ${relatorio.cultureData?.length}');

          return Right(relatorio);
        } else {
          print('❌ Dados do relatório de produção estão vazios');
          return Left(ErrorRelatorioProducao(
            message: FailureMessage.emptyListMessage,
          ));
        }
      } else {
        // Log dos erros GraphQL para debug
        String errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : result.exception?.linkException?.toString() ??
                'Erro desconhecido';

        print('❌ Erro GraphQL ao buscar relatório de produção: $errorMessage');

        return Left(ErrorRelatorioProducao(
          message: 'Erro ao buscar relatório de produção: $errorMessage',
        ));
      }
    } catch (e) {
      print('❌ Erro inesperado ao buscar relatório de produção: $e');

      return Left(ErrorRelatorioProducao(
        message:
            'Erro inesperado ao buscar relatório de produção: ${e.toString()}',
      ));
    }
  }
}

// Classe de erro específica para o RelatorioProducao
class ErrorRelatorioProducao implements Failure {
  @override
  final String message;

  ErrorRelatorioProducao({required this.message});

  @override
  List<Object?> get props => [message];
}
