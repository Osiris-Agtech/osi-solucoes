import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IProtocoloRepository {
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos();
}
