import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/protocolo/protocolo_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/protocolo/protocolo_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

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
}
