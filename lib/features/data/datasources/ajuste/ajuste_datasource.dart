import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/errors.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import '../../../presenter/models/atividade/atividade_model.dart';

abstract class IAjusteDatasource {
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      {required int contaId});
  Future<Either<Failure, Atividade>> salvarAjuste(
      {required Atividade atividade, required int usuarioId});
}

class AjusteDatasource implements IAjusteDatasource {
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
            solucao {
              id
              c_eletrica
              nome
              solucoes_fertilizantes_concentradas {
                id
                quantidade
                fertilizante {
                  id
                  nome
                  c_eletrica
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
  Future<Either<Failure, Atividade>> salvarAjuste(
      {required Atividade atividade, required int usuarioId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneAtividade($nome: String!, $descricao: String!, $contaId: Int!, $loteId: Int!, $usuarioId: Int!, $created_at: Datetime){
          createOneAtividade(
            nome: $nome,
            descricao: $descricao,
            conta: {
              connect: {
                id: $contaId
              }
            },
            lotes_atividades: {
              create: [
                {
                  conta: {
                    connect: {
                      id: $contaId
                    }
                  },
                  lote: {
                    connect: {
                      id: $loteId
                    }
                  },
                  usuario: {
                    connect: {
                      id: $usuarioId
                    }
                  }
                }
              ]
            },
            created_at: $created_at
          }) {
            id
            nome
            descricao
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
        "nome": atividade.nome,
        "descricao": atividade.descricao!,
        "contaId": atividade.conta!.id,
        "usuarioId":
            usuarioId, // passar por parametro - pegar no store com o getit do AuthController
        "created_at": atividade.created_at
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Atividade? atividadeResult =
          Atividade.fromJson(result.data?['CreateOneAtividade']);

      return Right(atividadeResult);
    } else {
      return Left(
          ErrorLote(message: FailureMessage.errorCadastrarAjusteMessage));
    }
  }
}
