import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class AreaNomeStep extends StatelessWidget {
  final AreaCultivoStore store;

  const AreaNomeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppFormSection(
            title: 'Identificação da Área',
            description: 'Dê um nome para identificar a área de cultivo.',
            isRequired: true,
            child: Observer(builder: (_) {
              return TextFormField(
                controller: store.novaAreaName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'EX. Estufa UFMT',
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            title: 'Descrição (opcional)',
            child: Observer(builder: (_) {
              return TextFormField(
                controller: store.novaAreaDescricao,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Adicione uma descrição para a área',
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
