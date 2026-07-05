import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/area_nome_step.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/area_localizacao_step.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

class CadastrarAreaCultivo extends StatefulWidget {
  const CadastrarAreaCultivo({super.key});

  @override
  State<CadastrarAreaCultivo> createState() => _CadastrarAreaCultivoState();
}

class _CadastrarAreaCultivoState extends State<CadastrarAreaCultivo> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  @override
  void initState() {
    super.initState();
    store.buscarLocalizacoes();
  }

  @override
  void dispose() {
    store.limparTudo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: store.isEditing ? 'Alterar Área de Cultivo' : 'Nova Área de Cultivo',
      onBack: () => Get.back(),
      child: AppStepWizard(
        steps: [
          AreaNomeStep(store: store),
          AreaLocalizacaoStep(store: store),
        ],
        onSubmit: () {
          if (store.validarCadastro()) {
            if (store.isEditing) {
              store.alterarArea();
            } else {
              store.registrarArea();
            }
          }
        },
        stepLabels: const ['Nome', 'Localização'],
      ),
    );
  }
}
