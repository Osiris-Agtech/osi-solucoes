// ignore_for_file: file_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/cadastrar_solucao_page.dart';

import '../../../../../../core/constants/constants.dart';

Widget receitaPage(BuildContext context, CarouselController controlerPages) {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();

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
              text: 'Qual ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'solução base ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
                TextSpan(
                  text: '\ndeseja usar?',
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
            'Todas as Soluções Nutritivas Cadastradas',
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
                if (store.isSolucaoListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
                if (store.solucaoList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Não há soluções\ncadastradas em sua conta',
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
                  itemCount: store.solucaoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: index == 0 ? 10 : 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          subtitle: Text(
                              'C. elétrica: ${store.solucaoList[index].c_eletrica} S.m/mm2'),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              store.solucaoList[index].nome ?? "---",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Constants.kPrimaryColor,
                          ),
                          onTap: () {
                            store.setSolucaoDetalhes(store.solucaoList[index]);
                            controlerPages.nextPage();
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Get.to(() => const CadastrarSolucaoPage(isShortcut: true));
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 8, left: 20),
            child: Text(
              'Deseja adicionar uma\nnova Receita?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: Constants.kPrimaryColor),
            ),
          ),
        ),
      ],
    ),
  );
}
