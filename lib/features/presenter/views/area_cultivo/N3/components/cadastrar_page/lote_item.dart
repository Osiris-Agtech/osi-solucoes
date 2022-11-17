import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart';

lote(
  BuildContext context,
  CarouselController carouselController,
  LoteStore store,
  GlobalKey<FormFieldState> key,
) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.label,
          color: Constants.kPrimaryColor,
        ),
        title: const Text(
          'Lote',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: store.novoLoteName.text.isNotEmpty
            ? SizedBox(
                width: 150,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 126,
                      child: Text(
                        store.novoLoteName.text,
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
            : const Text(
                "Preencher",
                style: TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
        onTap: () {
          store.setDotIndicator(1);
          bottomSheetN3(context, carouselController, store, key);
        },
      );
    }),
  );
}

lotePage(BuildContext context, LoteStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: EdgeInsets.only(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.08,
      right: MediaQuery.of(context).size.width * 0.08,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
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
                  text: 'Qual nome deseja para o ',
                ),
                TextSpan(
                  text: 'lote',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.kPrimaryColor,
                  ),
                ),
                TextSpan(
                  text: ' ?',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Observer(builder: (_) {
            return TextFormField(
              //controller: store.novoLoteName,
              initialValue: store.novoLoteName.text,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'EX. L01S01-250721',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onChanged: (String value) => store.alterarNome(value),
            );
          }),
        ),
        const Spacer(),
      ],
    ),
  );
}
