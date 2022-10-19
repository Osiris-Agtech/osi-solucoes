// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/detalhes_reservatorio_page.dart';

Padding reservatorioItem(int index, ReservatoriosStore store) {
  return Padding(
    padding: EdgeInsets.only(
      top: index == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: GestureDetector(
      onTap: () {
        store.setReservatorioDetalhes(store.reservatorioList[index]);
        Get.to(
          () => const DetalhesReservatorio(),
          transition: Transition.rightToLeft,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 5.0,
                      ),
                      child: SvgPicture.asset(
                          'assets/icons/reservatorio_icon.svg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 5.0,
                      ),
                      child: Text(
                        store.reservatorioList[index].nome ?? "---",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Cultivos:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "${store.reservatorioList[index].lotes?.length ?? 0} Ativos",
                              style: const TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
