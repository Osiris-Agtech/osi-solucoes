import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';

class CicloFiltrosSheet extends StatefulWidget {
  final RelatorioCicloFiltros filtrosAtuais;
  final void Function(RelatorioCicloFiltros) onAplicar;

  const CicloFiltrosSheet({
    super.key,
    required this.filtrosAtuais,
    required this.onAplicar,
  });

  @override
  State<CicloFiltrosSheet> createState() => _CicloFiltrosSheetState();
}

class _CicloFiltrosSheetState extends State<CicloFiltrosSheet> {
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Constants.kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Constants.kGreyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 20),
          const Text(
            'PERÍODO',
            style: TextStyle(fontSize: 11, color: Color(0xFF9F9F9F), letterSpacing: 0.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateButton(
                  label: 'De',
                  data: _dataInicio,
                  onTap: () => _selecionarData(isInicio: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateButton(
                  label: 'Até',
                  data: _dataFim,
                  onTap: () => _selecionarData(isInicio: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Atalhos de período
          Wrap(
            spacing: 8,
            children: [
              _PeriodoChip(
                label: '3 meses',
                onTap: () => setState(() {
                  _dataFim = DateTime.now();
                  _dataInicio = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
                }),
              ),
              _PeriodoChip(
                label: '6 meses',
                onTap: () => setState(() {
                  _dataFim = DateTime.now();
                  _dataInicio = DateTime(DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
                }),
              ),
              _PeriodoChip(
                label: '1 ano',
                onTap: () => setState(() {
                  _dataFim = DateTime.now();
                  _dataInicio = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
                }),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final padrao = RelatorioCicloFiltros.ultimos6Meses();
                    widget.onAplicar(padrao);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Constants.kGreyLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Limpar', style: TextStyle(color: Color(0xFF9F9F9F))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onAplicar(
                      RelatorioCicloFiltros(
                        dataInicio: _dataInicio,
                        dataFim: _dataFim,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
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
  final DateTime data;
  final VoidCallback onTap;

  const _DateButton({required this.label, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F))),
            const SizedBox(width: 6),
            Text(
              '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
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
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Constants.kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide.none,
    );
  }
}
