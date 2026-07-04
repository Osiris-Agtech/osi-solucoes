import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';

import 'components/cadastrar_page/step_progress_bar.dart';
import 'components/cadastrar_page/step_navigation_footer.dart';
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

  int currentStep = 0;
  final Set<int> completedSteps = {};
  static const int totalSteps = 5;
  static const List<String> stepLabels = [
    'Setor',
    'Lote',
    'Cultura',
    'Reservatório',
    'Protocolo',
  ];

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
        ),
        backgroundColor: Constants.kBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Observer(
                  builder: (_) => Text(
                    store.isEditing ? 'Alterando Lote' : 'Criando Novo Lote',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StepProgressBar(
                currentStep: currentStep,
                stepLabels: stepLabels,
                completedSteps: completedSteps,
                totalSteps: totalSteps,
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(),
              ),
              const SizedBox(height: 24),
              Observer(
                builder: (_) => StepNavigationFooter(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  canGoBack: currentStep > 0,
                  canGoForward: _canGoForward(),
                  isLastStep: currentStep == totalSteps - 1,
                  isLoading: store.isNovoLoteLoading,
                  onBack: _onBack,
                  onNext: _onNext,
                  onSubmit: _onSubmit,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    final stepKey = ValueKey<int>(currentStep);
    switch (currentStep) {
      case 0:
        return SetorStep(key: stepKey, store: store, formKey: formKey);
      case 1:
        return LoteStep(key: stepKey, store: store);
      case 2:
        return CulturaStep(key: stepKey, store: store);
      case 3:
        return ReservatorioStep(key: stepKey, store: store);
      case 4:
        return ProtocoloStep(
            key: stepKey, store: store, protocoloStore: protocoloStore);
      default:
        return const SizedBox.shrink();
    }
  }

  bool _canGoForward() {
    switch (currentStep) {
      case 0:
        return store.validarEtapaSetor();
      case 1:
        return store.validarEtapaLote();
      case 2:
        return store.validarEtapaCultura();
      case 3:
        return true;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _onNext() {
    setState(() {
      completedSteps.add(currentStep);
      currentStep++;
    });
  }

  void _onBack() {
    setState(() {
      currentStep--;
    });
  }

  void _onSubmit() {
    if (store.validarRegistro()) {
      if (store.isEditing) {
        store.alterarLote();
      } else {
        store.registrarLote();
      }
    }
  }
}
