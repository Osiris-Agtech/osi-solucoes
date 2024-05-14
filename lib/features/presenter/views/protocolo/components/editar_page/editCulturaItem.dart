import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

cultura(
  BuildContext context,
  CarouselController carouselController,
  GlobalKey<FormFieldState> key,
  ProtocoloStore store,
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
                'Cultura',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Expanded(
                    child: Text(
                      //store.novoLoteCultura.nome ?? '---',
                      "Nome",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Constants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Constants.kPrimaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          // store.setDotIndicator(2);
          // bottomSheetN3(context, carouselController, store, key);
        },
      );
    }),
  );
}

editCulturaPage(BuildContext context, ProtocoloStore store) {
  return SingleChildScrollView(
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.9 - 130,
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
                    text: 'cultura',
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
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF5F5F5),
                ),
                child: Observer(builder: (_) {
                  return store.isProtocoloListLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Constants.kPrimaryColor,
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: store.culturaList.length,
                          itemBuilder: (context, index) {
                            return Observer(builder: (_) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: index == 0 ? 10 : 0),
                                child: ListTile(
                                  leading: Observer(builder: (_) {
                                    // Mostrar a cultura atual - caso não tenha editado ainda
                                    if (store.novaCulturaProtocoloDetalhes ==
                                            null &&
                                        store.culturaList[index].nome ==
                                            store.protocoloSelecionado?.cultura
                                                ?.nome) {
                                      return const Icon(
                                        Icons.check_box,
                                        color: Constants.kPrimaryColor,
                                      );
                                    }
                                    // Caso não seja o editado nem o atual
                                    if (store.novaCulturaProtocoloDetalhes !=
                                        store.culturaList[index]) {
                                      return const Icon(Icons
                                          .check_box_outline_blank_rounded);
                                    }
                                    // Caso seja editado
                                    return const Icon(
                                      Icons.check_box,
                                      color: Constants.kPrimaryColor,
                                    );
                                  }),
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Text(
                                    store.culturaList[index].nome ?? "---",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () {
                                    store.editarCultura(
                                        store.culturaList[index]);
                                  },
                                ),
                              );
                            });
                          },
                        );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Observer(builder: (_) {
              return AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: addCulturaButton(store),
                secondChild: addCulturaTextFormField(store),
                crossFadeState: !store.isNovaCultura
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

addCulturaTextFormField(ProtocoloStore store) {
  return Column(
    children: [
      Row(
        children: [
          InkWell(
            child: const Icon(
              Icons.close,
              color: Constants.kButtonGrey,
            ),
            onTap: () => store.setIsNovaCultura(false),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: store.novaCulturaController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'Nome Cultura',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return Constants.kPrimaryColor;
              }),
            ),
            child: const Text(
              "Cadastrar",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            onPressed: store.registrarCultura,
          ),
        ],
      ),
    ],
  );
}

addCulturaButton(ProtocoloStore store) {
  return TextButton(
    onPressed: () => store.setIsNovaCultura(true),
    child: const Text(
      "Deseja cadastrar nova cultura ?",
      style: TextStyle(
        fontSize: 16,
        color: Constants.kPrimaryColor,
      ),
    ),
  );
}
