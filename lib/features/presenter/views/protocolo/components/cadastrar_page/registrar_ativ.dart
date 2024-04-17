import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/ativBottomSheet.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/atividadeItem.dart';

import '../../../../widgets/get_bottom_sheet.dart';

registrarAtivPage(BuildContext context, ProtocoloStore store) {
  final ScrollController _scrollController = ScrollController();

  return Scaffold(
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          mini: true,
          onPressed: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: Constants.kPrimaryColor,
          child: const Icon(
            Icons.arrow_downward,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          onPressed: () {
            store.limparAtividadeBottomSheet();
            store.limparFaseBottomSheet();
            getBottomSheet(const AtivBottomSheet(
              isNewRecord: true,
            ));
          },
          backgroundColor: Constants.kPrimaryColor,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
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
                  text: 'Registrar ',
                ),
                TextSpan(
                  text: 'Atividades',
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
          if (store.faseList.isEmpty) {
            return const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Nenhuma Fase ou Atividade ainda foi cadastrada para esse Protocolo, comece a partir do botão "+"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff6F6464),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          return ListFases(scrollController: _scrollController);
        }),
        const SizedBox(height: 24),
      ],
    ),
  );
}

class ListFases extends StatelessWidget {
  const ListFases({
    Key? key,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    ProtocoloStore store = GetIt.I<ProtocoloStore>();

    return Expanded(
      child: Observer(builder: (_) {
        return ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: store.faseList.length,
            itemBuilder: (_, index) {
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
                              store.faseList[index].nome ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                store.removeFase(index);
                                store.atualizarNovasAtividades();
                              },
                              child: const Icon(
                                Icons.delete_outlined,
                                size: 20,
                                color: Colors.red,
                              ),
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
                                      '${(store.faseList[index].duracao_dias).toString()} dias',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Observer(builder: (context) {
                          if (store.faseList[index].acao != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...store.faseList[index].acao!
                                    .asMap()
                                    .entries
                                    .map((entry) => atividadeItem(
                                          indexFase: index,
                                          indexAcao: entry.key,
                                          acao: entry.value,
                                        ))
                                    .toList()
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
            });
      }),
    );
  }
}
