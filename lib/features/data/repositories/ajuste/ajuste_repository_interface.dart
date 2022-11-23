import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import '../../../presenter/models/atividade/atividade_model.dart';

abstract class IAjusteRepository {
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
  Future<Either<Failure, Atividade>> salvarAjuste(
      Atividade atividade, int usuarioId);
}
