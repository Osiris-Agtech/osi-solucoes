import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../viewmodels/area_cultivo_store.dart';

class AreaCultivoPage extends StatefulWidget {
  final String title;
  const AreaCultivoPage({Key? key, this.title = 'AreaCultivoPage'})
      : super(key: key);
  @override
  AreaCultivoPageState createState() => AreaCultivoPageState();
}

class AreaCultivoPageState extends State<AreaCultivoPage> {
  // final AreaCultivoStore store = Modular.get();
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

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
