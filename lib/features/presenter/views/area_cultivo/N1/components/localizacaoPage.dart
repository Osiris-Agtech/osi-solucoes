// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sigma_hort_gestao_equipe/core/constants/constants.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/viewmodels/area_cultivo_store.dart';

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
                    return loadingWidget();
                  }
                  if (store.localizacaoList.isEmpty) {
                    return emptyList();
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

ListView showList(AreaCultivoStore store) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: store.localizacaoList.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: index == 0 ? 10 : 0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            subtitle: Text(
                '${store.localizacaoList[index].bairro}, ${store.localizacaoList[index].cidade}'),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                store.localizacaoList[index].endereco ?? "---",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Constants.kPrimaryColor,
            ),
            onTap: () {
              store.setLocalizacaoSelecionada(index);
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );
}
