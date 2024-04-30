// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:intl/intl.dart';

Container atividadesAbertas(BuildContext context) {
  LoteStore store = GetIt.I<LoteStore>();

  final ScrollController scrollController = ScrollController();
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.only(
      top: 0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Atividades',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.kPrimaryColor),
              children: <TextSpan>[
                TextSpan(
                  text: ' em aberto ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Text(
            'Marque caso essa atividade ja tenha sido finalizada',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Constants.kGreyText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Observer(builder: (_) {
          return Padding(
            padding: const EdgeInsets.only(right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Marcar todos',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    )),
                Checkbox(
                    fillColor:
                        MaterialStateProperty.all(Constants.kPrimaryColor),
                    value: store.marcarTodasAtividades,
                    onChanged: (value) {
                      store.verificarMarcarTodos();
                    }),
              ],
            ),
          );
        }),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.kCardColor,
              ),
              child: Observer(builder: (_) {
                if (store.atividadesPendentes.isEmpty) {
                  return const Center(child: Text('Nenhum lote encontrado'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.atividadesPendentes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 16.0 : 0.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: cardList(store, index)),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outlined),
                              color: Colors.red,
                              onPressed: () {
                                store.deletarAtividades(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget cardList(
  LoteStore store,
  int index,
) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    child: Observer(builder: (_) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        bottom: 8.0,
                        top: 5.0,
                      ),
                      child: Text(
                        store.atividadesPendentes[index].agenda.titulo ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Lote: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kText2,
                                )),
                            TextSpan(
                              text: store.atividadesPendentes[index].agenda
                                      .lote!.nome ??
                                  '',
                              style: const TextStyle(
                                color: Constants.kGreyMedium,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Data: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kText2,
                                )),
                            TextSpan(
                              text: store.atividadesPendentes[index].agenda
                                          .data !=
                                      null
                                  ? DateFormat("dd/MM/y", 'pt_br')
                                      .format(store.atividadesPendentes[index]
                                          .agenda.data!)
                                      .capitalize
                                  : 'Data não informada',
                              style: const TextStyle(
                                color: Constants.kGreyMedium,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Checkbox(
                activeColor: Constants.kPrimaryColor,
                value: store.atividadesPendentes[index].selected,
                onChanged: (bool? value) {
                  store.selecionarAtividadesParaFinalizar(index);
                },
              ),
            ],
          ),
        ),
      );
    }),
  );
}
