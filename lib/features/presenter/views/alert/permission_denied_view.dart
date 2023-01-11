import 'package:flutter/material.dart';

class PermissionDeniedPage extends StatefulWidget {
  const PermissionDeniedPage({Key? key}) : super(key: key);

  @override
  State<PermissionDeniedPage> createState() => _PermissionDeniedPageState();
}

class _PermissionDeniedPageState extends State<PermissionDeniedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Permissão Negada'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Você não possui permissão para acessar a página.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
