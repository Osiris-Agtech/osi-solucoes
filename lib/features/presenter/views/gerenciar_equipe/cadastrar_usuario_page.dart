import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/gerenciar_equipe_store.dart';

class CadastrarUsuarioPage extends StatefulWidget {
  const CadastrarUsuarioPage({Key? key}) : super(key: key);

  @override
  State<CadastrarUsuarioPage> createState() => _CadastrarUsuarioPageState();
}

class _CadastrarUsuarioPageState extends State<CadastrarUsuarioPage> {
  GerenciarEquipeStore store = GetIt.I<GerenciarEquipeStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          resizeToAvoidBottomInset: false,
          appBar: appBar(),
          backgroundColor: Constants.kBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  titulo(),
                  subtitulo(),
                  const SizedBox(height: 20),
                  image(context),
                  email(context, store),
                  cargo(context),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Divider(
                      color: Constants.kGreyText2.withOpacity(0.3),
                    ),
                  ),
                  info(context),
                  saveButton(size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Cadastrar Colaborador',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        'Novo Colaborador',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff6F6464),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget image(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 10,
          bottom: 25,
          top: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              child: Image.asset(
                "assets/images/cadastro_usuario.png",
              ),
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'O convite será enviado no ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Constants.kText2.withOpacity(0.75),
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'e-mail ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.kPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' do colaborador. Basta apenas aceitá-lo, para ter acesso aos cultivos',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Constants.kText2.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget cargo(BuildContext context) {
    // Initial Selected Value
    String dropdownvalue = 'Item 1';

    // List of items in our dropdown menu
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cargo',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          DropdownButton(
            value: dropdownvalue,
            isExpanded: true,
            underline: DropdownButtonHideUnderline(child: Container()),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Constants.kPrimaryColor,
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Constants.kPrimaryColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {},
          ),
        ],
      ),
    );
  }

  Widget email(BuildContext context, GerenciarEquipeStore store) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'E-mail',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          TextFormField(
            onChanged: (value) => {},
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Constants.kGreyText2.withOpacity(0.3)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Constants.kGreyText2.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget info(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      child: InkWell(
        onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return dialog();
            }),
        child: Row(
          children: const [
            Icon(
              Icons.help_outline_outlined,
              color: Constants.kPrimaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Permissões do Cargo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Constants.kPrimaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dialog() {
    return SimpleDialog(
      title: Row(
        children: const [
          Icon(
            Icons.group_add,
            color: Constants.kPrimaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text('Permissões'),
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Constants.kCardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: const ExpansionTile(
                      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        'Administrador',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Cultivos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Caderno',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Cargos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Inventario',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Equipamentos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: const ExpansionTile(
                      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        'Funcionário',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Cultivos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Caderno',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Inventario',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Ver e Editar',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Equipamentos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Somente ver',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: const ExpansionTile(
                      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        'Convidado',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Cultivos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Somente ver',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Caderno',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Somente ver',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Equipamentos',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            'Somente ver',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: SizedBox(
          width: size.width * .75,
          height: 30,
          child: Observer(builder: (_) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Enviar Convite",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {}, //store.registrarReservatorio(),
            );
          }),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.kBackgroundColor,
      elevation: 0,
      leading: const BackButton(
        color: Constants.kPrimaryColor,
      ),
    );
  }
}
