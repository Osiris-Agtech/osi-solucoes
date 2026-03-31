# Relatórios — Design

**Feature:** Módulo de Relatórios
**Data:** 2026-03-24

---

## Visão Geral da Arquitetura

O módulo de Relatórios se distribui entre dois sistemas:

```
┌─────────────────────────────┐         ┌──────────────────────────────┐
│  Flutter (osi-solucoes)     │         │  ISIS API (NestJS + GraphQL) │
│                             │         │                              │
│  ┌─────────────────────┐   │         │  ┌────────────────────────┐  │
│  │  RelatóriosPage     │   │──query──▶│  │  relatorioCircoCultura │  │
│  │  (hub/listagem)     │   │         │  │  (novo resolver)       │  │
│  └──────┬──────────────┘   │         │  └────────────────────────┘  │
│         │                   │         │                              │
│  ┌──────▼──────────────┐   │         │  Reutiliza:                  │
│  │  CicloPage          │   │         │  - Prisma lotes query        │
│  │  + CicloStore       │   │         │  - Protocolo → Acoes         │
│  │  + CicloDatasource  │   │         │  - Setor → Area              │
│  └──────┬──────────────┘   │         └──────────────────────────────┘
│         │                   │
│  ┌──────▼──────────────┐   │
│  │  ExportService      │   │
│  │  (CSV + PDF)        │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

---

## Parte 1 — ISIS API

### Novo Resolver: `relatorioCircoCultura`

**Localização:** `src/schemas/query.js` (adicionar junto aos outros resolvers de relatório existentes)

**Novo schema de tipos:** `src/schemas/relatorioCiclo.js`

#### Input

```graphql
input RelatorioCicloFiltros {
  dataInicio: DateTime
  dataFim: DateTime
  culturaIds: [Int]
  setorIds: [Int]
  areaIds: [Int]
}
```

#### Output

```graphql
type RelatorioCicloResult {
  culturas:         [CicloRankingCultura!]!
  totalLotes:       Int!
  desvioMedioGeral: Float!        # desvio médio de todos os lotes (%)
  periodoInicio:    DateTime!
  periodoFim:       DateTime!
}

type CicloRankingCultura {
  culturaId:              Int!
  culturaNome:            String!
  totalLotes:             Int!
  duracaoRealMedia:       Float!    # dias (média)
  duracaoPlanejadaMedia:  Float     # dias — null se sem protocolo
  desvioMedioDias:        Float     # null se sem protocolo
  desvioMedioPercentual:  Float     # null se sem protocolo
  desvioMaxDias:          Float     # null se sem protocolo
  desvioMinDias:          Float     # null se sem protocolo
  lotes:                  [CicloLoteDetalhe!]!
}

type CicloLoteDetalhe {
  loteId:              Int!
  loteNome:            String
  semeaduraData:       DateTime!
  transplantioData:    DateTime
  colheitaData:        DateTime!
  duracaoRealDias:     Int!
  duracaoPlanejadaDias: Int        # null se sem protocolo
  desvioDias:          Int         # null se sem protocolo
  desvioPercentual:    Float       # null se sem protocolo
  setorNome:           String
  areaNome:            String
}
```

#### Lógica do Resolver

```javascript
// Pseudocódigo do resolver
async relatorioCircoCultura(contaId, filtros) {
  // 1. Buscar lotes com ciclo completo (colheita_data não nulo)
  const lotes = await prisma.lote.findMany({
    where: {
      setor: { area: { fk_contas_id: contaId } },
      colheita_data: { not: null, gte: filtros.dataInicio, lte: filtros.dataFim },
      semeadura_data: { not: null },
      deleted_at: null,
      // filtros opcionais...
    },
    include: {
      cultura: true,
      protocolo: { include: { acoes: { include: { fase: true } } } },
      setor: { include: { area: true } }
    }
  });

  // 2. Para cada lote: calcular durações
  const lotesCalculados = lotes.map(lote => {
    const duracaoReal = diffDays(lote.colheita_data, lote.semeadura_data);
    const duracaoPlanejada = lote.protocolo
      ? lote.protocolo.acoes.reduce((sum, a) => sum + a.duracao_dias, 0)
      : null;
    const desvio = duracaoPlanejada != null ? duracaoReal - duracaoPlanejada : null;
    return { ...lote, duracaoReal, duracaoPlanejada, desvio };
  });

  // 3. Agrupar por cultura
  const grouped = groupBy(lotesCalculados, 'fk_culturas_id');

  // 4. Calcular agregados por cultura
  const culturas = Object.entries(grouped).map(([culturaId, lotes]) => ({
    culturaId,
    culturaNome: lotes[0].cultura.nome,
    totalLotes: lotes.length,
    duracaoRealMedia: avg(lotes.map(l => l.duracaoReal)),
    duracaoPlanejadaMedia: avgNullable(lotes.map(l => l.duracaoPlanejada)),
    desvioMedioDias: avgNullable(lotes.filter(l => l.desvio != null).map(l => l.desvio)),
    desvioMedioPercentual: avgNullable(lotes.filter(l => l.desvio != null).map(l =>
      l.duracaoPlanejada > 0 ? (l.desvio / l.duracaoPlanejada * 100) : null
    )),
    lotes: lotes.map(l => ({ ...mapeio CicloLoteDetalhe }))
  }));

  // 5. Ordenar por desvioMedioPercentual asc (null por último)
  culturas.sort((a, b) => (a.desvioMedioPercentual ?? Infinity) - (b.desvioMedioPercentual ?? Infinity));

  return { culturas, totalLotes: lotes.length, desvioMedioGeral, periodoInicio, periodoFim };
}
```

**Nota:** Filtro padrão sem `dataInicio/dataFim` = últimos 6 meses (calculado no resolver).

---

## Parte 2 — Flutter

### Estrutura de Arquivos (novos)

```
lib/features/
├── data/
│   └── datasources/
│       └── relatorio_ciclo_cultura/
│           └── relatorio_ciclo_cultura_datasource.dart   ← GraphQL query
│
├── domain/
│   └── (sem novo repositório — datasource direto no store, padrão existente)
│
└── presenter/
    ├── models/
    │   └── relatorio_ciclo_cultura/
    │       └── relatorio_ciclo_cultura_model.dart        ← DTOs
    │
    ├── viewmodels/
    │   └── relatorio_ciclo_cultura_store.dart            ← MobX store
    │
    ├── views/
    │   └── relatorios/
    │       ├── relatorios_page.dart                      ← Hub de relatórios
    │       └── ciclo_cultura/
    │           ├── relatorio_ciclo_cultura_page.dart     ← Tela do relatório
    │           ├── widgets/
    │           │   ├── ciclo_cultura_card.dart           ← Card por cultura
    │           │   ├── ciclo_destaques_header.dart       ← Seção de insights
    │           │   ├── ciclo_filtros_sheet.dart          ← Bottom sheet filtros
    │           │   └── ciclo_lote_tile.dart              ← Item expandido
    │           └── helpers/
    │               └── desvio_formatter.dart             ← Lógica de formatação/destaque
    │
    └── services/
        └── export_service.dart                           ← CSV + PDF export
```

### Navegação (Modificações em arquivos existentes)

**1. `modulos_page.dart`** — Adicionar 6ª aba "Relatórios"

```dart
// Adicionar à lista de páginas do IndexedStack
RelatoriosPage()

// Adicionar BottomNavigationBarItem
BottomNavigationBarItem(
  icon: Icon(Icons.bar_chart_outlined),
  activeIcon: Icon(Icons.bar_chart),
  label: 'Relatórios',
)
```

**2. `routes.dart`** — Adicionar rotas

```dart
static const relatoriosPage = '/relatoriosPage';
static const relatorioCircoCulturaPage = '/relatorioCircoCulturaPage';
```

**3. `app_pages.dart`** (ou equivalente GetX routes) — Registrar as novas rotas

### MobX Store — `relatorio_ciclo_cultura_store.dart`

```dart
@observable ObservableFuture? loadFuture;
@observable RelatorioCicloResult? resultado;
@observable RelatorioCicloFiltros filtros = RelatorioCicloFiltros.defaultUltimos6Meses();
@observable String? erro;

@action Future<void> carregar(int contaId) async { ... }
@action void atualizarFiltros(RelatorioCicloFiltros novosFiltros) { ... }

@computed bool get isLoading => loadFuture?.status == FutureStatus.pending;
@computed bool get hasData => resultado?.culturas.isNotEmpty == true;
@computed CicloRankingCultura? get piorCultura => resultado?.culturas.last;
@computed CicloRankingCultura? get melhorCultura => resultado?.culturas.first;
```

### Lógica de Destaque Visual — `desvio_formatter.dart`

```dart
// Thresholds
const double THRESHOLD_NORMAL = 5.0;    // ±5% = dentro do previsto
const double THRESHOLD_ALERTA = 30.0;   // >30% = badge de alerta

enum DesvioStatus { adiantado, normal, atrasado, semProtocolo }

DesvioStatus getDesvioStatus(double? desvioPercentual) {
  if (desvioPercentual == null) return DesvioStatus.semProtocolo;
  if (desvioPercentual > THRESHOLD_NORMAL) return DesvioStatus.atrasado;
  if (desvioPercentual < -THRESHOLD_NORMAL) return DesvioStatus.adiantado;
  return DesvioStatus.normal;
}

Color getDesvioColor(DesvioStatus status) {
  // usar cores do tema do app
  switch (status) {
    case DesvioStatus.atrasado: return AppColors.warning;   // laranja/vermelho
    case DesvioStatus.adiantado: return AppColors.success;  // verde
    case DesvioStatus.normal: return AppColors.textSecondary;
    case DesvioStatus.semProtocolo: return AppColors.disabled;
  }
}

String formatDesvio(double? desvioPercentual, double? desvioDias) {
  if (desvioPercentual == null) return '—';
  final sinal = desvioPercentual > 0 ? '+' : '';
  return '$sinal${desvioDias?.toStringAsFixed(0)}d ($sinal${desvioPercentual.toStringAsFixed(1)}%)';
}
```

### ExportService — `export_service.dart`

**CSV:**
- Usar package `csv` (já comum em Flutter) ou construção manual de string
- Colunas: Cultura, Total Lotes, Duração Real Média (dias), Duração Planejada Média (dias), Desvio Médio (dias), Desvio Médio (%)
- Salvar em temp dir, compartilhar via `share_plus`

**PDF (P3):**
- Usar package `pdf` (dart pdf)
- Layout: cabeçalho com logo + período, tabela de culturas, seção de destaques

### Layout da Tela do Relatório

```
┌──────────────────────────────────────────────┐
│  ← Ciclo de Produção por Cultura    🔍 ⋮     │
├──────────────────────────────────────────────┤
│  📊 DESTAQUES (card destacado)               │  ← REL-06
│  Melhor: Alface (+2d / +3%)         🟢        │
│  Pior: Rúcula (+12d / +28%)         🟠        │
│  Geral: +15% de atraso no período             │
├──────────────────────────────────────────────┤
│  FILTROS: Mar/25 – Set/25    [Filtrar ▼]     │  ← REL-04
├──────────────────────────────────────────────┤
│  RANKING POR CULTURA (ordenado por desvio)   │
│                                              │
│  #1 🟢 Alface                                │  ← REL-03
│     12 lotes · Real: 45d · Plan: 43d         │
│     Desvio: +2d / +4.7%             [▼]      │
│                                              │
│  #2 🔘 Manjericão                            │
│     5 lotes · Real: 38d · Sem protocolo     │
│     Desvio: —                       [▼]      │
│                                              │
│  #3 🟠 Rúcula        ← EXPANDIDO            │
│     8 lotes · Real: 35d · Plan: 23d         │
│     Desvio: +12d / +28%             [▲]      │
│     ├ Lote 003 · +8d / +22%                  │
│     ├ Lote 017 · +15d / +41%  ⚠ ALERTA      │
│     └ Lote 022 · +13d / +35%  ⚠ ALERTA      │
├──────────────────────────────────────────────┤
│  [  Exportar CSV  ]    [  Exportar PDF  ]    │  ← REL-05/07
└──────────────────────────────────────────────┘
```

---

## Decisões de Design

### D1 — Sem novo repositório (apenas datasource)

**Decisão:** Seguir o padrão atual do app — datasource chamado diretamente pelo store via GetIt.
**Razão:** Relatórios são queries read-only sem necessidade de cache ou offline. Adicionar repositório seria over-engineering para este caso.

### D2 — Cálculo 100% no servidor (API)

**Decisão:** Todo cálculo de desvio, agrupamento e ordenação acontece no resolver ISIS, não no Flutter.
**Razão:** Evita transferência de todos os lotes brutos para o cliente. Mais eficiente para volumes grandes.
**Trade-off:** Lógica de negócio no resolver. Aceitável pois já há precedente no `homeDashboard`.

### D3 — Threshold de desvio hardcoded no Flutter

**Decisão:** Os thresholds de destaque (±5% normal, >30% alerta) são constantes no `desvio_formatter.dart`.
**Razão:** Simplicidade. Configurabilidade por conta é escopo futuro.

### D4 — Aba 6 em vez de substituir uma existente

**Decisão:** Adicionar 6ª aba "Relatórios" ao BottomNavigationBar.
**Razão:** Não há aba óbvia para remover; relatórios são módulo distinto. Testar impacto visual com UX.
**Risco:** 6 itens é limite do Material BottomNavigationBar. Avaliar se NavigationBar (Material 3) é mais adequado.

### D5 — Hub de relatórios como ponto de entrada

**Decisão:** `RelatoriosPage` é uma tela de listagem com cards para cada relatório (incluindo os 2 existentes).
**Razão:** Os relatórios `relatorioProducao` e `relatorioStatusLotes` já existem mas não têm ponto de entrada na nav. O hub resolve isso e facilita adicionar novos relatórios.

---

## Packages Necessários (Flutter)

| Package | Uso | Já no projeto? |
|---|---|---|
| `csv` | Geração de CSV | Verificar pubspec |
| `share_plus` | Compartilhamento nativo | Verificar pubspec |
| `pdf` (P3) | Geração de PDF | Verificar pubspec |
| `path_provider` | Temp dir para arquivo | Verificar pubspec |

> ⚠️ Verificar `pubspec.yaml` antes de adicionar packages — podem já estar declarados.

---

## Queries GraphQL (Flutter → ISIS)

### Query Principal

```graphql
query RelatorioCircoCultura(
  $contaId: Int!
  $filtros: RelatorioCicloFiltros
) {
  relatorioCircoCultura(contaId: $contaId, filtros: $filtros) {
    totalLotes
    desvioMedioGeral
    periodoInicio
    periodoFim
    culturas {
      culturaId
      culturaNome
      totalLotes
      duracaoRealMedia
      duracaoPlanejadaMedia
      desvioMedioDias
      desvioMedioPercentual
      desvioMaxDias
      desvioMinDias
      lotes {
        loteId
        loteNome
        semeaduraData
        transplantioData
        colheitaData
        duracaoRealDias
        duracaoPlanejadaDias
        desvioDias
        desvioPercentual
        setorNome
        areaNome
      }
    }
  }
}
```

---

## Parte 3 — Relatório de Produtividade por Setor/Área

### Novo Resolver: `relatorioProdutividadeSetor`

**Schema de tipos:** `src/schemas/relatorioProdutividade.js`

#### Input

```graphql
input RelatorioProdutividadeFiltros {
  dataInicio: DateTime
  dataFim: DateTime
  setorIds: [Int]
  areaIds: [Int]
  culturaIds: [Int]
}
```

#### Output

```graphql
type RelatorioProdutividadeResult {
  setores:          [ProdutividadeSetorRanking!]!
  totalLotes:       Int!
  taxaGlobalMedia:  Float!
  periodoInicio:    DateTime!
  periodoFim:       DateTime!
}

type ProdutividadeSetorRanking {
  setorId:                  Int!
  setorNome:                String!
  areaNome:                 String
  totalLotes:               Int!
  totalBandejasSemeadas:    Int!
  totalMudasTransplantadas: Int!
  totalPlantasColhidas:     Int!
  totalEmbalagensProduzidas: Int!
  taxaGerminacao:           Float   # mudas_transplantadas / bandejas_semeadas
  taxaTransplantio:         Float   # plantas_colhidas / mudas_transplantadas * 100
  taxaEmbalagem:            Float   # embalagens_produzidas / plantas_colhidas * 100
  taxaGlobal:               Float   # embalagens_produzidas / bandejas_semeadas
  areas:                    [ProdutividadeAreaDetalhe!]!
}

type ProdutividadeAreaDetalhe {
  areaId:                   Int!
  areaNome:                 String!
  totalLotes:               Int!
  totalBandejasSemeadas:    Int!
  totalMudasTransplantadas: Int!
  totalPlantasColhidas:     Int!
  totalEmbalagensProduzidas: Int!
  taxaGerminacao:           Float
  taxaTransplantio:         Float
  taxaEmbalagem:            Float
  taxaGlobal:               Float
}
```

#### Lógica do Resolver

```javascript
async relatorioProdutividadeSetor(contaId, filtros) {
  // 1. Buscar lotes finalizados com campos produtivos
  const lotes = await prisma.lote.findMany({
    where: {
      setor: { area: { fk_contas_id: contaId } },
      colheita_data: { not: null, gte: filtros.dataInicio, lte: filtros.dataFim },
      deleted_at: null,
    },
    include: { setor: { include: { area: true } } }
  });

  // 2. Agrupar por setor
  const grouped = groupBy(lotes, 'fk_setores_id');

  // 3. Para cada setor: somar campos e calcular taxas
  const setores = Object.entries(grouped).map(([setorId, lotes]) => {
    const totais = lotes.reduce((acc, l) => ({
      bandejas: acc.bandejas + (l.bandejas_semeadas || 0),
      mudas: acc.mudas + (l.mudas_transplantadas || 0),
      plantas: acc.plantas + (l.plantas_colhidas || 0),
      embalagens: acc.embalagens + (l.embalagens_produzidas || 0),
    }), { bandejas: 0, mudas: 0, plantas: 0, embalagens: 0 });

    return {
      setorId, setorNome: lotes[0].setor.nome, areaNome: lotes[0].setor.area.nome,
      totalLotes: lotes.length, ...totais,
      taxaGerminacao: totais.bandejas > 0 ? totais.mudas / totais.bandejas : null,
      taxaTransplantio: totais.mudas > 0 ? totais.plantas / totais.mudas * 100 : null,
      taxaEmbalagem: totais.plantas > 0 ? totais.embalagens / totais.plantas * 100 : null,
      taxaGlobal: totais.bandejas > 0 ? totais.embalagens / totais.bandejas : null,
      areas: /* agrupar por area dentro do setor */
    };
  });

  // 4. Ordenar por taxaGlobal desc (null por último)
  setores.sort((a, b) => (b.taxaGlobal ?? -Infinity) - (a.taxaGlobal ?? -Infinity));

  return { setores, totalLotes: lotes.length, taxaGlobalMedia, periodoInicio, periodoFim };
}
```

---

### Flutter — Estrutura de Arquivos

```
lib/features/
├── data/
│   └── datasources/
│       └── relatorio_produtividade_setor/
│           └── relatorio_produtividade_setor_datasource.dart
│
└── presenter/
    ├── models/
    │   └── relatorio_produtividade_setor/
    │       └── relatorio_produtividade_setor_model.dart
    │
    ├── viewmodels/
    │   └── relatorio_produtividade_setor_store.dart
    │
    └── views/
        └── relatorios/
            └── produtividade_setor/
                ├── relatorio_produtividade_setor_page.dart
                ├── widgets/
                │   ├── produtividade_setor_card.dart      ← card expansível por setor
                │   ├── produtividade_destaques_header.dart ← banner de gargalo
                │   ├── produtividade_filtros_sheet.dart    ← bottom sheet filtros
                │   └── produtividade_area_tile.dart        ← tile de área expandida
                └── helpers/
                    └── conversao_formatter.dart            ← thresholds e cores
```

### Thresholds de Destaque Visual

```dart
// conversao_formatter.dart

// taxa_transplantio e taxa_embalagem (percentual 0-100)
const double kThresholdCritico   = 50.0;  // < 50% → vermelho
const double kThresholdAlerta    = 70.0;  // 50-70% → laranja
const double kThresholdBom       = 85.0;  // ≥ 85% → verde
// entre 70-85% → cinza (normal)

// taxa_germinacao (mudas por bandeja, esperado ~ 1x densidadeBandeja)
// não tem threshold fixo — exibido apenas como número

// taxa_global (embalagens por bandeja)
// ordenação: maior = melhor; sem threshold de cor
```

### Layout da Tela

```
┌──────────────────────────────────────────────┐
│  ← Produtividade por Setor/Área    🔍         │
├──────────────────────────────────────────────┤
│  📊 DESTAQUES                                │
│  Melhor: Setor A (4.2 emb/bandeja)   🟢      │
│  Gargalo: Transplantio — 62% das mudas 🟠     │
├──────────────────────────────────────────────┤
│  FILTROS: Mar/25 – Set/25    [Filtrar ▼]     │
├──────────────────────────────────────────────┤
│  RANKING POR SETOR                           │
│                                              │
│  #1 🟢 Setor A — Estufa Principal            │
│     12 lotes · 480 bandejas → 1.920 emb     │
│     Germ: 4.2/band · Transpl: 91% · Emb: 98% │
│     Global: 4.0 emb/band                [▼] │
│                                              │
│  #2 🟠 Setor B — Estufa Norte               │
│     8 lotes · 320 bandejas → 896 emb        │
│     Germ: 3.8/band · Transpl: 68% 🟠 · ...  │
│     Global: 2.8 emb/band                [▼] │
│       ├─ Área 1: ...                        │
│       └─ Área 2: ...                        │
├──────────────────────────────────────────────┤
│  [  Exportar CSV  ]                          │
└──────────────────────────────────────────────┘
```

### Rota

```dart
static const relatorioProdutividadeSetorPage = '/relatorioProdutividadeSetorPage';
```

---

## Parte 4 — Relatório de Desempenho da Equipe

### Novo Resolver: `relatorioDesempenhoEquipe`

**Schema de tipos:** `src/schemas/relatorioDesempenho.js`

#### Input

```graphql
input RelatorioDesempenhoFiltros {
  dataInicio: DateTime
  dataFim:    DateTime
  usuarioIds: [Int]
}
```

#### Output

```graphql
type RelatorioDesempenhoResult {
  usuarios:             [DesempenhoUsuarioRanking!]!
  totalUsuarios:        Int!
  taxaConclusaoMedia:   Float!
  periodoInicio:        DateTime!
  periodoFim:           DateTime!
}

type DesempenhoUsuarioRanking {
  usuarioId:            Int!
  usuarioNome:          String!
  totalAtividades:      Int!    # registros em Lotes_Atividades no período
  totalAgendas:         Int!    # agendas com data no período
  agendasFinalizadas:   Int!    # agendas com finalizado = true
  agendasNoPrazo:       Int!    # finalizadas com updated_at <= data
  taxaConclusao:        Float   # agendasFinalizadas / totalAgendas * 100; null se totalAgendas = 0
  taxaPrazo:            Float   # agendasNoPrazo / agendasFinalizadas * 100; null se agendasFinalizadas = 0
  ultimasAtividades:    [DesempenhoAtividadeItem!]!
  agendasPendentes:     [DesempenhoAgendaItem!]!
}

type DesempenhoAtividadeItem {
  atividadeId:   Int!
  atividadeNome: String!
  loteId:        Int!
  loteNome:      String
}

type DesempenhoAgendaItem {
  agendaId:    Int!
  titulo:      String
  data:        DateTime!
  finalizado:  Boolean!
  vencida:     Boolean!   # finalizado = false AND data < now()
}
```

#### Lógica do Resolver

```javascript
async relatorioDesempenhoEquipe(contaId, filtros) {
  const dataInicio = filtros?.dataInicio ?? subMonths(new Date(), 6);
  const dataFim    = filtros?.dataFim    ?? new Date();

  // 1. Buscar todos os usuários ativos da conta
  const conectas = await prisma.conectaConta.findMany({
    where: { fk_contas_id: contaId, usuario: { ativo: true } },
    include: { usuario: true }
  });
  const usuarios = conectas.map(c => c.usuario);

  // 2. Para cada usuário: contar atividades via lotes no período
  //    (Lotes_Atividades sem created_at → filtra pelo lote.semeadura_data)
  const atividadesPorUsuario = await prisma.lotes_Atividades.groupBy({
    by: ['fk_usuarios_id'],
    where: {
      fk_contas_id: contaId,
      fk_usuarios_id: { in: usuarios.map(u => u.id) },
      lote: { semeadura_data: { gte: dataInicio, lte: dataFim } }
    },
    _count: { id: true }
  });

  // 3. Para cada usuário: métricas de agenda
  const agendasPorUsuario = await prisma.agenda.groupBy({
    by: ['fk_usuarios_id', 'finalizado'],
    where: {
      fk_conta_id: contaId,
      fk_usuarios_id: { in: usuarios.map(u => u.id) },
      data: { gte: dataInicio, lte: dataFim },
      deleted_at: null
    },
    _count: { id: true }
  });

  // 4. Contar agendas no prazo (updated_at <= data)
  const agendasNoPrazoPorUsuario = await prisma.agenda.groupBy({
    by: ['fk_usuarios_id'],
    where: {
      fk_conta_id: contaId,
      fk_usuarios_id: { in: usuarios.map(u => u.id) },
      data: { gte: dataInicio, lte: dataFim },
      finalizado: true,
      deleted_at: null,
      AND: [{ updated_at: { lte: prisma.agenda.fields.data } }]
      // ⚠️ Nota: Prisma não suporta comparação campo-a-campo diretamente.
      // Alternativa: rawQuery ou buscar e filtrar em memória para V1.
    },
    _count: { id: true }
  });

  // 5. Buscar detalhes (últimas atividades e agendas pendentes) por usuário
  // ... (limitado a top 10 por usuário)

  // 6. Montar resultado por usuário e filtrar quem tem ao menos 1 registro
  const resultado = usuarios
    .map(u => montarMetricasUsuario(u, atividadesPorUsuario, agendasPorUsuario, agendasNoPrazoPorUsuario))
    .filter(u => u.totalAtividades > 0 || u.totalAgendas > 0);

  // 7. Filtrar por usuarioIds se informado
  // 8. Ordenar por totalAtividades desc
  resultado.sort((a, b) => b.totalAtividades - a.totalAtividades);

  const taxaConclusaoMedia = avg(resultado.map(u => u.taxaConclusao).filter(Boolean));

  return { usuarios: resultado, totalUsuarios: resultado.length, taxaConclusaoMedia, periodoInicio: dataInicio, periodoFim: dataFim };
}
```

> **Nota técnica:** A comparação `updated_at <= data` campo-a-campo no Prisma requer raw query (`$queryRaw`) ou fetch em memória. Para V1, recomenda-se buscar as agendas finalizadas em memória e filtrar com JS antes de retornar. Documentar como limitação técnica a otimizar na V2.

---

### Flutter — Estrutura de Arquivos

```
lib/features/
├── data/
│   └── datasources/
│       └── relatorio_desempenho_equipe/
│           └── relatorio_desempenho_equipe_datasource.dart
│
└── presenter/
    ├── models/
    │   └── relatorio_desempenho_equipe/
    │       └── relatorio_desempenho_equipe_model.dart
    │
    ├── viewmodels/
    │   └── relatorio_desempenho_equipe_store.dart
    │
    └── views/
        └── relatorios/
            └── desempenho_equipe/
                ├── relatorio_desempenho_equipe_page.dart
                ├── widgets/
                │   ├── desempenho_usuario_card.dart       ← card expansível por membro
                │   ├── desempenho_destaques_header.dart   ← banner com membro destaque + alertas
                │   ├── desempenho_filtros_sheet.dart      ← bottom sheet filtros
                │   ├── desempenho_atividade_tile.dart     ← tile de atividade expandida
                │   └── desempenho_agenda_tile.dart        ← tile de agenda pendente/vencida
                └── helpers/
                    └── desempenho_formatter.dart          ← thresholds e cores por taxa
```

### Thresholds de Destaque Visual

```dart
// desempenho_formatter.dart

// taxaConclusao (percentual 0-100)
const double kThresholdConclusaoCritico = 50.0;  // < 50% → vermelho
const double kThresholdConclusaoAlerta  = 80.0;  // 50–80% → laranja
// ≥ 80% → verde

// taxaPrazo (percentual 0-100)
const double kThresholdPrazoBaixo = 70.0;  // < 70% → badge "⚠ Atrasos"

enum ConclusaoStatus { critico, atencao, bom, semDados }

ConclusaoStatus getConclusaoStatus(double? taxa) {
  if (taxa == null) return ConclusaoStatus.semDados;
  if (taxa < kThresholdConclusaoCritico) return ConclusaoStatus.critico;
  if (taxa < kThresholdConclusaoAlerta)  return ConclusaoStatus.atencao;
  return ConclusaoStatus.bom;
}
```

### Layout da Tela

```
┌──────────────────────────────────────────────┐
│  ← Desempenho da Equipe           🔍          │
├──────────────────────────────────────────────┤
│  📊 DESTAQUES                                │
│  Mais ativo: João Silva (34 atividades) 🟢    │
│  Alerta: 2 membros com taxa de concl. < 50%  │
│  Média equipe: 72% de conclusão              │
├──────────────────────────────────────────────┤
│  FILTROS: Mar/25 – Set/25    [Filtrar ▼]     │
├──────────────────────────────────────────────┤
│  RANKING POR MEMBRO                          │
│                                              │
│  #1 🟢 João Silva                            │
│     34 atividades · 12/15 agendas · 80% ✅   │
│     No prazo: 91%                       [▼] │
│                                              │
│  #2 🟠 Maria Souza                          │
│     21 atividades · 7/14 agendas · 50% 🟠   │
│     No prazo: 57%  ⚠ Atrasos           [▼] │
│       ├─ Atividades: Transplantio (5), ...   │
│       └─ Agendas vencidas: 2                 │
│                                              │
│  #3 🔴 Carlos Lima                           │
│     8 atividades · 2/10 agendas · 20% 🔴    │
│     No prazo: 100%                      [▼] │
├──────────────────────────────────────────────┤
│  [  Exportar CSV  ]                          │
└──────────────────────────────────────────────┘
```

### Rota

```dart
static const relatorioDesempenhoEquipePage = '/relatorioDesempenhoEquipePage';
```

### MobX Store — `relatorio_desempenho_equipe_store.dart`

```dart
@observable ObservableFuture? loadFuture;
@observable RelatorioDesempenhoResult? resultado;
@observable RelatorioDesempenhoFiltros filtros = RelatorioDesempenhoFiltros.defaultUltimos6Meses();
@observable String? erro;

@action Future<void> carregar(int contaId) async { ... }
@action void atualizarFiltros(RelatorioDesempenhoFiltros novosFiltros) { ... }

@computed bool get isLoading => loadFuture?.status == FutureStatus.pending;
@computed bool get hasData => resultado?.usuarios.isNotEmpty == true;
@computed DesempenhoUsuarioRanking? get membroMaisAtivo => resultado?.usuarios.first;
@computed double? get taxaConclusaoMedia => resultado?.taxaConclusaoMedia;
@computed List<DesempenhoUsuarioRanking> get membrosComAlerta =>
    resultado?.usuarios.where((u) => (u.taxaConclusao ?? 100) < 50).toList() ?? [];
```

### Guard de Permissão — Flutter

```dart
// Em relatorio_desempenho_equipe_page.dart (initState / onReady)
final permissaoStore = GetIt.I<PermissaoStore>();
if (!permissaoStore.temPermissao('EQUIPE_VIEW')) {
  // Exibir widget de acesso negado — NÃO chamar carregar()
  return;
}
```

### Query GraphQL Flutter

```graphql
query RelatorioDesempenhoEquipe(
  $contaId: Int!
  $filtros: RelatorioDesempenhoFiltros
) {
  relatorioDesempenhoEquipe(contaId: $contaId, filtros: $filtros) {
    totalUsuarios
    taxaConclusaoMedia
    periodoInicio
    periodoFim
    usuarios {
      usuarioId
      usuarioNome
      totalAtividades
      totalAgendas
      agendasFinalizadas
      agendasNoPrazo
      taxaConclusao
      taxaPrazo
      ultimasAtividades {
        atividadeId
        atividadeNome
        loteId
        loteNome
      }
      agendasPendentes {
        agendaId
        titulo
        data
        finalizado
        vencida
      }
    }
  }
}
```

---

## Decisões de Design — Desempenho da Equipe

### D6 — Filtro de período via lote.semeadura_data para Lotes_Atividades

**Decisão:** Filtrar `Lotes_Atividades` pelo período usando `lote.semeadura_data`, não um `created_at` do próprio registro.
**Razão:** `Lotes_Atividades` não possui `created_at` no schema Prisma. O `semeadura_data` do lote é o melhor proxy disponível para "quando essa atividade ocorreu".
**Trade-off:** Uma atividade registrada em um lote semeado antes do período de filtro pode não aparecer. Documentar como limitação conhecida para V2 (adicionar `created_at` à tabela).

### D7 — `agendasNoPrazo` via memória para V1

**Decisão:** Buscar agendas finalizadas e filtrar `updated_at <= data` em memória JS no resolver.
**Razão:** Prisma não suporta comparação campo-a-campo (`WHERE updated_at <= data`). Raw query adicionaria complexidade desnecessária para V1.
**Trade-off:** Performance aceitável para volumes esperados (centenas de agendas por conta). Otimizar com `$queryRaw` na V2 se necessário.

### D8 — Guard de permissão EQUIPE_VIEW no Flutter (não só na API)

**Decisão:** Bloquear acesso à tela no Flutter antes de qualquer chamada à API quando o usuário não tem `EQUIPE_VIEW`.
**Razão:** UX mais responsiva (sem loading antes do bloqueio) e segurança em camadas.
**Como verificar:** Usar o mesmo mecanismo de `PermissaoStore` já adotado em outras telas com controle de acesso.

### Query GraphQL Flutter

```graphql
query RelatorioProdutividadeSetor(
  $contaId: Int!
  $filtros: RelatorioProdutividadeFiltros
) {
  relatorioProdutividadeSetor(contaId: $contaId, filtros: $filtros) {
    totalLotes
    taxaGlobalMedia
    periodoInicio
    periodoFim
    setores {
      setorId
      setorNome
      areaNome
      totalLotes
      totalBandejasSemeadas
      totalMudasTransplantadas
      totalPlantasColhidas
      totalEmbalagensProduzidas
      taxaGerminacao
      taxaTransplantio
      taxaEmbalagem
      taxaGlobal
      areas {
        areaId
        areaNome
        totalLotes
        totalBandejasSemeadas
        totalMudasTransplantadas
        totalPlantasColhidas
        totalEmbalagensProduzidas
        taxaGerminacao
        taxaTransplantio
        taxaEmbalagem
        taxaGlobal
      }
    }
  }
}
```
