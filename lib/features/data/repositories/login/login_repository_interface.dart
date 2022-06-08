import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/usuario/usuario_model.dart';

abstract class ILoginRepository {
  Future<Either<Failure, List<Usuario>>> login(
      String email, String senha, String codigo);
}
