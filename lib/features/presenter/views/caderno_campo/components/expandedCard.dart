// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';

class ExpandedLoteCard extends StatefulWidget {
  final int index;
  const ExpandedLoteCard({super.key, required this.index});

  @override
  State<ExpandedLoteCard> createState() => _ExpandedLoteCardState();
}

class _ExpandedLoteCardState extends State<ExpandedLoteCard> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.kBackgroundColor,
        elevation: 0,
        title: Observer(builder: (_) {
          final group = store.getLotesGroup[widget.index];
          final selection = _groupSelection();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.key,
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                selection.description,
                style: TextStyle(
                  color: selection.color ?? Constants.kGreyText2,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }),
        leading: const BackButton(
          color: Constants.kPrimaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Observer(builder: (_) {
                    final selection = _groupSelection();
                    return IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: Icon(selection.icon, color: selection.color),
                      onPressed: () => store.selectLotesGroup(
                        widget.index,
                        !selection.isAll,
                      ),
                    );
                  }),
                  Expanded(child: Observer(builder: (_) {
                    final group = store.getLotesGroup[widget.index];
                    final selection = _groupSelection();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.key,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Constants.kText2,
                          ),
                        ),
                        Text(
                          selection.description,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selection.color ?? Constants.kGreyText2,
                          ),
                        ),
                      ],
                    );
                  })),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.4,
                crossAxisCount: 2,
                children: List.generate(
                    store.getLotesGroup[widget.index].lotesSelection.length,
                    (indexLote) {
                  return _loteCard(indexLote);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loteCard(int indexLote) {
    return Observer(builder: (_) {
      final loteSelection =
          store.getLotesGroup[widget.index].lotesSelection[indexLote];
      final borderColor = loteSelection.selected
          ? Constants.kPrimaryColor
          : Constants.kCardColor;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: borderColor),
        ),
        color: Constants.kCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: Icon(
                  loteSelection.selected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  color:
                      loteSelection.selected ? Constants.kPrimaryColor : null,
                ),
                onPressed: () => store.selectLotesSelection(
                  widget.index,
                  indexLote,
                  !loteSelection.selected,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                loteSelection.lote.nome ?? 'Não informado',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Constants.kText2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${loteSelection.lote.setor?.nome ?? 'Setor não informado'} / ${loteSelection.lote.reservatorio?.nome ?? 'Reservatório não informado'}',
                style:
                    const TextStyle(fontSize: 14, color: Constants.kGreyText2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }

  _ExpandedGroupSelection _groupSelection() {
    final lotesSelection = store.getLotesGroup[widget.index].lotesSelection;
    return _ExpandedGroupSelection(
      selectedCount: lotesSelection.where((item) => item.selected).length,
      totalCount: lotesSelection.length,
    );
  }
}

class _ExpandedGroupSelection {
  final int selectedCount;
  final int totalCount;

  const _ExpandedGroupSelection({
    required this.selectedCount,
    required this.totalCount,
  });

  bool get isNone => selectedCount == 0;
  bool get isAll => totalCount > 0 && selectedCount == totalCount;

  IconData get icon {
    if (isNone) return Icons.check_box_outline_blank_rounded;
    if (isAll) return Icons.check_box;
    return Icons.indeterminate_check_box;
  }

  Color? get color => isNone ? null : Constants.kPrimaryColor;

  String get description {
    final label = selectedCount == 1 ? 'selecionado' : 'selecionados';
    return '$selectedCount de $totalCount $label';
  }
}
