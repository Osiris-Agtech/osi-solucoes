// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';

InkWell setor(
  BuildContext context,
  CarouselSliderController carouselController,
  LoteStore store,
  ProtocoloStore protocoloStore,
  GlobalKey<FormFieldState> key,
) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.park,
          color: Constants.kPrimaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'Setor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
            store.novoLoteSetor.nome != null &&
                    store.novoLoteSetor.nome!.isNotEmpty
                ? Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
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
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Preencher",
                        style: TextStyle(
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
          ],
        ),
        onTap: () {
          store.setDotIndicator(0);
          bottomSheetN3(
              context, carouselController, store, protocoloStore, key);
        },
      );
    }),
  );
}

SizedBox setorPage(
  BuildContext context,
  LoteStore store,
  GlobalKey<FormFieldState> key,
) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 30,
            right: 30,
          ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Área de\n Cultivo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      SizedBox(
                        width: 200,
                        child: Observer(builder: (_) {
                          return AppDropdown<Area>(
                            value: store.novoLoteArea.id != null
                                ? store.novoLoteArea
                                : null,
                            hint: const Text(
                              'Selecionar',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            items: store.areaList.map((Area area) {
                              return DropdownMenuItem<Area>(
                                value: area,
                                child: Text(area.nome ?? '-'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                key.currentState?.reset();
                                store.selecionarNovoLoteSetor(
                                    Setor()); // Resetar a seleção do setor
                                store.selecionarNovoLoteArea(value);
                              }
                            },
                          );
                        }),
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
                      const SizedBox(
                        width: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SizedBox(
                          width: 200,
                          child: Observer(builder: (_) {
                            return AppDropdown<Setor>(
                              fieldKey: key,
                              value: store.novoLoteSetor.id != null
                                  ? store.novoLoteSetor
                                  : null,
                              hint: const Text(
                                'Selecionar',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              items: (store.novoLoteArea.setores ?? [])
                                  .map((Setor setor) {
                                return DropdownMenuItem<Setor>(
                                  value: setor,
                                  child: Text(setor.nome!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  store.selecionarNovoLoteSetor(value);
                                }
                              },
                            );
                          }),
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
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 50.0),
        //   child: Text(
        //     'Caso não seja selecionado nenhuma área de cultivo ou setor, criaremos automaticamente uma genérica para alocar seu lote',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Constants.kGreyText2,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        // const Spacer(),
      ],
    ),
  );
}
