// ignore_for_file: file_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/solucao_store.dart';

import '../../../../../../core/constants/constants.dart';

Widget fertilizantePage(
    BuildContext context, CarouselController controlerPages) {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Qual fertilizante',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '\ndeseja ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
                TextSpan(
                  text: 'adicionar?',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
        // Observer(builder: (_) {
        //   return Padding(
        //     padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
        //     child: TextFormField(
        //       controller: store.pesquisarReceita,
        //       decoration: const InputDecoration(
        //         prefixIcon: Icon(Icons.search),
        //         hintText: 'Pesquisar',
        //         hintStyle: TextStyle(
        //           fontSize: 24,
        //           fontWeight: FontWeight.normal,
        //           fontStyle: FontStyle.italic,
        //         ),
        //       ),
        //     ),
        //   );
        // }),
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 20),
          child: Text(
            'Fertilizantes Disponíveis',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff6F6464),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5F5F5),
              ),
              child: Observer(builder: (_) {
                if (store.isFertilizanteListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
                if (store.fertilizanteList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Não há fertilizantes\ncadastrados em sua conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff6F6464),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.fertilizanteList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: index == 0 ? 10 : 0),
                      child: ListTile(
                        leading: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Observer(builder: (_) {
                            if (!store.fertilizanteList[index].selected) {
                              return const Icon(
                                  Icons.check_box_outline_blank_rounded);
                            }
                            return const Icon(
                              Icons.check_box,
                              color: Constants.kPrimaryColor,
                            );
                          }),
                          onPressed: () {
                            store.changeSelecaoFertilizante(
                              index,
                              !store.fertilizanteList[index].selected,
                            );
                          },
                        ),
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          store.fertilizanteList[index].fertilizante.nome ??
                              "---",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          // store.setSolucaoDetalhes(store.solucaoList[index]);
                          controlerPages.nextPage();
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
        // TextButton(
        //   onPressed: () {},
        //   child: const Padding(
        //     padding: EdgeInsets.only(top: 20, left: 20),
        //     child: Text(
        //       'Deseja adicionar uma\nnova Receita?',
        //       style: TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.w600,
        //           decoration: TextDecoration.underline),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
