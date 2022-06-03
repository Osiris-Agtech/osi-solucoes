import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../viewmodels/solucao_store.dart';

class SolucaoPage extends StatefulWidget {
  final String title;
  const SolucaoPage({Key? key, this.title = 'ReceitasPage'}) : super(key: key);
  @override
  SolucaoPageState createState() => SolucaoPageState();
}

class SolucaoPageState extends State<SolucaoPage> {
  // final ReceitasStore store = Modular.get();
  SolucaoStore store = GetIt.I<SolucaoStore>();

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
