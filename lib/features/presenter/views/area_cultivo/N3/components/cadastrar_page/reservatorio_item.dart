import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';

reservatorio(
  BuildContext context,
  CarouselController carouselController,
  LoteStore store,
  ProtocoloStore protocoloStore,
  GlobalKey<FormFieldState> key,
) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.waves,
          color: Constants.kPrimaryColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'Reservatório',
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
          store.setDotIndicator(3);
          bottomSheetN3(
              context, carouselController, store, protocoloStore, key);
        },
      );
    }),
  );
}

reservatorioPage(BuildContext context, LoteStore store) {
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
                  text: 'reservatorio',
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
            child: Text('Todos os reservatórios')),
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
                  if (store.isNovaAreaLoading) {
                    return loadingWidget();
                  }
                  if (store.reservatorioList.isEmpty) {
                    return emptyList();
                  }
                  return showList(store);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Center loadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Center emptyList() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Você não possui nenhum reservatório cadastrado',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

ListView showList(LoteStore store) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: store.reservatorioList.length,
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
            subtitle: Row(
              children: [
                Text('volume: ${store.reservatorioList[index].volume}'),
                const SizedBox(width: 16),
                Observer(builder: (_) {
                  if (store.novoLoteReservatorio.id != null &&
                      store.novoLoteReservatorio.id ==
                          store.reservatorioList[index].id) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Constants.kPrimaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'Vinculado',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.kBackgroundColor,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '${store.reservatorioList[index].nome}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Constants.kPrimaryColor,
            ),
            onTap: () {
              store.setReservatorioDetalhes(store.reservatorioList[index]);
              store.buscarReservatorioDetalhes();
            },
          ),
        ),
      );
    },
  );
}
