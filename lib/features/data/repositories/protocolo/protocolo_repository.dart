import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/protocolo/protocolo_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

import '../../../presenter/models/cultura/cultura_model.dart';

class ProtocoloRepository implements IProtocoloRepository {
  final IProtocoloDatasource datasource;
  ProtocoloRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId) async {
    var result = await datasource.buscarProtocolos(contaId);

    return result;
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId) async {
    var result = await datasource.buscarCulturas(contaId);
    return result;
  }

  @override
  Future<Either<Failure, List<Fase>>> buscarFases(int contaId) async {
    var result = await datasource.buscarFases(contaId);

    return result;
  }

  @override
  Future<Either<Failure, bool>> deletarProtocolo(int protocoloId) async {
    var result = await datasource.deletarProtocolo(protocoloId);
    return result;
  }

  @override
  Future<Either<Failure, Fase>> registrarFase(Fase fase) async {
    var result = await datasource.registrarFase(fase: fase);
    return result;
  }

  @override
  Future<Either<Failure, Protocolo>> registrarProtocolo(
      Protocolo protocolo) async {
    var result = await datasource.registrarProtocolo(protocolo: protocolo);
    return result;
  }

  @override
  Future<Either<Failure, Protocolo>> atualizarProtocolo(
      Protocolo alterarProtocolo) async {
    var result =
        await datasource.atualizarProtocolo(alterarProtocolo: alterarProtocolo);
    return result;
  }
}
