// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/caderno_campo_store.dart';

class ExpandedLoteCard extends StatefulWidget {
  final int index;
  const ExpandedLoteCard({Key? key, required this.index}) : super(key: key);

  @override
  State<ExpandedLoteCard> createState() => _ExpandedLoteCardState();
}

class _ExpandedLoteCardState extends State<ExpandedLoteCard> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.kBackgroundColor,
        elevation: 0,
        title: const Text(
          'Lista Completa',
          style: TextStyle(
            color: Constants.kGreyText,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(
          color: Constants.kPrimaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Observer(builder: (_) {
                    if (!store.getLotesGroup[widget.index].selected) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        icon: const Icon(Icons.check_box_outline_blank_rounded),
                        onPressed: () {
                          store.selectLotesGroup(widget.index, true);
                        },
                      );
                    }
                    return IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: const Icon(
                        Icons.check_box,
                        color: Constants.kPrimaryColor,
                      ),
                      onPressed: () {
                        store.selectLotesGroup(widget.index, false);
                      },
                    );
                  }),
                  Expanded(
                    child: Text(
                      store.getLotesGroup[widget.index].key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.kText2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.4,
                crossAxisCount: 2,
                children: List.generate(
                    store.getLotesGroup[widget.index].lotesSelection.length,
                    (indexLote) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Constants.kCardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(builder: (_) {
                            if (!store.getLotesGroup[widget.index]
                                .lotesSelection[indexLote].selected) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                icon: const Icon(
                                    Icons.check_box_outline_blank_rounded),
                                onPressed: () {
                                  store.selectLotesSelection(
                                      widget.index, indexLote, true);
                                },
                              );
                            }
                            return IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                              icon: const Icon(
                                Icons.check_box,
                                color: Constants.kPrimaryColor,
                              ),
                              onPressed: () {
                                store.selectLotesSelection(
                                    widget.index, indexLote, false);
                              },
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            store.getLotesGroup[widget.index]
                                    .lotesSelection[indexLote].lote.nome ??
                                'Não informado',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Constants.kText2,
                            ),
                          ),
                          Text(
                            '${store.getLotesGroup[widget.index].lotesSelection[indexLote].lote.setor?.nome ?? 'Setor não informado'} / ${store.getLotesGroup[widget.index].lotesSelection[indexLote].lote.reservatorio?.nome ?? 'Reservatório não informado'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Constants.kGreyText2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
