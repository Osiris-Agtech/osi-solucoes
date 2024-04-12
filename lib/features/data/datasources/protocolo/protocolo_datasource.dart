import 'package:dartz/dartz.dart';
import 'package:graphql/client.dart';
import 'package:osi_solucoes/core/errors/errors.dart';
import 'package:osi_solucoes/features/data/api_source.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

import '../../../../core/errors/failure.dart';

abstract class IProtocoloDatasource {
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId);
  Future<Either<Failure, List<Cultura>>> buscarCulturas();
  Future<Either<Failure, Fase>> registrarFase({required Fase fase});
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo});
}

class ProtocoloDatasource implements IProtocoloDatasource {
  @override
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId) async {
    GraphQLClient client = GraphQLAPI().getGraphQLClient();

    const String readRepositories = r'''
      query Protocolos($contaId: Int!) {
        protocolos(where: {
          conta: {
            id: {
              equals: $contaId
            }
          },
          deleted_at: {
            equals: null
          }
        }) {
          id
          nome
          cultura {
            id
            nome
          }
          sistema_cultivo
          implantacao
        }
      }
    ''';

    final QueryOptions? options;

    options = QueryOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{
        "contaId": contaId,
      },
    );

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      try {
        if (result.data?['protocolos'] == []) return const Right([]);

        List<Protocolo>? protocolos = (result.data?['protocolos'] as List?)
            ?.map((item) => Protocolo.fromJson(item as Map<String, dynamic>))
            .toList();
        if (protocolos == null) {
          return Left(
              ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
        }
        return Right(protocolos);
      } catch (e) {
        return Left(
            ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
      }
    } else {
      return Left(
          ErrorProtocolo(message: FailureMessage.errorBuscarProtocolos));
    }
    // Simule uma chamada de API assíncrona
    // await Future.delayed(const Duration(seconds: 2));

    // final protocolos = List.generate(
    //     3,
    //     (index) => Protocolo(
    //           id: index + 1,
    //           nome: 'Protocolo ${index + 1}',
    //           descricao: 'Descrição do Protocolo ${index + 1}',
    //           tipo_cultura: 'Tipo de Cultura ${index + 1}',
    //           sistema_cultivo: 'Sistema de Cultivo ${index + 1}',
    //           implantacao: 'Implantação ${index + 1}',
    //           created_at: DateTime.now(),
    //           updated_at: DateTime.now(),
    //           deleted_at: null,
    //           acao: [Acao(fase: Fase()), Acao(fase: Fase())],
    //           cultura: [Cultura(id: index, nome: 'Alface ${index + 1}')],
    //           conta: Conta(),
    //         ));

    // return Future.value(Right(protocolos));
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas() async {
    // Simule uma chamada de API assíncrona
    await Future.delayed(const Duration(seconds: 2));

    final culturas = List.generate(
        3,
        (index) => Cultura(
              id: index + 1,
              nome: 'Alface ${index + 1}',
              created_at: DateTime.now(),
              conta: Conta(),
            ));

    return Future.value(Right(culturas));
  }

  @override
  Future<Either<Failure, Fase>> registrarFase({required Fase fase}) async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(Right(fase));
  }

  @override
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      {required Protocolo protocolo}) async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(Right(protocolo));
  }
}
