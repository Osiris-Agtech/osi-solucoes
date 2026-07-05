import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class SetorReservatorioStep extends StatelessWidget {
  final SetorStore store;

  const SetorReservatorioStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppFormSection(
        title: 'Reservatório',
        description: 'Vincule um reservatório ao setor (opcional).',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(builder: (_) {
              return AppDropdown<Reservatorio>(
                value: store.novoSetorReservatorio.id != null
                    ? store.reservatorioList.firstWhere(
                        (element) => element.id == store.novoSetorReservatorio.id,
                        orElse: () => store.reservatorioList.isNotEmpty
                            ? store.reservatorioList.first
                            : Reservatorio(),
                      )
                    : null,
                hint: const Text('Selecionar reservatório'),
                items: store.reservatorioList.map((Reservatorio item) {
                  return DropdownMenuItem<Reservatorio>(
                    value: item,
                    child: Text(item.nome ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    store.setReservatorioSelecionada(value);
                  }
                },
              );
            }),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.to(() => const CadastrarReservatorioPage(isShortcut: true)),
              child: const Text(
                'Criar novo reservatório',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
