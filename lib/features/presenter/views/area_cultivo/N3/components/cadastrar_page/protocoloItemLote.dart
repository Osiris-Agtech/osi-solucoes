import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

Padding protocoloItemLote({
  required int index,
  required LoteStore store,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: index == 0 ? 10 : 5,
      left: 10,
      right: 10,
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        store.setProtocoloDetalhes(store.searchProtocolo[index]);
        store.buscarProtocoloDetalhes();
        if (store.abrirProtocoloDetalhesAtv) {
          store.toggleAbrirProtocoloDetalhesAtv();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 8.0,
                        top: 5.0,
                      ),
                      child: Text(
                        store.searchProtocolo[index].nome ?? "---",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Cultivos Alvo:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  store.searchProtocolo[index].cultura?.nome ??
                                      "---",
                                  style: const TextStyle(
                                    color: Constants.kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Lotes Vinculados:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  //"${store.searchReservatorio[index].lotes?.length ?? 0} Ativos",
                                  "0 Lotes",
                                  style: TextStyle(
                                    color: Constants.kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
