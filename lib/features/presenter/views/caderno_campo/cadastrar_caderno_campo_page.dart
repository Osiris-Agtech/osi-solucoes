import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/bottomSheet.dart';
import '../../../../../core/constants/constants.dart';
import 'package:intl/intl.dart';

class CadastroCadernoCampoPage extends StatefulWidget {
  const CadastroCadernoCampoPage({Key? key}) : super(key: key);

  @override
  State<CadastroCadernoCampoPage> createState() =>
      _CadastroCadernoCampoPageState();
}

class _CadastroCadernoCampoPageState extends State<CadastroCadernoCampoPage> {
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      store.groupLotesBy();
      store.buscarUsuariosConta();
    });
  }

  @override
  void dispose() {
    store.limparTudo();
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
      child: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          if (store.novaDescricao.text.isEmpty) {
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
                    _descricaoTextFormField(),
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
            return SizedBox(
              width: double.infinity,
              child:
                  store.novaDescricao.text.isEmpty && !store.showTextFormField
                      ? botaoDescricao()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            autofocus: true,
                            maxLines: 20,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: store.novaDescricao,
                          ),
                        ),
            );
          },
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
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 30,
      ),
      child: Center(
        child: SizedBox(
          height: 40,
          width: double.infinity,
          child: Observer(builder: (_) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: store.isNovoRegistroLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
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
                if (!store.validarCadastro()) {
                  toastError(message: 'Preencha todos os campos corretamente');
                  return;
                }

                if (store.isEditing) {
                  // store.alterarSetor();
                } else {
                  store.cadastrarAtividade();
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
          trailing: store.novoAtividadeName.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      store.novoAtividadeName.text,
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

  InkWell autor(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(
              'Autor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            trailing: store.novoAutorName.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        store.novoAutorName.text,
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
                        "Nenhum Selecionado",
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

  InkWell data(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.event),
          title: const Text(
            'Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat("dd/MM/y", 'pt_br')
                        .format(
                          store.dateRegistro,
                        )
                        .capitalize ??
                    '',
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
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              locale: const Locale("pt", "BR"),
            );

            if (date != null) {
              store.selectDateRegistro(date);
            }
          },
        );
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat("HH:mm", 'pt_br')
                        .format(store.dateRegistro)
                        .capitalize ??
                    '',
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
          ),
          onTap: () async {
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time != null) {
              store.selectTimeRegistro(time);
            }
          },
        );
      }),
    );
  }

  InkWell lote(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.eco),
          title: const SizedBox(
            width: 100,
            child: Text(
              'Lote',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
          trailing: store.selectedLotes.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${store.selectedLotes.length} lotes selecionados',
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
                      "Nenhum Selecionado",
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
            store.setDotIndicator(2);
            bottomSheet(context, carouselController, controlerPages, store);
          },
        );
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
              Icons.add_circle_outline,
              color: Colors.green,
            ),
          ),
          const Text('Adicionar descrição'),
        ],
      ),
    );
  }
}
