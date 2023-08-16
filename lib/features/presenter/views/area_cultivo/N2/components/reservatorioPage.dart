// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart';

Widget reservatorioPage(BuildContext context, SetorStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: EdgeInsets.only(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.08,
      right: MediaQuery.of(context).size.width * 0.08,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Deseja vincular ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'reservatório',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
                TextSpan(
                  text: ' ao setor ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 30),
        //   child: Center(
        //     child: Text(
        //       'Importante',
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold,
        //         fontStyle: FontStyle.italic,
        //         decoration: TextDecoration.underline,
        //         color: Constants.kText2,
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: RichText(
        //     textAlign: TextAlign.center,
        //     text: const TextSpan(
        //       text: 'Ao vincular o reservatório, todos os ',
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w600,
        //         color: Constants.kText2,
        //       ),
        //       children: <TextSpan>[
        //         TextSpan(
        //           text: 'lotes',
        //           style: TextStyle(color: Constants.kPrimaryColor),
        //         ),
        //         TextSpan(
        //           text: ' criados ou migrados para este setor, serão ',
        //           style: TextStyle(
        //             fontSize: 18,
        //             color: Constants.kText2,
        //           ),
        //         ),
        //         TextSpan(
        //           text: 'automaticamente',
        //           style: TextStyle(color: Constants.kPrimaryColor),
        //         ),
        //         TextSpan(
        //           text: ' vinculados ao reservatório \nescolhido.',
        //           style: TextStyle(color: Constants.kText2),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 90, left: 40),
        //   child: Text(
        //     'Vincular Reservatório',
        //     style: TextStyle(
        //       fontSize: 14,
        //       color: Color(0xff6F6464),
        //       fontWeight: FontWeight.w600,
        //       fontStyle: FontStyle.italic,
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 45, left: 10, right: 10),
          child: Observer(builder: (_) {
            return DropdownButtonFormField<Reservatorio>(
              value: store.novoSetorReservatorio.id != null
                  ? store.reservatorioList.firstWhere(
                      (element) => element.id == store.novoSetorReservatorio.id)
                  : null,
              isExpanded: true,
              hint: const Text('Selecionar'),
              iconEnabledColor: Constants.kPrimaryColor,
              items: store.reservatorioList.map((Reservatorio item) {
                return DropdownMenuItem<Reservatorio>(
                  value: item,
                  child: Text(item.nome ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  store.setReservatorioSelecionada(value);
                }
              },
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 40, left: 8),
          child: InkWell(
            child: const Text(
              "Deseja criar um novo reservatório?",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Constants.kPrimaryColor),
            ),
            onTap: () {
              Get.to(() => const CadastrarReservatorioPage(isShortcut: true));
            },
          ),
        )
      ],
    ),
  );
}

Center emptyList() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Você não possui nenhuma localização cadastrada',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Center loadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
