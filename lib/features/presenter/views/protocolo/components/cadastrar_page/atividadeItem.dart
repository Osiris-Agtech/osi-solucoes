import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/ativBottomSheet.dart';

import '../../../../widgets/get_bottom_sheet.dart';

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
        getBottomSheet(const AtivBottomSheet());
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
                  children: const [
                    Padding(
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
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Data 20/08/23",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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
                width: 16,
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
