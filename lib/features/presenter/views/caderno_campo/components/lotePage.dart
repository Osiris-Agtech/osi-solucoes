// ignore_for_file: file_names

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';

import 'expandedCard.dart';

Container lotePage(BuildContext context, CadernoCampoStore store) {
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
                  text: 'deseja selecionar ?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Constants.kText2),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.kCardColor,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: store.lotesGroup.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OpenContainer(
                      transitionDuration: const Duration(milliseconds: 500),
                      openBuilder: (context, _) =>
                          ExpandedLoteCard(index: index),
                      closedBuilder: (context, VoidCallback openContainer) =>
                          externalCardList(
                              store, index, scrollController, openContainer),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget externalCardList(
  CadernoCampoStore store,
  int index,
  ScrollController scrollController,
  VoidCallback onPressed,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Observer(builder: (_) {
                if (!store.lotesGroup[index].selected) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.check_box_outline_blank_rounded),
                    onPressed: () {
                      store.selectLotesGroup(index, true);
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
                    store.selectLotesGroup(index, false);
                  },
                );
              }),
              Text(
                store.lotesGroup[index].key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.open_in_full_rounded,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: onPressed,
              )
            ],
          ),
        ),
        internalCardList(scrollController, store, index),
      ],
    ),
  );
}

Widget internalCardList(
    ScrollController scrollController, CadernoCampoStore store, int index) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 8.0,
      right: 8.0,
      top: 8.0,
    ),
    child: GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.4,
      controller: scrollController,
      crossAxisCount: 2,
      children: List.generate(
          store.lotesGroup[index].lotesSelection.length > 4
              ? 4
              : store.lotesGroup[index].lotesSelection.length, (indexLote) {
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
                  if (!store
                      .lotesGroup[index].lotesSelection[indexLote].selected) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: const Icon(Icons.check_box_outline_blank_rounded),
                      onPressed: () {
                        store.selectLotesSelection(index, indexLote, true);
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
                      store.selectLotesSelection(index, indexLote, false);
                    },
                  );
                }),
                const SizedBox(width: 4),
                Text(
                  store.lotesGroup[index].lotesSelection[indexLote].lote.nome ??
                      'Não informado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.kText2,
                  ),
                ),
                Text(
                  '${store.lotesGroup[index].lotesSelection[indexLote].lote.setor?.nome ?? 'Setor não informado'} / ${store.lotesGroup[index].lotesSelection[indexLote].lote.reservatorio?.nome ?? 'Reservatório não informado'}',
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
  );
}
