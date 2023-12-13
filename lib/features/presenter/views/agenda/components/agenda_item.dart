import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/detalhes_bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

Padding agendaItem({
  required int index,
  VoidCallback? onTap,
  required AgendaStore store,
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
      onTap: onTap ??
          () {
            store.setShowEditPage(false);
            getBottomSheet(const DetalhesBottomSheet());
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
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        bottom: 5.0,
                        top: 5.0,
                      ),
                      child: Text(
                        //store.searchReservatorio[index].nome ?? "---",
                        "Ajuste de Solução",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text("Miguel Ribeiro"),
                            subtitle: Text("Admistrador"),
                            leading: Icon(Icons.person_add),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Constants.kPrimaryColor,
                            ),
                          ),
                          Row(
                            children: const [
                              Text("28/07/2023"),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: Constants.kPrimaryColor,
                              ),
                              Text("14:30 PM")
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
