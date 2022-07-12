import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';

class DetalhesReservatorio extends StatefulWidget {
  const DetalhesReservatorio({Key? key}) : super(key: key);

  @override
  State<DetalhesReservatorio> createState() => _DetalhesReservatorioState();
}

class _DetalhesReservatorioState extends State<DetalhesReservatorio> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 120, //MediaQuery.of(context).size.height * 0.17,
              // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
              floating: true,
              automaticallyImplyLeading: false,
              forceElevated: true,
              elevation: 0,
              flexibleSpace: TopAppBar(
                path: "",
                namePage: "Reservatório 1",
                subtitle: "Volume: 2000 litros",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
