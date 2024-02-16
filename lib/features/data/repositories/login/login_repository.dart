import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/core/errors/failure.dart';
import 'package:sigma_hort_gestao_equipe/features/data/datasources/login/login_datasource.dart';

import '../../../presenter/models/usuario/usuario_model.dart';
import 'login_repository_interface.dart';

class LoginRepository implements ILoginRepository {
  final ILoginDatasource datasource;
  LoginRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Usuario>>> login(
      String email, String senha, String codigo) async {
    var result =
        await datasource.login(email: email, password: senha, code: codigo);

    return result;
  }
}
