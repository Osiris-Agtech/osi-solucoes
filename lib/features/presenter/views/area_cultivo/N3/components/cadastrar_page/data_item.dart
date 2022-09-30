import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

datas(BuildContext context, LoteStore store) {
  return Observer(builder: (_) {
    return Column(
      children: [
        const ListTile(
          leading: Icon(
            Icons.watch_later,
            color: Constants.kPrimaryColor,
          ),
          title: Text(
            'Datas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
        ),
        registroItem(store, context),
        semeaduraItem(store, context),
        transplantioItem(store, context),
        colheitaItem(store, context),
      ],
    );
  });
}

registroItem(LoteStore store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      dense: true,
      title: const Text(
        'Registro',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 150,
        child: InkWell(
          onTap: () async {
            final data = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2030));
            locale:
            const Locale("pt", "BR");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  '${store.registroData.day}/${store.registroData.month}/${store.registroData.year}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

semeaduraItem(LoteStore store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Semeadura',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 150,
        child: InkWell(
          onTap: () async {
            final data = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2030));
            locale:
            const Locale("pt", "BR");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.event, color: Constants.kPrimaryColor),
            ],
          ),
        ),
      ),
    ),
  );
}

transplantioItem(LoteStore store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Transplantio',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
        child: InkWell(
          onTap: () async {
            final data = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2030));
            locale:
            const Locale("pt", "BR");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

colheitaItem(LoteStore store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Colheita',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
        child: InkWell(
          onTap: () async {
            final data = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2030));
            locale:
            const Locale("pt", "BR");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              SizedBox(
                width: 100,
                child: Text(
                  'Opcional',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Constants.kGreyText2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.event,
                color: Constants.kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
