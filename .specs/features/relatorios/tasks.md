# Relatórios — Tasks

**Feature:** Módulo de Relatórios (Ciclo de Produção por Cultura)
**Data:** 2026-03-24
**Spec:** spec.md | **Design:** design.md

---

## Visão Geral

```
ISIS API (Bloco A)          Flutter (Blocos B, C, D)
────────────────────        ──────────────────────────────────────
A1 → A2 → A3 → A4          B1 → B2
                             ↓
                            C1 → C2 → C3 → C4 → C5
                             ↓
                            D1 → D2

B pode rodar em paralelo com A.
C começa após B1 (modelos) e A4 (API disponível para teste).
D começa após C3 (export usa dados do store).
```

---

## BLOCO A — ISIS API: Resolver `relatorioCircoCultura`

### A1 · Criar schema de tipos GraphQL

**Arquivo:** `src/schemas/relatorioCiclo.js`
**Reqs:** REL-02

Criar o arquivo com os tipos Nexus:
- `RelatorioCicloFiltros` (input)
- `CicloLoteDetalhe` (objectType)
- `CicloRankingCultura` (objectType)
- `RelatorioCicloResult` (objectType)

Seguir o padrão dos arquivos `homeDashboard.js` / `relatorioProducao.js` existentes.

**Verificação:** Arquivo criado, tipos exportados, sem erros de sintaxe JS.

---

### A2 · Registrar os tipos no schema principal

**Arquivo:** `src/schema.js` (ou onde os types são agregados)
**Reqs:** REL-02

Importar e adicionar os novos tipos ao `makeSchema({ types: [...] })`.

**Verificação:** Servidor inicia sem erros.

---

### A3 · Implementar o resolver no query.js

**Arquivo:** `src/schemas/query.js`
**Reqs:** REL-02, REL-04

Adicionar o field `relatorioCircoCultura` ao `queryType`:

```javascript
t.field('relatorioCircoCultura', {
  type: 'RelatorioCicloResult',
  args: {
    contaId: nonNull(intArg()),
    filtros: arg({ type: 'RelatorioCicloFiltros' }),
  },
  resolve: async (_, { contaId, filtros }, ctx) => {
    // Implementar lógica descrita no design.md
    // 1. Query Prisma com filtros
    // 2. Calcular durações por lote
    // 3. Agrupar por cultura
    // 4. Calcular agregados
    // 5. Ordenar por desvioMedioPercentual asc
    // 6. Retornar RelatorioCicloResult
  }
})
```

**Filtro padrão:** Se `filtros.dataInicio` não informado → últimos 6 meses (`new Date()` - 6 meses).

**Verificação:**
- Query no GraphQL Playground com conta válida retorna dados
- Culturas ordenadas corretamente (menor desvio primeiro)
- Lotes sem protocolo retornam `duracaoPlanejadaDias: null`
- Filtro de período funciona

---

### A4 · Testar edge cases no resolver

**Arquivo:** `src/schemas/query.js`
**Reqs:** REL-02 edge cases

Verificar manualmente no Playground:
- [ ] Conta sem lotes → `{ culturas: [], totalLotes: 0 }`
- [ ] Lote sem protocolo → campos de desvio `null`
- [ ] Filtro `culturaIds` filtra corretamente
- [ ] Lote com `transplantio_data < semeadura_data` → excluído ou tratado
- [ ] `deleted_at` não nulo → excluído

**Verificação:** Todos os cenários acima produzem resultado esperado sem erros 500.

---

## BLOCO B — Flutter: Models e Datasource

### B1 · Criar models (DTOs)

**Arquivo:** `lib/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart`
**Reqs:** REL-02, REL-03

```dart
class RelatorioCicloFiltros { dataInicio, dataFim, culturaIds, setorIds, areaIds + defaultUltimos6Meses() }
class CicloLoteDetalhe { loteId, loteNome, semeaduraData, transplantioData, colheitaData, duracaoRealDias, duracaoPlanejadaDias, desvioDias, desvioPercentual, setorNome, areaNome }
class CicloRankingCultura { culturaId, culturaNome, totalLotes, duracaoRealMedia, duracaoPlanejadaMedia, desvioMedioDias, desvioMedioPercentual, desvioMaxDias, desvioMinDias, lotes }
class RelatorioCicloResult { culturas, totalLotes, desvioMedioGeral, periodoInicio, periodoFim }
```

Incluir factory `fromJson` em cada model.

**Verificação:** Models compilam sem erros, `fromJson` cobre campos nullable.

---

### B2 · Criar datasource

**Arquivo:** `lib/features/data/datasources/relatorio_ciclo_cultura/relatorio_ciclo_cultura_datasource.dart`
**Reqs:** REL-02

Seguir o padrão de `relatorioProducao_datasource.dart`:
- Método `buscarRelatorio(int contaId, RelatorioCicloFiltros filtros)`
- GraphQL query string com a query do design.md
- Retorno `Either<Failure, RelatorioCicloResult>`
- Parse do JSON via `RelatorioCicloResult.fromJson`

**Verificação:** Método compila; chamada real retorna dados da API (requer A3 concluído).

---

## BLOCO C — Flutter: UI do Relatório

### C1 · Criar helper de formatação/destaques

**Arquivo:** `lib/features/presenter/views/relatorios/ciclo_cultura/helpers/desvio_formatter.dart`
**Reqs:** REL-03

Implementar conforme design.md:
- enum `DesvioStatus`
- `getDesvioStatus(double?) → DesvioStatus`
- `getDesvioColor(DesvioStatus) → Color`
- `formatDesvio(double? percentual, double? dias) → String`
- constantes `THRESHOLD_NORMAL = 5.0`, `THRESHOLD_ALERTA = 30.0`

**Verificação:** Testes unitários básicos:
- `getDesvioStatus(6.0)` → `atrasado`
- `getDesvioStatus(-6.0)` → `adiantado`
- `getDesvioStatus(3.0)` → `normal`
- `getDesvioStatus(null)` → `semProtocolo`

---

### C2 · Criar MobX Store

**Arquivo:** `lib/features/presenter/viewmodels/relatorio_ciclo_cultura_store.dart`
**Reqs:** REL-03, REL-04

```dart
@injectable
class RelatorioCicloCulturaStore extends _RelatorioCicloCulturaStore with _$RelatorioCicloCulturaStore {
  RelatorioCicloCulturaStore(RelatorioCicloCulturaDatasource datasource) : super(datasource);
}

abstract class _RelatorioCicloCulturaStore with Store {
  @observable ObservableFuture? _loadFuture;
  @observable RelatorioCicloResult? resultado;
  @observable RelatorioCicloFiltros filtros = RelatorioCicloFiltros.defaultUltimos6Meses();

  @action Future<void> carregar(int contaId) async { ... }
  @action void atualizarFiltros(RelatorioCicloFiltros novosFiltros) { filtros = novosFiltros; carregar(contaId); }

  @computed bool get isLoading => ...;
  @computed bool get hasData => ...;
  @computed CicloRankingCultura? get piorCultura => ...;
  @computed CicloRankingCultura? get melhorCultura => ...;
}
```

Registrar no `injection_container.dart` (GetIt).

**Verificação:** `flutter pub run build_runner build` roda sem erros para o store.

---

### C3 · Criar widgets do relatório

**Arquivos:**
- `relatorio_ciclo_cultura_page.dart` — tela principal com Observer/FutureBuilder
- `ciclo_destaques_header.dart` — seção de insights (REL-06)
- `ciclo_filtros_sheet.dart` — bottom sheet com seletores de período/cultura/setor
- `ciclo_cultura_card.dart` — card expansível por cultura com cores de desvio
- `ciclo_lote_tile.dart` — tile individual de lote dentro do card expandido

**Reqs:** REL-03, REL-04, REL-06

Layout conforme mockup no design.md:
1. `AppBar` com título e botão de filtros
2. `CicloDestaqueHeader` (se `hasData`)
3. Chips de filtros ativos
4. `ListView` de `CicloCulturaCard` ordenados por ranking
5. Cada card: expansível mostrando `CicleLoteTile` por lote
6. Botões de exportação no rodapé (floatingActionButton ou footer)

**Estados:** loading skeleton, erro (botão retry), vazio (mensagem contextual).

**Verificação:** Tela abre e exibe dados corretamente. Expandir um card mostra lotes. Cores de desvio aplicadas conforme thresholds.

---

### C4 · Adicionar aba Relatórios e rotas

**Arquivos:**
- `lib/features/presenter/views/modulos/modulos_page.dart`
- `lib/features/presenter/routes/routes.dart`
- `lib/features/presenter/routes/app_pages.dart` (ou equivalente)

**Reqs:** REL-01

1. Adicionar rota `relatoriosPage` e `relatorioCircoCulturaPage` em `routes.dart`
2. Registrar GetX `GetPage` para cada rota
3. Em `modulos_page.dart`: adicionar 6ª aba com ícone `Icons.bar_chart_outlined`
4. Criar `relatorios_page.dart` (hub) — lista de cards:
   - "Produção" → rota existente
   - "Status de Lotes" → rota existente
   - "Ciclo por Cultura" → `relatorioCircoCulturaPage`

**Verificação:** Tocar aba Relatórios → ver hub com 3 cards. Tocar "Ciclo por Cultura" → navegar para a tela.

---

### C5 · Integração e ajustes finais

**Reqs:** todos P1

Garantir que:
- [ ] `contaId` é passado corretamente a partir da sessão do usuário (verificar como `homeDashboard` obtém `contaId`)
- [ ] Estado vazio exibe mensagem "Nenhum lote com ciclo completo no período selecionado"
- [ ] Filtro de período reseta para últimos 6 meses ao tocar "Limpar filtros"
- [ ] Scrolling funciona corretamente com vários cards expandidos
- [ ] Tela do relatório roda `carregar()` no `initState` / `onReady`

**Verificação:** Fluxo completo end-to-end: abrir app → Relatórios → Ciclo por Cultura → ver dados → filtrar → ver dados atualizados.

---

## BLOCO D — Flutter: Exportação CSV (P2)

### D1 · Verificar/adicionar packages

**Arquivo:** `pubspec.yaml`
**Reqs:** REL-05

Verificar se `csv`, `share_plus`, `path_provider` já estão no projeto.
Adicionar apenas os ausentes. Rodar `flutter pub get`.

**Verificação:** `flutter pub get` sem erros.

---

### D2 · Implementar ExportService

**Arquivo:** `lib/features/presenter/services/export_service.dart`
**Reqs:** REL-05

```dart
class ExportService {
  Future<void> exportarRelatorioCicloCSV(RelatorioCicloResult resultado) async {
    // 1. Montar lista de linhas (header + dados por cultura)
    // 2. Converter para string CSV usando package csv
    // 3. Salvar em temp dir via path_provider
    // 4. Compartilhar via share_plus
  }
}
```

Registrar no GetIt.

Conectar o botão "Exportar CSV" da `RelatorioCircoCulturaPage` ao método.

**Verificação:** Tocar "Exportar CSV" → arquivo gerado → seletor de compartilhamento abre → arquivo abre em planilha com dados corretos.

---

## Requirement Traceability — Atualização

| Requirement ID | Tasks | Status |
|---|---|---|
| REL-01 | C4 | Done |
| REL-02 | A1, A2, A3, A4, B1, B2 | Done |
| REL-03 | B1, C1, C2, C3, C5 | Done |
| REL-04 | A3, C3, C5 | Done |
| REL-05 | D1, D2 | Done |
| REL-06 | C3 (ciclo_destaques_header) | Done |
| REL-07 | — (P3, fora do escopo) | Deferred |
| REL-08 | Superseded → PROD-XX | Superseded |
| PROD-01 | E1, E2, E3 | Pending |
| PROD-02 | F1, F2, F3 | Pending |
| PROD-03 | E3, F2 | Pending |
| PROD-04 | F3 (produtividade_destaques_header) | Pending |
| PROD-05 | G1 | Pending |
| PROD-06 | — (P3, deferred) | Deferred |

**Coverage MVP:** 4/4 mapeados (PROD-01 a PROD-04) ✅

---

## BLOCO E — ISIS API: Resolver `relatorioProdutividadeSetor`

### E1 · Criar schema de tipos GraphQL para Produtividade

**Arquivo:** `src/schemas/relatorioProdutividade.js`
**Reqs:** PROD-01

Criar o arquivo com os tipos Nexus:
- `RelatorioProdutividadeFiltros` (input)
- `ProdutividadeAreaDetalhe` (objectType)
- `ProdutividadeSetorRanking` (objectType)
- `RelatorioProdutividadeResult` (objectType)

Seguir o padrão de `relatorioCiclo.js`.

**Verificação:** Tipos exportados, sem erros de sintaxe JS.

---

### E2 · Registrar os tipos no schema principal

**Arquivo:** `src/schema.js`
**Reqs:** PROD-01

Importar e adicionar ao `makeSchema({ types: [...] })`.

**Verificação:** Servidor inicia sem erros.

---

### E3 · Implementar o resolver

**Arquivo:** `src/schemas/query.js`
**Reqs:** PROD-01, PROD-03

Adicionar field `relatorioProdutividadeSetor` conforme design.md Parte 3.

Lógica:
1. Query Prisma — lotes finalizados com setor+área
2. Somar campos produtivos por setor e por área
3. Calcular as 4 taxas de conversão (cuidar divisão por zero)
4. Ordenar por `taxaGlobal` desc
5. Retornar `RelatorioProdutividadeResult`

**Filtro padrão:** últimos 6 meses se `dataInicio` não informado.

**Verificação:**
- Query no Playground com conta válida retorna setores com taxas
- Setores ordenados corretamente (maior taxa_global primeiro)
- Divisão por zero tratada (retorna null)
- Filtro de período funciona

---

## BLOCO F — Flutter: UI do Relatório de Produtividade

### F1 · Criar models e datasource

**Arquivos:**
- `lib/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart`
- `lib/features/data/datasources/relatorio_produtividade_setor/relatorio_produtividade_setor_datasource.dart`
**Reqs:** PROD-01, PROD-02

Models: `RelatorioProdutividadeFiltros`, `ProdutividadeAreaDetalhe`, `ProdutividadeSetorRanking`, `RelatorioProdutividadeResult` com `fromJson`.

Datasource segue padrão de `relatorio_ciclo_cultura_datasource.dart`.

**Verificação:** Compila sem erros, `fromJson` cobre nullable.

---

### F2 · Criar MobX Store

**Arquivo:** `lib/features/presenter/viewmodels/relatorio_produtividade_setor_store.dart`
**Reqs:** PROD-02, PROD-03

Observables: `isLoading`, `hasError`, `errorMessage`, `resultado`, `filtros`.
Computed: `hasData`, `melhorSetor`, `piorSetor`, `etapaGargalo`.
Actions: `carregarRelatorio()`, `atualizarFiltros()`, `carregarMock()`.

Registrar no `inject.dart`.

**Verificação:** `flutter pub run build_runner build` roda sem erros.

---

### F3 · Criar page e widgets

**Arquivos:**
- `relatorio_produtividade_setor_page.dart`
- `conversao_formatter.dart` — thresholds e cores
- `produtividade_destaques_header.dart` — gargalo identificado
- `produtividade_setor_card.dart` — card expansível por setor
- `produtividade_area_tile.dart` — tile de área
- `produtividade_filtros_sheet.dart` — bottom sheet
**Reqs:** PROD-02, PROD-03, PROD-04

Layout conforme design.md Parte 3.

**Verificação:** Tela abre com dados mock, cores de threshold aplicadas, expandir setor mostra áreas.

---

## BLOCO G — Exportação CSV Produtividade (P2)

### G1 · Adicionar método ao ExportService

**Arquivo:** `lib/core/services/export_service.dart`
**Reqs:** PROD-05

```dart
Future<void> exportarRelatorioProdutividadeCSV(RelatorioProdutividadeResult resultado) async {
  // Colunas: setor, area, total_lotes, bandejas_semeadas, mudas_transplantadas,
  //          plantas_colhidas, embalagens_produzidas, taxa_germinacao,
  //          taxa_transplantio, taxa_embalagem, taxa_global
}
```

**Verificação:** Arquivo gerado, abre em planilha.

---

## Requirement Traceability — Atualização

---

## BLOCO H — ISIS API: Resolver `relatorioDesempenhoEquipe`

### H1 · Criar schema de tipos GraphQL para Desempenho da Equipe

**Arquivo:** `src/schemas/relatorioDesempenho.js`
**Reqs:** EQP-01

Criar o arquivo com os tipos Nexus:
- `RelatorioDesempenhoFiltros` (inputType)
- `DesempenhoAtividadeItem` (objectType)
- `DesempenhoAgendaItem` (objectType)
- `DesempenhoUsuarioRanking` (objectType)
- `RelatorioDesempenhoResult` (objectType)

Seguir o padrão de `relatorioCiclo.js` e `relatorioProdutividade.js`.

**Verificação:** Tipos exportados, sem erros de sintaxe JS.

---

### H2 · Registrar os tipos no schema principal

**Arquivo:** `src/schema.js`
**Reqs:** EQP-01

Importar e adicionar ao `makeSchema({ types: [...] })`.

**Verificação:** Servidor inicia sem erros.

---

### H3 · Implementar o resolver

**Arquivo:** `src/schemas/query.js`
**Reqs:** EQP-01, EQP-03

Adicionar field `relatorioDesempenhoEquipe` conforme design.md Parte 4.

Lógica:
1. Resolver período (padrão últimos 6 meses)
2. Buscar usuários ativos da conta via `ConectaConta`
3. Agrupar `Lotes_Atividades` por usuário filtrando via `lote.semeadura_data` no período
4. Agrupar `Agenda` por usuário filtrando via `data` no período
5. Buscar agendas finalizadas e filtrar `updated_at <= data` em memória (D7)
6. Montar métricas por usuário (calcular taxas, tratar divisão por zero)
7. Filtrar usuários sem registros no período
8. Aplicar filtro `usuarioIds` se informado
9. Ordenar por `totalAtividades` descendente
10. Buscar `ultimasAtividades` (top 10 por usuário) e `agendasPendentes` (não finalizadas no período)
11. Retornar `RelatorioDesempenhoResult`

**Filtro padrão:** Se `filtros.dataInicio` não informado → últimos 6 meses.

**Verificação:**
- Query no Playground com conta válida retorna usuários com métricas
- Usuários sem atividade nem agenda omitidos
- `taxaConclusao` e `taxaPrazo` retornam `null` quando denominador = 0 (não NaN)
- `agendasNoPrazo` correto para casos de prazo respeitado e não respeitado
- Filtro de período funciona

---

### H4 · Testar edge cases no resolver

**Arquivo:** `src/schemas/query.js`
**Reqs:** EQP-01 edge cases

Verificar manualmente no Playground:
- [ ] Conta sem usuários ativos → `{ usuarios: [], totalUsuarios: 0 }`
- [ ] Usuário com apenas atividades e sem agendas → `taxaConclusao: null`
- [ ] Usuário com todas agendas finalizadas no prazo → `taxaPrazo: 100`
- [ ] `deleted_at` não nulo em Agenda → excluída das contagens
- [ ] Filtro `usuarioIds` filtra corretamente
- [ ] Período sem dados → resultado vazio sem erro 500

**Verificação:** Todos os cenários produzem resultado esperado sem erros 500.

---

## BLOCO I — Flutter: UI do Relatório de Desempenho da Equipe

### I1 · Criar models e datasource

**Arquivos:**
- `lib/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart`
- `lib/features/data/datasources/relatorio_desempenho_equipe/relatorio_desempenho_equipe_datasource.dart`
**Reqs:** EQP-01, EQP-02

Models: `RelatorioDesempenhoFiltros`, `DesempenhoAtividadeItem`, `DesempenhoAgendaItem`, `DesempenhoUsuarioRanking`, `RelatorioDesempenhoResult` com `fromJson`.

Incluir `RelatorioDesempenhoFiltros.defaultUltimos6Meses()` factory.

Datasource segue padrão de `relatorio_ciclo_cultura_datasource.dart`:
- Método `buscarRelatorio(int contaId, RelatorioDesempenhoFiltros filtros)`
- Query GraphQL conforme design.md Parte 4
- Retorno `Either<Failure, RelatorioDesempenhoResult>`

**Verificação:** Compila sem erros, `fromJson` cobre todos os campos nullable.

---

### I2 · Criar MobX Store

**Arquivo:** `lib/features/presenter/viewmodels/relatorio_desempenho_equipe_store.dart`
**Reqs:** EQP-02, EQP-03

Observables: `loadFuture`, `resultado`, `filtros`, `erro`.
Computed: `isLoading`, `hasData`, `membroMaisAtivo`, `taxaConclusaoMedia`, `membrosComAlerta`.
Actions: `carregar(int contaId)`, `atualizarFiltros(RelatorioDesempenhoFiltros)`.

Registrar no `inject.dart`.

**Verificação:** `flutter pub run build_runner build` roda sem erros para o store.

---

### I3 · Criar helper de formatação

**Arquivo:** `lib/features/presenter/views/relatorios/desempenho_equipe/helpers/desempenho_formatter.dart`
**Reqs:** EQP-02

Implementar conforme design.md Parte 4:
- enum `ConclusaoStatus { critico, atencao, bom, semDados }`
- `getConclusaoStatus(double?) → ConclusaoStatus`
- `getConclusaoColor(ConclusaoStatus) → Color`
- `formatTaxa(double?) → String` — ex: `"72%"` ou `"—"`
- constantes `kThresholdConclusaoCritico = 50.0`, `kThresholdConclusaoAlerta = 80.0`, `kThresholdPrazoBaixo = 70.0`

**Verificação:**
- `getConclusaoStatus(45.0)` → `critico`
- `getConclusaoStatus(65.0)` → `atencao`
- `getConclusaoStatus(85.0)` → `bom`
- `getConclusaoStatus(null)` → `semDados`

---

### I4 · Criar page e widgets

**Arquivos:**
- `relatorio_desempenho_equipe_page.dart` — tela principal com guard EQUIPE_VIEW + Observer
- `desempenho_destaques_header.dart` — banner com membro destaque e alertas (EQP-04)
- `desempenho_usuario_card.dart` — card expansível por membro com cores de taxaConclusao
- `desempenho_atividade_tile.dart` — tile de atividade dentro do card expandido
- `desempenho_agenda_tile.dart` — tile de agenda pendente/vencida
- `desempenho_filtros_sheet.dart` — bottom sheet com seletores de período e membros
**Reqs:** EQP-02, EQP-03, EQP-04

Layout conforme design.md mockup Parte 4:
1. Verificar `EQUIPE_VIEW` antes de qualquer chamada (exibir bloqueio se ausente)
2. `AppBar` com título e botão de filtros
3. `DesempenhoDestaquesHeader` (se `hasData`)
4. Chips de filtros ativos
5. `ListView` de `DesempenhoUsuarioCard` ordenados por ranking
6. Cada card expansível → mostra `DesempenhoAtividadeTile` e `DesempenhoAgendaTile`
7. Botão "Exportar CSV" no rodapé
8. Badge "⚠ Atrasos" em usuários com `taxaPrazo < 70%`

**Estados:** loading skeleton, erro (botão retry), acesso negado, vazio (mensagem contextual).

**Verificação:** Tela abre com guard funcionando, exibe dados, cores de threshold corretas, expand/collapse dos cards.

---

### I5 · Registrar rota e adicionar card no hub

**Arquivos:**
- `lib/features/presenter/routes/routes.dart`
- `lib/features/presenter/routes/app_pages.dart`
- `lib/features/presenter/views/relatorios/relatorios_page.dart`
**Reqs:** REL-01 (atualização do hub)

1. Adicionar `static const relatorioDesempenhoEquipePage = '/relatorioDesempenhoEquipePage'` em `routes.dart`
2. Registrar `GetPage` correspondente em `app_pages.dart`
3. Em `relatorios_page.dart`: adicionar card "Desempenho da Equipe" com ícone `Icons.people_outlined`; exibir o card apenas se o usuário tiver permissão `EQUIPE_VIEW`

**Verificação:** Hub de Relatórios exibe card "Desempenho da Equipe" para gestor. Card não aparece para usuário sem EQUIPE_VIEW. Tocar no card navega para a tela.

---

### I6 · Integração e ajustes finais

**Reqs:** EQP-01, EQP-02, EQP-03

Garantir que:
- [ ] `contaId` obtido corretamente da sessão (mesmo padrão dos outros relatórios)
- [ ] Guard de permissão não bloqueia requisições desnecessárias (verificar antes do `carregar()`)
- [ ] Estado vazio: "Nenhum dado de equipe encontrado no período selecionado"
- [ ] Filtro de período reseta para últimos 6 meses ao tocar "Limpar filtros"
- [ ] `carregar()` chamado em `onReady` / `initState` da page

**Verificação:** Fluxo end-to-end: gestor abre app → Relatórios → Desempenho da Equipe → vê ranking → filtra → dados atualizados. Usuário sem permissão vê bloqueio.

---

## BLOCO J — Exportação CSV Desempenho da Equipe (P2)

### J1 · Adicionar método ao ExportService

**Arquivo:** `lib/core/services/export_service.dart`
**Reqs:** EQP-05

```dart
Future<void> exportarRelatorioDesempenhoCSV(RelatorioDesempenhoResult resultado) async {
  // Colunas: usuario_nome, total_atividades, total_agendas, agendas_finalizadas,
  //          agendas_no_prazo, taxa_conclusao_pct, taxa_prazo_pct
  // Seguir padrão de exportarRelatorioProdutividadeCSV
}
```

Conectar botão "Exportar CSV" da `RelatorioDesempenhoEquipePage` ao método.

**Verificação:** Tocar exportar → arquivo gerado com 7 colunas → abre em planilha com dados corretos.

---

## Requirement Traceability — Atualização

| Requirement ID | Tasks | Status |
|---|---|---|
| REL-01 | C4, I5 | Done / Atualizado |
| REL-02 | A1, A2, A3, A4, B1, B2 | Done |
| REL-03 | B1, C1, C2, C3, C5 | Done |
| REL-04 | A3, C3, C5 | Done |
| REL-05 | D1, D2 | Done |
| REL-06 | C3 | Done |
| REL-07 | — (P3, deferred) | Deferred |
| REL-08 | Superseded → PROD-XX | Superseded |
| PROD-01 | E1, E2, E3 | Pending |
| PROD-02 | F1, F2, F3 | Pending |
| PROD-03 | E3, F2 | Pending |
| PROD-04 | F3 | Pending |
| PROD-05 | G1 | Pending |
| PROD-06 | — (P3, deferred) | Deferred |
| EQP-01 | H1, H2, H3, H4, I1 | Pending |
| EQP-02 | I1, I2, I3, I4, I6 | Pending |
| EQP-03 | H3, I4, I5, I6 | Pending |
| EQP-04 | I4 (desempenho_destaques_header) | Pending |
| EQP-05 | J1 | Pending |
| EQP-06 | — (P3, deferred) | Deferred |

**Coverage MVP:** 5/5 EQP P1+P2 mapeados ✅

---

## Ordem de Implementação Recomendada

```
Dia 1: A1 + A2 + A3 (API pronta e testável)
Dia 2: B1 + B2 + A4 (models + datasource + validar edge cases)
Dia 3: C1 + C2 (formatter + store)
Dia 4: C3 (widgets principais)
Dia 5: C4 + C5 (navegação + integração)
Dia 6: D1 + D2 (exportação CSV)
--- Ciclo 2: Produtividade por Setor ---
Dia 7:  E1 + E2 + E3 (API produtividade)
Dia 8:  F1 + F2 (models + store produtividade)
Dia 9:  F3 (widgets produtividade)
Dia 10: G1 (export CSV produtividade)
--- Ciclo 3: Desempenho da Equipe ---
Dia 11: H1 + H2 + H3 (API desempenho)
Dia 12: H4 + I1 (edge cases API + models Flutter)
Dia 13: I2 + I3 (store + formatter)
Dia 14: I4 (widgets)
Dia 15: I5 + I6 + J1 (rota + integração + export CSV)
```
