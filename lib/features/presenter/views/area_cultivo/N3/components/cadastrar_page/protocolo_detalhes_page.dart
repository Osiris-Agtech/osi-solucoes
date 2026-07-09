import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_cycle_preview.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_linked_lots_section.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/production_cycle_timeline.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/protocol_operational_summary.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';

ListView protocoloDetalhes(LoteStore store) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: [
      Observer(builder: (_) {
        final showTimeline = store.abrirProtocoloDetalhesAtv;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProtocolOperationalSummary(
                protocolo: store.protocoloDetalhes,
                fases: store.listaFaseDetalhes,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppPrimaryButton(
                  label: showTimeline ? 'Recolher' : 'Ver ciclo de produção',
                  icon: showTimeline
                      ? Icons.expand_less
                      : Icons.timeline_outlined,
                  onPressed: () {
                    if (!showTimeline) {
                      store.prepararListaDetalhesFase();
                    }
                    store.toggleAbrirProtocoloDetalhesAtv();
                  },
                ),
              ),
              const SizedBox(height: 8),
              if (showTimeline)
                ProductionCycleTimeline(
                  fases: store.listaFaseDetalhes,
                  actions: store.protocoloDetalhes?.acao ?? const <Acao>[],
                )
              else
                ProtocolCyclePreview(fases: store.listaFaseDetalhes),
              const SizedBox(height: 8),
              ProtocolLinkedLotsSection(
                lotes: store.protocoloDetalhes?.lotes ?? [],
              ),
            ],
          ),
        );
      }),
    ],
  );
}

void showProtocoloDetalhesSheet(
    BuildContext context, LoteStore store, ProtocoloStore? _) {
  store.prepararListaDetalhesFase();
  AppModalSheet.show(
    title: 'Detalhes do Protocolo',
    body: protocoloDetalhes(store),
    maxHeightFactor: 0.75,
    bottomWidget: Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Observer(builder: (_) {
        final isSelected =
            store.protocoloVinculado?.id == store.protocoloDetalhes?.id;
        return AppPrimaryButton(
          label: isSelected ? 'Desvincular' : 'Vincular ao lote',
          tone: isSelected ? AppButtonTone.danger : AppButtonTone.primary,
          onPressed: () {
            if (isSelected) {
              store.protocoloVinculado = null;
              toastSuccess(message: 'Protocolo desvinculado');
            } else if (store.protocoloDetalhes != null) {
              store.setProtocolo(store.protocoloDetalhes!);
              toastSuccess(message: 'Protocolo vinculado com sucesso');
            }
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        );
      }),
    ),
  );
}
