enum AgendaState {
  loading,
  loaded,
  error,
}

enum AgendaFilter {
  todos,
  lote,
  responsavel,
}

extension AgendaFilterExtension on AgendaFilter {
  String get name {
    switch (this) {
      case AgendaFilter.todos:
        return 'Todos';
      case AgendaFilter.lote:
        return 'Lote';
      case AgendaFilter.responsavel:
        return 'Responsável';
    }
  }
}
