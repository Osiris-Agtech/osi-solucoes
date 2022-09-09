import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';

import '../../../../core/errors/failure.dart';

abstract class IAreaRepository {
  Future<Either<Failure, Localizacao>> cadastrarLocalizacao(
      Localizacao localizacao);
  Future<Either<Failure, List<Localizacao>>> buscarLocalizacoes(int userId);
}
