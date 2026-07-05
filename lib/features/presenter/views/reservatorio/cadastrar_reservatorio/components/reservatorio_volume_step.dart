import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class ReservatorioVolumeStep extends StatelessWidget {
  final ReservatoriosStore store;

  const ReservatorioVolumeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppFormSection(
        title: 'Volume',
        description: 'Informe a capacidade total do reservatório.',
        isRequired: true,
        child: Observer(builder: (_) {
          return TextFormField(
            controller: store.novoReservatorioVolume,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Capacidade em litros',
              suffixText: 'Litros',
            ),
          );
        }),
      ),
    );
  }
}
