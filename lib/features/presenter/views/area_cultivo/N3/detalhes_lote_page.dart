import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/agenda_page.dart';

import 'components/detalhes_page/dados_cultivo.dart';
import 'components/detalhes_page/horizontal_lista.dart';

class DetalhesLotePage extends StatefulWidget {
  const DetalhesLotePage({Key? key}) : super(key: key);

  @override
  State<DetalhesLotePage> createState() => _DetalhesLotePageState();
}

class _DetalhesLotePageState extends State<DetalhesLotePage> {
  LoteStore store = GetIt.I<LoteStore>();
  ReservatoriosStore reservatorioStore = GetIt.I<ReservatoriosStore>();

  @override
  void initState() {
    super.initState();
    store.buscarDetalhesLote();
    store.buscarAreasList();
  }

  @override
  void dispose() {
    store.limparTudo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kBackgroundColor,
        appBar: appBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Observer(builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoLote(),
                horizontalList(context, reservatorioStore, store),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(
                      "assets/icons/relatorio_icon.svg",
                      color: Constants.kPrimaryColor,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          'Protocolo Base',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Text(
                    "Alfaces Hidrogood",
                    style: TextStyle(color: Constants.kPrimaryColor),
                  ),
                  onTap: () {},
                ),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                InkWell(
                  child: ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.event,
                        color: Constants.kPrimaryColor,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            'Agenda de Atividades',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Text("Atividades planejadas para o lote"),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Constants.kPrimaryColor,
                    ),
                    onTap: () {
                      Get.to(() => const AgendaPage());
                    },
                  ),
                ),
                // const SizedBox(height: 16),
                // dateTitle(),
                // const SizedBox(
                //   height: 10,
                // ),
                // registro(context, store),
                // semeadura(context, store),
                // transplantio(context, store),
                // colheita(context, store),
                // const SizedBox(height: 16),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 16),
                producaoTitle(),
                const SizedBox(height: 20),
                bandeijasSemeadas(store),
                mudasTransplantadas(store),
                plantasColhidas(store),
                embalagensProduzidas(store),
                const SizedBox(
                  height: 16,
                ),
                // Divider(
                //   color: const Color(0xFF9F9F9F).withOpacity(.6),
                //   indent: 20,
                //   endIndent: 20,
                // ),
                // const SizedBox(height: 8),
                // configuracaoButton(),
              ],
            );
          }),
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Constants.kBackgroundColor,
      iconTheme: const IconThemeData(
        color: Constants.kPrimaryColor, //change your color here
      ),
      actions: [
        Align(
          alignment: const Alignment(0.6, -0.9),
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: PopupMenuButton(
                icon: SvgPicture.asset(
                  "assets/icons/settings_icon.svg",
                  color: Constants.kButtonGrey,
                  height: 20,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: const [
                        Text('Editar'),
                      ],
                    ),
                    onTap: () async {
                      await store.setLoteEditing(store.loteSelecionado);
                      Get.toNamed(Routes.cadastrarLotePage);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  configuracaoButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        dense: true,
        minLeadingWidth: 10,
        title: const Text(
          'Configurações',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: const Text(
          'Alterar informações sobre o lote',
          style: TextStyle(
            color: Constants.kGreyText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: const Icon(
          Icons.settings,
          color: Constants.kPrimaryColor,
        ),
        onTap: () async {
          await store.setLoteEditing(store.loteSelecionado);
          Get.toNamed(Routes.cadastrarLotePage);
        },
      ),
    );
  }

  producaoTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: const [
          Icon(
            Icons.timeline,
            color: Constants.kPrimaryColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Produção',
            style: TextStyle(
              color: Constants.kGreyText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  dateTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: const [
          Icon(
            Icons.watch_later,
            color: Constants.kPrimaryColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Data',
            style: TextStyle(
              color: Constants.kGreyText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  infoLote() {
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
            style: TextStyle(
              color: Constants.kText2.withOpacity(.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
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
              Text(
                'Cultura: ',
                style: TextStyle(
                  color: Constants.kText2.withOpacity(.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                store.loteSelecionado.cultura?.nome ?? '-',
                style: const TextStyle(
                  color: Constants.kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
