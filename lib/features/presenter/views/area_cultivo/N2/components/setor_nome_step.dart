import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class SetorNomeStep extends StatelessWidget {
  final SetorStore store;

  const SetorNomeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppFormSection(
            title: 'Identificação do Setor',
            description: 'Dê um nome para identificar o setor.',
            isRequired: true,
            child: Observer(builder: (_) {
              return TextFormField(
                controller: store.novoSetorName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'EX. Setor de Crescimento',
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            title: 'Descrição (opcional)',
            child: Observer(builder: (_) {
              return TextFormField(
                controller: store.novoSetorDescription,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Adicione uma descrição para o setor',
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
