import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';

import '../views/area_cultivo/N2/cadastrar_setor_page.dart';

class NewFloatingActionButton extends StatefulWidget {
  final int nivel;
  const NewFloatingActionButton({
    Key? key,
    required this.nivel,
  }) : super(key: key);

  @override
  State<NewFloatingActionButton> createState() =>
      _NewFloatingActionButtonState();
}

class _NewFloatingActionButtonState extends State<NewFloatingActionButton> {
  AreaCultivoStore areaStore = GetIt.I<AreaCultivoStore>();
  SetorStore setorStore = GetIt.I<SetorStore>();
  LoteStore loteStore = GetIt.I<LoteStore>();

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
            onTap: widget.nivel <= 3
                ? () {
                    loteStore.setIsEditing(false);
                    Get.to(
                      () => const CadastrarLotePage(),
                      transition: Transition.rightToLeft,
                    );
                  }
                : null,
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/hydroponic1_icon.png",
              height: 70,
            ),
            label: "Novo Setor",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: widget.nivel <= 2
                ? () {
                    setorStore.setIsEditing(false);
                    Get.to(
                      () => const CadastrarSetorPage(),
                      transition: Transition.rightToLeft,
                    );
                  }
                : null,
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/greenhouse1_icon.png",
              height: 100,
            ),
            label: "Nova Área",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: widget.nivel <= 1
                ? () {
                    areaStore.setIsEditing(false);
                    Get.to(
                      () => const CadastrarAreaCultivo(),
                      transition: Transition.rightToLeft,
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
