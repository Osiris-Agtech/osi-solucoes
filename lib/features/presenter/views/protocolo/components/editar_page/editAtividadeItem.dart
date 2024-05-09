// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/editar_page/editAtivBottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

Padding editAtividadeItem({
  required int indexFase,
  required int indexAcao,
  required Acao acao,
  required ProtocoloStore store,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: indexAcao == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
                        left: 5.0,
                        bottom: 8.0,
                        top: 5.0,
                      ),
                      child: Text(
                        acao.titulo ?? "---",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Dia ${acao.duracao_dias}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  store.alterarAlertaAcaoDetalhes(indexFase, indexAcao);
                },
                child: Icon(
                  acao.alerta ?? false
                      ? Icons.notifications
                      : Icons.notifications_off,
                  size: 20,
                  color: acao.alerta ?? false
                      ? Constants.kPrimaryColor
                      : Constants.kButtonGrey,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Constants.kPrimaryColor,
                ),
                onSelected: (newValue) {
                  if (newValue == 1) {
                    store.prepararEditDetalhesAtiv(indexFase, indexAcao);
                    getBottomSheet(EditAtivBottomSheet(
                      isNewRecord: false,
                      isFase: false,
                      indexAcao: indexAcao,
                      indexFase: indexFase,
                    ));
                    return;
                  }
                  store.removeAcaoDetalhes(indexAcao, indexFase);
                  store.atualizarNovasAtividadesDetalhes();
                },
                itemBuilder: (_) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: Text('Editar'),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text('Apagar'),
                    value: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
