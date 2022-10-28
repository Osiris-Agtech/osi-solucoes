import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/bottomSheet.dart';
import '../../../../../core/constants/constants.dart';

class CadastroCadernoCampoPage extends StatefulWidget {
  const CadastroCadernoCampoPage({Key? key}) : super(key: key);

  @override
  State<CadastroCadernoCampoPage> createState() =>
      _CadastroCadernoCampoPageState();
}

class _CadastroCadernoCampoPageState extends State<CadastroCadernoCampoPage> {
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  SetorStore store = GetIt.I<SetorStore>();

  @override
  void initState() {
    super.initState();
    store.buscarReservatorios();
    store.setShowTextFormField(false);
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
                const SizedBox(height: 20),
                subtitulo(),
                const SizedBox(height: 10),
                atividade(context),
                const Divider(),
                autor(context),
                const Divider(),
                data(context),
                const Divider(),
                hora(context),
                const Divider(),
                lote(context),
                const Divider(),
                descricao(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffF5F5F5),
                      ),
                      child: Observer(
                        builder: (_) {
                          return SizedBox(
                            width: double.infinity,
                            child: store.novoSetorDescription.text.isEmpty &&
                                    !store.showTextFormField
                                ? botaoDescricao()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      autofocus: true,
                                      maxLines: 20,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: store.novoSetorDescription,
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
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        'Cadastrar no caderno de campo',
        style: TextStyle(
          fontSize: 14,
          color: Constants.kGreyText,
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

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Novo Registro',
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
                if (store.isEditing) {
                  store.alterarSetor();
                } else {
                  store.registrarSetor();
                }
              }, //store.registrarReservatorio(),
            );
          }),
        ),
      ),
    );
  }

  InkWell atividade(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.label),
            title: const Text(
              'Atividade',
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

  InkWell autor(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(
              'Autor',
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

  InkWell data(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.event),
            title: const Text(
              'Data',
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

  InkWell hora(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text(
              'Hora',
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

     InkWell lote (BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.eco),
            title: const Text(
              'Lote',
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


  Widget descricao() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 5),
      child: Text(
        'Descrição da Atividade',
        style: TextStyle(
          fontSize: 14,
          color: Constants.kGreyText,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding botaoDescricao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
