import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

import '../../../presenter/models/area/area_model.dart';
import '../../datasources/area/area_datasource.dart';
import 'area_repository_interface.dart';

class AreaRepository implements IAreaRepository {
  final IAreaDatasource datasource;
  AreaRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      Localizacao localizacao) async {
    var result =
        await datasource.cadastrarLocalizacao(localizacao: localizacao);

    return result;
  }

  @override
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacoes(
      int contaId) async {
    var result = await datasource.buscarLocalizacoes(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, Area>> registrarArea(Area novaArea) async {
    var result = await datasource.registrarArea(novaArea: novaArea);

    return result;
  }

  @override
  Future<Either<Failure, Area>> alterarArea(Area alterarArea) async {
    var result = await datasource.alterarArea(alterarArea: alterarArea);

    return result;
  }

  @override
  Future<Either<Failure, List<Area>>> buscarArea(
    int contaId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    var result = await datasource.buscarArea(
      contaId: contaId,
      orderBy: orderBy,
      order: order,
      startDate: startDate,
      endDate: endDate,
    );

    return result;
  }
}
