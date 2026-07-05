import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

import 'components/cadastrar_page/setor_step.dart';
import 'components/cadastrar_page/lote_step.dart';
import 'components/cadastrar_page/cultura_step.dart';
import 'components/cadastrar_page/reservatorio_step.dart';
import 'components/cadastrar_page/protocolo_step.dart';

class CadastrarLotePage extends StatefulWidget {
  const CadastrarLotePage({super.key});

  @override
  State<CadastrarLotePage> createState() => _CadastrarLotePageState();
}

class _CadastrarLotePageState extends State<CadastrarLotePage> {
  final LoteStore store = GetIt.I<LoteStore>();
  final ProtocoloStore protocoloStore = GetIt.I<ProtocoloStore>();
  final GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    store.buscarAreasList().then((_) => store.carregarAreaSetor());
    store.buscarCulturas();
    store.buscarReservatorios();
    protocoloStore.buscarProtocolos();
  }

  @override
  void dispose() {
    store.limparTudo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppFormHeader(
          onBack: () {
            Get.close(1);
            store.limparTudo();
          },
          title: store.isEditing ? 'Alterando Lote' : 'Criando Novo Lote',
        ),
        backgroundColor: Constants.kBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: AppStepWizard(
                steps: [
                  SetorStep(store: store, formKey: formKey),
                  ReservatorioStep(store: store),
                  LoteStep(store: store),
                  CulturaStep(store: store),
                  ProtocoloStep(store: store, protocoloStore: protocoloStore),
                ],
                onSubmit: () {
                  if (store.validarRegistro()) {
                    if (store.isEditing) {
                      store.alterarLote();
                    } else {
                      store.registrarLote();
                    }
                  }
                },
                stepLabels: const [
                  'Setor',
                  'Reservatório',
                  'Lote',
                  'Cultura',
                  'Protocolo',
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
