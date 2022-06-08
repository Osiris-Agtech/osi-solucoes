import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/onboarding/splash_page.dart';

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
        // top: MediaQuery.of(context).size.width * 0.02
      ),
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
                Get.off(() => const SplashPage());
                // Modular.to
                //     .pushNamedAndRemoveUntil(path!, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.arrow_back),
              color: Constants.kPrimaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.013,
                // top: MediaQuery.of(context).size.height * 0.002
              ),
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
                  style: const TextStyle(
                      color: Color(0xff707070),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
            else
              Container(),
          ]),
    );
  }
}
