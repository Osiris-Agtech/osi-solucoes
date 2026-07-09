import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/production_cycle_timeline.dart';

ListView protocoloAtividadeDetalhes(LoteStore store) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Ciclo de produção',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Observer(builder: (_) {
              return ProductionCycleTimeline(
                fases: store.listaFaseDetalhes,
                actions: store.protocoloDetalhes?.acao ?? const <Acao>[],
                emptyMessage:
                    'Este protocolo ainda não possui atividades cadastradas. Edite o protocolo para adicionar fases e atividades antes de vinculá-lo ao cultivo.',
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      )
    ],
  );
}
