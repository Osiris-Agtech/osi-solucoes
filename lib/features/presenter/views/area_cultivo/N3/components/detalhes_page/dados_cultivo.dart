import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(builder: (_) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Text(
                '${store.loteSelecionado.embalagens_produzidas ?? '0'}',
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondChild: SizedBox(
                width: 50,
                child: TextFormField(
                  controller: store.embalagensProduzidasController,
                ),
              ),
              crossFadeState: !store.isEmbalagensEditing
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          }),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: Observer(builder: (_) {
              if (store.isEmbalagensEditing) {
                return const Icon(
                  Icons.check,
                  color: Constants.kPrimaryColor,
                );
              }
              return const Icon(
                Icons.edit,
                color: Constants.kPrimaryColor,
              );
            }),
            onTap: () {
              store.setIsEmbalagensEditing(!store.isEmbalagensEditing);
            },
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
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(builder: (_) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Text(
                '${store.loteSelecionado.plantas_colhidas ?? '0'}',
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondChild: SizedBox(
                width: 50,
                child: TextFormField(
                  controller: store.plantasColhidasController,
                ),
              ),
              crossFadeState: !store.isPlantasEditing
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          }),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: Observer(builder: (_) {
              if (store.isPlantasEditing) {
                return const Icon(
                  Icons.check,
                  color: Constants.kPrimaryColor,
                );
              }
              return const Icon(
                Icons.edit,
                color: Constants.kPrimaryColor,
              );
            }),
            onTap: () {
              store.setIsPlantasEditing(!store.isPlantasEditing);
            },
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
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(builder: (_) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Text(
                '${store.loteSelecionado.mudas_transplantadas ?? '0'}',
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondChild: SizedBox(
                width: 50,
                child: TextFormField(
                  controller: store.mudasTransplantadasController,
                ),
              ),
              crossFadeState: !store.isMudasEditing
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          }),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: Observer(builder: (_) {
              if (store.isMudasEditing) {
                return const Icon(
                  Icons.check,
                  color: Constants.kPrimaryColor,
                );
              }
              return const Icon(
                Icons.edit,
                color: Constants.kPrimaryColor,
              );
            }),
            onTap: () {
              store.setIsMudasEditing(!store.isMudasEditing);
            },
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
        'Bandejas\nSemeadas',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Constants.kText2,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(builder: (_) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Text(
                '${store.loteSelecionado.bandeijas_semeadas ?? '0'}',
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondChild: SizedBox(
                width: 50,
                child: TextFormField(
                  controller: store.bandeijasSemeadasController,
                ),
              ),
              crossFadeState: !store.isBandeijasEditing
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );
          }),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: Observer(builder: (_) {
              if (store.isBandeijasEditing) {
                return const Icon(
                  Icons.check,
                  color: Constants.kPrimaryColor,
                );
              }
              return const Icon(
                Icons.edit,
                color: Constants.kPrimaryColor,
              );
            }),
            onTap: () {
              store.setIsBandeijaEditing(!store.isBandeijasEditing);
            },
          ),
        ],
      ),
    ),
  );
}
