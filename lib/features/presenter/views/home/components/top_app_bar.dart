import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    super.key,
    this.path,
    this.navigate,
    required this.namePage,
    this.subtitle,
    this.onPressed,
  });
  final bool? navigate;
  final String? path;
  final String namePage;
  final String? subtitle;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
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
              if (onPressed != null) {
                onPressed!.call();
              } else {
                Get.close(1);
              }
            },
            icon: const Icon(Icons.arrow_back),
            color: Constants.kPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              namePage,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.003,
                left: 8.0,
              ), //MediaQuery.of(context).size.width * 0.013),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
        ],
      ),
    );
  }
}
