import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocolo_atividadeItemDetalhes.dart';

ListView protocoloAtividadeDetalhes(LoteStore store) {
  return ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
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
                      text: 'Atividades ',
                    ),
                    TextSpan(
                      text: 'registradas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Observer(builder: (_) {
              if ((store.protocoloDetalhes?.acao ?? []).isEmpty) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 60, right: 60),
                    child: Column(
                      children: const [
                        Text(
                          'Nenhuma Fase ou Atividade ainda foi cadastrada para esse Protocolo!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff6F6464),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const ListFases();
            }),
            const SizedBox(height: 24),
          ],
        ),
      )
    ],
  );
}

class ListFases extends StatelessWidget {
  const ListFases({super.key});

  @override
  Widget build(BuildContext context) {
    LoteStore store = GetIt.I<LoteStore>();

    // Usando Observer do MobX para reagir a mudanças
    return Observer(builder: (_) {
      // Construindo uma lista de Widgets com índices
      List<Widget> faseWidgets =
          store.listaFaseDetalhes.asMap().entries.map<Widget>((entry) {
        int index = entry.key; // Aqui está o índice

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.kCardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Text(
                        store.listaFaseDetalhes[index].nome ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 16,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Período: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${(store.listaFaseDetalhes[index].duracao_dias).toString()} dias',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Observer(builder: (context) {
                    if (store.listaFaseDetalhes[index].acao != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...store.listaFaseDetalhes[index].acao!
                              .asMap()
                              .entries
                              .map((entry) => protocoloatividadeItemDetalhes(
                                    indexFase: index,
                                    indexAcao: entry.key,
                                    acao: entry.value,
                                  ))
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Nenhuma atividade cadastrada"),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      }).toList();

      return Column(
        children: faseWidgets,
      );
    });
  }
}
