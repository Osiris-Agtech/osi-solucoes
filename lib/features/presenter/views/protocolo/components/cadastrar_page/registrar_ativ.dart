import 'package:flutter/material.dart';
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
    body: SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
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
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(children: [
                                const Text(
                                  'Germinação',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    getBottomSheet(const AtivBottomSheet(
                                      isNewRecord: false,
                                      isFase: true,
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () => null,
                                  child: const Icon(
                                    Icons.delete,
                                    size: 20,
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
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: '2 dias',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ...['oi', 'oi', 'oi']
                                .asMap()
                                .entries
                                .map((entry) => atividadeItem(
                                    index: entry.key, store: store))
                                .toList()
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
