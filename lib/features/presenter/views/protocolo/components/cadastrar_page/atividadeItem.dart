import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/ativBottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

Padding atividadeItem({
  required int indexFase,
  required int indexAcao,
  required Acao acao,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: indexAcao == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: Observer(builder: (_) {
      ProtocoloStore store = GetIt.I<ProtocoloStore>();
      return InkWell(
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
                Observer(builder: (_) {
                  return InkWell(
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
                  );
                }),
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
      );
    }),
  );
}
