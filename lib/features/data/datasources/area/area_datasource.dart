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
  Future<Either<Failure, List<Area>>> buscarArea({required int contaId});
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
      const String readRepositories = r'''
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
              cep
              endereco
            }
            setores {
              nome
            }
          }
        } 
      ''';

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
          'localizacaoId': novaArea.localizacao!.id,
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
              cep
              endereco
            }
            setores {
              nome
            }
          }
        } 
      ''';

      final MutationOptions? options;

      options = MutationOptions(
        document: gql(readRepositories),
        variables: <String, dynamic>{
          'nome': alterarArea.nome,
          'descricao': alterarArea.descricao,
          'imagem': alterarArea.imagem,
          'tipo': alterarArea.tipo,
          'creat_at': alterarArea.created_at,
          'contaId': alterarArea.conta!.id,
          'localizacaoId': alterarArea.localizacao!.id,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (!result.hasException) {
        Area? area = Area.fromJson(result.data?['createOneArea']);

        return Right(area);
      } else {
        return Left(ErrorArea(message: FailureMessage.errorAlterarAreaMessage));
      }
    } catch (e) {
      return Left(ErrorArea(message: FailureMessage.errorAlterarAreaMessage));
    }
  }

  @override
  Future<Either<Failure, List<Area>>> buscarArea({required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query Areas ($contaId: Int!){
          areas(where: {
            conta: {
              id: {
                equals: $contaId
              }
            }
          }) {
            id
            nome
            localizacao {
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

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'contaId': contaId,
      },
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
