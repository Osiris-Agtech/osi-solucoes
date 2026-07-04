import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class LoteStep extends StatelessWidget {
  final LoteStore store;

  const LoteStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: 'Identificação do Lote',
      description: 'Dê um nome para identificar o lote',
      isRequired: true,
      child: Observer(builder: (_) {
        return TextFormField(
          initialValue: store.novoLoteName.text,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Ex: L01S01-250721',
          ),
          onChanged: store.alterarNome,
        );
      }),
    );
  }
}
