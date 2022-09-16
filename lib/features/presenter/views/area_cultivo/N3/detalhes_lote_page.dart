import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

class DetalhesLotePage extends StatefulWidget {
  const DetalhesLotePage({Key? key}) : super(key: key);

  @override
  State<DetalhesLotePage> createState() => _DetalhesLotePageState();
}

class _DetalhesLotePageState extends State<DetalhesLotePage> {
  LoteStore store = GetIt.I<LoteStore>();

  @override
  void initState() {
    super.initState();
    store.buscarDetalhesLote();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.kBackgroundColor,
          iconTheme: const IconThemeData(
            color: Constants.kPrimaryColor, //change your color here
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Observer(builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Detalhes do Lote',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    store.loteSelecionado.nome ?? '---',
                    style: const TextStyle(
                      color: Constants.kText2,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '${store.loteSelecionado.setor?.area?.nome ?? '-'} / ${store.loteSelecionado.setor?.nome ?? '-'}',
                    style: const TextStyle(
                      color: Constants.kGreyText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      const Text(
                        'Cultura: ',
                        style: TextStyle(
                          color: Constants.kGreyText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        store.loteSelecionado.cultura?.nome ?? '-',
                        style: const TextStyle(
                          color: Constants.kGreyText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: SvgPicture.asset(
                              "assets/icons/reservatorio_icon.svg",
                            ),
                            backgroundColor: Constants.kCardColor,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Reservatório',
                            style: TextStyle(
                              color: Constants.kGreyText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: SvgPicture.asset(
                              "assets/icons/caderno_campo_icon.svg",
                              height: 25,
                              width: 25,
                            ),
                            backgroundColor: Constants.kCardColor,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Caderno de\nCampo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Constants.kGreyText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: SvgPicture.asset(
                              "assets/icons/reservatorio_icon.svg",
                            ),
                            backgroundColor: Constants.kCardColor,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Migrar Lote',
                            style: TextStyle(
                              color: Constants.kGreyText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
