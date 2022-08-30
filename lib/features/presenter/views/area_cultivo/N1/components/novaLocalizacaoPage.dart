import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';

Widget novaLocalizacaoPage(BuildContext context,
    CarouselController controlerPages, AreaCultivoStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  controlerPages.previousPage();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                ),
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
          RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Cadastrar nova   ',
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
            height: 20,
          ),
          TextFormField(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
                hintText: 'EX.78010-000',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                labelText: 'Cep'),
          ),
          TextFormField(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
                hintText: 'EX.Rua Florianópolis',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                labelText: 'Endereço'),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: const InputDecoration(
                        hintText: 'EX.Centro',
                        hintStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                        labelText: 'Bairro'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: const InputDecoration(
                          hintText: 'EX.14',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                          labelText: 'Número'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
                hintText: 'EX.Juscimeira',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                labelText: 'Cidade'),
          ),
          TextFormField(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
                hintText: 'Opcional',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                labelText: 'Complemento'),
          ),
          const Spacer(),
          Row(
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
                        borderRadius: BorderRadius.circular(24)),
                    primary: Constants.kPrimaryColor,
                  ),
                  onPressed: () {},
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
                  ))
            ],
          )
        ],
      ),
    ),
  );
}
