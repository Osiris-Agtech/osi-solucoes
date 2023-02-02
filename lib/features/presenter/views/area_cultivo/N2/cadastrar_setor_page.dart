import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/bottomSheet.dart';
import '../../../../../core/constants/constants.dart';

class CadastrarSetorPage extends StatefulWidget {
  const CadastrarSetorPage({Key? key}) : super(key: key);

  @override
  State<CadastrarSetorPage> createState() => _CadastrarSetorPageState();
}

class _CadastrarSetorPageState extends State<CadastrarSetorPage> {
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  SetorStore store = GetIt.I<SetorStore>();

  @override
  void initState() {
    super.initState();
    store.buscarReservatorios();
    store.setShowTextFormField(false);
    store.setMostrarErroFormulario(false);
  }

  @override
  void dispose() {
    super.dispose();
    store.limparTudo();
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
        onTap: () {
          FocusScope.of(context).unfocus();
          if (store.novoSetorDescription.text.isEmpty) {
            store.setShowTextFormField(false);
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            backgroundColor: Constants.kBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titulo(),
                    const SizedBox(height: 20),
                    local(),
                    subtitulo(),
                    const SizedBox(height: 10),
                    nome(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.novoSetorName.text.isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Nome obrigatório',
                            style: TextStyle(
                              fontSize: 12,
                              color: Constants.kErrorColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                    const Divider(),
                    warning(),
                    reservatorio(context),
                    const Divider(),
                    descricao(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF5F5F5),
                          ),
                          child: Observer(
                            builder: (_) {
                              return SizedBox(
                                width: double.infinity,
                                child:
                                    store.novoSetorDescription.text.isEmpty &&
                                            !store.showTextFormField
                                        ? botaoDescricao()
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                              autofocus: true,
                                              maxLines: 20,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none),
                                              controller:
                                                  store.novoSetorDescription,
                                            ),
                                          ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    saveButton(size),
                  ],
                ),
              ),
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

  Widget warning() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        '*Migração Automática',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff9F9F9F),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget local() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text(
            'Local: ',
            style: TextStyle(
              fontSize: 18,
              color: Constants.kText2,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Observer(builder: (_) {
            return Text(
              store.areaSelecionada.nome ?? '',
              style: const TextStyle(
                fontSize: 18,
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            );
          }),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: SizedBox(
            child: Image.asset(
              "assets/icons/greenhouse1_icon.png",
              height: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Criando Novo Setor',
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
              child: store.isNovoSetorLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : store.isEditing
                      ? const Text(
                          "Alterar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              onPressed: () {
                if (store.validarCadastro()) {
                  if (store.isEditing) {
                    store.alterarSetor();
                  } else {
                    store.registrarSetor();
                  }
                }
              }, //store.registrarReservatorio(),
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
            trailing: store.novoSetorName.text.isNotEmpty
                ? SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 76,
                          child: Text(
                            store.novoSetorName.text,
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
              store.setDotIndicator(0);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell reservatorio(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: SvgPicture.asset(
            'assets/icons/reservatorio_icon.svg',
            height: 25,
            width: 25,
          ),
          title: const Text(
            'Reservatório',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoSetorReservatorio.nome != null &&
                  store.novoSetorReservatorio.nome!.isNotEmpty
              ? SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 76,
                        child: Text(
                          store.novoSetorReservatorio.nome!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
                )
              : const Icon(
                  Icons.chevron_right,
                  color: Constants.kPrimaryColor,
                ),
          onTap: () {
            store.setDotIndicator(1);
            bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          store.setShowTextFormField(true);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Colors.green,
            ),
            Text('Adicionar descrição'),
            Text('(opcional)')
          ],
        ),
      ),
    );
  }
}
