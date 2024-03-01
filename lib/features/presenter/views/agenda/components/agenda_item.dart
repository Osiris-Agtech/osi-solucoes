import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/detalhes_bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

import 'package:intl/intl.dart';

Padding agendaItem({
  required int index,
  VoidCallback? onTap,
  required AgendaStore store,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: index == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap ??
          () {
            store.setShowEditPage(false);
            getBottomSheet(const DetalhesBottomSheet());
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      //store.searchReservatorio[index].nome ?? "---",
                      store.atividadeList[index].titulo ?? "---",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const ListTile(
                      horizontalTitleGap: 0,
                      title: Text("Miguel Ribeiro"),
                      subtitle: Text("Admistrador"),
                      leading: Icon(Icons.person_add),
                    ),
                    Row(
                      children: [
                        Text(DateFormat("dd/MM/y", 'pt_br')
                                .format(
                                  store.atividadeList[index].data!,
                                )
                                .capitalize ??
                            ''),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Constants.kPrimaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(DateFormat("HH:mm", 'pt_br')
                                .format(
                                  store.atividadeList[index].data!,
                                )
                                .capitalize ??
                            '')
                      ],
                    ),
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
