// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

class EditFaseBottomSheetFaseBottomSheet extends StatefulWidget {
  const EditFaseBottomSheetFaseBottomSheet({super.key});

  @override
  State<EditFaseBottomSheetFaseBottomSheet> createState() =>
      _EditFaseBottomSheetFaseBottomSheet();
}

class _EditFaseBottomSheetFaseBottomSheet
    extends State<EditFaseBottomSheetFaseBottomSheet> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(Get.context!).size;

    return SizedBox(
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
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
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "${store.selectedDetalhesFase?.nome} ",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Selecione o dia que essa atividade será realizada dentro da fase escolhida.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Observer(builder: (_) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(
                      store.selectedDetalhesFase!.duracao_dias!, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => {store.alterarDiaDaAtiv(index + 1)},
                          child: Icon(
                            store.diaDaAtivDetalhes != null &&
                                    (store.diaDaAtivDetalhes! - 1) == index
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 50,
                            color: store.diaDaAtivDetalhes != null &&
                                    (store.diaDaAtivDetalhes! - 1) == index
                                ? Constants.kPrimaryColor
                                : Constants.kGreyMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dia ${index + 1}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    );
                  }),
                ),
              );
            }),
            Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Center(
                  child: SizedBox(
                    width: size.width * .8,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Selecionar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          store.setarDuracaoDiasFaseDetalhes(
                              store.diaDaAtivDetalhes.toString());
                          Get.back();
                        }),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
