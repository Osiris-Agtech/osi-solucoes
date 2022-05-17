import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Modular.to.pushReplacementNamed("/Login/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: kBackgroundColor,
      child: Center(
        child: Image.asset(
          "assets/images/osiris-logo.png",
          width: MediaQuery.of(context).size.width * .5,
        ),
      ),
    );
  }
}
