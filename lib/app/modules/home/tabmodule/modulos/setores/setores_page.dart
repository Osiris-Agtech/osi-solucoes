import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/setores/setores_store.dart';

class SetoresPage extends StatefulWidget {
  final String title;
  const SetoresPage({Key? key, this.title = 'SetoresPage'}) : super(key: key);
  @override
  SetoresPageState createState() => SetoresPageState();
}

class SetoresPageState extends State<SetoresPage> {
  final SetoresStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          color: Colors.red,
        ));
  }
}
