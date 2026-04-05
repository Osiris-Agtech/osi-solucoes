import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioStatusLotes/relatorioStatusLotes_model.dart';

abstract class IRelatorioStatusLotesDatasource {
  Future<Either<Failure, RelatorioStatusLotes>> buscarRelatorioStatusLotes({
    required int contaId,
  });
}

class RelatorioStatusLotesDatasource
    implements IRelatorioStatusLotesDatasource {
  @override
  Future<Either<Failure, RelatorioStatusLotes>> buscarRelatorioStatusLotes({
    required int contaId,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String relatorioStatusLotesQuery = r'''
      query RelatorioStatusLotes($contaId: Int!) {
        relatorioStatusLotes(contaId: $contaId) {
          statusData {
            color
            label
            value
            speciesDetails {
              name
              percentage
            }
          }
          subtitle
          title
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(relatorioStatusLotesQuery),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    try {
      final QueryResult result = await client.query(options);

      if (!result.hasException) {
        final Map<String, dynamic>? data = result.data?['relatorioStatusLotes'];

        if (data != null) {
          RelatorioStatusLotes relatorio = RelatorioStatusLotes.fromJson(data);
          return Right(relatorio);
        } else {
          return Left(ErrorRelatorioStatusLotes(
            message: FailureMessage.emptyListMessage,
          ));
        }
      } else {
        // Log dos erros GraphQL para debug
        String errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : result.exception?.linkException?.toString() ??
                'Erro desconhecido';

        return Left(ErrorRelatorioStatusLotes(
          message: 'Erro ao buscar relatório: $errorMessage',
        ));
      }
    } catch (e) {
      return Left(ErrorRelatorioStatusLotes(
        message: 'Erro inesperado ao buscar relatório: ${e.toString()}',
      ));
    }
  }
}

// Classe de erro específica para o RelatorioStatusLotes
class ErrorRelatorioStatusLotes implements Failure {
  @override
  final String message;

  ErrorRelatorioStatusLotes({required this.message});

  List<Object?> get props => [message];
}
