import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/gerenciar_equipe_store.dart';

class DetalhesUsuarioPage extends StatefulWidget {
  const DetalhesUsuarioPage({Key? key}) : super(key: key);

  @override
  State<DetalhesUsuarioPage> createState() => _DetalhesUsuarioPageState();
}

class _DetalhesUsuarioPageState extends State<DetalhesUsuarioPage> {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: const FloatingActionButton.extended(
            backgroundColor: Constants.kPrimaryColor,
            label: Text(
              'Salvar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Constants.kBackgroundColor,
              ),
            ),
            onPressed: null,
          ),
          resizeToAvoidBottomInset: false,
          appBar: appBar(),
          backgroundColor: Constants.kBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titulo(),
                subtitulo(),
                const SizedBox(height: 20),
                nome(context, store),
                ativo(context),
                const Divider(),
                cargo(context),
                const Divider(),
                email(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        'Visualização de Informações',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff6F6464),
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
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
        'Detalhes',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget nome(BuildContext context, GerenciarEquipeStore store) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
        top: 10,
        bottom: 15,
      ),
      child: Text(
        store.usuarioSelecionado?.nome ?? '',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InkWell ativo(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          title: const Text(
            'Ativo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          onTap: () {},
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeTrackColor: Constants.kGreyText2,
            activeColor: Constants.kPrimaryColor,
          ),
        );
      }),
    );
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
        top: 5,
        bottom: 5,
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

  Widget email(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'E-mail',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'miguel_ribeiro@hotmail.com',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
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
