import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

import 'protocolo_detalhes_page.dart';

class ProtocoloStep extends StatelessWidget {
  final LoteStore store;
  final ProtocoloStore protocoloStore;

  const ProtocoloStep({
    super.key,
    required this.store,
    required this.protocoloStore,
  });

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: 'Protocolo',
      description: 'Vincule um protocolo de cultivo ao lote (opcional)',
      child: Observer(builder: (_) {
        final isLoading = protocoloStore.isProtocoloListLoading;
        final protocolos = protocoloStore.getProtocoloGroup;
        final selectedProtocoloId = store.protocoloVinculado?.id;

        if (isLoading) {
          return const AppStatePanel(
            stateKind: AppStateKind.loading,
            title: 'Carregando protocolos...',
          );
        }

        if (protocolos.isEmpty) {
          return const AppStatePanel(
            stateKind: AppStateKind.empty,
            title: 'Nenhum protocolo encontrado',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildProtocoloList(context, protocolos, selectedProtocoloId),
          ],
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      onChanged: (value) => protocoloStore.setSeachProtocoloPage(value),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Buscar protocolo...',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _buildProtocoloList(
    BuildContext context,
    List<Protocolo> protocolos,
    int? selectedProtocoloId,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: protocolos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final protocolo = protocolos[index];
        final isSelected = selectedProtocoloId == protocolo.id;

        return AppFormSelectionTile(
          title: protocolo.nome ?? '---',
          subtitle: 'Cultura: ${protocolo.cultura?.nome ?? '---'}',
          isSelected: isSelected,
          badge: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF26C165)
                  : const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${protocolo.lotes.length} lote${protocolo.lotes.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF888888),
              ),
            ),
          ),
          onTap: () {
            store.setProtocoloDetalhes(protocolo);
            showProtocoloDetalhesSheet(context, store, protocoloStore);
          },
        );
      },
    );
  }
}
