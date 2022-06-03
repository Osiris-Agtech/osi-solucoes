import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/caderno_campo_store.dart';

class CadernoCampoPage extends StatefulWidget {
  final String title;
  const CadernoCampoPage({Key? key, this.title = 'CadernoCampoPage'})
      : super(key: key);
  @override
  CadernoCampoPageState createState() => CadernoCampoPageState();
}

class CadernoCampoPageState extends State<CadernoCampoPage> {
  final CadernoCampoStore store = Modular.get();

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
