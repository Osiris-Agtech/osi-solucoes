import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

abstract class IAgendaDatasource {
  Future<Either<Failure, List<Agenda>>> buscarAtividades();
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> deletarAtividade(int id);
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> marcarComoFeito(int id);
}

class AgendaDatasource implements IAgendaDatasource {
  @override
  Future<Either<Failure, List<Agenda>>> buscarAtividades() async {
    await Future.delayed(const Duration(seconds: 2));

    return Future.value(Right(atividadeList));
  }

  @override
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda) async {
    await Future.delayed(const Duration(seconds: 2));

    atividadeList.add(agenda);
    atividadeList = List.from(atividadeList);

    return Future.value(Right(agenda));
  }

  @override
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda) async {
    await Future.delayed(const Duration(seconds: 2));

    int index = atividadeList.indexWhere((element) => element.id == agenda.id);
    if (index != -1) {
      atividadeList[index] = agenda;
      atividadeList = List.from(atividadeList);
    }

    return Future.value(Right(agenda));
  }

  @override
  Future<Either<Failure, Agenda>> deletarAtividade(int id) async {
    await Future.delayed(const Duration(seconds: 2));

    Agenda? agenda;
    int index = atividadeList.indexWhere((element) => element.id == id);
    if (index != -1) {
      agenda = atividadeList[index];
      atividadeList.removeAt(index);
      atividadeList = List.from(atividadeList);
    }

    return Future.value(Right(agenda ?? Agenda()));
  }

  @override
  Future<Either<Failure, Agenda>> marcarComoFeito(int id) async {
    await Future.delayed(const Duration(seconds: 2));

    Agenda? agenda;
    int index = atividadeList.indexWhere((element) => element.id == id);
    if (index != -1) {
      atividadeList[index].finalizado = true;
      atividadeList = List.from(atividadeList);
      agenda = atividadeList[index];
    }

    return Future.value(Right(agenda ?? Agenda()));
  }
}

List<Agenda> atividadeList = [
  Agenda(
    id: 1,
    descricao: 'Descrição da Atividade 1',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 1)),
    titulo: 'Atividade 1',
    alerta: false,
    ativo: true,
    finalizado: false,
    conta: Conta(),
    lote: Lote(),
    usuario: Usuario(),
  ),
  Agenda(
    id: 2,
    descricao: 'Descrição da Atividade 2',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 2)),
    titulo: 'Atividade 2',
    alerta: false,
    ativo: true,
    finalizado: true,
    conta: Conta(),
    lote: Lote(),
    usuario: Usuario(),
  ),
  Agenda(
    id: 3,
    descricao: 'Descrição da Atividade 3',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    deleted_at: DateTime.now(),
    data: DateTime.now().subtract(const Duration(days: 3)),
    titulo: 'Atividade 3',
    alerta: false,
    ativo: true,
    finalizado: false,
    conta: Conta(),
    lote: Lote(),
    usuario: Usuario(),
  ),
];
