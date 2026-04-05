// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/ativBottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

Padding atividadeItem({
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Dia ${acao.duracao_dias}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (acao.duracao_dias_real != acao.duracao_dias &&
                        acao.duracao_dias_real != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Dia Real ${acao.duracao_dias_real}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  store.alterarAlertaAcao(indexFase, indexAcao);
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
                    store.prepararEditAtiv(indexFase, indexAcao);
                    getBottomSheet(AtivBottomSheet(
                      isNewRecord: false,
                      isFase: false,
                      indexAcao: indexAcao,
                      indexFase: indexFase,
                    ));
                    return;
                  }
                  store.removeAcao(indexAcao, indexFase);
                  store.atualizarNovasAtividades();
                },
                itemBuilder: (_) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('Apagar'),
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
