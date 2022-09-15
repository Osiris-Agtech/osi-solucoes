import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';

Widget novaLocalizacaoPage(BuildContext context,
    CarouselController controlerPages, AreaCultivoStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Cadastrar nova\n',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'localização',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            children: [
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.cep,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Cep'),
                );
              }),
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.endereco,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Endereço'),
                );
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Observer(builder: (_) {
                        return TextFormField(
                          controller: store.bairro,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                              ),
                              labelText: 'Bairro'),
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Observer(builder: (_) {
                          return TextFormField(
                            controller: store.numero,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                ),
                                labelText: 'Número'),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.cidade,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Cidade'),
                );
              }),
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.estado,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Estado'),
                );
              }),
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.pais,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'País'),
                );
              }),
              Observer(builder: (_) {
                return TextFormField(
                  controller: store.complemento,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Complemento'),
                );
              }),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.chevron_left, color: Colors.grey),
                      Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    primary: Constants.kPrimaryColor,
                  ),
                  onPressed: () {
                    store.cadastrarNovaLocalizacao(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Cadastrar',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.chevron_right_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
