# Spec: Ordenação Adaptativa de Dashboard (sem bloqueio de navegação)

**Feature ID:** `adaptive-dashboard-ordering`
**Referência:** `.specs/features/adaptive-interface/tdd.md`
**Status:** Pronto para implementação
**Escopo:** Médio — 2 arquivos, lógica de reordenação + remoção de Observer reativo

---

## Contexto

O sistema de interface adaptativa usa Firebase + BigQuery + ML para recomendar qual dashboard exibir ao usuário com base no horário e comportamento histórico. A recomendação é retornada via `adaptiveDashboard` (String com o título) e `dashboardConfidence` (double 0–1) no `HomeStore`.

O carousel de dashboards na `HomePage` possui 4 posições fixas:
```
[0] Lotes em Produção
[1] Tarefas Pendentes
[2] Produção Total
[3] Top Culturas
```

---

## Problema

### Bug Identificado

Existe **dois mecanismos** de aplicação do dashboard adaptativo em `home_page.dart`:

1. **`_applyAdaptiveDashboard()`** (linha ~72) — chamado uma vez no `initState` via `loadAdaptiveInterface().then()`. Correto: anima para o índice do dashboard recomendado.

2. **`Observer` dentro do `SliverToBoxAdapter`** (linhas ~804–820) — **este é o bug**. A cada rebuild do widget (incluindo swipes do usuário), o Observer detecta `adaptiveDashboard != null && dashboardConfidence > 0.5` e re-anima o `PageController` de volta para o índice recomendado, cancelando qualquer navegação manual do usuário.

**Efeito colateral:** O usuário fica preso no dashboard recomendado e não consegue visualizar os demais, mesmo que as setas de navegação estejam habilitadas.

---

## Comportamento Esperado

| Situação | Comportamento atual (bug) | Comportamento correto |
|---|---|---|
| ML recomenda "Produção Total" | Dashboard abre no índice 2, e volta para ele a cada rebuild | Dashboard recomendado vai para posição 0; usuário pode navegar livremente |
| Usuário swipa para próximo dashboard | Observer re-aplica e volta para o recomendado | Navegação livre, sem interferência do ML após carregamento |
| Dashboard recomendado na posição atual | Badge "recomendado" exibido | Mantido — badge continua sendo exibido quando o recomendado está visível |
| Sem recomendação (null ou confiança baixa) | Ordem original `[0..3]` | Sem mudança — ordem padrão mantida |

---

## Requisitos

### REQ-01 — Remover re-aplicação reativa contínua
O `Observer` dentro do `SliverToBoxAdapter` que re-aplica `animateToPage` deve ser removido. A aplicação do dashboard adaptativo deve ocorrer **uma única vez**, no carregamento inicial.

### REQ-02 — Reordenar a lista `_dashboardTitles` com o recomendado na posição 0
Quando `adaptiveDashboard != null` e `dashboardConfidence > 0.5`, construir a lista ordenada movendo o dashboard recomendado para o índice 0, mantendo os demais na ordem original.

**Exemplo:**
```
adaptiveDashboard = "Produção Total"
Lista padrão:  ['Lotes em Produção', 'Tarefas Pendentes', 'Produção Total', 'Top Culturas']
Lista ordenada: ['Produção Total', 'Lotes em Produção', 'Tarefas Pendentes', 'Top Culturas']
```

### REQ-03 — Iniciar o carousel na posição 0 após reordenação
Como o dashboard recomendado já está na posição 0, não é necessário animar para outro índice. O `PageController` inicia no índice 0 por padrão. A chamada `_applyAdaptiveDashboard()` pode ser simplificada ou removida.

### REQ-04 — Preservar a flag "recomendado" no badge
O badge "recomendado" deve continuar sendo exibido quando o dashboard visível corresponder ao `adaptiveDashboard`. A lógica de comparação pelo título continua válida — apenas a posição muda.

### REQ-05 — Navegação livre entre dashboards
Após o carregamento inicial, o usuário deve poder navegar livremente entre todos os 4 dashboards usando as setas ou swipe, sem nenhuma interferência do sistema adaptativo.

### REQ-06 — Fallback sem mudança
Quando `adaptiveDashboard == null` ou `dashboardConfidence <= 0.5`, a lista permanece na ordem original `['Lotes em Produção', 'Tarefas Pendentes', 'Produção Total', 'Top Culturas']`.

---

## Solução Técnica (alto nível)

### Mudança 1 — Computed list para dashboards ordenados

Em `HomePageState`, substituir a lista fixa `_dashboardTitles` por um método/getter que retorna a lista reordenada baseado no estado do store:

```
orderedDashboards = recomendado está na posição 0 + restantes na ordem original
```

Este getter é chamado **uma vez** após `loadAdaptiveInterface()` completar, e o resultado é armazenado em estado local. Não é recalculado a cada rebuild.

### Mudança 2 — Remover o Observer de re-aplicação

O bloco Observer em `SliverToBoxAdapter` (linhas ~804–820) que chama `animateToPage` dentro de `addPostFrameCallback` deve ser removido. Esse Observer é a causa raiz do bug.

### Mudança 3 — Simplificar `_applyAdaptiveDashboard()`

Como o recomendado já está em `index 0`, a função pode ser simplificada para apenas atualizar a lista ordenada em estado — sem precisar animar o `PageController`.

---

## Arquivos a Modificar

| Arquivo | Mudança |
|---|---|
| `lib/features/presenter/views/home/home_page.dart` | Reordenar `_dashboardTitles` dinamicamente + remover Observer de re-aplicação |

Nenhuma mudança necessária em `home_store.dart`, `adaptive_interface_service.dart` ou modelos.

---

## Critérios de Aceitação

- [ ] **CA-01:** Quando ML retorna "Produção Total" com confiança > 0.5, esse dashboard aparece em primeiro ao abrir a home
- [ ] **CA-02:** O usuário consegue navegar para "Tarefas Pendentes", "Lotes em Produção" e "Top Culturas" normalmente após o carregamento
- [ ] **CA-03:** O badge "recomendado" aparece somente quando o dashboard recomendado está visível
- [ ] **CA-04:** Quando `adaptiveDashboard == null` ou confiança ≤ 0.5, a ordem original é mantida e o comportamento é idêntico ao atual
- [ ] **CA-05:** Ao navegar para outro dashboard e voltar ao app (sem reiniciar), a lista permanece estável — não há re-animação
