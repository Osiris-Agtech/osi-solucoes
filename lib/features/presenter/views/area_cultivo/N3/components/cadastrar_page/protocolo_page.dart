import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocoloItemLote.dart';

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
  final ScrollController _scrollController = ScrollController();
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
        const SizedBox(
          height: 8,
        ),
        filterWidget(context),
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 8),
          child: Text(
            "Todos os Protocolos",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Expanded(
          child: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  Observer(builder: (_) {
                    if (store.isProtocoloListLoading) {
                      return loadingList();
                    }
                    if (store.protocoloList.isEmpty) {
                      return emptyList();
                    }
                    return showList(store);
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Container filterWidget(BuildContext context) {
  return Container(
    height: 50,
    color: const Color(0xFFF8F8F6),
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.04,
      vertical: 5, //MediaQuery.of(context).size.height * 0.007,
    ),
    child: TextFormField(
      onChanged: ((value) => {
            //store.setSearchReservatorioText(value),
          }),
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.start,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        border: InputBorder.none,
        prefixIcon: IconButton(
          onPressed: null,
          icon: Icon(
            Icons.search,
            size: 24,
          ),
        ),
        labelText: "Buscar...",
        labelStyle: TextStyle(fontSize: 18),
      ),
    ),
  );
}

SliverList showList(LoteStore store) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return protocoloItemLote(index: index, store: store);
      },
      childCount: store.protocoloList.length,
    ),
  );
}

SliverList loadingList() {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          ),
        ),
      ],
    ),
  );
}

SliverList emptyList() {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Text(
              'Não há protocolos\ncadastrados em sua conta',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff6F6464),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
