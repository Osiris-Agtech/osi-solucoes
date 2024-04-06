import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/detalhes_bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

import 'package:intl/intl.dart';

Padding agendaItem({
  required Agenda agenda,
  required AgendaStore store,
  required bool isFirst,
  required bool isLast,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: isFirst ? 16 : 4,
      bottom: isLast ? 16 : 4,
      left: 10,
      right: 10,
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap ??
          () {
            store.setShowEditPage(false);
            getBottomSheet(DetalhesBottomSheet(agenda: agenda));
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
                      agenda.titulo ?? "---",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 16,
                      title: Text(
                        agenda.usuario?.nome ?? "Sem responsável",
                        style: const TextStyle(
                          color: Constants.kText2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        agenda.usuario?.selected_conta?.cargo?.cargo ?? "---",
                        style: const TextStyle(
                          color: Constants.kText2,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: agenda.usuario?.pessoa?.imagem != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                agenda.usuario?.pessoa?.imagem ?? '',
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.kGreyLight,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Constants.kGreyMedium.withOpacity(.3),
                                    blurRadius: 2,
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MM/y", 'pt_br')
                                  .format(
                                    agenda.data!,
                                  )
                                  .capitalize ??
                              '',
                          style: const TextStyle(
                            color: Constants.kGreyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Constants.kPrimaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat("HH:mm", 'pt_br')
                                  .format(
                                    agenda.data!,
                                  )
                                  .capitalize ??
                              '',
                          style: const TextStyle(
                            color: Constants.kGreyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: agenda.finalizado ?? false,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Constants.kPrimaryColor,
                    size: 30,
                  ),
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
