// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/resultado_lote.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

Container detalhesProducao(BuildContext context) {
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
            text: const TextSpan(
              text: 'Detalhes da sua produção',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Text(
            'Confirme os resultados da sua produção',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Constants.kGreyText,
            ),
          ),
        ),
        const SizedBox(height: 8),
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
                if (store.lotesParaFinalizar.isEmpty) {
                  return const Center(child: Text('Nenhum lote encontrado'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.lotesParaFinalizar.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: cardList(store, index),
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
                        store.lotesParaFinalizar[index].lote.nome ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Observer(builder: (_) {
                        return RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Plantas Colhidas: ',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                  )),
                              TextSpan(
                                text: store.lotesParaFinalizar[index].lote
                                            .plantas_colhidas !=
                                        null
                                    ? store.lotesParaFinalizar[index].lote
                                        .plantas_colhidas
                                        .toString()
                                    : 'Não Informado',
                                style: const TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Observer(builder: (_) {
                        return RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Embalagens Produzidas: ',
                                  style: TextStyle(
                                    color: Constants.kText2,
                                  )),
                              TextSpan(
                                text: store.lotesParaFinalizar[index].lote
                                            .embalagens_produzidas !=
                                        null
                                    ? store.lotesParaFinalizar[index].lote
                                        .embalagens_produzidas
                                        .toString()
                                    : 'Não Informado',
                                style: const TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: () {
                  getBottomSheet(ResultadoLote(
                      lote: store.lotesParaFinalizar[index].lote));
                },
              ),
            ],
          ),
        ),
      );
    }),
  );
}
