import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_section_header.dart';

class ProducaoSection extends StatefulWidget {
  const ProducaoSection({super.key});

  @override
  State<ProducaoSection> createState() => _ProducaoSectionState();
}

class _ProducaoSectionState extends State<ProducaoSection> {
  final LoteStore _store = GetIt.I<LoteStore>();
  bool _isEditing = false;

  late TextEditingController _bandeijasCtrl;
  late TextEditingController _mudasCtrl;
  late TextEditingController _plantasCtrl;
  late TextEditingController _embalagensCtrl;

  late FocusNode _bandeijasFocus;
  late FocusNode _mudasFocus;
  late FocusNode _plantasFocus;
  late FocusNode _embalagensFocus;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _bandeijasFocus = FocusNode();
    _mudasFocus = FocusNode();
    _plantasFocus = FocusNode();
    _embalagensFocus = FocusNode();
  }

  @override
  void dispose() {
    _bandeijasCtrl.dispose();
    _mudasCtrl.dispose();
    _plantasCtrl.dispose();
    _embalagensCtrl.dispose();
    _bandeijasFocus.dispose();
    _mudasFocus.dispose();
    _plantasFocus.dispose();
    _embalagensFocus.dispose();
    super.dispose();
  }

  void _initControllers() {
    final l = _store.loteSelecionado;
    _bandeijasCtrl = TextEditingController(
      text: (l.bandeijas_semeadas ?? 0).toString(),
    );
    _mudasCtrl = TextEditingController(
      text: (l.mudas_transplantadas ?? 0).toString(),
    );
    _plantasCtrl = TextEditingController(
      text: (l.plantas_colhidas ?? 0).toString(),
    );
    _embalagensCtrl = TextEditingController(
      text: (l.embalagens_produzidas ?? 0).toString(),
    );
  }

  void _enterEditMode() {
    _initControllers();
    setState(() => _isEditing = true);
    // Auto-focus first field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bandeijasFocus.requestFocus();
    });
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
  }

  Future<void> _saveEdit() async {
    // Snapshot old values BEFORE syncing controllers (alterarProducaoLote
    // mutates loteSelecionado internally).
    final old = {
      'bandejas_semeadas': _store.loteSelecionado.bandeijas_semeadas ?? 0,
      'mudas_transplantadas': _store.loteSelecionado.mudas_transplantadas ?? 0,
      'plantas_colhidas': _store.loteSelecionado.plantas_colhidas ?? 0,
      'embalagens_produzidas': _store.loteSelecionado.embalagens_produzidas ?? 0,
    };

    final novo = {
      'bandejas_semeadas': int.tryParse(_bandeijasCtrl.text) ?? 0,
      'mudas_transplantadas': int.tryParse(_mudasCtrl.text) ?? 0,
      'plantas_colhidas': int.tryParse(_plantasCtrl.text) ?? 0,
      'embalagens_produzidas': int.tryParse(_embalagensCtrl.text) ?? 0,
    };

    // Sync local controllers into store controllers (alterarProducaoLote
    // reads from the store's own controllers internally).
    _store.bandeijasSemeadasController.text = _bandeijasCtrl.text;
    _store.mudasTransplantadasController.text = _mudasCtrl.text;
    _store.plantasColhidasController.text = _plantasCtrl.text;
    _store.embalagensProduzidasController.text = _embalagensCtrl.text;

    await _store.alterarProducaoLote();

    // Log changes as atividade no caderno de campo (non-blocking).
    await _store.registrarAtividadeProducao(
      oldValues: old,
      newValues: novo,
    );

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            icon: Icons.timeline,
            title: 'Produção',
            subtitle: 'Registros de produção do lote',
            trailing: _editActions(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppPanelCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _fieldRow(
                    label: 'Bandejas semeadas',
                    storeValue: _store.loteSelecionado.bandeijas_semeadas,
                    controller: _bandeijasCtrl,
                    focusNode: _bandeijasFocus,
                    nextFocus: _mudasFocus,
                    showDivider: true,
                  ),
                  _fieldRow(
                    label: 'Mudas transplantadas',
                    storeValue: _store.loteSelecionado.mudas_transplantadas,
                    controller: _mudasCtrl,
                    focusNode: _mudasFocus,
                    nextFocus: _plantasFocus,
                    showDivider: true,
                  ),
                  _fieldRow(
                    label: 'Plantas colhidas',
                    storeValue: _store.loteSelecionado.plantas_colhidas,
                    controller: _plantasCtrl,
                    focusNode: _plantasFocus,
                    nextFocus: _embalagensFocus,
                    showDivider: true,
                  ),
                  _fieldRow(
                    label: 'Embalagens produzidas',
                    storeValue: _store.loteSelecionado.embalagens_produzidas,
                    controller: _embalagensCtrl,
                    focusNode: _embalagensFocus,
                    nextFocus: null,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _editActions() {
    if (_isEditing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(Icons.close, Constants.kErrorColor, _cancelEdit),
          const SizedBox(width: 4),
          _iconButton(Icons.check, Constants.kPrimaryColor, _saveEdit),
        ],
      );
    }
    return _iconButton(Icons.edit_outlined, Constants.kPrimaryColor, _enterEditMode);
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        tooltip: _isEditing ? null : 'Editar produção',
      ),
    );
  }

  Widget _fieldRow({
    required String label,
    required int? storeValue,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocus,
    required bool showDivider,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Constants.kText2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _isEditing ? _editField(controller, focusNode, nextFocus) : _readValue(storeValue),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _readValue(int? value) {
    final display = (value == null || value == 0) ? '-' : value.toString();
    return Text(
      display,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Constants.kPrimaryColor,
      ),
    );
  }

  Widget _editField(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocus,
  ) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Constants.kPrimaryColor,
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Constants.kGreyLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Constants.kPrimaryColor, width: 1.5),
          ),
        ),
        textInputAction:
            nextFocus != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            nextFocus.requestFocus();
          } else {
            _saveEdit();
          }
        },
      ),
    );
  }
}
