import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(12),
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
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nome Fase ( 10 dias )',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Constants.kText2,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(10, (index) {
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
