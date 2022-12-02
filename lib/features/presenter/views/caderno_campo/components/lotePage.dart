// ignore_for_file: file_names

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextFormField(
                  initialValue: store.searchLotePage.text,
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
            Container(
              height: 30,
              width: 70,
              margin: const EdgeInsets.only(right: 24.0),
              decoration: const BoxDecoration(
                color: Constants.kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  value: store.selectedGroup,
                  dropdownColor: Constants.kPrimaryColor,
                  underline: DropdownButtonHideUnderline(
                    child: Container(),
                  ),
                  iconSize: 0,
                  iconEnabledColor: Constants.kPrimaryColor,
                  elevation: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (store.selectedGroup != newValue) {
                        store.setSelectedGroup(newValue);
                        store.groupLotesBy();
                      } else {
                        store.setSelectedGroup(newValue);
                      }
                    }
                  },
                  items: <String>['Cultura', 'Setor']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
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
                if (store.isCadastroLoteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.getLotesGroup.length,
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
                );
              }),
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
      controller: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Observer(builder: (_) {
                if (!store.getLotesGroup[index].selected) {
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
              Expanded(
                child: Text(
                  store.getLotesGroup[index].key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.kText2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onPressed,
                child: SvgPicture.asset(
                  "assets/icons/maximize.svg",
                ),
              ),
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
          store.getLotesGroup[index].lotesSelection.length > 4
              ? 4
              : store.getLotesGroup[index].lotesSelection.length, (indexLote) {
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
                  if (!store.getLotesGroup[index].lotesSelection[indexLote]
                      .selected) {
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
                  store.getLotesGroup[index].lotesSelection[indexLote].lote
                          .nome ??
                      'Não informado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.kText2,
                  ),
                ),
                Text(
                  '${store.getLotesGroup[index].lotesSelection[indexLote].lote.setor?.nome ?? 'Setor não informado'} / ${store.getLotesGroup[index].lotesSelection[indexLote].lote.reservatorio?.nome ?? 'Reservatório não informado'}',
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
