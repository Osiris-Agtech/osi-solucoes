import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/login/login_datasource.dart';

import '../../../presenter/models/usuario/usuario_model.dart';
import 'login_repository_interface.dart';

class LoginRepository implements ILoginRepository {
  final ILoginDatasource datasource;
  LoginRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Usuario>> login({
    required String senha,
    String? email,
    String? codigo,
  }) async {
    var result = await datasource.login(
      email: email,
      password: senha,
      code: codigo,
    );

    return result;
  }
}
