// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/services/navigation_resource_args.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';

Padding reservatorioItem(int index, ReservatoriosStore store) {
  return Padding(
    padding: EdgeInsets.only(
      top: index == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: AppEntityCard(
      title: store.searchReservatorio[index].nome ?? "---",
      leading: SvgPicture.asset('assets/icons/reservatorio_icon.svg'),
      metadata: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Cultivos:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "${store.searchReservatorio[index].lotes?.length ?? 0} Ativos",
              style: const TextStyle(
                color: Constants.kPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
      actions: const [
        Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Constants.kPrimaryColor,
        ),
      ],
      onTap: () {
        final reservatorio = store.searchReservatorio[index];
        store.setReservatorioDetalhes(reservatorio);
        Get.toNamed(
          Routes.detalhesReservatorio,
          arguments: NavigationResourceArgs(
            resourceId: reservatorio.id?.toString(),
            resourceType: 'reservatorio',
            resourceName: reservatorio.nome,
          ),
        );
      },
    ),
  );
}
