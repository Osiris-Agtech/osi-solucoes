import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';

class NewFloatingActionButton extends StatelessWidget {
  final int nivel;
  const NewFloatingActionButton({
    Key? key,
    required this.nivel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: SpeedDial(
        elevation: 10,
        backgroundColor: Constants.kPrimaryColor,
        icon: Icons.add,
        activeIcon: Icons.close,
        spaceBetweenChildren: 0,
        // childMargin: EdgeInsets.all(10),
        spacing: 10,
        iconTheme: const IconThemeData(size: 35),
        children: [
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/hydroponic2_icon.png",
              height: 70,
            ),
            label: "Novo Lote",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: nivel <= 3
                ? () => Get.to(
                      () => const CadastrarLotePage(),
                      transition: Transition.rightToLeft,
                    )
                : null,
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/hydroponic1_icon.png",
              height: 70,
            ),
            label: "Novo Setor",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: nivel <= 2 ? () {} : null,
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/greenhouse1_icon.png",
              height: 100,
            ),
            label: "Nova Área",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: nivel <= 1
                ? () => Get.to(
                      () => const CadastrarAreaCultivo(),
                      transition: Transition.rightToLeft,
                    )
                : null,
          ),
        ],
      ),
    );
  }
}
