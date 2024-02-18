import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/area/area_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/setor/setor_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/lote_store.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    LoteStore store = GetIt.I<LoteStore>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                alignment: Alignment.topLeft,
                icon: const Icon(
                  Icons.close,
                  size: 24,
                ),
                color: Constants.kPrimaryColor,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Migrar Lote',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                store.loteSelecionado.nome ?? '---',
                style: const TextStyle(
                  color: Constants.kText2,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Localização Atual:',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      store.loteSelecionado.setor?.area?.nome ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Estufa',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        "assets/icons/greenhouse1_icon.png",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      store.loteSelecionado.setor?.nome ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Setor',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        "assets/icons/hydroponic1_icon.png",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Selecione o novo local',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF5F5F5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Área de\n Cultivo:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 150,
                                child: Observer(builder: (_) {
                                  return DropdownButtonFormField<Area>(
                                    hint: const Text(
                                      'Selecionar',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    isExpanded: true,
                                    iconEnabledColor: Constants.kPrimaryColor,
                                    items: store.areaList.map((Area item) {
                                      return DropdownMenuItem<Area>(
                                        value: item,
                                        child: Text(
                                          item.nome ?? '',
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _key.currentState?.reset();
                                        store.selecionarArea(value);
                                        store.isVisible = true;
                                      }
                                    },
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Observer(builder: (_) {
                        return Visibility(
                          visible: store.isVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Setor:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 150,
                                    child: DropdownButtonFormField<Setor>(
                                      key: _key,
                                      hint: const Text(
                                        'Selecionar',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      isExpanded: true,
                                      iconEnabledColor: Constants.kPrimaryColor,
                                      items:
                                          (store.areaSelecionada.setores ?? [])
                                              .map((Setor item) {
                                        return DropdownMenuItem<Setor>(
                                          value: item,
                                          child: Text(
                                            item.nome ?? '',
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          store.selecionarSetorMigrar(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Constants.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Observer(builder: (_) {
                      if (store.isMigrateLoteLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const Text(
                        "Migrar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Deseja alterar reservatório ?",
                              style: TextStyle(
                                color: Constants.kText2,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: const Text(
                              "Caso aceite, o reservatório do lote será alterado automaticamente para o reservatório vinculado ao setor escolhido",
                              style: TextStyle(
                                color: Constants.kGreyText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "Sim",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  store.migrarLote(true);
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Não",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  store.migrarLote(false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
