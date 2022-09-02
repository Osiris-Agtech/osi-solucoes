import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

import '../../../../core/errors/errors.dart';

abstract class IAreaDatasource {
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      {required Localizacao localizacao});
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacao(
      {required int contaId});
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
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacao(
      {required int contaId}) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
        query CreateOneLocalizacao ($cep: String!, $endereco: String!, $bairro: String!, $cidade: String!, $pais: String!, $estado: String!, $complemento: String) {
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

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        'id': contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      List<Localizacao>? localizacaoResult = [];

      return Right(localizacaoResult);
    } else {
      return Left(ErrorReservatorio(message: FailureMessage.emptyListMessage));
    }
  }
}
