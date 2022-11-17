import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

colheita(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Colheita',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
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
  );
}

transplantio(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Transplantio',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
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
  );
}

semeadura(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Semeadura',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
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
  );
}

registro(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Registro',
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
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
  );
}
