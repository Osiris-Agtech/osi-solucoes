import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ILoteRepository {
  Future<Either<Failure, List<Lote>>> buscarLotes(
    int setorId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<Either<Failure, Lote>> buscarDetalhesLote(int loteId);
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId);
  Future<Either<Failure, List<Area>>> buscarAreasList(int contaId);
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      int reservatorioId);
  Future<Either<Failure, Lote>> registrarLote(Lote lote);
  Future<Either<Failure, Cultura>> registrarCultura(
      Cultura cultura, int contaId);
  Future<Either<Failure, Lote>> migrarLote(
      int loteId, int setorId, int reservatorioId);
  Future<Either<Failure, Lote>> alterarLote(Lote alterarLote);
}
