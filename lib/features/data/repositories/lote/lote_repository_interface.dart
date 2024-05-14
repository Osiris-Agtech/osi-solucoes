import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
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
  Future<Either<Failure, List<Agenda>>> verificarAtividades(List<int> lotesIds);
  Future<Either<Failure, Lote>> registrarLote(Lote lote, int contaId);
  Future<Either<Failure, Cultura>> registrarCultura(
      Cultura cultura, int contaId);
  Future<Either<Failure, Lote>> migrarLote(
      int loteId, int setorId, int reservatorioId);
  Future<Either<Failure, Lote>> alterarLote(Lote alterarLote);
  Future<Either<Failure, bool>> deletarAtividades(List<int> agendaIds);
  Future<Either<Failure, bool>> finalizarAtividades(List<int> agendaIds);
  Future<Either<Failure, bool>> finalizarLotes(List<Lote> lotes);
  Future<Either<Failure, List<Lote>>> buscarLotesFinalizados(
      {required List<int> setoresId});
  Future<Either<Failure, List<int>>> buscarTodosSetoresId(
      {required List<int> areasId});
  Future<Either<Failure, List<int>>> buscarTodasAreasId({required int contaId});
}
