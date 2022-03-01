import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/receitas/receitas_store.dart';

class ReceitasPage extends StatefulWidget {
  final String title;
  const ReceitasPage({Key? key, this.title = 'ReceitasPage'}) : super(key: key);
  @override
  ReceitasPageState createState() => ReceitasPageState();
}
class ReceitasPageState extends State<ReceitasPage> {
  final ReceitasStore store = Modular.get();

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