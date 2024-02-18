import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/core/utils/decimal_format.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/solucao_store.dart';

class DetalhesSolucao extends StatefulWidget {
  const DetalhesSolucao({Key? key}) : super(key: key);

  @override
  State<DetalhesSolucao> createState() => _DetalhesSolucaoState();
}

class _DetalhesSolucaoState extends State<DetalhesSolucao> {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .5,
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${store.solucaoSelecionada.nome}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Text(
                  "C.elétrica: ${getCurrency(double.parse(store.solucaoSelecionada.c_eletrica ?? '0'))} S.m/mm2",
                  style:
                      const TextStyle(fontSize: 16, color: Constants.kGreyText),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(children: const [
                  Text(
                    'Fertilizantes',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                  Spacer(),
                  Text(
                    'quantidade / Litro',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                ]),
              ),
              Observer(builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: store.solucaoSelecionada
                          .solucoes_fertilizantes_concentradas?.length ??
                      0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                store
                                        .solucaoSelecionada
                                        .solucoes_fertilizantes_concentradas?[
                                            index]
                                        .fertilizante
                                        ?.nome ??
                                    'Não informado',
                                style:
                                    const TextStyle(color: Constants.kGreyText),
                              ),
                              Text(
                                "${getCurrency(double.parse(store.solucaoSelecionada.solucoes_fertilizantes_concentradas?[index].quantidade ?? '0'))} mg",
                                style:
                                    const TextStyle(color: Constants.kGreyText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Text(
                  'Lista de Nutrientes',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Observer(builder: (_) {
                if (store.isSolucaoDetalhesLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: store.nutrientesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(store.nutrientesList[index].key),
                              Text(
                                getCurrency(
                                  double.parse(store.nutrientesList[index]
                                          .values[0].teor_nutriente ??
                                      '0'),
                                ),
                              ),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                      // child: ListTile(
                      //   dense: true,
                      //   visualDensity: const VisualDensity(vertical: -4),
                      //   title: Text(store.nutrientesList[index].key),
                      //   trailing: Text(store
                      //           .nutrientesList[index].values[0].teor_nutriente ??
                      //       'Não encontrado'),
                      // ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
