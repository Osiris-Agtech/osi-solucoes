import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';

class CulturaStep extends StatelessWidget {
  final LoteStore store;

  const CulturaStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: 'Cultura',
      description: 'Selecione a cultura que será cultivada neste lote',
      child: Observer(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...store.culturaList.asMap().entries.map((entry) {
              final index = entry.key;
              final cultura = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < store.culturaList.length - 1 ? 8 : 0,
                ),
                child: AppFormSelectionTile(
                  title: cultura.nome ?? '---',
                  isSelected: store.novoLoteCultura.id == cultura.id,
                  onTap: () => store.setNovoLoteCultura(index),
                ),
              );
            }),
            const SizedBox(height: 12),
            store.isNovaCultura
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: store.novaCulturaController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Nome da cultura',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.kPrimaryColor,
                        ),
                        onPressed: store.registrarCultura,
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )
                : TextButton(
                    onPressed: () => store.setIsNovaCultura(true),
                    child: const Text(
                      'Adicionar nova cultura',
                      style: TextStyle(color: Constants.kPrimaryColor),
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
