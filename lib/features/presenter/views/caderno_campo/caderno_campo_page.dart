import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/caderno_campo_store.dart';

class CadernoCampoPage extends StatefulWidget {
  final String title;
  const CadernoCampoPage({Key? key, this.title = 'CadernoCampoPage'})
      : super(key: key);
  @override
  CadernoCampoPageState createState() => CadernoCampoPageState();
}

class CadernoCampoPageState extends State<CadernoCampoPage> {
  // final CadernoCampoStore store = Modular.get();
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Constants.kBackgroundColor,
      ),
    );
  }
}
