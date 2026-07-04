import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

import 'reservatorio_detalhes_page.dart';

class ReservatorioStep extends StatelessWidget {
  final LoteStore store;

  const ReservatorioStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: 'Reservatório',
      description: 'Vincule um reservatório ao lote (opcional)',
      child: Observer(builder: (_) {
        if (store.reservatorioList.isEmpty) {
          return const AppStatePanel(
            stateKind: AppStateKind.empty,
            title: 'Nenhum reservatório cadastrado',
          );
        }
        // Lê o observable DENTRO do builder do Observer para registrar
        // a dependência. O valor é capturado e usado no itemBuilder,
        // que executa fora do contexto de reação.
        final selectedReservatorioId = store.novoLoteReservatorio.id;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: store.reservatorioList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final reservatorio = store.reservatorioList[index];
            final isSelected = selectedReservatorioId != null &&
                selectedReservatorioId == reservatorio.id;

            return AppFormSelectionTile(
              title: reservatorio.nome ?? '---',
              subtitle: 'Volume: ${reservatorio.volume ?? '---'} litros',
              isSelected: isSelected,
              onTap: () {
                store.setReservatorioDetalhes(reservatorio);
                store.buscarReservatorioDetalhes();
                showReservatorioDetalhesSheet(context, store);
              },
            );
          },
        );
      }),
    );
  }
}
