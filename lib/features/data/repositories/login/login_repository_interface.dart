import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/usuario/usuario_model.dart';

abstract class ILoginRepository {
  Future<Either<Failure, Usuario>> login({
    required String senha,
    String? email,
    String? codigo,
  });
}
