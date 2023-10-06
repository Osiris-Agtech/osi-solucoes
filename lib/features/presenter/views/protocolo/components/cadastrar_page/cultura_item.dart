import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

cultura(
  BuildContext context,
  CarouselController carouselController,
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
                'Cultura',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
            // store.novoLoteCultura.nome != null &&
            //         store.novoLoteCultura.nome!.isNotEmpty
            //     ?
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
            // : Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: const [
            //       Text(
            //         "Preencher",
            //         style: TextStyle(
            //           color: Constants.kPrimaryColor,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       Icon(
            //         Icons.chevron_right,
            //         color: Constants.kPrimaryColor,
            //       ),
            //     ],
            //   ),
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

culturaPage(BuildContext context) {
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
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 10,
                          top: index == 0 ? 16.0 : 8.0,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {
                                //if (value != null) store.setNovoLoteCultura(index);
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Alface",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.only(top: 8, left: 20),
            child: Text(
              'Deseja criar uma\nnova cultura?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                color: Constants.kPrimaryColor,
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        //   child: Observer(builder: (_) {
        //     return AnimatedCrossFade(
        //       duration: const Duration(milliseconds: 200),
        //       firstChild: addCulturaButton(store),
        //       secondChild: addCulturaTextFormField(store),
        //       crossFadeState: !store.isNovaCultura
        //           ? CrossFadeState.showFirst
        //           : CrossFadeState.showSecond,
        //     );
        //   }),
        // ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

addCulturaTextFormField(LoteStore store) {
  return Column(
    children: [
      Row(
        children: [
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

addCulturaButton() {
  return const TextButton(
    //onPressed: () => store.setIsNovaCultura(true),
    onPressed: null,
    child: Text(
      "Deseja cadastrar nova cultura ?",
      style: TextStyle(
        fontSize: 16,
        color: Constants.kPrimaryColor,
      ),
    ),
  );
}
