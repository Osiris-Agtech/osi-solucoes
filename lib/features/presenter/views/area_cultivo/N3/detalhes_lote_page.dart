import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/detalhes_reservatorio_page.dart';

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
                    style: TextStyle(
                      color: Constants.kText2.withOpacity(.8),
                      fontSize: 18,
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
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          reservatorioStore.setReservatorioDetalhes(
                              store.loteSelecionado.reservatorio!);
                          Get.to(
                            () => const DetalhesReservatorio(),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Column(
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
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: SvgPicture.asset(
                                "assets/icons/migrar_lote.svg",
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
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog();
                              });
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
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
                          color: Constants.kText2,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Registro',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.registro_data?.day ?? '--'}/${store.loteSelecionado.registro_data?.month ?? '--'}/${store.loteSelecionado.registro_data?.year ?? '--'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.date_range,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Semeadura',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.semeadura_data?.day ?? '--'}/${store.loteSelecionado.semeadura_data?.month ?? '--'}/${store.loteSelecionado.semeadura_data?.year ?? '--'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.date_range,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Transplantio',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.transplantio_data?.day ?? '--'}/${store.loteSelecionado.transplantio_data?.month ?? '--'}/${store.loteSelecionado.transplantio_data?.year ?? '--'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.date_range,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Colheita',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.colheita_data?.day ?? '--'}/${store.loteSelecionado.colheita_data?.month ?? '--'}/${store.loteSelecionado.colheita_data?.year ?? '--'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.date_range,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
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
                          color: Constants.kText2,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Bandeijas\nSemeadas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.bandeijas_semeadas ?? '-'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.edit,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Mudas\nTransplantadas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.mudas_transplantadas ?? '-'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.edit,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Plantas\nColhidas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.plantas_colhidas ?? '-'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.edit,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    title: const Text(
                      'Embalagens\nProduzidas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.loteSelecionado.embalagens_produzidas ?? '-'}',
                          style: const TextStyle(
                            color: Constants.kGreyText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.edit,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: const Color(0xFF9F9F9F).withOpacity(.6),
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    dense: true,
                    minLeadingWidth: 10,
                    title: Text(
                      'Configurações',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Alterar informações sobre o lote',
                      style: TextStyle(
                        color: Constants.kGreyText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Constants.kPrimaryColor,
                    ),
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

class CustomDialog extends StatefulWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    LoteStore store = GetIt.I<LoteStore>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                alignment: Alignment.topLeft,
                icon: const Icon(
                  Icons.close,
                  size: 24,
                ),
                color: Constants.kPrimaryColor,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Migrar Lote',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                store.loteSelecionado.nome ?? '---',
                style: const TextStyle(
                  color: Constants.kText2,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Localização Atual:',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      ' - ${store.loteSelecionado.setor?.area?.nome ?? '-'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Estufa',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Image.asset(
                    "assets/icons/greenhouse1_icon.png",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      ' - ${store.loteSelecionado.setor?.nome ?? '-'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Setor',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Image.asset(
                    "assets/icons/hydroponic1_icon.png",
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Selecione o novo local',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF5F5F5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Área de\n Cultivo:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 150,
                                child: Observer(builder: (_) {
                                  return DropdownButtonFormField<Area>(
                                    hint: const Text(
                                      'Selecionar',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    isExpanded: true,
                                    iconEnabledColor: Constants.kPrimaryColor,
                                    items: store.areaList.map((Area item) {
                                      return DropdownMenuItem<Area>(
                                        value: item,
                                        child: Text(
                                          item.nome ?? '',
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _key.currentState?.reset();
                                        store.selecionarArea(value);
                                        store.isVisible = true;
                                      }
                                    },
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Observer(builder: (_) {
                          return Visibility(
                            visible: store.isVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Setor:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 150,
                                    child: DropdownButtonFormField<Setor>(
                                      key: _key,
                                      hint: const Text(
                                        'Selecionar',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      isExpanded: true,
                                      iconEnabledColor: Constants.kPrimaryColor,
                                      items:
                                          (store.areaSelecionada.setores ?? [])
                                              .map((Setor item) {
                                        return DropdownMenuItem<Setor>(
                                          value: item,
                                          child: Text(
                                            item.nome ?? '',
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          store.selecionarSetorMigrar(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Constants.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Migrar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
