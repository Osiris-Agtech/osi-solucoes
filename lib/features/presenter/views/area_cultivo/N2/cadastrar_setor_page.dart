import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_validation_message.dart';
import '../../../../../core/constants/constants.dart';

class CadastrarSetorPage extends StatefulWidget {
  const CadastrarSetorPage({super.key});

  @override
  State<CadastrarSetorPage> createState() => _CadastrarSetorPageState();
}

class _CadastrarSetorPageState extends State<CadastrarSetorPage> {
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
            appBar: AppFormHeader(
              onBack: () => Get.back(),
              title: 'Novo Setor',
            ),
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
                    const SizedBox(height: 20),
                    local(),
                    subtitulo(),
                    const SizedBox(height: 10),
                    nome(context),
                    AppValidationMessage(
                      message: store.mostrarErroFormulario &&
                              store.novoSetorName.text.isEmpty
                          ? 'Nome obrigatório'
                          : null,
                    ),
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
            'Área: ',
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

  Widget saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        width: size.width * .8,
        child: Observer(builder: (_) {
          return AppPrimaryButton(
            label: store.isEditing ? 'Alterar' : 'Salvar',
            isLoading: store.isNovoSetorLoading,
            onPressed: () {
              if (store.validarCadastro()) {
                if (store.isEditing) {
                  store.alterarSetor();
                } else {
                  store.registrarSetor();
                }
              }
            },
          );
        }),
      ),
    );
  }

  Widget nome(BuildContext context) {
    return Observer(builder: (_) {
      final hasName = store.novoSetorName.text.isNotEmpty;
      return AppFormSelectionTile(
        leading: const Icon(Icons.label),
        title: 'Nome',
        subtitle: hasName ? store.novoSetorName.text : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasName ? store.novoSetorName.text : 'Preencher',
              style: const TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
          ],
        ),
        onTap: () {
          store.setDotIndicator(0);
          bottomSheet(context, store);
        },
      );
    });
  }

  Widget reservatorio(BuildContext context) {
    return Observer(builder: (_) {
      final hasRes = store.novoSetorReservatorio.nome != null &&
          store.novoSetorReservatorio.nome!.isNotEmpty;
      return AppFormSelectionTile(
        leading: const Icon(Icons.water_drop),
        title: 'Reservatório',
        subtitle: hasRes ? store.novoSetorReservatorio.nome : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasRes ? store.novoSetorReservatorio.nome! : 'Selecionar',
              style: const TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
          ],
        ),
        onTap: () {
          store.setDotIndicator(1);
          bottomSheet(context, store);
        },
      );
    });
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
