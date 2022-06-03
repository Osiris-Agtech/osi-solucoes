import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../viewmodels/reservatorios_store.dart';

class ReservatoriosPage extends StatefulWidget {
  final String title;
  const ReservatoriosPage({Key? key, this.title = 'ReservatoriosPage'})
      : super(key: key);
  @override
  ReservatoriosPageState createState() => ReservatoriosPageState();
}

class ReservatoriosPageState extends State<ReservatoriosPage> {
  // final ReservatoriosStore store = Modular.get();
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
