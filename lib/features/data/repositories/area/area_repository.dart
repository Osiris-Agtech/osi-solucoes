import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

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
}
