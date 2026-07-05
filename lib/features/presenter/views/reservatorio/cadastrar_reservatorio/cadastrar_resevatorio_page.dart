import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/reservatorio_nome_step.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/reservatorio_volume_step.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/reservatorio_receita_step.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

class CadastrarReservatorioPage extends StatefulWidget {
  final String title;
  final bool isShortcut;
  const CadastrarReservatorioPage({
    super.key,
    this.title = 'CadastrarReservatorioPage',
    this.isShortcut = false,
  });
  @override
  CadastrarReservatorioPageState createState() =>
      CadastrarReservatorioPageState();
}

class CadastrarReservatorioPageState extends State<CadastrarReservatorioPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();

  @override
  void initState() {
    super.initState();
    store.buscarSolucoes();
  }

  @override
  void dispose() {
    store.limparNovoReservatorio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: store.isEditing ? 'Alterar Reservatório' : 'Novo Reservatório',
      onBack: () => Get.back(),
      child: AppStepWizard(
        steps: [
          ReservatorioNomeStep(store: store),
          ReservatorioVolumeStep(store: store),
          ReservatorioReceitaStep(store: store),
        ],
        onSubmit: () {
          if (store.validarReservatorio()) {
            if (!store.isEditing || widget.isShortcut) {
              store.registrarReservatorio(isShortcut: widget.isShortcut);
            } else {
              store.updateReservatorio();
            }
          }
        },
        stepLabels: const ['Nome', 'Volume', 'Solução'],
      ),
    );
  }
}
