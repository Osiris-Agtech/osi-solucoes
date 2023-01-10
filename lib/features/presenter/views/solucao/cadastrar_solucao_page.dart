import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/bottomSheet.dart';
import '../../../../../core/constants/constants.dart';

class CadastrarSolucaoPage extends StatefulWidget {
  const CadastrarSolucaoPage({Key? key}) : super(key: key);

  @override
  State<CadastrarSolucaoPage> createState() => _CadastrarSolucaoPageState();
}

class _CadastrarSolucaoPageState extends State<CadastrarSolucaoPage> {
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  void initState() {
    store.buscarFertilizantes();
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
      child: GestureDetector(
        onTap: () {},
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            backgroundColor: Constants.kBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titulo(),
                    const SizedBox(height: 20),
                    subtitulo(),
                    const SizedBox(height: 10),
                    nome(context),
                    const Divider(),
                    fertilizantes(context),
                    _descricaoTextFormField(),
                    saveButton(size)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _descricaoTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF5F5F5),
        ),
        child: Observer(
          builder: (_) {
            return SizedBox(width: double.infinity, child: avisoFertilizante());
          },
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        'Cadastrar informações',
        style: TextStyle(
          fontSize: 14,
          color: Constants.kGreyText,
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
        'Nova Solução Nutritiva',
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

  InkWell nome(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.label),
          title: const Text(
            'Nome',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novaSolucaoName.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      store.novaSolucaoName.text,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Constants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Constants.kPrimaryColor,
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Preencher",
                      style: TextStyle(
                        fontSize: 12,
                        color: Constants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Constants.kPrimaryColor,
                    ),
                  ],
                ),
          onTap: () {
            store.setDotIndicator(0);
            bottomSheet(context, carouselController, controlerPages, store);
          },
        );
      }),
    );
  }

  InkWell fertilizantes(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.invert_colors),
            title: const Text(
              'Fertilizantes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            trailing:
                // store.novoAutorName.text.isNotEmpty
                //     ? Row(
                //         mainAxisSize: MainAxisSize.min,
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Text(
                //             store.novoAutorName.text,
                //             textAlign: TextAlign.end,
                //             style: const TextStyle(
                //               color: Constants.kPrimaryColor,
                //               fontWeight: FontWeight.w600,
                //             ),
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           const Icon(
                //             Icons.chevron_right,
                //             color: Constants.kPrimaryColor,
                //           ),
                //         ],
                //       )
                //     :
                Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  "Selecionar",
                  style: TextStyle(
                    fontSize: 12,
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Constants.kPrimaryColor,
                ),
              ],
            ),
            onTap: () {
              store.setDotIndicator(1);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  Padding avisoFertilizante() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/alert-triangle.svg",
            color: Constants.kButtonGrey,
            height: 20,
          ),
          const Text(
            'Nenhum fertilizante\nselecionado',
            textAlign: TextAlign.center,
          ),
        ],
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
              child: const Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {}, //store.registrarReservatorio(),
            );
          }),
        ),
      ),
    );
  }
}
