import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';

import '../../../../core/constants/constants.dart';
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
        color: Constants.kBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Novo Reservatório",
        backgroundColor: Constants.kPrimaryColor,
        onPressed: () => Get.to(
          () => const CadastrarReservatorioPage(),
          transition: Transition.rightToLeft,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
