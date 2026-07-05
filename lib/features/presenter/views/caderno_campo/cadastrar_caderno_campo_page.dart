import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/caderno_atividade_step.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/caderno_autor_step.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/caderno_lote_step.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

class CadastroCadernoCampoPage extends StatefulWidget {
  const CadastroCadernoCampoPage({super.key});

  @override
  State<CadastroCadernoCampoPage> createState() =>
      _CadastroCadernoCampoPageState();
}

class _CadastroCadernoCampoPageState extends State<CadastroCadernoCampoPage> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.groupLotesBy();
      store.buscarUsuariosConta();
    });
  }

  @override
  void dispose() {
    store.limparTudo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: store.isEditing ? 'Alterar Registro' : 'Novo Registro',
      onBack: () => Get.back(),
      child: AppStepWizard(
        steps: [
          CadernoAtividadeStep(store: store),
          CadernoAutorStep(store: store),
          CadernoLoteStep(store: store),
        ],
        onSubmit: () {
          if (!store.validarCadastro()) {
            toastError(message: 'Preencha todos os campos corretamente');
            return;
          }
          if (store.isEditing) {
            // store.alterarAtividade();
          } else {
            store.cadastrarAtividade();
          }
        },
        stepLabels: const ['Atividade', 'Autor', 'Lotes'],
      ),
    );
  }
}
