import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_section_header.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class ProtocolLinkedLotsSection extends StatelessWidget {
  final List<Lote> lotes;

  const ProtocolLinkedLotsSection({super.key, required this.lotes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Cultivos vinculados',
          subtitle: 'Lotes que utilizam este protocolo',
          icon: Icons.grass_outlined,
        ),
        AppPanelCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: lotes.isEmpty
              ? const AppStatePanel(
                  stateKind: AppStateKind.empty,
                  icon: Icons.link_off_outlined,
                  title: 'Nenhum cultivo vinculado',
                  message:
                      'Este protocolo ainda não está vinculado a lotes ou cultivos.',
                  isCompact: true,
                )
              : Column(
                  children: lotes.asMap().entries.map((entry) {
                    return _LinkedLotItem(
                      lote: entry.value,
                      isLast: entry.key == lotes.length - 1,
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _LinkedLotItem extends StatelessWidget {
  final Lote lote;
  final bool isLast;

  const _LinkedLotItem({required this.lote, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final cultura = lote.cultura?.nome ?? 'Cultura não informada';

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.eco_outlined,
            color: Constants.kPrimaryColor,
          ),
          title: Text(
            lote.nome ?? 'Lote sem nome',
            style: const TextStyle(
              fontSize: 16,
              color: Constants.kText2,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(
            'Cultura: $cultura',
            style: const TextStyle(
              fontSize: 13,
              color: Constants.kGreyText2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: Constants.kSecondBackgroundColor),
      ],
    );
  }
}
