import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_store.dart';

class ConfirmsegurancaPage extends StatefulWidget {
  final String title;
  const ConfirmsegurancaPage({Key? key, this.title = 'ConfirmaPage'})
      : super(key: key);
  @override
  ConfirmsegurancaPageState createState() => ConfirmsegurancaPageState();
}

class ConfirmsegurancaPageState extends State<ConfirmsegurancaPage> {
  final FocusScopeNode focusNode = FocusScopeNode();
  final store = Modular.get<CadastroStore>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Builder(builder: (_) {
              return Padding(
                padding: EdgeInsets.only(left: size.width * 0.07),
                child: IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: () => Modular.to.pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  color: Colors.green,
                ),
              );
            }),
            elevation: 0,
          ),
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
                              text: " " + 'confirmaText4'.i18n(),
                              style: const TextStyle(
                                  color: Color(0xFF1C5EC1), fontSize: 12),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {}),
                          TextSpan(
                            text: '\n' + "confirmaText5".i18n(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        ]),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: size.height * .094),
                    child: Center(
                      child: SizedBox(
                        width: size.width * .7,
                        height: 45,
                        child: ElevatedButton(
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
                                      Modular.to
                                          .popUntil(ModalRoute.withName("/")),
                                      Modular.to.canPop(),
                                      Modular.to.pushReplacementNamed("/Home/"),
                                    }
                                  : {
                                      showErrorDialog(context, res),
                                      await Future.delayed(
                                          const Duration(seconds: 2)),
                                      Navigator.pop(context),
                                      Navigator.pop(context),
                                    };
                            }
                          },
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: TextButton(
                      onPressed: () {
                        Modular.to.pushNamedAndRemoveUntil(
                            "/", ModalRoute.withName('/'));
                      },
                      child: Text(
                        "confirmaText6".i18n(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCircularProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  showErrorDialog(BuildContext context, String error) {
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
