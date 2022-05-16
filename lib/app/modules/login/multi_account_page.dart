import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:osi_solucoes/app/constants.dart';

class MultiAccountsPage extends StatefulWidget {
  const MultiAccountsPage({Key? key}) : super(key: key);

  @override
  State<MultiAccountsPage> createState() => _MultiAccountsPageState();
}

class _MultiAccountsPageState extends State<MultiAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kSecondBackgroundColor,
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
                  onPressed: () => Modular.to.pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  color: kPrimaryColor,
                ),
              );
            }),
            elevation: 0,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20,
                  ),
                  child: Text(
                    "Escolha a Conta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .15),
                      child: const Text(
                        "Você possui vínculo com mais de uma conta. Em qual deseja entrar ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 12,
                    childAspectRatio: .7,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    children: List.generate(5, (index) {
                      return Column(
                        children: [
                          Card(
                            elevation: 2,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24.0),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24.0),
                              ),
                              child: Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              "Osíris",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 2,
                            ),
                            child: Text(
                              "Administrador",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
