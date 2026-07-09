import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

import 'expandedCard.dart';

class CadernoLoteStep extends StatelessWidget {
  final CadernoCampoStore store;

  const CadernoLoteStep({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppFormSection(
            title: 'Lotes',
            description: 'Selecione os lotes para esta atividade.',
            child: Column(
              children: [
                _searchBar(context),
                const SizedBox(height: 12),
                _groupFilter(context),
                const SizedBox(height: 12),
                Observer(builder: (_) {
                  final selectedCount = store.selectedLotes.length;
                  if (selectedCount == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            size: 16, color: Constants.kPrimaryColor),
                        const SizedBox(width: 6),
                        Text(
                          '$selectedCount lote${selectedCount == 1 ? '' : 's'} selecionado${selectedCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Constants.kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                _loteList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return TextFormField(
      initialValue: store.searchLotePage,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search_rounded),
        hintText: 'Pesquisar por',
        hintStyle: TextStyle(fontSize: 18, color: Constants.kGreyText),
      ),
      onChanged: (String value) => store.setSeachLotePage(value),
    );
  }

  Widget _groupFilter(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 30,
        width: 110,
        decoration: const BoxDecoration(
          color: Constants.kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              alignment: Alignment.center,
              value: store.selectedGroup,
              dropdownColor: Constants.kPrimaryColor,
              icon: const Icon(Icons.expand_more, color: Colors.white),
              elevation: 16,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  store.setSelectedGroup(newValue);
                  store.groupLotesBy();
                }
              },
              items: <String>['Cultura', 'Setor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loteList(BuildContext context) {
    return Observer(builder: (_) {
      if (store.isCadastroLoteLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: store.getLotesGroup.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OpenContainer(
              transitionDuration: const Duration(milliseconds: 500),
              openBuilder: (context, _) => ExpandedLoteCard(index: index),
              closedBuilder: (context, VoidCallback openContainer) =>
                  _externalCard(index, openContainer),
            ),
          );
        },
      );
    });
  }

  Widget _externalCard(int index, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Observer(builder: (_) {
              final isSelected = store.getLotesGroup[index].selected;
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40),
                icon: Icon(
                  isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  color: isSelected ? Constants.kPrimaryColor : null,
                ),
                onPressed: () => store.selectLotesGroup(index, !isSelected),
              );
            }),
            Expanded(
              child: Text(
                store.getLotesGroup[index].key,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
              ),
            ),
            InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset("assets/icons/maximize.svg"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
