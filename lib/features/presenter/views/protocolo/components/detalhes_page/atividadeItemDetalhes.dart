// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';

Padding atividadeItemDetalhes({
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
              ],
            ),
          ),
        ),
      );
    }),
  );
}
