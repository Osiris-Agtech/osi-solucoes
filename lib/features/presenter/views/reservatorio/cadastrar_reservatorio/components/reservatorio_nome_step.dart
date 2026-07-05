import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class ReservatorioNomeStep extends StatelessWidget {
  final ReservatoriosStore store;

  const ReservatorioNomeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppFormSection(
        title: 'Identificação do Reservatório',
        description: 'Dê um nome para identificar o reservatório.',
        isRequired: true,
        child: Observer(builder: (_) {
          return TextFormField(
            controller: store.novoReservatorioName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'EX. Tanque A',
            ),
          );
        }),
      ),
    );
  }
}
