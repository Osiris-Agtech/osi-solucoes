import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/core/errors/failure.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/reservatorio/reservatorio_model.dart';
import '../../../presenter/models/atividade/atividade_model.dart';

abstract class IAjusteRepository {
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
  Future<Either<Failure, Atividade>> salvarAjuste(
      Atividade atividade, int usuarioId, List<int> listLoteId);
}
