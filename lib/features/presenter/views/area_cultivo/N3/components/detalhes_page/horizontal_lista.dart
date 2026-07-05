import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

import 'custom_dialog.dart';

SingleChildScrollView horizontalList(
  BuildContext context,
  ReservatoriosStore reservatorioStore,
  LoteStore store,
) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 24,
        ),
        Visibility(
          visible: store.loteSelecionado.reservatorio?.id != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  reservatorioStore.setReservatorioDetalhes(
                      store.loteSelecionado.reservatorio!);
                  Get.toNamed(Routes.reservatoriosPage);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Constants.kCardColor,
                      child: SvgPicture.asset(
                        "assets/icons/reservatorio_icon.svg",
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Reservatório',
                      style: TextStyle(
                        color: Constants.kGreyText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Constants.kCardColor,
              child: SvgPicture.asset(
                "assets/icons/caderno_campo_icon.svg",
                height: 25,
                width: 25,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Caderno de\nCampo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Constants.kGreyText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Constants.kCardColor,
                child: SvgPicture.asset(
                  "assets/icons/migrar_lote.svg",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Migrar Lote',
                style: TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog();
              },
            );
          },
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    ),
  );
}
