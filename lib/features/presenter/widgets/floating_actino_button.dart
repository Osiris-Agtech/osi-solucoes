import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_floating_action_button.dart';

class NewFloatingActionButton extends StatefulWidget {
  final int nivel;
  const NewFloatingActionButton({
    super.key,
    required this.nivel,
  });

  @override
  State<NewFloatingActionButton> createState() =>
      _NewFloatingActionButtonState();
}

class _NewFloatingActionButtonState extends State<NewFloatingActionButton> {
  AreaCultivoStore areaStore = GetIt.I<AreaCultivoStore>();
  SetorStore setorStore = GetIt.I<SetorStore>();
  LoteStore loteStore = GetIt.I<LoteStore>();

  void _navigateToCadastro() {
    switch (widget.nivel) {
      case 1:
        areaStore.setIsEditing(false);
        Get.toNamed(Routes.cadastrarAreaCultivoPage);
        break;
      case 2:
        setorStore.setIsEditing(false);
        Get.toNamed(Routes.cadastrarSetorPage);
        break;
      case 3:
        loteStore.setIsEditing(false);
        Get.toNamed(Routes.cadastrarLotePage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFloatingActionButton.add(
      heroTag: 'fab_nivel_${widget.nivel}',
      onPressed: _navigateToCadastro,
      bottom: 18,
    );
  }
}
