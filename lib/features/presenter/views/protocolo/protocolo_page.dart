import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/protocolo_store.dart';
import '../home/components/top_app_bar.dart';
import 'components/detalhes_page/protocoloItem.dart';

class ProtocoloPage extends StatefulWidget {
  final String title;
  const ProtocoloPage({Key? key, this.title = 'ProtocoloPage'})
      : super(key: key);
  @override
  ProtocoloPageState createState() => ProtocoloPageState();
}

class ProtocoloPageState extends State<ProtocoloPage> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // store.setSearchReservatorioText('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.kSecondBackgroundColor,
          body: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  sliverAppBar(context),
                  Observer(builder: (_) {
                    // if (store.isReservatorioListLoading) {
                    //   return loadingList();
                    // }
                    // if (store.reservatorioList.isEmpty) {
                    //   return emptyList();
                    // }
                    return showList();
                  }),
                ],
              ),
            ),
          ),
          floatingActionButton: floatingButton(),
        ),
      ),
    );
  }

  FloatingActionButton floatingButton() {
    return FloatingActionButton(
      heroTag: "NovoProtocolo",
      onPressed: () {
        Get.toNamed(Routes.cadastrarProtocoloPage);
      },
      child: const Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
      backgroundColor: Constants.kPrimaryColor,
    );
  }

  SliverList showList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return protocoloItem(index: index);
        },
        childCount: 2,
        //childCount: store.searchReservatorio.length,
      ),
    );
  }

  SliverList emptyList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: Text(
                'Não há protocolos\ncadastrados em sua conta',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff6F6464),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverList loadingList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar sliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 120, //MediaQuery.of(context).size.height * 0.17,
      // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 1,
      flexibleSpace: TopAppBar(
        path: "/Home/",
        namePage: "Meus Protocolos",
        subtitle: "Lista de protocolos cadastrados",
        onPressed: () {
          Get.offNamedUntil(Routes.homePage, (route) => false);
        },
      ),
      bottom: PreferredSize(
        child: filterWidget(context),
        preferredSize: const Size(
          double.infinity,
          60, //MediaQuery.of(context).size.height * 0.06,
        ),
      ),
    );
  }

  Container filterWidget(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFFF8F8F6),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 5, //MediaQuery.of(context).size.height * 0.007,
      ),
      child: TextFormField(
        onChanged: ((value) => {
              //store.setSearchReservatorioText(value),
            }),
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          prefixIcon: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              size: 24,
            ),
          ),
          labelText: "Buscar...",
          labelStyle: const TextStyle(fontSize: 18),
          suffixIcon: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              primary: Constants.kPrimaryColor,
            ),
            child: const Text(
              "nome",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
