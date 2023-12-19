import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';

class DetalhesBottomSheet extends StatefulWidget {
  const DetalhesBottomSheet({Key? key}) : super(key: key);

  @override
  State<DetalhesBottomSheet> createState() => _DetalhesBottomSheetState();
}

class _DetalhesBottomSheetState extends State<DetalhesBottomSheet> {
  late int selectedRadio;
  late int selectedRadioTile;
  final AgendaStore store = GetIt.I<AgendaStore>();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 1;
  }

  Widget buildScrollableContent() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.close,
                size: 28,
                color: Constants.kPrimaryColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Detalhes da ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              Text(
                'Atividade',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    store.setShowEditPage(true);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        child: Icon(
                          Icons.edit,
                          color: Constants.kPrimaryColor,
                        ),
                        backgroundColor: Constants.kCardColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Editar',
                        style: TextStyle(
                          color: Constants.kGreyText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 36,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        child: Icon(
                          Icons.delete,
                          color: Constants.kGreyLight,
                        ),
                        backgroundColor: Constants.kCardColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Excluir',
                        style: TextStyle(
                          color: Constants.kGreyText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(child: Text("Título")),
                    Text(
                      "Realizar transplantio",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(child: Text("Data")),
                    Text(
                      "09 ago 2023",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text("Teste"),
                        SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Miguel Ribeiro",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Administrador"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Descrição',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.kCardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [Text('Teste')],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Center(
              child: SizedBox(
                width: size.width * .8,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Constants.kCardColor,
                    side: const BorderSide(
                        color: Constants.kPrimaryColor), // Borda verde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {}, //store.registrarReservatorio(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check,
                          color: Constants.kPrimaryColor), // Ícone de check
                      SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                      Text(
                        "Marcar como feito",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Constants.kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScrollableContent2() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.close,
                size: 28,
                color: Constants.kPrimaryColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Editar ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              Text(
                'Atividade',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Título',
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Constants.kCardColor),
                      color: Constants.kCardColor, // Cor do retângulo
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black), // Cor do texto do TextField
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Digite aqui",
                          hintStyle: TextStyle(
                              color: Colors.black), // Cor do texto de dica
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Constants.kCardColor),
                      color: Constants.kCardColor,
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Responsável',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              isExpanded: true,
              alignment: Alignment.center,
              value: 'Hidroponia',
              focusColor: Colors.transparent,
              iconEnabledColor: Constants.kPrimaryColor,
              elevation: 16,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onChanged: (String? newValue) async {},
              items: <String>['Hidroponia', 'teste 2']
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descrição',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Constants.kCardColor),
                      color: Constants.kCardColor, // Cor do retângulo
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black), // Cor do texto do TextField
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Digite aqui",
                          hintStyle: TextStyle(
                              color: Colors.black), // Cor do texto de dica
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
                    "Atualizar",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  onPressed: () {}, //store.registrarReservatorio(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2021, 1, 1),
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: !store.showEditPage
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: buildScrollableContent(),
        secondChild: buildScrollableContent2(),
      );
    });
  }
}
