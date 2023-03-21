import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ISolucaoDatasource {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      {required int contaId});
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva(
      {required SolucaoNutritiva solucao, required int contaId});
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes();
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      {required int solucaoId});
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada});
}

class SolucaoDatasource implements ISolucaoDatasource {
  @override
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query SNutritivas($contaId: Int) {
          sNutritivas(where: {
            solucoes_contas: {
              every: {
                fk_contas_id: {
                  equals: $contaId
                }
              }
            }
          }) {
            id
            c_eletrica
            nome
            reservatorios {
              id
              nome
              lotes {
                id
                ativo
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
      List? solucoes = result.data?['sNutritivas']
          ?.map((item) => SolucaoNutritiva.fromJson(item))
          .toList();
      if (solucoes == null || solucoes.isEmpty) {
        return Left(
            ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<SolucaoNutritiva> solucoesList = solucoes.cast<SolucaoNutritiva>();
      return Right(solucoesList);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva(
      {required SolucaoNutritiva solucao, required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    /// MODIFICAR ESSA LÓGICA PARA EXECUTAR APENAS QUANDO NÃO TEM CONCENTRADA
    /// CASO TENHA, ADICIONAR O ID DELA NA LISTA

    //Criando a query para varios lotes
    String query = '';
    for (SolucaoFertilizanteConcentrada element
        in solucao.solucoes_fertilizantes_concentradas ?? []) {
      if (element ==
          solucao.solucoes_fertilizantes_concentradas![
              solucao.solucoes_fertilizantes_concentradas!.length - 1]) {
        query += """{
          fk_fertilizantes_id: ${element.fertilizante!.id},
          quantidade: ${element.quantidade}
        }""";
      } else {
        query += """{
          fk_fertilizantes_id: ${element.fertilizante!.id},
          quantidade: ${element.quantidade}
        },""";
      }
    }

    String readRepositories = """
        mutation CreateOneSNutritiva {
          createOneSNutritiva(data: {
            nome: "${solucao.nome}",
            c_eletrica: ${solucao.c_eletrica},
            solucoes_contas: {
              create: [
                {
                  conta_original: $contaId,
                  conta: {
                    connect: {
                      id: $contaId
                    }
                  }
                }
              ]
            },
            solucoes_fertilizantes_concentradas: {
              createMany: {
                data: [
                  $query
                ]
              }
            }
          }) {
            id
            nome
            c_eletrica
            solucoes_fertilizantes_concentradas {
              id
              quantidade
              fertilizante {
                nome
              }
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
      SolucaoNutritiva novaSolucao =
          SolucaoNutritiva.fromJson(result.data?['createOneSNutritiva']);
      return Right(novaSolucao);
    } else {
      return Left(
          ErrorReservatorio(message: FailureMessage.internalErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes() async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Fertilizantes{
          fertilizantes {
            id
            nome
            c_eletrica
            fertilizantes_nutrientes {
              id
              teor_nutriente
              nutriente {
                id
                nome
                sigla
              }
            }
          }
        }
      ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: const <String, dynamic>{},
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? fertilizantes = result.data?['fertilizantes']
          ?.map((item) => Fertilizante.fromJson(item))
          .toList();
      if (fertilizantes == null || fertilizantes.isEmpty) {
        return Left(
            ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<Fertilizante> fertilizanteList = fertilizantes.cast<Fertilizante>();
      return Right(fertilizanteList);
    } else {
      return Left(ErrorFertilizante(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      {required int solucaoId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query SNutritiva($id: Int!) {
          sNutritiva(where: {
            id: $id
          }) {
            nome
            c_eletrica
            solucoes_contas {
              conta {
                nome
              }
            }
            solucoes_fertilizantes_concentradas {
              quantidade
              fertilizante {
                nome
                fertilizantes_nutrientes {
                  teor_nutriente
                  nutriente {
                    id
                    nome
                    sigla
                  }
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
        'id': solucaoId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      SolucaoNutritiva? solucao =
          SolucaoNutritiva.fromJson(result.data?['sNutritiva']);

      return Right(solucao);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.errorInfoMessage));
    }
  }

  @override
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = """
        mutation CreateOneConcentrada {
          createOneConcentrada(data: {
            nome: "${novaSolucaoConcentrada.nome}",
            fator_concentracao: ${novaSolucaoConcentrada.fator_concentracao}
          }) {
            id
            nome
            volume
            fator_concentracao
            created_at
          }
        }
     """;

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      SolucaoConcentrada? solucao =
          SolucaoConcentrada.fromJson(result.data?['createOneConcentrada']);

      return Right(solucao);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.errorInfoMessage));
    }
  }
}
