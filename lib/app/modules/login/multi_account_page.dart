import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/app_controller.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/models/usuario/usuario_model.dart';

class MultiAccountsPage extends StatefulWidget {
  final Usuario user;
  const MultiAccountsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MultiAccountsPage> createState() => _MultiAccountsPageState();
}

class _MultiAccountsPageState extends State<MultiAccountsPage> {
  final appController = Modular.get<AppController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            leading: Builder(builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                ), // size.width * 0.07
                child: IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => Modular.to
                      .pop(), //Modular.to.pushReplacementNamed("/Login/"),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  color: kPrimaryColor,
                ),
              );
            }),
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Escolha a Conta",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            elevation: 0,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .15,
                        right: MediaQuery.of(context).size.width * .15,
                        top: 20,
                      ),
                      child: const Text(
                        "Você possui vínculo com mais de uma conta. Em qual deseja entrar ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSecondBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      width: double.infinity,
                      // padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Scrollbar(
                        thickness: 8,
                        radius: const Radius.circular(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Wrap(
                                runSpacing: 12,
                                spacing: 4,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ...widget.user.contas!.map(
                                    (conta) => InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        showCircularProgressIndicator(context);
                                        appController.usuario = widget.user;
                                        appController.usuario.contas?.clear();
                                        appController.usuario.contas
                                            ?.add(conta);
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        Navigator.pop(context);
                                        Modular.to.pushNamedAndRemoveUntil(
                                            "/Home/", ModalRoute.withName('/'));
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        child: Column(
                                          children: [
                                            Card(
                                              elevation: 2,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(24.0),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(24.0),
                                                ),
                                                child: Image.network(
                                                  conta.conta?.imagem ??
                                                      'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png',
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                              ),
                                              child: Text(
                                                conta.conta?.nome ?? "...",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: Text(
                                                conta.cargo?.cargo ?? "...",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 40,
                      top: 25,
                    ),
                    child: Text(
                      "Selecione para avançar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      ),
                    ),
                  ),
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
}
