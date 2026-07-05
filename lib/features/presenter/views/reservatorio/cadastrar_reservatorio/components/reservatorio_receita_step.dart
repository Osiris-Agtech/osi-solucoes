import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/cadastrar_solucao_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class ReservatorioReceitaStep extends StatefulWidget {
  final ReservatoriosStore store;

  const ReservatorioReceitaStep({super.key, required this.store});

  @override
  State<ReservatorioReceitaStep> createState() => _ReservatorioReceitaStepState();
}

class _ReservatorioReceitaStepState extends State<ReservatorioReceitaStep> {
  @override
  void initState() {
    super.initState();
    widget.store.buscarSolucoes();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppFormSection(
            title: 'Solução Nutritiva',
            description: 'Selecione a solução nutritiva base para o reservatório.',
            child: Observer(builder: (_) {
              if (store.isSolucaoListLoading) {
                return const AppStatePanel(
                  stateKind: AppStateKind.loading,
                  title: 'Carregando soluções...',
                  isCompact: true,
                );
              }
              if (store.solucaoList.isEmpty) {
                return const AppStatePanel(
                  stateKind: AppStateKind.empty,
                  title: 'Nenhuma solução cadastrada',
                  isCompact: true,
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: store.solucaoList.length,
                itemBuilder: (context, index) {
                  final solucao = store.solucaoList[index];
                  final isSelected =
                      store.solucaoNutritiva.id == solucao.id;
                  return Card(
                    elevation: isSelected ? 2 : 0,
                    color: isSelected
                        ? Constants.kPrimaryColor.withValues(alpha: 0.08)
                        : Constants.kCardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: isSelected
                          ? const BorderSide(color: Constants.kPrimaryColor)
                          : BorderSide.none,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => store.setSolucaoDetalhes(solucao),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? Constants.kPrimaryColor
                                  : Constants.kGreyText2,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    solucao.nome ?? '---',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Constants.kText2,
                                    ),
                                  ),
                                  if (solucao.c_eletrica != null)
                                    Text(
                                      'C. elétrica: ${solucao.c_eletrica} S.m/mm2',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Constants.kGreyText2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                Get.to(() => const CadastrarSolucaoPage(isShortcut: true)),
            child: const Text(
              'Criar nova solução nutritiva',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Constants.kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
