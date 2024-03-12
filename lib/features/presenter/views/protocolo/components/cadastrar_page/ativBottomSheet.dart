import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/showFaseBottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

class AtivBottomSheet extends StatefulWidget {
  final bool isNewRecord;
  final bool isFase;

  const AtivBottomSheet({
    Key? key,
    this.isFase = false,
    required this.isNewRecord,
  }) : super(key: key);

  @override
  State<AtivBottomSheet> createState() => _AtivBottomSheetState();
}

class _AtivBottomSheetState extends State<AtivBottomSheet> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    super.initState();
    store.alterarIsNovaFaseBottonSheet(widget.isFase);
    store.alterarRadioIndicator(widget.isFase ? 2 : 1);
  }

  Widget buildAtividadeFase() {
    var size = MediaQuery.of(Get.context!).size;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.close,
                  size: 28,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isNewRecord ? 'Nova Atividade' : 'Editar Atividade',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Observer(builder: (_) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          tileColor: Colors.transparent,
                          selectedTileColor: Colors.transparent,
                          title: const Text('Atividade'),
                          value: 1,
                          activeColor: Colors.green,
                          groupValue: store.radioIndicator,
                          onChanged: (value) {
                            if (value != null) {
                              store.alterarRadioIndicator(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RadioListTile<int>(
                          tileColor: Colors.transparent,
                          selectedTileColor: Colors.transparent,
                          title: const Text('Fase'),
                          value: 2,
                          activeColor: Colors.green,
                          groupValue: store.radioIndicator,
                          onChanged: (value) {
                            if (value != null) {
                              store.alterarRadioIndicator(value);
                              store.alterarIsNovaFaseBottonSheet(true);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text('Selecione a Fase: '),
              Observer(builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DropdownButton<Fase>(
                    isExpanded: true,
                    value: store.selectedFase,
                    alignment: Alignment.center,
                    hint: store.faseDropDownList.isEmpty
                        ? const Text("Crie uma fase ...")
                        : const Text("Selecione uma fase ..."),
                    focusColor: Colors.transparent,
                    iconEnabledColor: Constants.kPrimaryColor,
                    elevation: 16,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    onChanged: (Fase? newValue) {
                      if (newValue != null) {
                        store.alterarDropdownFase(newValue);
                      }
                    },
                    items: store.faseDropDownList
                        .map<DropdownMenuItem<Fase>>((Fase value) {
                      return DropdownMenuItem<Fase>(
                        value: value,
                        child: Text(
                          value.nome ?? "",
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text('Titulo:'),
              Observer(builder: (_) {
                return TextFormField(
                  initialValue: store.novoTituloAtividade,
                  onChanged: store.alterarTituloAtividade,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text('Dia da Atividade:'),
              TextFormField(
                readOnly: true,
                controller: store.diaDaAtivController,
                onTap: () {
                  if (store.selectedFase?.nome != null &&
                      store.selectedFase?.duracao_dias != null) {
                    getBottomSheet(
                      const ShowFaseBottomSheet(),
                    );
                  } else {
                    toastError(
                      message: 'Selecione uma fase para atividade',
                    );
                  }
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: Constants.kPrimaryColor,
                  ),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Descrição:'),
              Observer(builder: (_) {
                return TextFormField(
                  initialValue: store.novoDescricaoAtividade,
                  onChanged: store.alterarDescricaoAtividade,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: SizedBox(
                    width: size.width * .8,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Constants.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Adicionar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        store.addToFaseList();
                        Get.back();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNovaFase() {
    var size = MediaQuery.of(Get.context!).size;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.close,
                  size: 28,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isNewRecord ? 'Nova Fase' : 'Editar Fase',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Observer(builder: (_) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          tileColor: Colors.transparent,
                          selectedTileColor: Colors.transparent,
                          title: const Text('Atividade'),
                          value: 1,
                          activeColor: Colors.green,
                          groupValue: store.radioIndicator,
                          onChanged: (value) {
                            if (value != null) {
                              store.alterarRadioIndicator(value);
                              store.alterarIsNovaFaseBottonSheet(false);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RadioListTile<int>(
                          tileColor: Colors.transparent,
                          selectedTileColor: Colors.transparent,
                          title: const Text('Fase'),
                          value: 2,
                          activeColor: Colors.green,
                          groupValue: store.radioIndicator,
                          onChanged: (value) {
                            if (value != null) {
                              store.alterarRadioIndicator(value);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text('Titulo:'),
              Observer(builder: (_) {
                return TextFormField(
                  initialValue: store.novoTituloFase,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'EX: Fase de Germinação ...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onChanged: store.alterarTituloFase,
                );
              }),
              const SizedBox(height: 16),
              const Text('Total de Dias:'),
              Observer(builder: (_) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Numero de dias da Fase ...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onChanged: (value) {
                    if (value != "") {
                      store.alterarDuracaoDiasFase(int.parse(value));
                    }
                  },
                );
              }),
              // const Padding(
              //   padding: EdgeInsets.only(top: 5.0),
              //   child: Text('Data Prevista: 24/10/2023 - 26/10/2023'),
              // ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: SizedBox(
                    width: size.width * .8,
                    height: 40,
                    child: Observer(builder: (_) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Constants.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          store.registrarFase();
                          store.limparFaseBottomSheet();
                          Get.back();
                        },
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: store.isNovaFaseBottonSheet
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: buildNovaFase(),
        secondChild: buildAtividadeFase(),
      );
    });
  }
}
