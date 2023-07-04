import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/area/area_model.dart';

abstract class IAreaRepository {
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      Localizacao localizacao, int contaId);
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacoes(int userId);
  Future<Either<Failure, Area>> registrarArea(Area novaArea);
  Future<Either<Failure, Area>> alterarArea(Area alterarArea);
  Future<Either<Failure, List<Area>>> buscarArea(
    int contaId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  );
}
