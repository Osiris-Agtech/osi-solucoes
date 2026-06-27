// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';

Widget localizacaoPage(BuildContext context, AreaCultivoStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 40),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Qual localização sua\n',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'área',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
                TextSpan(
                  text: ' se encontra?',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5F5F5),
              ),
              child: Observer(
                builder: (_) {
                  if (store.isNovaAreaLoading) {
                    return const AppStatePanel(
                      stateKind: AppStateKind.loading,
                      title: 'Carregando...',
                      isCompact: true,
                    );
                  }
                  if (store.localizacaoList.isEmpty) {
                    return const AppStatePanel(
                      stateKind: AppStateKind.empty,
                      title: 'Nenhuma localização cadastrada',
                      isCompact: true,
                    );
                  }
                  return showList(store);
                },
              ),
            ),
          ),
        )
      ],
    ),
  );
}

ListView showList(AreaCultivoStore store) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: store.localizacaoList.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: index == 0 ? 10 : 0),
        child: AppFormSelectionTile(
          title: store.localizacaoList[index].endereco ?? '---',
          subtitle:
              '${store.localizacaoList[index].bairro}, ${store.localizacaoList[index].cidade}',
          leading: const Icon(Icons.location_on),
          onTap: () {
            store.setLocalizacaoSelecionada(index);
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
