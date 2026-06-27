import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/detalhes_solucao.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_icon_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

class SolucaoReceitaCard extends StatefulWidget {
  final SolucaoNutritiva solucaoNutritiva;

  const SolucaoReceitaCard({super.key, required this.solucaoNutritiva});

  @override
  State<SolucaoReceitaCard> createState() => _SolucaoReceitaCardState();
}

class _SolucaoReceitaCardState extends State<SolucaoReceitaCard> {
  final SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  Widget build(BuildContext context) {
    return AppPanelCard(
      onTap: () {
        store.selecionarSolucao(widget.solucaoNutritiva);
        store.buscarDetalhesSolucao();
        getBottomSheet(const DetalhesSolucao());
      },
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconTile(
            asset: 'assets/icons/solucoes_nutritivas_icon.svg',
            semanticLabel: 'Solução nutritiva',
            size: 44,
            iconSize: 26,
          ),
          const SizedBox(height: 8),
          Text(
            widget.solucaoNutritiva.nome ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Constants.kGreyText,
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Reservatórios\nativos: ',
                  style: TextStyle(color: Constants.kGreyMedium),
                ),
                TextSpan(
                  text: '${widget.solucaoNutritiva.reservatorios?.length ?? 0}',
                  style: const TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
