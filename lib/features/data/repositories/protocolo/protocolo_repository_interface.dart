import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import '../../../presenter/models/fase/fase_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IProtocoloRepository {
  Future<Either<Failure, List<Protocolo>>> buscarProtocolos(int contaId);
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId);
  Future<Either<Failure, List<Fase>>> buscarFases(int contaId);
  Future<Either<Failure, Fase>> registrarFase(Fase fase);
  Future<Either<Failure, Protocolo>> registrarProtocolo(Protocolo protocolo);
  Future<Either<Failure, Protocolo>> atualizarProtocolo(
      Protocolo alterarProtocolo);
}
