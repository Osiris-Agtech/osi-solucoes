import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

class CadernoAtividadeStep extends StatelessWidget {
  final CadernoCampoStore store;

  const CadernoAtividadeStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final bottomKeyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomScrollPadding = bottomKeyboardInset + 96;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(bottom: bottomScrollPadding),
      child: Column(
        children: [
          AppFormSection(
            title: 'Atividade',
            description: 'Dê um título para a atividade.',
            isRequired: true,
            child: TextFormField(
              controller: store.novoAtividadeName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Título da Atividade',
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            title: 'Data e Hora',
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                        locale: const Locale("pt", "BR"),
                      );
                      if (date != null) store.selectDateRegistro(date);
                    },
                    child: Observer(builder: (_) {
                      return InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data',
                          prefixIcon: Icon(Icons.event),
                        ),
                        child: Text(
                          DateFormat("dd/MM/y", 'pt_br')
                              .format(store.dateRegistro),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Constants.kPrimaryColor,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) store.selectTimeRegistro(time);
                    },
                    child: Observer(builder: (_) {
                      return InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora',
                          prefixIcon: Icon(Icons.schedule),
                        ),
                        child: Text(
                          DateFormat("HH:mm", 'pt_br')
                              .format(store.dateRegistro),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Constants.kPrimaryColor,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            title: 'Descrição da Atividade (opcional)',
            child: TextFormField(
              controller: store.novaDescricao,
              maxLines: 5,
              scrollPadding: EdgeInsets.only(bottom: bottomScrollPadding),
              decoration: const InputDecoration(
                hintText: 'Descreva a atividade realizada...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
