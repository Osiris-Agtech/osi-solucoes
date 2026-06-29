import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/onboarding/splash_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/material.dart';

import '../../viewmodels/cadastro_store.dart';
import '../home/home_page.dart';

class ConfirmaSegurancaPage extends StatefulWidget {
  final String title;
  const ConfirmaSegurancaPage({super.key, this.title = 'ConfirmaPage'});
  @override
  ConfirmaSegurancaPageState createState() => ConfirmaSegurancaPageState();
}

class ConfirmaSegurancaPageState extends State<ConfirmaSegurancaPage> {
  final FocusScopeNode focusNode = FocusScopeNode();
  // final store = Modular.get<CadastroStore>();
  CadastroStore store = GetIt.I<CadastroStore>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.kBackgroundColor,
          appBar: appBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: SizedBox(
                      child: Image.asset(
                        "assets/images/osiris-logo.png",
                        width: size.width * 0.42,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.118,
                      left: size.width * 0.066,
                      right: size.width * 0.066),
                  child: Text(
                    "confirmaText1".i18n(),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: FocusScope(
                    node: focusNode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: size.width * 0.021),
                          width: size.width * 0.16,
                          child: TextFormField(
                            controller: store.primeiroDigito,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              store.primeiroDigito.text.isNotEmpty
                                  ? focusNode.nextFocus()
                                  : focusNode.unfocus();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: size.width * 0.021),
                          width: size.width * 0.16,
                          child: TextFormField(
                            controller: store.segundoDigito,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              store.segundoDigito.text.isNotEmpty
                                  ? focusNode.nextFocus()
                                  : focusNode.previousFocus();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: size.width * 0.021),
                          width: size.width * 0.16,
                          child: TextFormField(
                            controller: store.terceiroDigito,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              store.terceiroDigito.text.isNotEmpty
                                  ? focusNode.nextFocus()
                                  : focusNode.previousFocus();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: size.width * 0.021),
                          width: size.width * 0.16,
                          child: TextFormField(
                            controller: store.quartoDigito,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              store.quartoDigito.text.isNotEmpty
                                  ? focusNode.unfocus()
                                  : focusNode.previousFocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.012),
                  child: Text("confirmaText2".i18n()),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.078,
                      left: size.width * 0.234,
                      right: size.width * 0.234),
                  child: RichText(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: 'confirmaText3'.i18n(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: "MontSerrat "),
                        children: <TextSpan>[
                          TextSpan(
                            text: " ${'confirmaText4'.i18n()}",
                            style: const TextStyle(
                                color: Color(0xFF1C5EC1), fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                showCircularProgressIndicator(context);
                                await store.enviarCodigoEmail();
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                          ),
                          TextSpan(
                            text: '\n${"confirmaText5".i18n()}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * .08),
                  child: Center(
                    child: SizedBox(
                      width: size.width * .7,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.kPrimaryColor),
                        child: Text(
                          "TextButtonConfirmar".i18n(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          if (store.verificaCodigo()) {
                            showCircularProgressIndicator(context);
                            String res = await store.cadastraUser();
                            await Future.delayed(const Duration(seconds: 2));
                            res == "sucesso"
                                ? {
                                    if (context.mounted)
                                      showDoneAnimation(context),
                                    await Future.delayed(
                                        const Duration(milliseconds: 1400)),
                                    Get.offAll(() => const HomePage()),
                                  }
                                : {
                                    if (context.mounted)
                                      showErrorDialog(context, res),
                                    await Future.delayed(
                                        const Duration(seconds: 2)),
                                    if (context.mounted) Navigator.pop(context),
                                    if (context.mounted) Navigator.pop(context),
                                  };
                          } else {
                            showErrorDialog(context, "Código Incorreto");
                          }
                        },
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAll(() => const SplashPage());
                  },
                  child: Text(
                    "confirmaText6".i18n(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppFormHeader appBar() {
    return AppFormHeader(
      onBack: () => Get.back(),
    );
  }

  void showCircularProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void showDoneAnimation(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child:
                rive.RiveAnimation.asset("assets/animation/doneAnimation.riv"),
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              error,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
