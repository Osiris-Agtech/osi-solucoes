import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/atividadeItemDetalhes.dart';

class DetalhesAtivPage extends StatefulWidget {
  const DetalhesAtivPage({Key? key}) : super(key: key);

  @override
  State<DetalhesAtivPage> createState() => _DetalhesAtivPageState();
}

class _DetalhesAtivPageState extends State<DetalhesAtivPage> {
  final ScrollController _scrollController = ScrollController();
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    store.alterarLoteFoiAlterado(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag:
                store.protocoloSelecionado!.id.toString() + 'floatingButton1',
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
        ],
      ),
      appBar: AppBar(
        backgroundColor: Constants.kBackgroundColor,
        foregroundColor: Constants.kPrimaryColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 24),
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
            if ((store.protocoloSelecionado!.acao ?? []).isEmpty) {
              return const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Nenhuma Fase ou Atividade ainda foi cadastrada para esse Protocolo, edite o protocolo e adicione as fases e atividades desejadas.',
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
            itemCount: store.listaFaseDetalhes.length,
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
                          child: Text(
                            store.listaFaseDetalhes[index].nome ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
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
                          if (store.listaFaseDetalhes[index].acao != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...store.listaFaseDetalhes[index].acao!
                                    .asMap()
                                    .entries
                                    .map((entry) => atividadeItemDetalhes(
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
