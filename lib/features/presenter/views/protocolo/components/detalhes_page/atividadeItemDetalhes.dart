// ignore_for_file: file_names

import 'package:flutter/material.dart';
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
                        'Na fase: ${acao.duracao_dias}º dia',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (acao.duracao_dias_real != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'No cultivo: ${acao.duracao_dias_real}º dia',
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
            ],
          ),
        ),
      ),
    ),
  );
}
