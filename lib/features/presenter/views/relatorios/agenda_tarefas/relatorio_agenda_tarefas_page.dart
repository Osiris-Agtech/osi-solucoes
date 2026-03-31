import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/services/export_service.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_agenda_tarefas/relatorio_agenda_tarefas_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/relatorio_agenda_tarefas_store.dart';

class RelatorioAgendaTarefasPage extends StatefulWidget {
  const RelatorioAgendaTarefasPage({super.key});

  @override
  State<RelatorioAgendaTarefasPage> createState() =>
      _RelatorioAgendaTarefasPageState();
}

class _RelatorioAgendaTarefasPageState
    extends State<RelatorioAgendaTarefasPage> {
  final RelatorioAgendaTarefasStore store =
      GetIt.I<RelatorioAgendaTarefasStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      final useMock = args is Map && args['mock'] == true;
      if (useMock) {
        store.carregarMock();
      } else {
        store.carregarRelatorio();
      }
    });
  }

  void _abrirFiltros() {
    final filtrosAtuais = store.filtros;
    int diasSelecionados = filtrosAtuais.diasAVencer;
    bool apenasAlerta = filtrosAtuais.apenasComAlerta;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'TAREFAS A VENCER EM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9F9F9F),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '$diasSelecionados dias',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: diasSelecionados.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      activeColor: Constants.kPrimaryColor,
                      onChanged: (v) =>
                          setModalState(() => diasSelecionados = v.round()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Apenas tarefas com alerta',
                      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                    ),
                  ),
                  Switch(
                    value: apenasAlerta,
                    activeThumbColor: Constants.kPrimaryColor,
                    onChanged: (v) =>
                        setModalState(() => apenasAlerta = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    store.atualizarFiltros(
                      filtrosAtuais.copyWith(
                        diasAVencer: diasSelecionados,
                        apenasComAlerta: apenasAlerta,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF333333)),
        title: const Text(
          'Agenda e Tarefas',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined, color: Color(0xFF333333)),
            onPressed: _abrirFiltros,
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Constants.kPrimaryColor),
            );
          }

          if (store.hasError) {
            return _buildErro();
          }

          if (!store.hasData) {
            return _buildVazio();
          }

          return _buildConteudo();
        },
      ),
    );
  }

  Widget _buildConteudo() {
    final resultado = store.resultado!;

    return ListView(
      children: [
        const SizedBox(height: 12),
        // Banner de destaques
        _buildDestaquesHeader(resultado),
        // Seção: Vencidas
        _buildSectionLabel('VENCIDAS', resultado.tarefasVencidas.length),
        if (resultado.tarefasVencidas.isEmpty)
          _buildVazioSecao(
            icon: Icons.check_circle_outline,
            message: 'Nenhuma tarefa vencida',
            color: const Color(0xFF059669),
          )
        else
          ...resultado.tarefasVencidas.map((t) => _TarefaCard(
                tarefa: t,
                tipo: _TipoTarefa.vencida,
              )),
        // Seção: A vencer
        _buildSectionLabel(
          'A VENCER EM ${resultado.diasAVencer} DIAS',
          resultado.tarefasAVencer.length,
        ),
        if (resultado.tarefasAVencer.isEmpty)
          _buildVazioSecao(
            icon: Icons.event_available_outlined,
            message: 'Nenhuma tarefa nos próximos ${resultado.diasAVencer} dias',
            color: const Color(0xFF9F9F9F),
          )
        else
          ...resultado.tarefasAVencer.map((t) => _TarefaCard(
                tarefa: t,
                tipo: _TipoTarefa.aVencer,
              )),
        // Seção: Taxa de conclusão por lote
        _buildSectionLabel(
          'CONCLUSÃO POR LOTE ATIVO',
          resultado.lotesComTaxaConclusao.length,
        ),
        if (resultado.lotesComTaxaConclusao.isEmpty)
          _buildVazioSecao(
            icon: Icons.inventory_2_outlined,
            message: 'Nenhum lote ativo com tarefas',
            color: const Color(0xFF9F9F9F),
          )
        else
          ...resultado.lotesComTaxaConclusao.map(
            (l) => _LoteTaxaCard(lote: l),
          ),
        // Botão exportar
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: _exportarCSV,
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text('Exportar CSV'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Constants.kGreyText,
              side: const BorderSide(color: Constants.kGreyLight),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDestaquesHeader(RelatorioAgendaResult resultado) {
    final totalVencidas = resultado.tarefasVencidas.length;
    final totalAVencer = resultado.tarefasAVencer.length;
    final loteCritico = store.loteMaisCritico;
    final membroCritico = store.membroComMaisVencidas;

    Color cor;
    IconData icone;
    String mensagem;

    if (totalVencidas > 0) {
      cor = const Color(0xFFDC2626);
      icone = Icons.warning_amber_outlined;
      mensagem = '$totalVencidas tarefa${totalVencidas != 1 ? 's' : ''} vencida${totalVencidas != 1 ? 's' : ''} — ação necessária';
    } else if (totalAVencer > 0) {
      cor = const Color(0xFFD97706);
      icone = Icons.schedule_outlined;
      mensagem = '$totalAVencer tarefa${totalAVencer != 1 ? 's' : ''} a vencer nos próximos ${resultado.diasAVencer} dias';
    } else {
      cor = const Color(0xFF059669);
      icone = Icons.check_circle_outline;
      mensagem = 'Agenda em dia — nenhuma tarefa pendente crítica';
    }

    final bgColor = cor.withValues(alpha: 0.08);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_outlined, size: 16, color: cor),
              const SizedBox(width: 6),
              Text(
                'Destaques',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(icone, size: 14, color: cor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  mensagem,
                  style: TextStyle(
                    fontSize: 12,
                    color: cor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (loteCritico != null || membroCritico != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (loteCritico != null)
                  Expanded(
                    child: _DestaqueChip(
                      label: 'LOTE CRÍTICO',
                      value: loteCritico.loteNome,
                      sub: '${loteCritico.tarefasVencidas} vencidas',
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                if (loteCritico != null && membroCritico != null)
                  Container(
                    width: 1,
                    height: 36,
                    color: cor.withValues(alpha: 0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                if (membroCritico != null)
                  Expanded(
                    child: _DestaqueChip(
                      label: 'MEMBRO',
                      value: membroCritico,
                      sub: 'mais tarefas vencidas',
                      color: const Color(0xFFD97706),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9F9F9F),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVazioSecao({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            message,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF9F9F9F)),
            const SizedBox(height: 12),
            Text(
              store.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9F9F9F), fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: store.carregarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Tentar novamente',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_note_outlined,
                size: 64, color: Color(0xFFD9D9D9)),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma tarefa encontrada',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF9F9F9F)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não há tarefas vencidas, a vencer ou lotes ativos com agenda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFFD9D9D9)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _abrirFiltros,
              icon: const Icon(Icons.tune_outlined, size: 16),
              label: const Text('Ajustar filtros'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.kGreyText,
                side: const BorderSide(color: Constants.kGreyLight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarCSV() async {
    final resultado = store.resultado;
    if (resultado == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gerando CSV...'),
        backgroundColor: Constants.kPrimaryColor,
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final exportService = GetIt.I<ExportService>();
      await exportService.exportarRelatorioAgendaCSV(resultado);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
            backgroundColor: Constants.kErrorColor,
          ),
        );
      }
    }
  }
}

// ─── Tipo de tarefa para coloração ──────────────────────────────────────────

enum _TipoTarefa { vencida, aVencer }

// ─── Card de tarefa ──────────────────────────────────────────────────────────

class _TarefaCard extends StatelessWidget {
  final AgendaTarefaItem tarefa;
  final _TipoTarefa tipo;

  const _TarefaCard({required this.tarefa, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final diasRestantes = tarefa.calcularDiasRestantes();
    final diasAtraso = tarefa.calcularDiasAtraso();

    Color urgenciaColor;
    String urgenciaLabel;
    IconData urgenciaIcon;

    if (tipo == _TipoTarefa.vencida) {
      urgenciaColor = const Color(0xFFDC2626);
      urgenciaLabel = diasAtraso == 1 ? '1 dia atraso' : '$diasAtraso dias atraso';
      urgenciaIcon = Icons.warning_amber_rounded;
    } else {
      if (diasRestantes <= 1) {
        urgenciaColor = const Color(0xFFDC2626);
        urgenciaLabel = diasRestantes == 0 ? 'Hoje' : 'Amanhã';
        urgenciaIcon = Icons.schedule_rounded;
      } else if (diasRestantes <= 3) {
        urgenciaColor = const Color(0xFFD97706);
        urgenciaLabel = 'em $diasRestantes dias';
        urgenciaIcon = Icons.schedule_outlined;
      } else {
        urgenciaColor = const Color(0xFF6B7280);
        urgenciaLabel = 'em $diasRestantes dias';
        urgenciaIcon = Icons.schedule_outlined;
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: urgenciaColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  tarefa.displayTitulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  if (tarefa.alerta)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.notifications_active_outlined,
                          size: 14, color: Color(0xFFD97706)),
                    ),
                  Icon(urgenciaIcon, size: 13, color: urgenciaColor),
                  const SizedBox(width: 3),
                  Text(
                    urgenciaLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: urgenciaColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (tarefa.usuarioNome != null)
                _MetaChip(
                  icon: Icons.person_outline,
                  label: tarefa.usuarioNome!,
                ),
              if (tarefa.loteNome != null)
                _MetaChip(
                  icon: Icons.inventory_2_outlined,
                  label: tarefa.loteNome!,
                ),
              if (tarefa.setorNome != null)
                _MetaChip(
                  icon: Icons.location_on_outlined,
                  label: tarefa.setorNome!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Card de lote com taxa de conclusão ──────────────────────────────────────

class _LoteTaxaCard extends StatelessWidget {
  final AgendaLoteTaxaConclusao lote;

  const _LoteTaxaCard({required this.lote});

  @override
  Widget build(BuildContext context) {
    final taxa = lote.taxaConclusao;

    Color taxaColor;
    if (taxa < 50) {
      taxaColor = const Color(0xFFDC2626);
    } else if (taxa < 80) {
      taxaColor = const Color(0xFFD97706);
    } else {
      taxaColor = const Color(0xFF059669);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lote.loteNome,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        if (lote.tarefasVencidas > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${lote.tarefasVencidas} vencida${lote.tarefasVencidas != 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (lote.setorNome != null)
                      Text(
                        lote.setorNome!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9F9F9F),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${taxa.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: taxaColor,
                    ),
                  ),
                  const Text(
                    'conclusão',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9F9F9F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: taxa / 100,
              backgroundColor: taxaColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(taxaColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${lote.tarefasConcluidas} de ${lote.totalTarefas} tarefas concluídas',
            style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
          ),
        ],
      ),
    );
  }
}

// ─── Chips de metadado ────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: const Color(0xFF9F9F9F)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
        ),
      ],
    );
  }
}

// ─── Destaque chip ─────────────────────────────────────────────────────────────

class _DestaqueChip extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _DestaqueChip({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF9F9F9F),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          sub,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
