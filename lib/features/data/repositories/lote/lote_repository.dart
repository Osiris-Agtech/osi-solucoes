import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/lote/lote_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/lote/lote_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

class LoteRepository implements ILoteRepository {
  final ILoteDatasource datasource;
  LoteRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Lote>>> buscarLotes(int setorId) async {
    var result = await datasource.buscarLotes(setorId: setorId);
    return result;
  }

  @override
  Future<Either<Failure, Lote>> buscarDetalhesLote(int loteId) async {
    var result = await datasource.buscarDetalhesLote(loteId: loteId);
    return result;
  }
}
