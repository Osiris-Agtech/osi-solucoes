import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app/constants.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    Key? key,
    this.path,
    this.navigate,
    required this.namePage,
    this.subtitle,
  }) : super(key: key);
  final bool? navigate;
  final String? path;
  final String namePage;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.088,
          top: MediaQuery.of(context).size.width * 0.024),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              onPressed: () {
                Modular.to
                    .pushNamedAndRemoveUntil(path!, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.arrow_back),
              color: kPrimaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.013,
                  top: MediaQuery.of(context).size.height * 0.002),
              child: Text(
                namePage,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.003,
                    left: MediaQuery.of(context).size.width * 0.013),
                child: Text(
                  "subtitleTopAppBar".i18n(),
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              )
            else
              Container(),
          ]),
    );
  }
}
