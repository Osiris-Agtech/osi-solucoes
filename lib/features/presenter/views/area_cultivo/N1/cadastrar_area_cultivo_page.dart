import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/bottomSheet.dart';

class CadastrarAreaCultivo extends StatefulWidget {
  const CadastrarAreaCultivo({Key? key}) : super(key: key);

  @override
  State<CadastrarAreaCultivo> createState() => _CadastrarAreaCultivoState();
}

class _CadastrarAreaCultivoState extends State<CadastrarAreaCultivo> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();

  @override
  void initState() {
    super.initState();
    store.setShowTextFormField(false);
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
          resizeToAvoidBottomInset: false,
          appBar: appBar(),
          backgroundColor: Constants.kBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titulo(),
                subtitulo(),
                const SizedBox(height: 20),
                nome(context),
                const Divider(),
                localizacao(context),
                const Divider(),
                descricao(context),
                // solucaoNutritiva(context),
                // const Divider(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffF5F5F5),
                    ),
                    child: Observer(builder: (_) {
                      return SizedBox(
                        width: double.infinity,
                        child: store.novaAreaDescricao.text.isEmpty &&
                                !store.showTextFormField
                            ? botaoDescricao()
                            : Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                    autofocus: true,
                                    maxLines: 20,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    controller: store.novaAreaDescricao),
                              ),
                      );
                    }),
                  ),
                )),
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
              onPressed: null, //store.registrarReservatorio(),
            );
          }),
        ),
      ),
    );
  }

  InkWell nome(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.label),
          title: const Text(
            'Nome',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novaAreaName.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.novaAreaName.text,
                      style: const TextStyle(
                        color: Constants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Constants.kPrimaryColor,
                    ),
                  ],
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          onTap: () {
            store.setDotIndicator(0);
            bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }

  InkWell localizacao(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: const Icon(Icons.location_on),
        trailing: const Icon(
          Icons.chevron_right,
          color: Constants.kPrimaryColor,
        ),
        title: const Text(
          'Localização',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        onTap: () {
          store.setDotIndicator(1);
          bottomSheet(context, controlerPages, carouselController, store);
        },
      ),
    );
  }

  InkWell descricao(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: const Text(
          'Descrição',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        onTap: () {
          // bottomSheet(context, controlerPages, carouselController, store);
        },
      ),
    );
  }

  Padding botaoDescricao() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              store.setShowTextFormField(true);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.green,
            ),
          ),
          const Text('Adicionar descrição'),
          const Text('(opcional)')
        ],
      ),
    );
  }
}
