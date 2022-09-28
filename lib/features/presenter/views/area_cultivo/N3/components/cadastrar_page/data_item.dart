import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

datas(BuildContext context) {
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
        registroItem(),
        semeaduraItem(),
        transplantioItem(),
        colheitaItem(),
      ],
    );
  });
}

registroItem() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      dense: true,
      title: const Text(
        'Registro',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            SizedBox(
              width: 100,
              child: Text(
                '25/07/2021',
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
  );
}

semeaduraItem() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Semeadura',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
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
  );
}

transplantioItem() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Transplantio',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
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
  );
}

colheitaItem() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: ListTile(
      title: const Text(
        'Colheita',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: SizedBox(
        width: 140,
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
  );
}
