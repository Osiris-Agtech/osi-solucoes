import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

colheita(BuildContext context, LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Colheita',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          final data = await showDatePicker(
            context: context,
            initialDate: store.loteSelecionado.colheita_data ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 2),
            lastDate: DateTime(DateTime.now().year + 3),
            locale: const Locale("pt", "BR"),
          );

          if (data != null) {
            store.setColheitaData(data);
            store.alterarDatasLote();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${store.loteSelecionado.colheita_data?.day ?? '--'}/${store.loteSelecionado.colheita_data?.month ?? '--'}/${store.loteSelecionado.colheita_data?.year ?? '--'}',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.date_range,
              color: Constants.kPrimaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}

transplantio(BuildContext context, LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Transplantio',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          final data = await showDatePicker(
            context: context,
            initialDate:
                store.loteSelecionado.transplantio_data ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 2),
            lastDate: DateTime(DateTime.now().year + 3),
            locale: const Locale("pt", "BR"),
          );

          if (data != null) {
            store.setTransplantioData(data);
            store.alterarDatasLote();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${store.loteSelecionado.transplantio_data?.day ?? '--'}/${store.loteSelecionado.transplantio_data?.month ?? '--'}/${store.loteSelecionado.transplantio_data?.year ?? '--'}',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.date_range,
              color: Constants.kPrimaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}

semeadura(BuildContext context, LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Semeadura',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          final data = await showDatePicker(
            context: context,
            initialDate: store.loteSelecionado.semeadura_data ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 2),
            lastDate: DateTime(DateTime.now().year + 3),
            locale: const Locale("pt", "BR"),
          );

          if (data != null) {
            store.setSemeaduraData(data);
            store.alterarDatasLote();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${store.loteSelecionado.semeadura_data?.day ?? '--'}/${store.loteSelecionado.semeadura_data?.month ?? '--'}/${store.loteSelecionado.semeadura_data?.year ?? '--'}',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.date_range,
              color: Constants.kPrimaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}

registro(BuildContext context, LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Registro',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          final data = await showDatePicker(
            context: context,
            initialDate: store.loteSelecionado.registro_data ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 2),
            lastDate: DateTime(DateTime.now().year + 3),
            locale: const Locale("pt", "BR"),
          );

          if (data != null) {
            store.setRegistroData(data);
            store.alterarDatasLote();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${store.loteSelecionado.registro_data?.day ?? '--'}/${store.loteSelecionado.registro_data?.month ?? '--'}/${store.loteSelecionado.registro_data?.year ?? '--'}',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.date_range,
              color: Constants.kPrimaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}
