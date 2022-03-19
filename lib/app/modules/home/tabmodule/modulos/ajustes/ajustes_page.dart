import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/ajustes/ajustes_store.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/modulos_module.dart';
import 'package:osi_solucoes/app/modules/home/tabmodule/modulos/modulos_store.dart';

class AjustesPage extends StatefulWidget {
  final String title;

  const AjustesPage({Key? key, this.title = 'AjustesPage'}) : super(key: key);
  @override
  AjustesPageState createState() => AjustesPageState();
}

class AjustesPageState extends State<AjustesPage> {
  // final ModulosStore modulosStore = Modular.get();
  final AjustesStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              toolbarHeight: MediaQuery.of(context).size.height * 0.233,
              automaticallyImplyLeading: true,
              forceElevated: true,
              elevation: 1,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.088,
                    top: MediaQuery.of(context).size.width * 0.024),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () {
                          Modular.to.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: kPrimaryColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.013),
                        child: const Text(
                          "Ajustes",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.003,
                            left: MediaQuery.of(context).size.width * 0.013),
                        child: const Text(
                          "Selecione e ajuste seu reservatório",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    ]),
              ),
              bottom: PreferredSize(
                child: Container(
                  color: const Color(0xFFF8F8F6),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.018),
                  child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.034),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            size: 18,
                          ),
                        ),
                        labelText: "Buscar Reservatório...",
                        labelStyle: const TextStyle(fontSize: 18),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            size: 36,
                          ),
                          color: kPrimaryColor,
                        ),
                      )),
                ),
                preferredSize: Size(double.infinity,
                    MediaQuery.of(context).size.height * 0.061),
              ),
            )
          ],
        ),
      ),
    );
  }
}
