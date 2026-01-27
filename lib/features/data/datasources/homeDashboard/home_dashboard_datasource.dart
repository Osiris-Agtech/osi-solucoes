import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';

abstract class IHomeDashboardDatasource {
  Future<Either<Failure, HomeDashboard>> buscarHomeDashboard({
    required int contaId,
  });
}

class HomeDashboardDatasource implements IHomeDashboardDatasource {
  @override
  Future<Either<Failure, HomeDashboard>> buscarHomeDashboard({
    required int contaId,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String homeDashboardQuery = r'''
      query HomeDashboard($contaId: Int!) {
        homeDashboard(contaId: $contaId) {
          resumo {
            totalLotes
            lotesAtivos
            lotesFinalizados
            taxaConclusao
          }
          tarefas {
            pendentesHoje
            pendentesSemana
            atrasadas
          }
          producao {
            totalPlantasColhidas
            totalEmbalagensProduzidas
            lotesComColheitaProxima
            periodoInicio
            periodoFim
          }
          culturas {
            nome
            quantidade
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(homeDashboardQuery),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    try {
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        return Left(ErrorHomeDashboard(
          message: 'Erro ao buscar dashboard: ${result.exception?.graphqlErrors.first.message ?? 'Erro desconhecido'}',
        ));
      }

      final data = result.data?['homeDashboard'];
      if (data == null) {
        return Left(ErrorHomeDashboard(message: 'Dados do dashboard vazios'));
      }

      final dashboard = HomeDashboard.fromJson(data);
      return Right(dashboard);
    } catch (e) {
      return Left(ErrorHomeDashboard(
        message: 'Erro inesperado: ${e.toString()}',
      ));
    }
  }
}

class ErrorHomeDashboard implements Failure {
  @override
  final String message;
  ErrorHomeDashboard({required this.message});
}
