import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

import '../../../../../core/constants/constants.dart';

class CadastrarReservatorioPage extends StatefulWidget {
  final String title;
  const CadastrarReservatorioPage(
      {Key? key, this.title = 'CadastrarReservatorioPage'})
      : super(key: key);
  @override
  CadastrarReservatorioPageState createState() =>
      CadastrarReservatorioPageState();
}

class CadastrarReservatorioPageState extends State<CadastrarReservatorioPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();

  @override
  void dispose() {
    store.limparNovoReservatorio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.kBackgroundColor,
            elevation: 0,
            leading: const BackButton(
              color: Constants.kPrimaryColor,
            ),
          ),
          backgroundColor: Constants.kBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10), //talvez mudar para 16/20, verificar no celular
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 28),
                  child: Text(
                    'Novo Reservatório',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 25),
                  child: Text('Cadastrar Informações',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff6F6464),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Observer(builder: (_) {
                    return ListTile(
                      leading: const Icon(Icons.label),
                      title: const Text(
                        'Nome',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      trailing: store.novoReservatorioName.text.isNotEmpty
                          ? Text(
                              store.novoReservatorioName.text,
                              style: const TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                          : const Text(
                              "Preencher",
                              style: TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                      onTap: () {
                        bottomSheet(context, 0);
                        // showConfirmDialog(context);
                      },
                    );
                  }),
                ),
                const Divider(),
                InkWell(
                  child: Observer(builder: (_) {
                    return ListTile(
                      leading: const Icon(Icons.waves),
                      title: const Text(
                        'Volume',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      trailing: store.novoReservatorioVolume.text.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  store.novoReservatorioVolume.text + " Litros",
                                  style: const TextStyle(
                                      color: Constants.kPrimaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Constants.kPrimaryColor,
                                )
                              ],
                            )
                          : const Text(
                              "Preencher",
                              style: TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                      onTap: () {
                        bottomSheet(context, 1);
                      },
                    );
                  }),
                ),
                const Divider(),
                InkWell(
                  child: Observer(builder: (_) {
                    return ListTile(
                      leading: const Icon(Icons.invert_colors),
                      title: const Text(
                        'Solução Nutritiva',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      trailing: store.isSolucaoNutritivaValid
                          ? Text(
                              store.solucaoNutritiva.nome ?? "",
                              style: const TextStyle(
                                color: Constants.kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                      onTap: () {
                        bottomSheet(context, 2);
                      },
                    );
                  }),
                ),
                const Divider(),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: SizedBox(
                      width: size.width * .8,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Constants.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context, int index) {
    return showModalBottomSheet<void>(
      backgroundColor: Constants.kBackgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CarouselSlider(
          carouselController: controlerPages,
          options: CarouselOptions(
            initialPage: 0,
            enableInfiniteScroll: false,
            height: MediaQuery.of(context).size.height * 0.9,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            scrollPhysics: const NeverScrollableScrollPhysics(),
          ),
          items: [
            pagesNewReservatorio(context, index),
            receitaDetalhe(context),
          ],
        );
      },
    );
  }

  SizedBox pagesNewReservatorio(BuildContext context, int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 32,
                  ),
                  color: Constants.kPrimaryColor,
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: index * 1.0, // Depois vai pro controler
                ),
                const SizedBox(
                  width: 70,
                ),
              ],
            ),
          ),
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              initialPage: index,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height * 0.9 - 140,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
            items: [
              nomePage(context),
              volumePage(context),
              receitaPage(context),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    carouselController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.chevron_left),
                      Text(
                        'Voltar',
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    primary: Constants.kPrimaryColor,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Avançar',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  onPressed: () {
                    carouselController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container nomePage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: EdgeInsets.only(
        top: 0,
        left: MediaQuery.of(context).size.width * 0.08,
        right: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                text: 'Qual nome deseja para o ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'reservatório?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.kPrimaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: TextFormField(
              controller: store.novoReservatorioName,
              decoration: const InputDecoration(
                hintText: 'EX. Reservatório Central',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Container volumePage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: EdgeInsets.only(
        top: 0,
        left: MediaQuery.of(context).size.width * 0.08,
        right: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                text: 'Qual ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Volume ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.kPrimaryColor)),
                  TextSpan(
                    text: 'do Reservatório?',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: store.novoReservatorioVolume,
              decoration: const InputDecoration(
                suffixText: 'Litros',
                hintText: 'EX. 2500',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget receitaPage(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                text: 'Qual ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'receita base ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.kPrimaryColor)),
                  TextSpan(
                    text: '\ndeseja usar?',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Pesquisar',
                    hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic))),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 25, left: 20),
            child: Text(
              'Todas as Receitas Cadastradas',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff6F6464),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF5F5F5),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          subtitle: const Text('C. elétrica: 1.8 S.m/mm2'),
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Furlani',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Constants.kPrimaryColor,
                          ),
                          onTap: () {
                            controlerPages.nextPage();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'Deseja adicionar uma\nnova Receita?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget receitaDetalhe(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => controlerPages.previousPage(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 28,
                  ),
                  color: Constants.kPrimaryColor,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 30),
            child: Text(
              'Furlani',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 30, bottom: 20),
            child: Text(
              'C. elétrica: 1.8 S.m/mm2',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff6F6464),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Fertilizantes',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'quantidade/Litro',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ...[
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                      ].map(
                        (fertilizante) => Text(fertilizante.nome ?? ''),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Relação de Nutrientes',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ...[
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                      ].map(
                        (fertilizante) => const ListTile(
                          title: Text('k/n'),
                          trailing: Text('0.8'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Teor de Nutrientes',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'mg/Litro',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      ...[
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                        Fertilizante(nome: "fertilizante 1"),
                      ].map(
                        (fertilizante) => const ListTile(
                          title: Text('k/n'),
                          trailing: Text('1.5'),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 30.0),
                    child: SizedBox(
                      height: 40,
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          primary: Constants.kPrimaryColor,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Selecionar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                        onPressed: () {
                          store.setSolucaoNutritiva(store.solucaoTest);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
