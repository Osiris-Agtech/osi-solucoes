import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

Padding atividadeItem({
  required int index,
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
        // store.setReservatorioDetalhes(store.searchReservatorio[index]);
        //Get.to(() => const DetalhesProtocolo());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 5.0,
                        bottom: 8.0,
                        top: 5.0,
                      ),
                      child: Text(
                        //store.searchReservatorio[index].nome ?? "---",
                        "Preparar Início da Germinação",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: const [
                          Text(
                            "Data 20/08/23",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.notifications,
                size: 20,
                color: Constants.kPrimaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.edit,
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
