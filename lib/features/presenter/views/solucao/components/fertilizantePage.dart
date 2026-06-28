// ignore_for_file: file_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/nutriente/nutriente_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';

import '../../../../../../core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

Widget fertilizantePage(
    BuildContext context, CarouselSliderController controlerPages) {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Qual fertilizante',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '\ndeseja ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
                TextSpan(
                  text: 'adicionar?',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
        // Observer(builder: (_) {
        //   return Padding(
        //     padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
        //     child: TextFormField(
        //       controller: store.pesquisarReceita,
        //       decoration: const InputDecoration(
        //         prefixIcon: Icon(Icons.search),
        //         hintText: 'Pesquisar',
        //         hintStyle: TextStyle(
        //           fontSize: 24,
        //           fontWeight: FontWeight.normal,
        //           fontStyle: FontStyle.italic,
        //         ),
        //       ),
        //     ),
        //   );
        // }),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Fertilizantes Disponíveis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff6F6464),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final loaded = await store.carregarNutrientesCatalogo();
                  if (!loaded || !context.mounted) {
                    return;
                  }

                  _showFertilizanteDialog(
                    context,
                    store: store,
                    title: 'Novo fertilizante',
                    confirmText: 'Criar',
                    onConfirm: (nome, nutrientes) {
                      return store.criarFertilizanteCustomComNutrientes(
                        nome: nome,
                        nutrientes: nutrientes,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo fertilizante'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5F5F5),
              ),
              child: Observer(builder: (_) {
                if (store.isFertilizanteListLoading) {
                  return const AppStatePanel(
                    stateKind: AppStateKind.loading,
                    title: 'Carregando fertilizantes...',
                    isCompact: true,
                  );
                }
                if (store.fertilizanteList.isEmpty) {
                  return const AppStatePanel(
                    stateKind: AppStateKind.empty,
                    title: 'Nenhum fertilizante cadastrado',
                    isCompact: true,
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.fertilizanteList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: index == 0 ? 10 : 0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: index == 0 ? 10 : 0),
                        child: AppFormSelectionTile(
                          leading: Observer(builder: (_) {
                            if (!store.fertilizanteList[index].selected) {
                              return const Icon(
                                  Icons.check_box_outline_blank_rounded);
                            }
                            return const Icon(
                              Icons.check_box,
                              color: Constants.kPrimaryColor,
                            );
                          }),
                          title:
                              store.fertilizanteList[index].fertilizante.nome ??
                                  '---',
                          badge: _buildFertilizanteBadge(
                            store.fertilizanteList[index].fertilizante,
                            store,
                          ),
                          trailing: store.canEditFertilizante(
                                  store.fertilizanteList[index].fertilizante)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'Editar',
                                      onPressed: () async {
                                        final loaded = await store
                                            .carregarNutrientesCatalogo();
                                        if (!loaded || !context.mounted) {
                                          return;
                                        }
                                        _showFertilizanteDialog(
                                          context,
                                          store: store,
                                          title: 'Editar fertilizante',
                                          initialValue: store
                                                  .fertilizanteList[index]
                                                  .fertilizante
                                                  .nome ??
                                              '',
                                          initialNutrientes: store
                                                  .fertilizanteList[index]
                                                  .fertilizante
                                                  .fertilizantes_nutrientes
                                                  ?.map(
                                                    (item) =>
                                                        FertilizanteNutrienteFormItem(
                                                      nutrienteId:
                                                          item.nutriente?.id,
                                                      teor:
                                                          item.teor_nutriente ??
                                                              '',
                                                    ),
                                                  )
                                                  .toList() ??
                                              [],
                                          confirmText: 'Salvar',
                                          onConfirm: (nome, nutrientes) {
                                            return store
                                                .atualizarFertilizanteCustom(
                                              fertilizante: store
                                                  .fertilizanteList[index]
                                                  .fertilizante,
                                              nome: nome,
                                              nutrientes: nutrientes,
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Excluir',
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                          context,
                                          store,
                                          store.fertilizanteList[index]
                                              .fertilizante,
                                        );
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                )
                              : null,
                          onTap: () {
                            store.changeSelecaoFertilizante(
                              index,
                              !store.fertilizanteList[index].selected,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
        // TextButton(
        //   onPressed: () {},
        //   child: const Padding(
        //     padding: EdgeInsets.only(top: 20, left: 20),
        //     child: Text(
        //       'Deseja adicionar uma\nnova Receita?',
        //       style: TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.w600,
        //           decoration: TextDecoration.underline),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

Widget _buildFertilizanteBadge(Fertilizante fertilizante, SolucaoStore store) {
  if (store.isFertilizanteSistema(fertilizante)) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xffE8EAF6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Sistema',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Constants.kPrimaryColor,
        ),
      ),
    );
  }

  if (store.isFertilizanteCustom(fertilizante)) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xffE8F5E9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Custom',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xff2E7D32),
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xffEEEEEE),
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Text(
      'Origem desconhecida',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xff616161),
      ),
    ),
  );
}

Future<void> _showFertilizanteDialog(
  BuildContext context, {
  required SolucaoStore store,
  required String title,
  required String confirmText,
  required Future<bool> Function(
    String nome,
    List<FertilizanteNutrienteFormItem> nutrientes,
  ) onConfirm,
  String initialValue = '',
  List<FertilizanteNutrienteFormItem> initialNutrientes = const [],
}) async {
  final nomeController = TextEditingController(text: initialValue);
  final nutrientes = initialNutrientes
      .map(
        (item) => FertilizanteNutrienteFormItem(
          nutrienteId: item.nutrienteId,
          teor: item.teor,
        ),
      )
      .toList();

  if (nutrientes.isEmpty) {
    nutrientes.add(FertilizanteNutrienteFormItem());
  }

  bool isSubmitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Nome do fertilizante',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nutrientes',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...nutrientes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: AppDropdown<int>(
                                value: store.nutrientesCatalogo.any(
                                  (nutriente) =>
                                      nutriente.id == item.nutrienteId,
                                )
                                    ? item.nutrienteId
                                    : null,
                                labelText: 'Nutriente',
                                items: store.nutrientesCatalogo
                                    .map(
                                      (Nutriente nutriente) =>
                                          DropdownMenuItem<int>(
                                        value: nutriente.id,
                                        child: Text(
                                          '${nutriente.sigla ?? '-'} - ${nutriente.nome ?? 'Sem nome'}',
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: isSubmitting
                                    ? null
                                    : (value) {
                                        setState(() {
                                          nutrientes[index].nutrienteId = value;
                                        });
                                      },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                initialValue: item.teor,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Teor',
                                ),
                                onChanged: (value) {
                                  nutrientes[index].teor = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Remover nutriente',
                              onPressed: isSubmitting || nutrientes.length == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        nutrientes.removeAt(index);
                                      });
                                    },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                setState(() {
                                  nutrientes
                                      .add(FertilizanteNutrienteFormItem());
                                });
                              },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Adicionar nutriente'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);
                        final success = await onConfirm(
                          nomeController.text,
                          nutrientes,
                        );
                        if (success && dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          return;
                        }
                        if (dialogContext.mounted) {
                          setState(() => isSubmitting = false);
                        }
                      },
                child: Text(confirmText),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showDeleteConfirmationDialog(
  BuildContext context,
  SolucaoStore store,
  Fertilizante fertilizante,
) async {
  bool isSubmitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Excluir fertilizante'),
            content: Text(
              'Deseja realmente excluir "${fertilizante.nome ?? 'Não informado'}"?',
            ),
            actions: [
              TextButton(
                onPressed:
                    isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);
                        final success =
                            await store.excluirFertilizanteCustom(fertilizante);
                        if (success && dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          return;
                        }
                        if (dialogContext.mounted) {
                          setState(() => isSubmitting = false);
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          );
        },
      );
    },
  );
}
