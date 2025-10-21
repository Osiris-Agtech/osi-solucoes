import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

ListView reservatorioDetalhesPage(LoteStore store) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                store.reservatorioDetalhes.nome ?? "...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                "Volume: ${store.reservatorioDetalhes.volume ?? "..."} litros",
                style: const TextStyle(
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: Text(
            'Receita Vinculada',
            style: TextStyle(
              fontSize: 16,
              color: Constants.kButtonGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          // trailing: Text(
          //   "Furlani",
          //   style: TextStyle(
          //     fontSize: 18,
          //     color: Constants.kContentColorLightTheme.withOpacity(.8),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
      ),
      Observer(builder: (_) {
        if (store.solucaoNutritivaList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 10.0,
            ),
            child: Center(
              child: Text(
                "Não contém solução nutritiva vinculada a este reservatório",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: store.solucaoNutritivaList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45.0,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    store.solucaoNutritivaList[index].fertilizante?.nome ?? '-',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Constants.kButtonGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${store.solucaoNutritivaList[index].quantidade ?? '-'} mg/L',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Constants.kButtonGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      const SizedBox(
        height: 15,
      ),
      const Divider(
        // height: 15,
        indent: 20,
        endIndent: 20,
        thickness: 0.5,
        color: Color(0xFFC4C4C4),
      ),
      const SizedBox(
        height: 15,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Text(
          'Cultivos Vinculados',
          style: TextStyle(
            fontSize: 16,
            color: Constants.kButtonGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Observer(builder: (_) {
        if (store.reservatorioDetalhes.lotes == null ||
            store.reservatorioDetalhes.lotes!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 10.0,
            ),
            child: Center(
              child: Text(
                "Não contém lotes vinculados a este reservatório",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: store.reservatorioDetalhes.lotes?.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  store.reservatorioDetalhes.lotes![index].nome ?? "...",
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Constants.kContentColorLightTheme.withValues(alpha: .8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Setor: ${store.reservatorioDetalhes.lotes![index].setor?.nome ?? '--'}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        Constants.kContentColorLightTheme.withValues(alpha: .7),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Text(
                  '${store.reservatorioDetalhes.lotes![index].bandeijas_semeadas ?? '--'}\nbandejas',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        Constants.kContentColorLightTheme.withValues(alpha: .7),
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      }),
    ],
  );
}
