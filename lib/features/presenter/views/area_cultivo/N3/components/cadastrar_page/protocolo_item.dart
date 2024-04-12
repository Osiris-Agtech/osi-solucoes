import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/cadastrar_protocolo_page.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/protocoloItem.dart';

protocolo(
  BuildContext context,
  CarouselController carouselController,
  LoteStore store,
  GlobalKey<FormFieldState> key,
) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.assignment,
          color: Constants.kPrimaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'Protocolo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
            store.novoLoteReservatorio.nome != null &&
                    store.novoLoteReservatorio.nome!.isNotEmpty
                ? Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            store.novoLoteReservatorio.nome ?? '---',
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
                        "Selecionar",
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
          store.setDotIndicator(4);
          bottomSheetN3(context, carouselController, store, key);
        },
      );
    }),
  );
}

protocoloPage(BuildContext context, LoteStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 30),
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
                  text: 'Qual ',
                ),
                TextSpan(
                  text: 'protocolo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.kPrimaryColor,
                  ),
                ),
                TextSpan(
                  text: ' deseja usar ?',
                ),
              ],
            ),
          ),
        ),
        const Padding(
            padding: EdgeInsets.only(top: 20, left: 30),
            child: Text('Todos os protocolos')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF5F5F5),
              ),
              child: Observer(
                builder: (_) {
                  return showList(store);
                },
              ),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Get.to(() => const CadastrarProtocoloPage(isShortcut: true));
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 8, left: 20),
            child: Text(
              'Deseja adicionar um\nnovo Protocolo?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                color: Constants.kPrimaryColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget showList(LoteStore store) {
  return ListView.builder(
    itemCount: 2, // Defina o número correto de itens aqui
    itemBuilder: (BuildContext context, int index) {
      return protocoloItem(
          index: index,
          onTap: () {
            store.setProtocoloDetalhes();
            // store.buscarReservatorioDetalhes();
          });
    },
  );
}

protocoloDetalhes(LoteStore store) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: const [],
  );
}
