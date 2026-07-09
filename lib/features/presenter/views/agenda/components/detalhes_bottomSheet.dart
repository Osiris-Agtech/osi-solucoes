// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:intl/intl.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/editar_atividade_sheet.dart';

class DetalhesBottomSheet extends StatefulWidget {
  const DetalhesBottomSheet({super.key, this.agenda});

  final Agenda? agenda;

  @override
  State<DetalhesBottomSheet> createState() => _DetalhesBottomSheetState();
}

class _DetalhesBottomSheetState extends State<DetalhesBottomSheet> {
  final AgendaStore store = GetIt.I<AgendaStore>();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: widget.agenda?.finalizado == true
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Constants.kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Constants.kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Atividade concluída',
                          style: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        if (widget.agenda != null) {
                          store.marcarAtividadeComoFeita(widget.agenda!.id!);
                        }
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'Marcar como feito',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                        getBottomSheet(EditarAtividadeSheet(
                            agenda: widget.agenda));
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
                                  Get.back();
                                },
                                child: const Text(
                                  'Cancelar',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (widget.agenda == null) return;
                                  Get.back();
                                  store.deletarAtividade(widget.agenda!.id!);
                                },
                                child: const Text(
                                  'Excluir',
                                  style: TextStyle(
                                    color: Constants.kErrorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Constants.kText2,
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
                vertical: (widget.agenda?.descricao ?? '').isEmpty ? 24 : 16,
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildScrollableContent();
  }
}
