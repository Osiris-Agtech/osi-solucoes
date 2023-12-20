import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

abstract class IAgendaDatasource {
  Future<Either<Failure, List<Acao>>> buscarAcoes();
}

class AgendaDatasource implements IAgendaDatasource {
  @override
  Future<Either<Failure, List<Acao>>> buscarAcoes() async {
    await Future.delayed(const Duration(seconds: 2));

    final acao = List.generate(
        3,
        (index) => Acao(
              id: index + 1,
              titulo: 'Acao ${index + 1}',
              descricao: 'Descrição da Acao ${index + 1}',
              duracao_dias: 5,
              alerta: true,
              created_at: DateTime.now(),
              updated_at: DateTime.now(),
              deleted_at: null,
              protocolo: Protocolo(),
              fase: Fase(),
            ));

    return Future.value(Right(acao));
  }
}
