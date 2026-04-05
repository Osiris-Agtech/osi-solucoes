// ignore_for_file: file_names

import 'package:brasil_fields/brasil_fields.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/loadingDialog.dart';

Widget novaLocalizacaoPage(BuildContext context,
    CarouselSliderController controlerPages, AreaCultivoStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              controlerPages.previousPage();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 28,
              color: Constants.kPrimaryColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Cadastrar nova\n',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'localização',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Expanded(
            child: FormularioNovaLocalizacao(),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left, color: Colors.grey),
                        Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: Constants.kPrimaryColor,
                    ),
                    onPressed: () {
                      store.cadastrarNovaLocalizacao(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Cadastrar',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.chevron_right_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FormularioNovaLocalizacao extends StatefulWidget {
  const FormularioNovaLocalizacao({
    super.key,
  });

  @override
  State<FormularioNovaLocalizacao> createState() =>
      _FormularioNovaLocalizacaoState();
}

class _FormularioNovaLocalizacaoState extends State<FormularioNovaLocalizacao> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Observer(builder: (_) {
              return TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
                onChanged: (value) async {
                  if (value.length == 10) {
                    showCircularProgressIndicator(context);
                    await store.buscaCEP();
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                controller: store.cep,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    labelText: 'Cep'),
              );
            }),
            Observer(builder: (_) {
              return TextFormField(
                textInputAction: TextInputAction.next,
                controller: store.endereco,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    labelText: 'Endereço'),
              );
            }),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Observer(builder: (_) {
                      return TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: store.bairro,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                            labelText: 'Bairro'),
                      );
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Observer(builder: (_) {
                        return TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: store.numero,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                              ),
                              labelText: 'Número'),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Observer(builder: (_) {
              return TextFormField(
                textInputAction: TextInputAction.next,
                controller: store.cidade,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    labelText: 'Cidade'),
              );
            }),
            Observer(builder: (_) {
              return TextFormField(
                textInputAction: TextInputAction.next,
                controller: store.estado,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    labelText: 'Estado'),
              );
            }),
            Observer(
              builder: (_) {
                return TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: store.pais,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'País'),
                );
              },
            ),
            Observer(
              builder: (_) {
                return TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: store.complemento,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      labelText: 'Complemento'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
