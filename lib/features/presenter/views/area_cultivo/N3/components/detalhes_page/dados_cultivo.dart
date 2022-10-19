import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

embalagensProduzidas(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Embalagens\nProduzidas',
        textAlign: TextAlign.start,
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
            '${store.loteSelecionado.embalagens_produzidas ?? '-'}',
            style: const TextStyle(
              color: Constants.kGreyText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.edit,
            color: Constants.kPrimaryColor,
          ),
        ],
      ),
    ),
  );
}

plantasColhidas(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Plantas\nColhidas',
        textAlign: TextAlign.start,
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
            '${store.loteSelecionado.plantas_colhidas ?? '-'}',
            style: const TextStyle(
              color: Constants.kGreyText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.edit,
            color: Constants.kPrimaryColor,
          ),
        ],
      ),
    ),
  );
}

mudasTransplantadas(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Mudas\nTransplantadas',
        textAlign: TextAlign.start,
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
            '${store.loteSelecionado.mudas_transplantadas ?? '-'}',
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
            Icons.edit,
            color: Constants.kPrimaryColor,
          ),
        ],
      ),
    ),
  );
}

bandeijasSemeadas(LoteStore store) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: ListTile(
      title: const Text(
        'Bandeijas\nSemeadas',
        textAlign: TextAlign.start,
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
            '${store.loteSelecionado.bandeijas_semeadas ?? '-'}',
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
            Icons.edit,
            color: Constants.kPrimaryColor,
          ),
        ],
      ),
    ),
  );
}
