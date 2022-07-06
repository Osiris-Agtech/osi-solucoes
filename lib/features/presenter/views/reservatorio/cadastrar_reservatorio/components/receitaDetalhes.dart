// ignore_for_file: file_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

Widget receitaDetalhe(BuildContext context, CarouselController controlerPages,
    ReservatoriosStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  controlerPages.previousPage();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                ),
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 30),
          child: Text(
            'Furlani',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 30, bottom: 20),
          child: Text(
            'C. elétrica: 1.8 S.m/mm2',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff6F6464),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Fertilizantes',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'quantidade/Litro',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...[
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                    ].map(
                      (fertilizante) => Text(fertilizante.nome ?? ''),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Relação de Nutrientes',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ...[
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                    ].map(
                      (fertilizante) => const ListTile(
                        title: Text('k/n'),
                        trailing: Text('0.8'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Teor de Nutrientes',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'mg/Litro',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    ...[
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                      Fertilizante(nome: "fertilizante 1"),
                    ].map(
                      (fertilizante) => const ListTile(
                        title: Text('k/n'),
                        trailing: Text('1.5'),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 30.0),
                  child: SizedBox(
                    height: 40,
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        primary: Constants.kPrimaryColor,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Selecionar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      onPressed: () {
                        store.setSolucaoNutritiva(store.solucaoTest);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
