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
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos() async {
    var result = await datasource.buscarProtocolos();

    return result;
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas() async {
    var result = await datasource.buscarCulturas();
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
}
