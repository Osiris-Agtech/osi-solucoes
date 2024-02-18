import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_producao/core/errors/failure.dart';
import 'package:sigma_hort_gestao_producao/features/data/datasources/lote/lote_datasource.dart';
import 'package:sigma_hort_gestao_producao/features/data/repositories/lote/lote_repository_interface.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/cultura/cultura_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/lote/lote_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/reservatorio/reservatorio_model.dart';

import '../../../presenter/models/area/area_model.dart';

class LoteRepository implements ILoteRepository {
  final ILoteDatasource datasource;
  LoteRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Lote>>> buscarLotes(
    int setorId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    var result = await datasource.buscarLotes(
      setorId: setorId,
      orderBy: orderBy,
      order: order,
      startDate: startDate,
      endDate: endDate,
    );
    return result;
  }

  @override
  Future<Either<Failure, Lote>> buscarDetalhesLote(int loteId) async {
    var result = await datasource.buscarDetalhesLote(loteId: loteId);
    return result;
  }

  @override
  Future<Either<Failure, List<Cultura>>> buscarCulturas(int contaId) async {
    var result = await datasource.buscarCulturas(contaId: contaId);
    return result;
  }

  @override
  Future<Either<Failure, List<Area>>> buscarAreasList(int contaId) async {
    var result = await datasource.buscarAreasList(contaId: contaId);
    return result;
  }

  @override
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      int contaId) async {
    var result = await datasource.buscarReservatorios(contaId: contaId);
    return result;
  }

  @override
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      int reservatorioId) async {
    var result = await datasource.buscarReservatorioDetalhes(
        reservatorioId: reservatorioId);
    return result;
  }

  @override
  Future<Either<Failure, Lote>> registrarLote(Lote lote) async {
    var result = await datasource.registrarLote(lote: lote);
    return result;
  }

  @override
  Future<Either<Failure, Lote>> migrarLote(
      int loteId, int setorId, int reservatorioId) async {
    var result = await datasource.migrarLote(
        loteId: loteId, setorId: setorId, reservatorioId: reservatorioId);
    return result;
  }

  @override
  Future<Either<Failure, Lote>> alterarLote(Lote alterarLote) async {
    var result = await datasource.alterarLote(alterarLote: alterarLote);
    return result;
  }

  @override
  Future<Either<Failure, Cultura>> registrarCultura(
      Cultura cultura, int contaId) async {
    var result =
        await datasource.registrarCultura(cultura: cultura, contaId: contaId);
    return result;
  }
}
