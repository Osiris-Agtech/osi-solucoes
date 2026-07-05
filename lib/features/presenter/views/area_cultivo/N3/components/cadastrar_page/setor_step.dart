import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class SetorStep extends StatelessWidget {
  final LoteStore store;
  final GlobalKey<FormFieldState> formKey;

  const SetorStep({super.key, required this.store, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: 'Área de Cultivo e Setor',
      description: 'Selecione a área e o setor onde o lote será alocado',
      isRequired: true,
      child: Observer(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<Area>(
              labelText: 'Área de Cultivo',
              hintText: 'Selecionar',
              value: store.novoLoteArea.id != null ? store.novoLoteArea : null,
              items: store.areaList.map((area) {
                return DropdownMenuItem<Area>(
                  value: area,
                  child: Text(area.nome ?? '-'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  formKey.currentState?.reset();
                  store.selecionarNovoLoteSetor(Setor());
                  store.resetarReservatorio();
                  store.selecionarNovoLoteArea(value);
                }
              },
            ),
            const SizedBox(height: 14),
            AppDropdown<Setor>(
              fieldKey: formKey,
              labelText: 'Setor',
              hintText: 'Selecionar',
              value:
                  store.novoLoteSetor.id != null ? store.novoLoteSetor : null,
              items: (store.novoLoteArea.setores ?? []).map((setor) {
                return DropdownMenuItem<Setor>(
                  value: setor,
                  child: Text(setor.nome ?? '-'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  store.selecionarNovoLoteSetor(value);
                  store.autoPreencherReservatorioDoSetor();
                }
              },
            ),
          ],
        );
      }),
    );
  }
}
