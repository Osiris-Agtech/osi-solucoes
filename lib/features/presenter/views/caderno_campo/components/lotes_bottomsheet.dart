import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/caderno_campo_store.dart';

class LotesBottomSheet extends StatefulWidget {
  const LotesBottomSheet({Key? key}) : super(key: key);

  @override
  State<LotesBottomSheet> createState() => _LotesBottomSheetState();
}

class _LotesBottomSheetState extends State<LotesBottomSheet> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lotes Selecionados',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const SizedBox(height: 16),
              Observer(builder: (_) {
                if (store.selectedLotes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'É preciso selecionar pelos menos 1 lote que esteja sendo afetado pela atividade',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Constants.kGreyMedium,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: store.selectedLotes.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(
                            Icons.check_box,
                            color: Constants.kPrimaryColor,
                          ),
                          onPressed: () {
                            store.selectLotesByLote(
                                store.selectedLotes[index], false);
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            store.selectedLotes[index].nome ?? 'Não informado',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Constants.kText2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
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
                          : const Text(
                              "Confirmar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      onPressed: store.selectedLotes.isNotEmpty
                          ? () {
                              if (store.isEditing) {
                                // store.alterarSetor();
                              } else {
                                store.cadastrarAtividade();
                              }
                            }
                          : null, //store.registrarReservatorio(),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
