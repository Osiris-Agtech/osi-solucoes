import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class SolucaoNomeStep extends StatelessWidget {
  final SolucaoStore store;

  const SolucaoNomeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppFormSection(
        title: 'Identificação da Solução',
        description: 'Dê um nome para identificar a solução nutritiva.',
        isRequired: true,
        child: Observer(builder: (_) {
          return TextFormField(
            controller: store.novaSolucaoName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'EX. Solução para alface',
            ),
          );
        }),
      ),
    );
  }
}
