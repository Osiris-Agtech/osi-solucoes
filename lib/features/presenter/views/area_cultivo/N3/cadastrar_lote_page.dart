import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

import 'components/cadastrar_page/setorItem.dart';

class CadastrarLotePage extends StatefulWidget {
  const CadastrarLotePage({Key? key}) : super(key: key);

  @override
  State<CadastrarLotePage> createState() => _CadastrarLotePageState();
}

class _CadastrarLotePageState extends State<CadastrarLotePage> {
  LoteStore store = GetIt.I<LoteStore>();
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        backgroundColor: Constants.kBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                titulo(),
                subtitulo(),
                const SizedBox(height: 20),
                setor(context, store),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                lote(context),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                cultura(context),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                reservatorio(context),
                // fase(context),
                const Divider(),
                datas(context),
                const SizedBox(height: 20),
                saveButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        'Cadastrar Informações',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff6F6464),
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Criando Nova Área de Cultivo',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.kBackgroundColor,
      elevation: 0,
      leading: const BackButton(
        color: Constants.kPrimaryColor,
      ),
    );
  }

  Padding saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Center(
        child: SizedBox(
          width: size.width * .8,
          height: 40,
          child: Observer(builder: (_) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: store.isNovaAreaLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              onPressed: () {
                // store.registrarArea();
              }, //store.registrarReservatorio(),
            );
          }),
        ),
      ),
    );
  }

  lote(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(
            Icons.label,
            color: Constants.kPrimaryColor,
          ),
          title: const Text(
            'Lote',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoLoteName.text.isNotEmpty
              ? SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 76,
                        child: Text(
                          store.novoLoteName.text,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          onTap: () {
            // store.setDotIndicator(0);
            // bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }

  cultura(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(
            Icons.park,
            color: Constants.kPrimaryColor,
          ),
          title: const Text(
            'Cultura',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoLoteCultura.nome != null &&
                  store.novoLoteCultura.nome!.isNotEmpty
              ? SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 76,
                        child: Text(
                          store.novoLoteCultura.nome ?? '---',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          onTap: () {
            // store.setDotIndicator(0);
            // bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }

  reservatorio(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(
            Icons.waves,
            color: Constants.kPrimaryColor,
          ),
          title: const Text(
            'Reservatório',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoLoteReservatorio.nome != null &&
                  store.novoLoteReservatorio.nome!.isNotEmpty
              ? SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 76,
                        child: Text(
                          store.novoLoteReservatorio.nome ?? '---',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          onTap: () {
            // store.setDotIndicator(0);
            // bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }

  datas(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.watch_later,
              color: Constants.kPrimaryColor,
            ),
            title: Text(
              'Datas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
          registroItem(),
          semeaduraItem(),
          transplantioItem(),
          colheitaItem(),
        ],
      );
    });
  }

  registroItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        dense: true,
        title: const Text(
          'Registro',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: SizedBox(
          width: 140,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  '25/07/2021',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  semeaduraItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        title: const Text(
          'Semeadura',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: SizedBox(
          width: 140,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  transplantioItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        title: const Text(
          'Transplantio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: SizedBox(
          width: 140,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  colheitaItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        title: const Text(
          'Colheita',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: SizedBox(
          width: 140,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
