import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';

class CadastrarSolucaoConcentradaPage extends StatefulWidget {
  const CadastrarSolucaoConcentradaPage({Key? key}) : super(key: key);

  @override
  State<CadastrarSolucaoConcentradaPage> createState() =>
      _CadastrarSolucaoConcentradaPageState();
}

class _CadastrarSolucaoConcentradaPageState
    extends State<CadastrarSolucaoConcentradaPage>
    with TickerProviderStateMixin {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    store.clearSolucaoConcentrada();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

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
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  titulo(),
                  const SizedBox(height: 20),
                  subtitulo(),
                  const SizedBox(height: 10),
                  _fator(context),
                  const Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffF5F5F5),
                        ),
                        child: _cardListSolucao(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: isKeyboardOpen ? null : _saveButton(size),
          ),
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 20,
      ),
      child: Text(
        'Cadastre sua solução concentrada',
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
        left: 40,
        right: 30,
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

  _fator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Observer(builder: (_) {
          return ListTile(
            leading: const Icon(Icons.invert_colors),
            title: const Text(
              'Fator de concentração',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: store.fatorConcentracao.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        store.fatorConcentracao.text + 'x',
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
              _fatorTextField(context);
            },
          );
        }),
      ),
    );
  }

  _fatorTextField(BuildContext context) {
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
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
                color: Constants.kPrimaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
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
                        text: 'Fator de concentração',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.kPrimaryColor),
                      ),
                      TextSpan(text: ' você deseja ?'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                child: Observer(
                  builder: (_) {
                    return TextFormField(
                      controller: store.fatorConcentracao,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'EX. 300',
                        hintStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
          child: Observer(builder: (_) {
            if (store.isNovaSolucaoLoading) {
              return const CircularProgressIndicator(
                color: Constants.kBackgroundColor,
              );
            }
            return const Text(
              "Salvar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
          onPressed: () {
            store.criarSolucaoConcentrada();
            // store.cadastrarSolucaoNutritiva();
          },
        ),
      ),
    );
  }

  _cardListSolucao() {
    return Observer(builder: (_) {
      if (store.solucaoConcentradaList.isEmpty) {
        return Column(
          children: [
            _addCard(),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: store.solucaoConcentradaList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          if (index == (store.solucaoConcentradaList.length - 1)) {
            return Column(
              children: [
                _cardSolucaoConcentrada(index),
                _addCard(),
              ],
            );
          }
          return _cardSolucaoConcentrada(index);
        },
      );
    });
  }

  _addCard() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 16,
        left: 16,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          store.addToSolucaoConcentradaList();
        },
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.add_circle_outline,
                    color: Constants.kPrimaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Adicionar concentrada",
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.kGreyText,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _cardSolucaoConcentrada(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 16,
        left: 16,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Nome',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        store.deleteSolucaoConcentradaToTheList(index);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Constants.kGreyText2,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Observer(builder: (_) {
                  return TextFormField(
                    initialValue: store.solucaoConcentradaList[index].nome,
                    onChanged: (nome) {
                      store.setNomeSolucaoConcentrada(nome, index);
                    },
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'EX. Solução A',
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Fertilizantes',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(builder: (_) {
                  if (store.solucaoConcentradaList[index]
                          .solucoes_fertilizantes_concentradas?.isEmpty ??
                      true) {
                    return const Center(
                      child: Text(
                        'Nenhum fertilizante\nadicionado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Constants.kGreyMedium,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: store.solucaoConcentradaList[index]
                        .solucoes_fertilizantes_concentradas?.length,
                    itemBuilder: (_, indexFert) {
                      return Row(
                        children: const [
                          Text(
                            "• ",
                            style: TextStyle(
                              fontSize: 30,
                              color: Constants.kGreyMedium,
                            ),
                          ),
                          Text(
                            'Fertilizante #1',
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Constants.kGreyMedium,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _solucaoConcentradaFertList(
                        store.solucaoConcentradaList[index].nome);
                  },
                  child: const Text(
                    '+ Adicionar fertilizante',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Constants.kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _solucaoConcentradaFertList(String? nome) {
    return showModalBottomSheet<void>(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
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
        return Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.close,
                      size: 28,
                      color: Constants.kPrimaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nome != null && nome.isNotEmpty ? nome : 'Sua solução',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Constants.kText2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Observer(builder: (_) {
                    if (store.showFertilizantesNaoUtilizados.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Nenhum fertilizantes disponível para adição',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Constants.kGreyMedium,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: store.showFertilizantesNaoUtilizados.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                            top: index == 0 ? 10 : 0,
                          ),
                          child: ListTile(
                            leading: Observer(builder: (_) {
                              if (!store.showFertilizantesNaoUtilizados[index]
                                  .selected) {
                                return const Icon(
                                    Icons.check_box_outline_blank_rounded);
                              }
                              return const Icon(
                                Icons.check_box,
                                color: Constants.kPrimaryColor,
                              );
                            }),
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            title: Text(
                              store.showFertilizantesNaoUtilizados[index]
                                      .fertilizante.nome ??
                                  "---",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              store.changeSelecaoFertilizantesEscolhidos(
                                index,
                                !store.showFertilizantesNaoUtilizados[index]
                                    .selected,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 32),
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
                          child: const Text(
                            "Confirmar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {},
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
