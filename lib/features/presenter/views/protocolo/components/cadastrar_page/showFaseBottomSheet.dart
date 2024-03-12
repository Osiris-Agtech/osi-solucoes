import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

class ShowFaseBottomSheet extends StatefulWidget {
  const ShowFaseBottomSheet({Key? key}) : super(key: key);

  @override
  State<ShowFaseBottomSheet> createState() => _ShowFaseBottomSheet();
}

class _ShowFaseBottomSheet extends State<ShowFaseBottomSheet> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(Get.context!).size;

    return Padding(
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
          Text(
            "${store.selectedFase?.nome}: Selecione o dia para realização da atividade ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Constants.kPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Observer(builder: (_) {
            return Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children:
                    List.generate(store.selectedFase!.duracao_dias!, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => {store.setDiaDaAtiv(index + 1)},
                        child: Icon(
                          store.diaDaAtiv != null &&
                                  (store.diaDaAtiv! - 1) == index
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 80,
                          color: Constants.kPrimaryColor,
                        ),
                      ),
                      Text(
                        'Dia ${index + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  );
                }),
              ),
            );
          }),
          Observer(builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
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
                      child: const Text(
                        "Selecionar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        store.setarDuracaoDiasFase(store.diaDaAtiv.toString());
                        Get.back();
                      }),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
