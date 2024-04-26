import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

class ResultadoLote extends StatefulWidget {
  final Lote? lote;
  const ResultadoLote({Key? key, required this.lote}) : super(key: key);

  @override
  State<ResultadoLote> createState() => _ResultadoLoteState();
}

class _ResultadoLoteState extends State<ResultadoLote> {
  var size = MediaQuery.of(Get.context!).size;
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Text(
                widget.lote!.nome ?? "Lote",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
              const SizedBox(height: 30),
              const Text('Plantas colhidas:'),
              TextFormField(
                initialValue: widget.lote!.plantas_colhidas != null
                    ? widget.lote!.plantas_colhidas.toString()
                    : "",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                  hintText: 'Número de plantas colhidas ...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onChanged: (value) {
                  if (value != "") {
                    store.preencherPlantasColhidas(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Embalagens produzidas:'),
              TextFormField(
                initialValue: widget.lote!.embalagens_produzidas != null
                    ? widget.lote!.embalagens_produzidas.toString()
                    : "",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                  hintText: 'Número de embalagens produzidas ...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onChanged: (value) {
                  if (value != "") {
                    store.preencherEmbalagensProduzidas(value);
                  }
                },
              ),
              // const Padding(
              //   padding: EdgeInsets.only(top: 5.0),
              //   child: Text('Data Prevista: 24/10/2023 - 26/10/2023'),
              // ),
              const SizedBox(height: 50),
              Padding(
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
                        "Salvar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        store.salvarDetalhesLote(widget.lote!.id!);
                        Get.back();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
