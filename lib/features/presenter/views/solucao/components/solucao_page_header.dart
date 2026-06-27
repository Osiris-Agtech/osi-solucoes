import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/core/utils/spacing.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';

class SolucaoPageHeader extends StatelessWidget {
  final SolucaoStore store;

  const SolucaoPageHeader({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AppPageHeaderSliver(
      title: 'Minhas Soluções Nutritivas',
      subtitle: 'Lista de receitas cadastrados',
      titleMaxLines: 2,
      expandedHeight: ResponsiveBreakpoints.isDesktop(context) ? 160 : 190,
      pinned: true,
      floating: true,
      onBack: () => Get.back(),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Container(
          height: 60,
          color: const Color(0xFFF8F8F6),
          padding: Spacing.horizontal(context).add(
            const EdgeInsets.symmetric(vertical: 7),
          ),
          child: AppSearchBar(
            hintText: 'Buscar solução...',
            onChanged: store.setsearchSolucaoText,
          ),
        ),
      ),
    );
  }
}
