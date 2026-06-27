import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

ListView protocoloDetalhes(LoteStore store, ProtocoloStore protocoloStore) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16, bottom: 8),
              child: Text(
                store.protocoloDetalhes?.nome ?? "...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 15),
              child: Text(
                'Informações',
                style: TextStyle(
                  color: Constants.kButtonGrey,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Cultura'),
                      ),
                      Flexible(
                        child: Text(
                          store.protocoloDetalhes?.cultura?.nome ?? '',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Constants.kText2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Sistema de Cultivo'),
                      ),
                      Text(
                        store.protocoloDetalhes?.sistema_cultivo ?? "...",
                        style: const TextStyle(
                          color: Constants.kText2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Forma de Implantação (Inicio)'),
                      ),
                      Text(
                        store.protocoloDetalhes?.implantacao ?? "...",
                        style: const TextStyle(
                          color: Constants.kText2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            InkWell(
                child: ListTile(
              leading: const Icon(
                Icons.checklist,
                color: Constants.kPrimaryColor,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'Atividades',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              subtitle: const Text("Atividades planejadas para o cultivo"),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Constants.kPrimaryColor,
              ),
              onTap: () {
                store.prepararListaDetalhesFase();
                store.toggleAbrirProtocoloDetalhesAtv();
              },
            )),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Cultivos Vinculados',
                style: TextStyle(
                  fontSize: 12,
                  color: Constants.kButtonGrey,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  minWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Constants.kCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Observer(builder: (_) {
                  if ((store.loteSelecionado.protocolo?.lotes ?? []).isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "Não contém lotes vinculados a este reservatório",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (store.loteSelecionado.protocolo?.lotes ?? []).length,
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      color: Constants.kBackgroundColor,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 8.0 : 0.0,
                              bottom: index ==
                                      (store.loteSelecionado.protocolo?.lotes
                                                  .length ??
                                              0) -
                                          1
                                  ? 8.0
                                  : 0.0,
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              title: Text(
                                store.loteSelecionado.protocolo?.lotes[index]
                                        .nome ??
                                    '---',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Constants.kContentColorLightTheme
                                      .withValues(alpha: .8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Cultura: ${store.loteSelecionado.protocolo?.lotes[index].nome ?? 'Sem Cultura'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.kContentColorLightTheme
                                      .withValues(alpha: .8),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
