import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

import '../../../../core/errors/errors.dart';

abstract class IAreaDatasource {
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      {required Localizacao localizacao});
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacoes(
      {required int contaId});
  Future<Either<Failure, List<Area>>> buscarArea(
      {required int contaId,
      required String orderBy,
      required String order,
      DateTime? startDate,
      DateTime? endDate});
  Future<Either<Failure, Area>> registrarArea({required Area novaArea});
  Future<Either<Failure, Area>> alterarArea({required Area alterarArea});
}

class AreaDatasource implements IAreaDatasource {
  @override
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      {required Localizacao localizacao}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        mutation CreateOneLocalizacao ($cep: String!, $endereco: String!, $bairro: String!, $cidade: String!, $pais: String!, $estado: String!, $complemento: String) {
          createOneLocalizacao(data: {
            cep: $cep,
            endereco: $endereco,
            bairro: $bairro,
            cidade: $cidade,
            pais: $pais,
            estado: $estado,
            complemento: $complemento,
          }) {
            id
            cep
            endereco
            bairro
            pais
            estado
            complemento
            cidade
            areas {
              nome
              conta {
                nome
              }
            }
          }
        }
      ''';

    final MutationOptions? options;

    options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'cep': localizacao.cep,
        'endereco': localizacao.endereco,
        'bairro': localizacao.bairro,
        'cidade': localizacao.cidade,
        'pais': localizacao.pais,
        'estado': localizacao.estado,
        'complemento': localizacao.complemento,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (!result.hasException) {
      Localizacao? localizacaoResult =
          Localizacao.fromJson(result.data?['createOneLocalizacao']);

      return Right(localizacaoResult);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacoes(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Localizacaos($contaId: Int!) {
          localizacaos(where: {
              conta: {
                id: {
                  equals: $contaId
                }
              }
            }) {
            id
            endereco
            numero
            bairro
            cidade
            estado
            areas {
              nome
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
      List localizacaoResult = result.data?['localizacaos']
          ?.map((item) => Localizacao.fromJson(item))
          .toList();

      List<Localizacao> localizacaoList = localizacaoResult.cast<Localizacao>();
      return Right(localizacaoList);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }

  @override
  Future<Either<Failure, Area>> registrarArea({required Area novaArea}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      String readRepositories = '';
      if (novaArea.localizacao?.id == null) {
        readRepositories = r'''
        mutation CreateOneArea ($nome: String!, $descricao: String!, $tipo: String!, $contaId: Int!) {
          createOneArea(data: {
            nome: $nome,
            descricao: $descricao,
            tipo: $tipo,
            conta: {
              connect: {
                id: $contaId
              }
            },
          }) {
            id
            nome
            descricao
            tipo
            conta {
              nome
            }
            localizacao {
              id
              cep
              endereco
            }
            setores {
              nome
            }
          }
        } 
      ''';
      } else {
        readRepositories = r'''
        mutation CreateOneArea ($nome: String!, $descricao: String!, $tipo: String!, $contaId: Int!, $localizacaoId: Int!) {
          createOneArea(data: {
            nome: $nome,
            descricao: $descricao,
            tipo: $tipo,
            conta: {
              connect: {
                id: $contaId
              }
            },
            localizacao: {
              connect: {
                id: $localizacaoId
              }
            }
          }) {
            id
            nome
            descricao
            tipo
            conta {
              nome
            }
            localizacao {
              id
              cep
              endereco
            }
            setores {
              nome
            }
          }
        } 
      ''';
      }

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          'nome': novaArea.nome,
          'descricao': novaArea.descricao,
          'imagem': novaArea.imagem,
          'tipo': novaArea.tipo,
          'creat_at': novaArea.created_at,
          'contaId': novaArea.conta!.id,
          if (novaArea.localizacao?.id != null)
            'localizacaoId': novaArea.localizacao?.id,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Area? area = Area.fromJson(result.data?['createOneArea']);

        return Right(area);
      } else {
        return Left(ErrorArea(message: FailureMessage.errorNovaAreaMessage));
      }
    } catch (e) {
      return Left(ErrorArea(message: FailureMessage.errorNovaAreaMessage));
    }
  }

  @override
  Future<Either<Failure, Area>> alterarArea({required Area alterarArea}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    try {
      const String readRepositories = r'''
        mutation($areaId: Int!, $areaNome: String!, $areaDescricao: String!, $areaTipo: String!, $localizacaoId: Int!, $contaId: Int!) {
          updateArea(areaId: $areaId, areaNome: $areaNome, areaDescricao: $areaDescricao, areaTipo: $areaTipo, localizacaoId: $localizacaoId, contaId: $contaId) {
            id
            nome
            descricao
            tipo
            conta {
              id
              nome
            }
            localizacao {
              id
              endereco
            }
          }
        }
      ''';

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          "areaId": alterarArea.id,
          "areaNome": alterarArea.nome,
          "areaDescricao": alterarArea.descricao,
          "areaTipo": "hidroponia",
          "localizacaoId": alterarArea.localizacao!.id,
          "contaId": alterarArea.conta!.id
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Area? area = Area.fromJson(result.data?['updateArea']);

        return Right(area);
      } else {
        return Left(ErrorArea(message: FailureMessage.errorAlterarAreaMessage));
      }
    } catch (e) {
      return Left(ErrorArea(message: FailureMessage.errorAlterarAreaMessage));
    }
  }

  @override
  Future<Either<Failure, List<Area>>> buscarArea({
    required int contaId,
    required String orderBy,
    required String order,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    String readRepositories = '';
    Map<String, dynamic> variables = <String, dynamic>{
      'contaId': contaId,
      'order': order,
    };

    if (orderBy == 'Data') {
      variables['startDate'] = startDate?.toIso8601String();
      variables['endDate'] = endDate?.toIso8601String();

      readRepositories = r'''
        query Areas ($contaId: Int!, $order: SortOrder!, $startDate: DateTime, $endDate: DateTime){
          areas(where: {
            conta: {
              id: {
                equals: $contaId
              }
            },
            created_at: {
              gt: $startDate,
              lte: $endDate
            }
          }, orderBy: [
            {
              created_at: $order,
            }
          ]) {
            id
            nome
            localizacao {
              id
              endereco
              bairro
              cidade
              estado
            }
            setores {
              id
              lotes {
                id
              }
            }
          }
        }
      ''';
    } else {
      readRepositories = r'''
        query Areas ($contaId: Int!, $order: SortOrder!){
          areas(where: {
            conta: {
              id: {
                equals: $contaId
              }
            }
          }, orderBy: [
            {
              nome: $order,
            }
          ]) {
            id
            nome
            localizacao {
              id
              endereco
              bairro
              cidade
              estado
            }
            setores {
              id
              lotes {
                id
              }
            }
          }
        }
      ''';
    }

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: variables,
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List areaResult =
          result.data?['areas']?.map((item) => Area.fromJson(item)).toList();

      List<Area> areaList = areaResult.cast<Area>();
      return Right(areaList);
    } else {
      return Left(ErrorArea(message: FailureMessage.emptyListMessage));
    }
  }
}
