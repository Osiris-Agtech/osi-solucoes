// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';

setor(
  BuildContext context,
  CarouselController carouselController,
  LoteStore store,
) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.park,
          color: Constants.kPrimaryColor,
        ),
        title: const Text(
          'Setor',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: store.novoLoteSetor.nome != null &&
                store.novoLoteSetor.nome!.isNotEmpty
            ? SizedBox(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        store.novoLoteSetor.nome ?? '---',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Constants.kPrimaryColor,
                    ),
                  ],
                ),
              )
            : const Text(
                "Preencher",
                style: TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
        onTap: () {
          store.setDotIndicator(0);
          bottomSheetN3(context, carouselController, store);
        },
      );
    }),
  );
}

setorPage(BuildContext context, LoteStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: EdgeInsets.only(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.08,
      right: MediaQuery.of(context).size.width * 0.08,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Em qual ',
                ),
                TextSpan(
                  text: 'setor',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.kPrimaryColor,
                  ),
                ),
                TextSpan(
                  text: ' deseja criar o lote ?',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffF5F5F5),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Área de\n Cultivo:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Selecionar',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            isExpanded: true,
                            iconEnabledColor: Constants.kPrimaryColor,
                            items: ['bau', 'bau', 'bau']
                                .map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Setor:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Selecionar',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            isExpanded: true,
                            iconEnabledColor: Constants.kPrimaryColor,
                            items: ['bau', 'bau', 'bau']
                                .map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Caso não seja selecionado nenhuma área de cultivo ou setor, criaremos automaticamente uma genérica para alocar seu lote',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Constants.kGreyText2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
      ],
    ),
  );
}
