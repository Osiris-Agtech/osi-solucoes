// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

Widget selecionarLote(BuildContext context) {
  LoteStore store = GetIt.I<LoteStore>();

  final ScrollController scrollController = ScrollController();
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.only(
      top: 0,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Quais',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: ' lotes ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.kPrimaryColor),
                ),
                TextSpan(
                  text: 'deseja finalizar ?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Constants.kText2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: "Pesquisar por",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Constants.kGreyText,
                    ),
                  ),
                  onChanged: (String value) {
                    store.setSeachLotePage(value);
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.kCardColor,
              ),
              child: Observer(builder: (_) {
                if (store.isLoteListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (store.getLotesGroup.isEmpty) {
                  return const Center(child: Text('Nenhum lote encontrado'));
                }
                return Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: store.getLotesGroup.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: cardList(
                            store,
                            index,
                          ),
                        );
                      },
                    ),
                    if (store.carregandoFinalizarLotes)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
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
            horizontal: 15.0,
            vertical: 15.0,
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
                        store.getLotesGroup[index].lote.nome ?? '',
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
                                text: 'Cultura: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kText2,
                                )),
                            TextSpan(
                              text: store.getLotesGroup[index].lote.cultura
                                      ?.nome ??
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
                                text: 'Previsão de Colheita: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kText2,
                                )),
                            TextSpan(
                              text: store.getLotesGroup[index].lote
                                          .colheita_data !=
                                      null
                                  ? DateFormat("dd/MM/y", 'pt_br')
                                      .format(store.getLotesGroup[index].lote
                                          .colheita_data!)
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
                value: store.getLotesGroup[index].selected,
                onChanged: (bool? value) {
                  store.selecionarLoteParaFinalizar(index);
                },
              ),
            ],
          ),
        ),
      );
    }),
  );
}
