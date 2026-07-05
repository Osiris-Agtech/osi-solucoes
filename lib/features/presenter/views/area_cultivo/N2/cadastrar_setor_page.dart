import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/setor_nome_step.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/setor_reservatorio_step.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

class CadastrarSetorPage extends StatefulWidget {
  const CadastrarSetorPage({super.key});

  @override
  State<CadastrarSetorPage> createState() => _CadastrarSetorPageState();
}

class _CadastrarSetorPageState extends State<CadastrarSetorPage> {
  SetorStore store = GetIt.I<SetorStore>();

  @override
  void initState() {
    super.initState();
    store.buscarReservatorios();
  }

  @override
  void dispose() {
    super.dispose();
    store.limparTudo();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: store.isEditing ? 'Alterar Setor' : 'Novo Setor',
      onBack: () => Get.back(),
      child: AppStepWizard(
        steps: [
          SetorNomeStep(store: store),
          SetorReservatorioStep(store: store),
        ],
        onSubmit: () {
          if (store.validarCadastro()) {
            if (store.isEditing) {
              store.alterarSetor();
            } else {
              store.registrarSetor();
            }
          }
        },
        stepLabels: const ['Nome', 'Reservatório'],
      ),
    );
  }
}
