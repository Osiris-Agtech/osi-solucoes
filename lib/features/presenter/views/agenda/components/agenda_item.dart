import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/detalhes_bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/editar_atividade_sheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

import 'package:intl/intl.dart';

Widget agendaItem({
  required Agenda agenda,
  required AgendaStore store,
  required bool isFirst,
  required bool isLast,
  VoidCallback? onTap,
}) {
  final isDone = agenda.finalizado ?? false;
  final isOverdue = !isDone && (agenda.alerta == true || (agenda.data != null && agenda.data!.isBefore(DateTime.now())));
  return Slidable(
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            store.setShowEditPage(true);
            store.carregarDadosDaAtividade(agenda);
            getBottomSheet(EditarAtividadeSheet(agenda: agenda));
          },
          backgroundColor: Constants.kPrimaryColor,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Editar',
          borderRadius: BorderRadius.circular(12),
        ),
        SlidableAction(
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Deletar Atividade', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                content: const Text('Deseja deletar esta atividade?', style: TextStyle(color: Constants.kGreyText, fontWeight: FontWeight.w500)),
                actions: [
                  TextButton(
                    onPressed: () { Get.back(); store.deletarAtividade(agenda.id!); },
                    child: const Text('Sim', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () { Get.back(); },
                    child: const Text('Não', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Constants.kErrorColor,
          foregroundColor: Colors.white,
          icon: Icons.delete_outline,
          label: 'Excluir',
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    ),
    child: Padding(
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
        child: AppPanelCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Opacity(
            opacity: isDone ? 0.65 : 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              agenda.titulo ?? "---",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isOverdue)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.warning_amber_rounded, color: Constants.kWarninngColor, size: 20),
                            ),
                          if (isDone)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.check_circle, color: Constants.kPrimaryColor, size: 16),
                            ),
                        ],
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
                                      color: Constants.kGreyMedium
                                          .withValues(alpha: .3),
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
                // Checkbox: ação (pendente) vs status (concluído)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDone)
                      // Status: apenas indicador visual, sem clique
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.check_circle, color: Constants.kPrimaryColor, size: 30),
                      )
                    else
                      // Ação: tooltip + gesto + label
                      Tooltip(
                        message: 'Marcar como concluída',
                        preferBelow: true,
                        triggerMode: TooltipTriggerMode.tap,
                        child: GestureDetector(
                          onTap: () => store.marcarAtividadeComoFeita(agenda.id!),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.check_circle_outline, color: Constants.kPrimaryColor, size: 30),
                          ),
                        ),
                      ),
                    if (!isDone)
                      const Text(
                        'Concluir',
                        style: TextStyle(fontSize: 11, color: Constants.kGreyMedium, fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Constants.kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
