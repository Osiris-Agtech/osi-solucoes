import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/constants.dart';
import '../../models/cargo/cargo_model.dart';
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
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await store.buscarCargos();
      store.setInitialCargo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    store.clearDatalhes();
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
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Constants.kPrimaryColor,
            label: const Text(
              'Salvar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Constants.kBackgroundColor,
              ),
            ),
            onPressed: () {
              store.alterarUsuario();
            },
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
                email(context, store),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(top: 5, left: 25),
      child: Text(
        'Visualização e atualização de Informações',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff6F6464),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 25,
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
        left: 15,
        right: 10,
        top: 10,
        bottom: 15,
      ),
      child: Text(
        store.usuarioSelecionado.nome ?? '',
        style: const TextStyle(
          color: Constants.kText2,
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
            value: store.ativoIsChanged,
            onChanged: (value) {
              store.setAtivo(value);
            },
            activeTrackColor: Constants.kPrimaryColor,
            activeColor: Constants.kCardColor,
            inactiveTrackColor: Constants.kGreyText2,
            inactiveThumbColor: Constants.kCardColor,
          ),
        );
      }),
    );
  }

  Widget cargo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Cargo',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Observer(builder: (_) {
            return DropdownButton<Cargo>(
              focusColor: Colors.transparent,
              value: store.cargoSelecionadoDetalhesPage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.visible,
              ),
              isExpanded: true,
              underline: DropdownButtonHideUnderline(child: Container()),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Constants.kPrimaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              selectedItemBuilder: (BuildContext context) {
                return store.cargosList.map((Cargo value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      store.cargoSelecionadoDetalhesPage?.cargo ?? '',
                      style: const TextStyle(color: Constants.kPrimaryColor),
                    ),
                  );
                }).toList();
              },
              items: store.cargosList.map((Cargo cargo) {
                return DropdownMenuItem<Cargo>(
                  value: cargo,
                  child: Text(
                    cargo.cargo ?? '-',
                    style: const TextStyle(color: Constants.kGreyText),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  store.setCargoDetalhesPage(value);
                }
              },
            );
          }),
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
          const SizedBox(
            height: 10,
          ),
          Text(
            store.usuarioSelecionado.email ?? 'E-mail não encontrado',
            style: const TextStyle(
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
