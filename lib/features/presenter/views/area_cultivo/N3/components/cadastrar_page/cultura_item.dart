import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

cultura(BuildContext context, LoteStore store) {
  return InkWell(
    child: Observer(builder: (_) {
      return ListTile(
        leading: const Icon(
          Icons.park,
          color: Constants.kPrimaryColor,
        ),
        title: const Text(
          'Cultura',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: store.novoLoteCultura.nome != null &&
                store.novoLoteCultura.nome!.isNotEmpty
            ? SizedBox(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        store.novoLoteCultura.nome ?? '---',
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
          // store.setDotIndicator(0);
          // bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    }),
  );
}
