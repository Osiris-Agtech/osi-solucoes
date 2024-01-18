import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
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
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: DropdownButton<String>(
                  isExpanded: true,
                  alignment: Alignment.center,
                  value: 'Germinação (5 dias)',
                  focusColor: Colors.transparent,
                  iconEnabledColor: Constants.kPrimaryColor,
                  elevation: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  onChanged: (String? newValue) {},
                  items: <String>['Germinação (5 dias)', 'Germinação (2 dias)']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Titulo:'),
              TextFormField(
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
              ),
              const SizedBox(height: 16),
              const Text('Dia:'),
              TextFormField(
                onTap: () {
                  getBottomSheet(
                    const ShowFaseBottomSheet(),
                  );
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
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
              TextFormField(
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
              ),
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
                      onPressed: () {},
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
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return store.mockList.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                },
              ),
              const SizedBox(height: 16),
              const Text('Total de Dias:'),
              InkWell(
                child: TextFormField(
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
                ),
              ),
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
                      onPressed: () {},
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
