// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:intl/intl.dart';
import 'package:osi_solucoes/features/presenter/widgets/date_picker.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';

class EditarAtividadeSheet extends StatefulWidget {
  final Agenda? agenda;
  const EditarAtividadeSheet({super.key, this.agenda});

  @override
  State<EditarAtividadeSheet> createState() => _EditarAtividadeSheetState();
}

class _EditarAtividadeSheetState extends State<EditarAtividadeSheet> {
  final AgendaStore store = GetIt.I<AgendaStore>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              children: [
                Text(
                  widget.agenda != null ? 'Editar ' : 'Nova ',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Constants.kText2,
                  ),
                ),
                const Text(
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
                      color: Constants.kCardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Observer(builder: (_) {
                        return TextFormField(
                          controller: store.tituloController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Digite aqui",
                            hintStyle: TextStyle(color: Colors.black),
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
                      color: Constants.kCardColor,
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
}
