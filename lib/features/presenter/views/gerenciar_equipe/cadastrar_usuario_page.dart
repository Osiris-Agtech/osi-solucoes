import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/cargo/cargo_model.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      store.buscarCargos();
    });
  }

  @override
  void dispose() {
    store.clearCadastro();
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
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titulo(),
                    subtitulo(),
                    const SizedBox(height: 20),
                    image(context),
                    email(context, store),
                    nome(context, store),
                    sobrenome(context, store),
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
            height: MediaQuery.of(context).size.height * 0.20,
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
      ),
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
              value: store.cargoSelecionado,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.visible,
              ),
              hint: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  'Selecione o cargo',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    overflow: TextOverflow.visible,
                    color: Constants.kGreyText2,
                    fontSize: 18,
                  ),
                ),
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
                      store.cargoSelecionado?.cargo ?? '',
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
                  store.setCargo(value);
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget nome(BuildContext context, GerenciarEquipeStore store) {
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
            'Nome',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Observer(builder: (_) {
            return TextFormField(
              enabled: !(store.pessoaFound),
              controller: store.nome,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Nome do colaborador",
                hintStyle: const TextStyle(
                  color: Constants.kGreyText2,
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
            );
          }),
        ],
      ),
    );
  }

  Widget sobrenome(BuildContext context, GerenciarEquipeStore store) {
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
            'Sobrenome',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Observer(builder: (_) {
            return TextFormField(
              enabled: !(store.pessoaFound),
              controller: store.sobrenome,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Sobrenome do colaborador",
                hintStyle: const TextStyle(
                  color: Constants.kGreyText2,
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
          TextFormField(
            onChanged: (String value) {
              store.setEmail(value);
            },
            onEditingComplete: () async {
              await store.buscarPessoa();
            },
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "E-mail do colaborador",
              hintStyle: const TextStyle(
                color: Constants.kGreyText2,
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
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
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
    var size = MediaQuery.of(context).size;

    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
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
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Constants.kCardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: store.cargosList
                    .map((cargo) => _contentDialogCard(context, cargo))
                    .toList(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: SizedBox(
              width: size.width * .75,
              height: 38,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Constants.kPrimaryColor,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Constants.kPrimaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _contentDialogCard(BuildContext context, Cargo cargo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              cargo.cargo ?? 'Não informado',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: cargo.concatenatedPermission != null
                ? cargo.concatenatedPermission!
                    .map(
                      (concatenatedPermission) => ListTile(
                        title: Text(
                          concatenatedPermission.title ?? "Não encontrado",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Text(
                          (concatenatedPermission.permissionRead! &&
                                  concatenatedPermission.permissionWrite!)
                              ? 'Ver e Editar'
                              : 'Somente ver',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList()
                : [],
          ),
        ),
      ],
    );
  }

  Padding saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Center(
        child: SizedBox(
          width: size.width * .75,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Constants.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              "Enviar Convite",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () async {
              await store.registrarUsuario();
            }, //store.registrarReservatorio(),
          ),
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
