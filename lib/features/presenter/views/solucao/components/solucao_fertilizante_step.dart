import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class SolucaoFertilizanteStep extends StatelessWidget {
  final SolucaoStore store;

  const SolucaoFertilizanteStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppFormSection(
            title: 'Fertilizantes',
            description: 'Selecione os fertilizantes para esta solução.',
            child: Observer(builder: (_) {
              if (store.isFertilizanteListLoading) {
                return const AppStatePanel(
                  stateKind: AppStateKind.loading,
                  title: 'Carregando fertilizantes...',
                  isCompact: true,
                );
              }
              return _buildContent();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (store.fertilizanteList.isEmpty) {
      return const AppStatePanel(
        stateKind: AppStateKind.empty,
        title: 'Nenhum fertilizante cadastrado',
        isCompact: true,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(store.fertilizanteList.length, (index) {
          final selecao = store.fertilizanteList[index];
          final fert = selecao.fertilizante;
          final isSelected = selecao.selected;
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 4),
            child: Card(
              elevation: 0,
              color: isSelected
                  ? Constants.kPrimaryColor.withValues(alpha: 0.06)
                  : Constants.kSecondBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isSelected
                    ? const BorderSide(color: Constants.kPrimaryColor)
                    : BorderSide.none,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () =>
                    store.changeSelecaoFertilizante(index, !isSelected),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank_rounded,
                        color: isSelected
                            ? Constants.kPrimaryColor
                            : Constants.kGreyText2,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          fert.nome ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Constants.kText2,
                          ),
                        ),
                      ),
                      if (isSelected)
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            initialValue: store.expandedFertilizantes
                                .firstWhere(
                                  (f) => f.fertilizante.id == fert.id,
                                  orElse: () => ItemFertilizante(
                                    fertilizante: fert,
                                    quantidade: '0',
                                  ),
                                )
                                .quantidade,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'mg/L',
                              hintStyle: TextStyle(fontSize: 12),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              if (fert.id != null) {
                                store.setFertilizanteQuantidade(
                                    fert.id!, value);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
