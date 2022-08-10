// ignore_for_file: file_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/relacaoNutriente/relacaoNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

Widget receitaDetalhe(BuildContext context, CarouselController controlerPages,
    ReservatoriosStore store) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.8,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: 3,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Constants.kContentColorLightTheme.withOpacity(.4),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
          child: Row(
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
        ),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    flexibleSpace: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Observer(builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, left: 30),
                            child: Text(
                              store.solucaoDetalhes?.nome ?? "---",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }),
                        Observer(builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 30, bottom: 0),
                            child: Text(
                              'C. elétrica: ${store.solucaoDetalhes?.c_eletrica} S.m/mm2',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff6F6464),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Fertilizantes',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'quantidade/Litro',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Observer(builder: (_) {
                            if (store.isDetalhesSolucaoLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            if (store.solucaoDetalhes
                                        ?.solucoes_fertilizantes_concentradas !=
                                    null &&
                                store
                                    .solucaoDetalhes!
                                    .solucoes_fertilizantes_concentradas!
                                    .isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    'Não há fertilizantes\ncadastrados nesta solução nutritiva',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff6F6464),
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: store.solucaoDetalhes
                                  ?.solucoes_fertilizantes_concentradas?.length,
                              itemBuilder: (context, index) {
                                SolucaoFertilizanteConcentrada? item = store
                                        .solucaoDetalhes
                                        ?.solucoes_fertilizantes_concentradas?[
                                    index];
                                return ListTile(
                                  dense: true,
                                  title: Text(item?.fertilizante?.nome ?? ''),
                                  trailing: Text(
                                      '${item?.quantidade?.replaceAll(".", ",")} g/L'),
                                );
                              },
                            );
                          }),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Relação de Nutrientes',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Observer(builder: (_) {
                            if (store.isDetalhesSolucaoLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: store.relacaoNutrientes.length,
                              itemBuilder: (context, index) {
                                RelacaoNutriente? item =
                                    store.relacaoNutrientes[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(item.relacao),
                                  trailing: Text(
                                    item.valor
                                        .toStringAsFixed(2)
                                        .replaceAll(".", ","),
                                  ),
                                );
                              },
                            );
                          }),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Teor de Nutrientes',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'mg/Litro',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Observer(builder: (_) {
                            if (store.isDetalhesSolucaoLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: store.teorNutrientes.length,
                              itemBuilder: (context, index) {
                                FertilizanteNutriente? item =
                                    store.teorNutrientes[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(item.nutriente?.nome ?? ''),
                                  trailing: Text(
                                      double.parse(item.teor_nutriente!)
                                              .toStringAsFixed(2)
                                              .replaceAll(".", ",") +
                                          ' mg/L'),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 30.0),
                  child: Observer(builder: (_) {
                    bool isAlreadySelected = store.solucaoNutritiva.id !=
                            null &&
                        store.solucaoNutritiva.id == store.solucaoDetalhes?.id;
                    return SizedBox(
                      height: 40,
                      width: isAlreadySelected ? 151 : 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          primary: isAlreadySelected
                              ? Constants.kErrorColor
                              : Constants.kPrimaryColor,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isAlreadySelected
                                    ? 'Desvincular'
                                    : 'Selecionar',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                isAlreadySelected
                                    ? Icons.close
                                    : Icons.chevron_right,
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          isAlreadySelected
                              ? store.desvincularSolucaoNutritiva()
                              : store
                                  .setSolucaoNutritiva(store.solucaoDetalhes!);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
