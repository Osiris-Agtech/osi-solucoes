import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AtivBottomSheet extends StatefulWidget {
  const AtivBottomSheet({Key? key}) : super(key: key);

  @override
  State<AtivBottomSheet> createState() => _AtivBottomSheetState();
}

class _AtivBottomSheetState extends State<AtivBottomSheet> {
  late int selectedRadio;
  late int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 1;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
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
              const Text(
                'Nova Atividade',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('Atividade'),
                        value: 1,
                        activeColor: Colors.green,
                        groupValue: selectedRadioTile,
                        onChanged: null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('Fase'),
                        value: 2,
                        activeColor: Colors.green,
                        groupValue: selectedRadioTile,
                        onChanged: null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Titulo'),
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
                  onChanged: (String? newValue) async {
                    // if (newValue == store.dropDownValue) {
                    //   store.changeOrder();
                    // } else {
                    //   store.setSearchAreaText('');
                    // }
                    //store.setDropDown(newValue!);
                    //await store.buscarArea();
                  },
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
              const Text('Dias'),
              TextFormField(
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text('Data Prevista: 24/10/2023 - 26/10/2023'),
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
                      onPressed: () {}, //store.registrarReservatorio(),
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
}
