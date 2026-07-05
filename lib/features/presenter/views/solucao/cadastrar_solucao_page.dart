import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/solucao_nome_step.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/solucao_fertilizante_step.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';
import '../../routes/routes.dart';

class CadastrarSolucaoPage extends StatefulWidget {
  final bool isShortcut;
  const CadastrarSolucaoPage({
    super.key,
    this.isShortcut = false,
  });

  @override
  State<CadastrarSolucaoPage> createState() => _CadastrarSolucaoPageState();
}

class _CadastrarSolucaoPageState extends State<CadastrarSolucaoPage> {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  void initState() {
    store.buscarFertilizantes();
    super.initState();
  }

  @override
  void dispose() {
    store.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'Nova Solução Nutritiva',
      onBack: () => Get.back(),
      child: AppStepWizard(
        steps: [
          SolucaoNomeStep(store: store),
          SolucaoFertilizanteStep(store: store),
        ],
        onSubmit: () {
          if (store.validateNewSN()) {
            store.setFertilizantesEscolhidos();
            Get.toNamed(Routes.cadastrarSolucaoConcentradaPage);
          }
        },
        stepLabels: const ['Nome', 'Fertilizantes'],
      ),
    );
  }
}
