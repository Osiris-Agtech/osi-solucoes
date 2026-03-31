import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';

class DesempenhoFiltrosSheet extends StatefulWidget {
  final RelatorioDesempenhoFiltros filtrosAtuais;
  final void Function(RelatorioDesempenhoFiltros) onAplicar;

  const DesempenhoFiltrosSheet({
    super.key,
    required this.filtrosAtuais,
    required this.onAplicar,
  });

  @override
  State<DesempenhoFiltrosSheet> createState() => _DesempenhoFiltrosSheetState();
}

class _DesempenhoFiltrosSheetState extends State<DesempenhoFiltrosSheet> {
  late DateTime _dataInicio;
  late DateTime _dataFim;

  @override
  void initState() {
    super.initState();
    _dataInicio = widget.filtrosAtuais.dataInicio;
    _dataFim = widget.filtrosAtuais.dataFim;
  }

  Future<void> _selecionarData({required bool isInicio}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isInicio ? _dataInicio : _dataFim,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Constants.kPrimaryColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          _dataInicio = picked;
          if (_dataInicio.isAfter(_dataFim)) _dataFim = _dataInicio;
        } else {
          _dataFim = picked;
          if (_dataFim.isBefore(_dataInicio)) _dataInicio = _dataFim;
        }
      });
    }
  }

  void _aplicarAtalho(int meses) {
    final fim = DateTime.now();
    setState(() {
      _dataFim = fim;
      _dataInicio = DateTime(fim.year, fim.month - meses, fim.day);
    });
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PERÍODO',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF9F9F9F),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateButton(
                  label: 'Início',
                  value: _formatarData(_dataInicio),
                  onTap: () => _selecionarData(isInicio: true),
                ),
              ),
              const SizedBox(width: 10),
              const Text('→',
                  style: TextStyle(color: Color(0xFF9F9F9F), fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: _DateButton(
                  label: 'Fim',
                  value: _formatarData(_dataFim),
                  onTap: () => _selecionarData(isInicio: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _PeriodoChip(label: '3 meses', onTap: () => _aplicarAtalho(3)),
              _PeriodoChip(label: '6 meses', onTap: () => _aplicarAtalho(6)),
              _PeriodoChip(label: '1 ano', onTap: () => _aplicarAtalho(12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final padrao = RelatorioDesempenhoFiltros.ultimos6Meses();
                    setState(() {
                      _dataInicio = padrao.dataInicio;
                      _dataFim = padrao.dataFim;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9F9F9F),
                    side: const BorderSide(color: Color(0xFFD9D9D9)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Limpar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onAplicar(
                      widget.filtrosAtuais.copyWith(
                        dataInicio: _dataInicio,
                        dataFim: _dataFim,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Aplicar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 10, color: Color(0xFF9F9F9F))),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodoChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PeriodoChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      backgroundColor: const Color(0xFFF3F4F6),
      side: BorderSide.none,
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
