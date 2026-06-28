// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:intl/intl.dart';

import '../../../models/usuario/usuario_model.dart';
import '../../../widgets/date_picker.dart';
import '../../../widgets/common/app_dropdown.dart';

class DetalhesBottomSheet extends StatefulWidget {
  const DetalhesBottomSheet({super.key, this.agenda});

  final Agenda? agenda;

  @override
  State<DetalhesBottomSheet> createState() => _DetalhesBottomSheetState();
}

class _DetalhesBottomSheetState extends State<DetalhesBottomSheet> {
  final AgendaStore store = GetIt.I<AgendaStore>();
  final _formKey = GlobalKey<FormState>();
  // late int selectedRadio;
  // late int selectedRadioTile;
  // DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // selectedRadio = 0;
    // selectedRadioTile = 1;
  }

  Widget buildScrollableContent() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
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
          Visibility(
            visible: widget.agenda != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (widget.agenda != null) {
                          store.carregarDadosDaAtividade(widget.agenda!);
                        }
                        store.setShowEditPage(true);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Constants.kCardColor,
                            child: Icon(
                              Icons.edit,
                              color: Constants.kPrimaryColor,
                            ),
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Deletar Atividade',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              'Deseja deletar esta atividade ?',
                              style: TextStyle(
                                color: Constants.kGreyText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (widget.agenda == null) return;
                                  Get.back();
                                  store.deletarAtividade(widget.agenda!.id!);
                                },
                                child: const Text(
                                  'Sim',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  'Não',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Constants.kCardColor,
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Constants.kErrorColor,
                            ),
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
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Constants.kText2,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "Título",
                        style: TextStyle(
                          fontSize: 16,
                          color: Constants.kGreyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      widget.agenda?.titulo ?? "---",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "Data",
                        style: TextStyle(
                          fontSize: 16,
                          color: Constants.kGreyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      widget.agenda != null
                          ? DateFormat("dd MMM y", 'pt_br')
                                  .format(
                                    widget.agenda!.data!,
                                  )
                                  .capitalize ??
                              ''
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Text(
                      "Responsável",
                      style: TextStyle(
                        fontSize: 16,
                        color: Constants.kGreyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Spacer(),
                    widget.agenda?.usuario?.pessoa?.imagem != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              widget.agenda?.usuario?.pessoa?.imagem ?? '',
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.kGreyLight,
                              boxShadow: [
                                BoxShadow(
                                  color: Constants.kGreyMedium
                                      .withValues(alpha: .5),
                                  blurRadius: 3,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.agenda?.usuario?.nome ?? "Sem responsável",
                          style: const TextStyle(
                            color: Constants.kText2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.agenda?.usuario?.selected_conta?.cargo
                                  ?.cargo ??
                              " ---",
                          style: const TextStyle(
                            color: Constants.kText2,
                            fontWeight: FontWeight.normal,
                          ),
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
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Constants.kGreyText,
                    fontWeight: FontWeight.w800,
                  ),
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
              padding: EdgeInsets.symmetric(
                vertical: (widget.agenda?.descricao ?? '').isEmpty ? 100 : 16,
                horizontal: 24,
              ),
              child: Text(
                widget.agenda?.descricao ?? "Sem descrição",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Constants.kText2,
                  fontWeight: FontWeight.w500,
                ),
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
                    backgroundColor: Constants.kBackgroundColor,
                    side: BorderSide(
                      color: (widget.agenda?.finalizado ?? false)
                          ? Constants.kGreyMedium
                          : Constants.kPrimaryColor,
                    ), // Borda verde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: (widget.agenda?.finalizado ?? false)
                      ? null
                      : () {
                          if (widget.agenda != null) {
                            store.marcarAtividadeComoFeita(widget.agenda!.id!);
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 28,
                        color: (widget.agenda?.finalizado ?? false)
                            ? Constants.kGreyMedium
                            : Constants.kPrimaryColor,
                      ), // Ícone de check
                      const SizedBox(
                          width: 8), // Espaçamento entre o ícone e o texto
                      Text(
                        "Marcar como feito",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: (widget.agenda?.finalizado ?? false)
                              ? Constants.kGreyMedium
                              : Constants.kPrimaryColor,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Título',
                    style: TextStyle(
                      fontSize: 16,
                      color: Constants.kText2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Constants.kCardColor),
                      color: Constants.kCardColor, // Cor do retângulo
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Observer(builder: (_) {
                        return TextFormField(
                          controller: store.tituloController,
                          style: const TextStyle(
                              color: Colors.black), // Cor do texto do TextField
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Digite aqui",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ), // Cor do texto de dica
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Constants.kText2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      DateTime? dateTime = await datePicker(
                        context: context,
                        title: 'Data da Atividade',
                        initialDate: widget.agenda?.data ?? DateTime.now(),
                        // phaseColors: store.calcularFases(widget.agenda),
                        // subtitle: store.calularSubtitulo(widget.agenda),
                      );
                      if (dateTime != null) {
                        store.setDataAtividade(dateTime);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(width: 2, color: Constants.kCardColor),
                        color: Constants.kCardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Observer(builder: (_) {
                                return Text(
                                  store.dataAtividade != null
                                      ? DateFormat("dd/MM/y", 'pt_br')
                                              .format(
                                                store.dataAtividade!,
                                              )
                                              .capitalize ??
                                          ''
                                      : 'Selecione a data',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // const TextStyle(color: Constants.kGreyText),
                                );
                              }),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Constants.kPrimaryColor,
                            ),
                          ],
                        ),
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
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Responsável',
                style: TextStyle(
                  fontSize: 16,
                  color: Constants.kText2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Observer(builder: (_) {
                return AppDropdown<Usuario>(
                  value: store.usuarioAtividade,
                  hint: const Text(
                    'Selecionar Responsável',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  items: store.usuariosConta.map((Usuario usuario) {
                    return DropdownMenuItem<Usuario>(
                      value: usuario,
                      child: Text(
                          '${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})'),
                    );
                  }).toList(),
                  onChanged: store.setUsuarioAtividade,
                  validator: (value) {
                    if (value == null) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                );
              }),
              // child: DropdownButton<String>(
              //   isExpanded: true,
              //   alignment: Alignment.center,
              //   value: 'Hidroponia',
              //   focusColor: Colors.transparent,
              //   iconEnabledColor: Constants.kPrimaryColor,
              //   elevation: 16,
              //   borderRadius: const BorderRadius.all(Radius.circular(5)),
              //   onChanged: (String? newValue) async {},
              //   items: <String>['Hidroponia', 'teste 2']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //       ),
              //     );
              //   }).toList(),
              // ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 16,
                      color: Constants.kText2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Constants.kCardColor),
                      color: Constants.kCardColor, // Cor do retângulo
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Observer(builder: (_) {
                        return TextFormField(
                          controller: store.descricaoController,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Digite aqui",
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        );
                      }),
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
                      backgroundColor: Constants.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      widget.agenda != null ? "Atualizar" : "Cadastrar",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (widget.agenda != null) {
                        store.editAgenda(widget.agenda!);
                      } else {
                        store.cadastrarAtividade();
                      }
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

  // Future<void> _selectDate(BuildContext context) async {
  //   DatePicker.showDatePicker(
  //     context,
  //     showTitleActions: true,
  //     minTime: DateTime(2021, 1, 1),
  //     maxTime: DateTime(2100, 12, 31),
  //     onConfirm: (date) {
  //       setState(() {
  //         selectedDate = date;
  //       });
  //     },
  //     currentTime: selectedDate,
  //   );
  // }

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
