import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/failure.dart';

abstract class IReservatorioRepository {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(int contaId);
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(int solucaoId);
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      int reservatorioId);
  Future<Either<Failure, Reservatorio>> registrarReservatorio(
      Reservatorio novoReservatorio);
}
