import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class CadernoAutorStep extends StatelessWidget {
  final CadernoCampoStore store;

  const CadernoAutorStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppFormSection(
        title: 'Autor',
        description: 'Selecione o autor da atividade.',
        isRequired: true,
        child: Observer(builder: (_) {
          return AppDropdown<Usuario>(
            value: store.selectedUsuario,
            hint: const Text('Selecionar autor'),
            items: store.usuariosConta.map((Usuario usuario) {
              return DropdownMenuItem<Usuario>(
                value: usuario,
                child: Text(
                  '${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})',
                ),
              );
            }).toList(),
            onChanged: store.selectUser,
          );
        }),
      ),
    );
  }
}
