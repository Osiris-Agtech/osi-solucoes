import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/detalhes_page/production_cycle/production_cycle_timeline.dart';

class DetalhesAtivPage extends StatefulWidget {
  const DetalhesAtivPage({super.key});

  @override
  State<DetalhesAtivPage> createState() => _DetalhesAtivPageState();
}

class _DetalhesAtivPageState extends State<DetalhesAtivPage> {
  final ScrollController _scrollController = ScrollController();
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    store.prepararListaDetalhesFase();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if ((store.protocoloSelecionado?.acao ?? []).isNotEmpty)
            FloatingActionButton(
              heroTag: '${store.protocoloSelecionado!.id}floatingButton1',
              mini: true,
              onPressed: () {
                if (!_scrollController.hasClients) return;

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
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(
              'Ciclo de produção',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Constants.kText2,
              ),
            ),
          ),
          Observer(builder: (_) {
            return Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  ProductionCycleTimeline(
                    fases: store.listaFaseDetalhes,
                    actions: store.protocoloSelecionado?.acao ?? const <Acao>[],
                    emptyMessage:
                        'Este protocolo ainda não possui atividades cadastradas. Edite o protocolo para adicionar fases e atividades ao ciclo.',
                    emptyActionLabel: 'Editar protocolo',
                    onEmptyAction: () =>
                        Get.toNamed(Routes.editarProtocoloPage),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
