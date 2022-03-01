import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/reservatorios/reservatorios_store.dart';

class ReservatoriosPage extends StatefulWidget {
  final String title;
  const ReservatoriosPage({Key? key, this.title = 'ReservatoriosPage'}) : super(key: key);
  @override
  ReservatoriosPageState createState() => ReservatoriosPageState();
}
class ReservatoriosPageState extends State<ReservatoriosPage> {
  final ReservatoriosStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(color: Colors.red,)
    );
  }
}