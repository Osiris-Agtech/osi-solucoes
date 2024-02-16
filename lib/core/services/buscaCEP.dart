// ignore_for_file: file_names

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sigma_hort_gestao_equipe/core/errors/errors.dart';
import 'package:sigma_hort_gestao_equipe/core/errors/failure.dart';
import '../../features/presenter/models/resultadoCEP/resultadoCEP_model.dart';

Future<Either<Failure, ResultCep>> buscarPorCEP(String cep) async {
  final response = await http.get(Uri.https('viacep.com.br', '/ws/$cep/json/'));
  if (response.statusCode == 200) {
    return Right(ResultCep.fromJson(response.body));
  } else {
    return Left(ErrorCEP(message: FailureMessage.cepErrorMessage));
  }
}
