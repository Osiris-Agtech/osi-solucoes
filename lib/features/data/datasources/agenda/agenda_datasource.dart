import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

abstract class IAgendaDatasource {
  Future<Either<Failure, List<Agenda>>> buscarAtividades();
}

class AgendaDatasource implements IAgendaDatasource {
  @override
  Future<Either<Failure, List<Agenda>>> buscarAtividades() async {
    await Future.delayed(const Duration(seconds: 2));

    final atividade = List.generate(
        3,
        (index) => Agenda(
              id: index + 1,
              descricao: 'Descrição da Atividade ${index + 1}',
              created_at: DateTime.now(),
              updated_at: DateTime.now(),
              deleted_at: DateTime.now(),
              titulo: 'Titulo ${index + 1}',
              alerta: false,
              ativo: true,
              finalizado: false,
              conta: Conta(),
              lote: Lote(),
              usuario: Usuario(),
            ));

    return Future.value(Right(atividade));
  }
}
