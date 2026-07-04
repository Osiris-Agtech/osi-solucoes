import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/nutriente/nutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/errors.dart';

abstract class ISolucaoDatasource {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      {required int contaId});
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva({
    required SolucaoNutritiva solucao,
    required int contaId,
    required bool hasConcentrada,
  });
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes(
      {required int contaId});
  Future<Either<Failure, Fertilizante>> criarFertilizanteCustom({
    required int contaId,
    required String nome,
    required List<Map<String, dynamic>> nutrientes,
  });
  Future<Either<Failure, Fertilizante>> atualizarFertilizanteCustom({
    required int contaId,
    required int fertilizanteId,
    required String nome,
    required List<Map<String, dynamic>> nutrientes,
  });
  Future<Either<Failure, List<Nutriente>>> buscarNutrientes();
  Future<Either<Failure, bool>> excluirFertilizanteCustom({
    required int contaId,
    required int fertilizanteId,
  });
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      {required int solucaoId});
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada});
  Future<Either<Failure, bool>> deletarSolucaoNutritiva(
      {required int snutritivaId});
}

class SolucaoDatasource implements ISolucaoDatasource {
  String? _graphQlErrorCode(QueryResult result) {
    final graphQLErrors = result.exception?.graphqlErrors ?? [];
    if (graphQLErrors.isEmpty) {
      return null;
    }

    final extensions = graphQLErrors.first.extensions;
    return extensions == null ? null : extensions['code']?.toString();
  }

  bool _hasNetworkError(QueryResult result) {
    return result.exception?.linkException != null;
  }

  String _solucaoScopeErrorMessage(QueryResult result, String fallbackMessage) {
    if (_hasNetworkError(result)) {
      return FailureMessage.connectionErrorMessage;
    }

    final code = _graphQlErrorCode(result);
    if (code == 'UNAUTHENTICATED') {
      return 'Sessão expirada. Faça login novamente';
    }

    if (code == 'TENANT_SCOPE_VIOLATION' || code == 'FORBIDDEN') {
      return 'Conta sem permissão para acessar os dados desta solução';
    }

    return fallbackMessage;
  }

  String _fertilizanteMutationErrorMessage(
    QueryResult result, {
    required String forbiddenMessage,
    required String immutableMessage,
    required String notFoundMessage,
    required String fallbackMessage,
  }) {
    if (_hasNetworkError(result)) {
      return FailureMessage.connectionErrorMessage;
    }

    final firstCode = _graphQlErrorCode(result);

    if (firstCode == 'UNAUTHENTICATED') {
      return 'Sessão expirada. Faça login novamente';
    }

    if (firstCode == 'TENANT_SCOPE_VIOLATION' || firstCode == 'FORBIDDEN') {
      return forbiddenMessage;
    }

    if (firstCode == 'SYSTEM_FERTILIZER_IMMUTABLE' ||
        firstCode == 'SEED_IMMUTABLE') {
      return immutableMessage;
    }

    if (firstCode == 'NOT_FOUND') {
      return notFoundMessage;
    }

    return fallbackMessage;
  }

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
    }

    return Left(
      ErrorReservatorio(
        message: _solucaoScopeErrorMessage(
          result,
          FailureMessage.emptyListMessage,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva({
    required SolucaoNutritiva solucao,
    required int contaId,
    required bool hasConcentrada,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    /// MODIFICAR ESSA LÓGICA PARA EXECUTAR APENAS QUANDO NÃO TEM CONCENTRADA
    /// CASO TENHA, ADICIONAR O ID DELA NA LISTA

    //Criando a query para varios lotes
    String query = '';
    if (hasConcentrada) {
      for (SolucaoFertilizanteConcentrada element
          in solucao.solucoes_fertilizantes_concentradas ?? []) {
        if (element ==
            solucao.solucoes_fertilizantes_concentradas![
                solucao.solucoes_fertilizantes_concentradas!.length - 1]) {
          query += """{
          fk_fertilizantes_id: ${element.fertilizante!.id},
          fk_concentradas_id: ${element.concentrada!.id},
          quantidade: ${element.quantidade}
        }""";
        } else {
          query += """{
          fk_fertilizantes_id: ${element.fertilizante!.id},
          fk_concentradas_id: ${element.concentrada!.id},
          quantidade: ${element.quantidade}
        },""";
        }
      }
    } else {
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
                id
                nome
                origin
                compatibilidade
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
    }

    return Left(
      ErrorReservatorio(
        message: _solucaoScopeErrorMessage(
          result,
          FailureMessage.internalErrorMessage,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query FertilizantesCatalogo($contaId: Int!) {
          fertilizantesCatalogo(contaId: $contaId) {
            id
            nome
            origin
            deleted_at
            c_eletrica
            compatibilidade
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
      variables: <String, dynamic>{
        'contaId': contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? fertilizantes = result.data?['fertilizantesCatalogo']
          ?.map((item) => Fertilizante.fromJson(item))
          .toList();
      if (fertilizantes == null || fertilizantes.isEmpty) {
        return Left(
            ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<Fertilizante> fertilizanteList = fertilizantes.cast<Fertilizante>();
      return Right(fertilizanteList);
    } else {
      if (_hasNetworkError(result)) {
        return Left(
          ErrorFertilizante(message: FailureMessage.connectionErrorMessage),
        );
      }

      final firstCode = _graphQlErrorCode(result);

      if (firstCode == 'UNAUTHENTICATED') {
        return Left(
          ErrorFertilizante(message: 'Sessão expirada. Faça login novamente'),
        );
      }

      if (firstCode == 'TENANT_SCOPE_VIOLATION' || firstCode == 'FORBIDDEN') {
        return Left(ErrorFertilizante(
            message: 'Conta sem permissão para acessar este catálogo'));
      }

      return Left(
        ErrorFertilizante(message: FailureMessage.internalErrorMessage),
      );
    }
  }

  @override
  Future<Either<Failure, Fertilizante>> criarFertilizanteCustom({
    required int contaId,
    required String nome,
    required List<Map<String, dynamic>> nutrientes,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      mutation CreateFertilizante($contaId: Int!, $nome: String!, $nutrientes: [FertilizanteNutrienteInput!]!) {
        createFertilizante(
          contaId: $contaId,
          input: { nome: $nome, nutrientes: $nutrientes }
        ) {
          id
          nome
          origin
          c_eletrica
          compatibilidade
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

    final MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{
        'contaId': contaId,
        'nome': nome,
        'nutrientes': nutrientes,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      final raw = result.data?['createFertilizante'];
      if (raw is Map<String, dynamic>) {
        return Right(Fertilizante.fromJson(raw));
      }
    }

    return Left(
      ErrorFertilizante(
        message: _fertilizanteMutationErrorMessage(
          result,
          forbiddenMessage:
              'Conta sem permissão para criar fertilizante nesta conta',
          immutableMessage:
              'Operação não permitida para fertilizantes de sistema',
          notFoundMessage: 'Conta não encontrada para criar fertilizante',
          fallbackMessage: 'Não foi possível criar o fertilizante',
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Fertilizante>> atualizarFertilizanteCustom({
    required int contaId,
    required int fertilizanteId,
    required String nome,
    required List<Map<String, dynamic>> nutrientes,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      mutation UpdateFertilizante($contaId: Int!, $fertilizanteId: Int!, $nome: String!, $nutrientes: [FertilizanteNutrienteInput!]) {
        updateFertilizante(
          contaId: $contaId,
          fertilizanteId: $fertilizanteId,
          input: { nome: $nome, nutrientes: $nutrientes }
        ) {
          id
          nome
          origin
          c_eletrica
          compatibilidade
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

    final MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{
        'contaId': contaId,
        'fertilizanteId': fertilizanteId,
        'nome': nome,
        'nutrientes': nutrientes,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      final raw = result.data?['updateFertilizante'];
      if (raw is Map<String, dynamic>) {
        return Right(Fertilizante.fromJson(raw));
      }
    }

    return Left(
      ErrorFertilizante(
        message: _fertilizanteMutationErrorMessage(
          result,
          forbiddenMessage: 'Conta sem permissão para editar este fertilizante',
          immutableMessage: 'Fertilizantes de sistema não podem ser editados',
          notFoundMessage: 'Fertilizante não encontrado para edição',
          fallbackMessage: 'Não foi possível editar o fertilizante',
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Nutriente>>> buscarNutrientes() async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Nutrientes {
        nutrientes(orderBy: { nome: asc }) {
          id
          nome
          sigla
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(readRepositories),
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List? nutrientes = result.data?['nutrientes']
          ?.map((item) => Nutriente.fromJson(item))
          .toList();

      if (nutrientes == null || nutrientes.isEmpty) {
        return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
      }

      List<Nutriente> nutrientesList = nutrientes.cast<Nutriente>();
      return Right(nutrientesList);
    }

    return Left(ErrorReservatorio(message: FailureMessage.internalErrorMessage));
  }

  @override
  Future<Either<Failure, bool>> excluirFertilizanteCustom({
    required int contaId,
    required int fertilizanteId,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String query = r'''
      mutation SoftDeleteFertilizante($contaId: Int!, $fertilizanteId: Int!) {
        softDeleteFertilizante(contaId: $contaId, fertilizanteId: $fertilizanteId) {
          id
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(query),
      variables: <String, dynamic>{
        'contaId': contaId,
        'fertilizanteId': fertilizanteId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      return const Right(true);
    }

    return Left(
      ErrorFertilizante(
        message: _fertilizanteMutationErrorMessage(
          result,
          forbiddenMessage:
              'Conta sem permissão para excluir este fertilizante',
          immutableMessage: 'Fertilizantes de sistema não podem ser excluídos',
          notFoundMessage: 'Fertilizante não encontrado para exclusão',
          fallbackMessage: 'Não foi possível excluir o fertilizante',
        ),
      ),
    );
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
                id
                nome
                origin
                deleted_at
                compatibilidade
                fertilizantes_nutrientes {
                  teor_nutriente
                  nutriente {
                    id
                    nome
                    sigla
                  }
                }
              }
              concentrada {
                id
                nome
                volume
                fator_concentracao
                solucoes_fertilizantes_concentradas {
                  fertilizante {
                    id
                    nome
                    origin
                    deleted_at
                  }
                  quantidade
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
    }

    return Left(
      ErrorReservatorio(
        message: _solucaoScopeErrorMessage(
          result,
          FailureMessage.errorInfoMessage,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = """
        mutation CreateOneConcentrada {
          createOneConcentrada(data: {
            nome: "${novaSolucaoConcentrada.nome}",
            fator_concentracao: ${novaSolucaoConcentrada.fator_concentracao},
            volume: ${novaSolucaoConcentrada.volume ?? 1},
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

  @override
  Future<Either<Failure, bool>> deletarSolucaoNutritiva(
      {required int snutritivaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      mutation SoftDeleteSNutritiva($snutritivaId: Int!) {
        softDeleteSNutritiva(snutritivaId: $snutritivaId) {
          id
          deleted_at
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'snutritivaId': snutritivaId,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      try {
        final response = result.data?['softDeleteSNutritiva'];
        if (response is bool) return Right(response);
        if (response is Map<String, dynamic>) {
          final id = response['id'];
          return Right(id is int && id > 0);
        }
        return const Right(true);
      } catch (e) {
        return Left(ErrorReservatorio(
            message: FailureMessage.errorDeleteSolucaoNutritiva));
      }
    }

    return Left(ErrorReservatorio(
        message: FailureMessage.errorDeleteSolucaoNutritiva));
  }
}
