import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/authentication/authentication_model.dart';

abstract class ILoginRepository {
  Future<Either<Failure, Authentication>> login({
    required String senha,
    String? email,
    String? codigo,
  });
}
