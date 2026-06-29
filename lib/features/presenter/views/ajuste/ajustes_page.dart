import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:brasil_fields/brasil_fields.dart';

import '../../models/reservatorio/reservatorio_model.dart';
import '../../viewmodels/ajustes_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_floating_action_button.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_section_header.dart';

class AjustesPage extends StatefulWidget {
  final String title;
  const AjustesPage({super.key, this.title = 'AjustesPage'});
  @override
  AjustesPageState createState() => AjustesPageState();
}

class AjustesPageState extends State<AjustesPage> {
  AjustesStore store = GetIt.I<AjustesStore>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    store.buscarReservatorios();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    store.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Constants.kSecondBackgroundColor,
            floatingActionButton: Observer(builder: (_) {
              return AppFloatingActionButton(
                heroTag: 'calcular_ajuste',
                label: 'Calcular',
                icon: Icons.calculate_outlined,
                onPressed: store.selectedReservatorio.nome != null &&
                        store.selectedReservatorio.nome!.isNotEmpty
                    ? () async {
                        if (store.validarCampos()) {
                          store.calculoAjusteReposicao();
                          store.montandoDescricao();
                          Get.toNamed(Routes.resultadoajustePage);
                        }
                      }
                    : () => toastError(
                        message: 'Selecione um reservatório para o ajuste'),
              );
            }),
            body: Form(
              key: formKey,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  sliverHeader(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppSectionHeader(
                            icon: Icons.checklist_rounded,
                            title: 'Obrigatório',
                            subtitle: 'Campos necessários para o cálculo',
                          ),
                          const SizedBox(height: 12),
                          _adjustmentFieldCard(),
                          const SizedBox(height: 24),
                          const AppSectionHeader(
                            icon: Icons.tune_rounded,
                            title: 'Opcional',
                            subtitle: 'Registre dados complementares',
                          ),
                          const SizedBox(height: 12),
                          _optionalFieldCard(
                            label: 'pH',
                            hint: '8,4',
                            controller: store.pH,
                          ),
                          const SizedBox(height: 12),
                          _temperatureFieldCard(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppPageHeaderSliver sliverHeader() {
    return AppPageHeaderSliver(
      title: 'Ajustes',
      subtitle: 'Selecione e ajuste seu reservatório',
      onBack: () => Get.offNamedUntil(Routes.homePage, (route) => false),
      bottom: PreferredSize(
        // 48 (AppDropdown height) + 12 (bottom padding) = 60
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Observer(builder: (_) {
            return AppDropdown<Reservatorio>(
              value: store.selectedReservatorio.nome != null &&
                      store.selectedReservatorio.nome!.isNotEmpty
                  ? store.selectedReservatorio
                  : null,
              hintText: store.reservatorioList.isNotEmpty
                  ? 'Selecione um reservatório'
                  : 'Nenhum reservatório disponível',
              items: store.reservatorioList.map((reservatorio) {
                return DropdownMenuItem<Reservatorio>(
                  value: reservatorio,
                  child: Text(
                    '${reservatorio.nome ?? ''} - ${reservatorio.volume ?? ''}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  store.selectReservatorio(value);
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _adjustmentFieldCard() {
    return AppPanelCard(
      child: Column(
        children: [
          _fieldPair(
            label: 'C. Elétrico',
            valueLabel1: 'Atual',
            valueLabel2: 'Desejado',
            controller1: store.cEletricoAtual,
            controller2: store.cEletricoDesejado,
            hint1: 'µS/cm',
            hint2: 'µS/cm',
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _fieldPair(
              label: 'Volume',
              valueLabel1: 'Atual',
              valueLabel2: 'Desejado',
              controller1: store.volumeAtual,
              controller2: store.volumeDesejado,
              hint1: 'Litros',
              hint2: 'Litros',
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldPair({
    required String label,
    required String valueLabel1,
    required String valueLabel2,
    required TextEditingController controller1,
    required TextEditingController controller2,
    required String hint1,
    required String hint2,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Constants.kText2,
              ),
            ),
          ),
          const Spacer(),
          _inputGroup(
            label: valueLabel1,
            controller: controller1,
            hint: hint1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.arrow_forward,
              size: 18,
              color: Constants.kPrimaryColor.withValues(alpha: 0.6),
            ),
          ),
          _inputGroup(
            label: valueLabel2,
            controller: controller2,
            hint: hint2,
          ),
        ],
      ),
    );
  }

  Widget _inputGroup({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Constants.kGreyMedium,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(),
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13,
                color: Constants.kGreyText2.withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Constants.kGreyLight.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Constants.kGreyLight.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Constants.kPrimaryColor,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Constants.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionalFieldCard({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return AppPanelCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text(
            'Registrar ',
            style: const TextStyle(
              fontSize: 14,
              color: Constants.kGreyMedium,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Constants.kText2,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 88,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(),
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Constants.kGreyText2.withValues(alpha: 0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Constants.kGreyLight.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Constants.kGreyLight.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Constants.kPrimaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Constants.kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _temperatureFieldCard() {
    return AppPanelCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text(
            'Registrar ',
            style: const TextStyle(
              fontSize: 14,
              color: Constants.kGreyMedium,
            ),
          ),
          const Text(
            'Temperatura',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Constants.kText2,
            ),
          ),
          const Spacer(),
          Observer(builder: (_) {
            return AppInlineDropdown<int>(
              value: store.selectedItem,
              items: store.quantityList.map((int e) {
                return DropdownMenuItem<int>(
                  value: e,
                  child: Text("$e ºC"),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) store.newValueItem(newValue);
              },
            );
          }),
        ],
      ),
    );
  }
}
