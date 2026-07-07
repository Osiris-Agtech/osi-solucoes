import 'package:flutter/widgets.dart';

/// Observador de rota compartilhado para detectar quando uma página
/// se torna ativa novamente após pop (ex: voltar da Agenda para Home).
/// Usado por HomePageState para refresh automático do INSTANT.
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
