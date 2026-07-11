enum AgendaState {
  loading,
  loaded,
  error,
}

enum AgendaFilter {
  hoje,
  todos,
  lote,
  responsavel,
}

extension AgendaFilterExtension on AgendaFilter {
  String get name {
    switch (this) {
      case AgendaFilter.hoje:
        return 'Hoje';
      case AgendaFilter.todos:
        return 'Todos';
      case AgendaFilter.lote:
        return 'Por Lote';
      case AgendaFilter.responsavel:
        return 'Por Responsável';
    }
  }
}
