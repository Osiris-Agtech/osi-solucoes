// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class TopAppBarArea extends StatelessWidget {
  const TopAppBarArea({
    Key? key,
    this.path,
    this.navigate,
    required this.namePage1,
    required this.namePage2,
    this.subtitle,
    this.onPressed,
  }) : super(key: key);
  final bool? navigate;
  final String? path;
  final String namePage1;
  final String namePage2;
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
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.013, right: 16
                // top: MediaQuery.of(context).size.height * 0.002
                ),
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: namePage1,
                  style: const TextStyle(
                    color: Constants.kText2,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: namePage2,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.003,
                  left: MediaQuery.of(context).size.width * 0.013),
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
