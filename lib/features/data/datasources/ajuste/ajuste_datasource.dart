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
      {required Atividade atividade,
      required int usuarioId,
      required List<int> listLoteId});
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
            lotes {
              id
              nome
            }
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
      {required Atividade atividade,
      required int usuarioId,
      required List<int> listLoteId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();
    //Criando a query para varios lotes
    String query = '';
    for (var element in listLoteId) {
      if (element == listLoteId[listLoteId.length - 1]) {
        query += """{
          conta: {
            connect: {
              id: ${atividade.conta!.id}
            }
          },
          lote: {
            connect: {
              id: $element
            }
          },
          usuario: {
            connect: {
              id: $usuarioId
            }
          }
        }""";
      } else {
        query += """{
          conta: {
            connect: {
              id: ${atividade.conta!.id}
            }
          },
          lote: {
            connect: {
              id: $element
            }
          },
          usuario: {
            connect: {
              id: $usuarioId
            }
          }
        },""";
      }
    }

    // Erro esta no usuario - id 38
    String readRepositories = """
        mutation CreateOneAtividade{
          createOneAtividade(
            data: {
              nome: "${atividade.nome!}",
              descricao: "${atividade.descricao!}",
              conta: {
                connect: {
                  id: ${atividade.conta!.id}
                }
              },
              lotes_atividades: {
                create: [
                  $query
                ]
              },
              created_at: "${atividade.created_at}"
            }
          ) {
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
      """;
    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Atividade? atividadeResult =
          Atividade.fromJson(result.data?['createOneAtividade']);

      return Right(atividadeResult);
    } else {
      return Left(
          ErrorLote(message: FailureMessage.errorCadastrarAjusteMessage));
    }
  }
}
