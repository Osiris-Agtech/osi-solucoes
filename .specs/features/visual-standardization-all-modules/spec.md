# Padronização Visual de Todos os Módulos

**Spec**: `.specs/features/visual-standardization-all-modules/spec.md`
**Status**: Draft
**Agent**: architect (tlc-spec-driven)

---

## Problem Statement

O app possui uma camada de componentes compartilhados modernos (`AppPageHeaderSliver`, `AppSearchBar`, `AppStatePanel`, `AppEntityCard`, `AppBadge`, `AppIconTile`, `AppPanelCard`) em `lib/features/presenter/widgets/common/`, mas a adoção é inconsistente entre os módulos. O módulo Protocolo e Gerenciar Equipe já usam a maior parte dos componentes compartilhados e servem como referência visual. Outros módulos (Histórico, Área de Cultivo, Agenda, Caderno de Campo, Solução, Relatórios, Ajustes, Reservatórios) misturam estilos locais, `CircularProgressIndicator` solto, `Text` de estado vazio, headers manuais e cards com estilos divergentes. Essa inconsistência prejudica a experiência do usuário, que percebe o app como "coleção de telas" em vez de "produto coeso".

## Goals

- [ ] Todos os módulos operacionais (10 módulos) usarem os componentes compartilhados disponíveis para header, search, estados (loading/empty/searchEmpty) e cards de listagem
- [ ] Eliminar `CircularProgressIndicator` solto como única resposta de loading em listagens
- [ ] Eliminar `Text` solto como estado vazio em listagens
- [ ] Eliminar headers manuais que duplicam `AppPageHeaderSliver`
- [ ] Manter regras de negócio, stores, rotas e serviços intactos — mudança exclusivamente visual
- [ ] Seguir a estratégia de adoção por grupos definida em `.specs/shared-components-adoption-by-ui-groups.md`

## Out of Scope

| Item | Razão |
|------|-------|
| Formulários de cadastro/edição em profundidade | Escopo muito grande; apenas headers e padrões de listagem serão padronizados |
| Criação de novos componentes compartilhados | Os 10 existentes são suficientes; só criar se houver necessidade real |
| Refatoração de stores, serviços ou regras de negócio | Violaria a boundary definida |
| Alteração de rotas, contratos de API ou schemas | Fora de escopo |
| Implementação de testes | Sem pedido explícito |
| Home, Login, Cadastro, MultiAccounts, Recuperar Senha, Onboarding | Já padronizados ou em fluxo separado |
| Adaptive Admin / Metrics Dashboard | Módulo administrativo com padrão próprio |

---

## User Stories

### P1: Header Padronizado em Todos os Módulos ⭐ MVP

**User Story**: Como usuário, quero que todas as telas de listagem usem o mesmo header (AppPageHeaderSliver) com título, subtítulo, botão voltar e search quando aplicável, para que a navegação seja previsível.

**Why P1**: Header é o primeiro elemento visual que o usuário vê em cada tela.

**Acceptance Criteria**:

1. VS-HEADER-01: WHEN a tela de listagem de um módulo é aberta THEN o header SHALL usar `AppPageHeaderSliver` com título e subtítulo consistentes
2. VS-HEADER-02: WHEN a tela tem funcionalidade de busca THEN o `AppSearchBar` SHALL estar integrado via `bottom` do `AppPageHeaderSliver`
3. VS-HEADER-03: WHEN o usuário toca no botão voltar THEN a navegação SHALL preservar o comportamento existente (Get.back() ou rota específica)

**Independent Test**: Abrir cada módulo e verificar visualmente o header — todos devem ter a mesma estrutura com fundo branco, título em negrito 22px e subtítulo em cinza 14px.

---

### P1: Estados Padronizados (Loading/Empty/SearchEmpty) ⭐ MVP

**User Story**: Como usuário, quero que os estados de carregamento, lista vazia e busca sem resultado tenham a mesma aparência em todos os módulos, usando `AppStatePanel`.

**Why P1**: Estados são cruciais para feedback e consistência.

**Acceptance Criteria**:

1. VS-STATE-01: WHEN a lista está carregando THEN a tela SHALL exibir `AppStatePanel` com `stateKind: AppStateKind.loading`
2. VS-STATE-02: WHEN a lista está vazia (sem dados) THEN a tela SHALL exibir `AppStatePanel` com `stateKind: AppStateKind.empty`
3. VS-STATE-03: WHEN a busca não retorna resultados THEN a tela SHALL exibir `AppStatePanel` com `stateKind: AppStateKind.searchEmpty`
4. VS-STATE-04: WHEN ocorre um erro no carregamento THEN a tela SHALL exibir `AppStatePanel` com `stateKind: AppStateKind.error` (quando o store expuser o estado de erro)

**Independent Test**: Simular cada estado em cada módulo e verificar visualmente a consistência.

---

### P1: Cards de Listagem Padronizados ⭐ MVP

**User Story**: Como usuário, quero que os itens de listagem em todos os módulos usem o mesmo card visual (`AppEntityCard`) com título, subtítulo, badges e metadados consistentes.

**Why P1**: Cards de listagem são o padrão visual mais repetido no app.

**Acceptance Criteria**:

1. VS-CARD-01: WHEN um item de listagem é exibido THEN o card SHALL usar `AppEntityCard` com padding, raio, sombra e tipografia padronizados
2. VS-CARD-02: WHEN o item tem status THEN o badge SHALL usar `AppBadge` com o `AppBadgeTone` correspondente
3. VS-CARD-03: WHEN o item é tocável THEN o card SHALL ter `onTap` e exibir `chevron_right` como indicador de navegação

**Independent Test**: Comparar visualmente cards de Protocolo (referência) com cards dos módulos migrados.

---

### P2: Cores Semânticas e Tokens

**User Story**: Como desenvolvedor, quero que todas as cores nos componentes compartilhados usem os tokens do `Constants` em vez de valores hardcoded, para facilitar manutenção e theming futuro.

**Acceptance Criteria**:

1. VS-TOKEN-01: WHEN um módulo usa cores de badge/status THEN SHALL usar `AppBadge` com `AppBadgeTone` em vez de `Color()` hardcoded
2. VS-TOKEN-02: WHEN um módulo define background THEN SHALL usar `Constants.kSecondBackgroundColor` em vez de cores literais

---

### P2: Background Consistente

**User Story**: Como usuário, quero que todas as telas de listagem tenham o mesmo fundo neutro.

**Acceptance Criteria**:

1. VS-BG-01: WHEN uma tela de listagem é exibida THEN o `Scaffold.backgroundColor` SHALL ser `Constants.kSecondBackgroundColor`

---

## Grupos de Adoção (por prioridade de implementação)

Seguindo a estratégia de `.specs/shared-components-adoption-by-ui-groups.md`:

### Grupo 1 — Módulos com maior gap visual (P1)
| Módulo | Problemas a corrigir |
|--------|----------------------|
| Histórico | Header, loading, empty, cards, badges — tudo local |
| Área de Cultivo | Loading, cards, sem search |
| Reservatórios (completar) | Card item local |

### Grupo 2 — Módulos com gap médio (P1)
| Módulo | Problemas a corrigir |
|--------|----------------------|
| Caderno de Campo | Card lote local |
| Agenda | Empty state, cards, background |
| Solução | Header local |

### Grupo 3 — Ajustes finos (P2)
| Módulo | Problemas a corrigir |
|--------|----------------------|
| Relatórios | Header local, cores hardcoded |
| Ajustes | Header já ok, formulário é especial |

---

## Edge Cases

- VS-EDGE-01: WHEN um módulo já usa parcialmente `AppStatePanel` mas com `SliverList` em vez de `SliverToBoxAdapter` THEN a migração SHALL unificar para `SliverToBoxAdapter`
- VS-EDGE-02: WHEN `CardLote` em CadernoCampoPage tem 165 linhas THEN a migração SHALL extrair subcomponentes locais ANTES de substituir por `AppEntityCard`, para não aumentar acoplamento
- VS-EDGE-03: WHEN um módulo usa `AppPageHeaderSliver` mas com parâmetros diferentes (ex: `expandedHeight`) THEN a migração SHALL padronizar para `expandedHeight: 180` (padrão da referência)
- VS-EDGE-04: WHEN existe `_searchController` local duplicando funcionalidade do `AppSearchBar.onChanged` THEN a migração SHALL manter o comportamento funcional existente

---

## Requirement Traceability

| ID | Story | Description | Phase | Status |
|----|-------|-------------|-------|--------|
| VS-HEADER-01 | P1: Header | AppPageHeaderSliver com título/subtítulo | Design | Pending |
| VS-HEADER-02 | P1: Header | AppSearchBar integrado via bottom | Design | Pending |
| VS-HEADER-03 | P1: Header | Botão voltar preserva navegação | Design | Pending |
| VS-STATE-01 | P1: Estados | Loading com AppStatePanel | Design | Pending |
| VS-STATE-02 | P1: Estados | Empty com AppStatePanel | Design | Pending |
| VS-STATE-03 | P1: Estados | SearchEmpty com AppStatePanel | Design | Pending |
| VS-STATE-04 | P1: Estados | Error com AppStatePanel | Design | Pending |
| VS-CARD-01 | P1: Cards | AppEntityCard padronizado | Design | Pending |
| VS-CARD-02 | P1: Cards | AppBadge com AppBadgeTone | Design | Pending |
| VS-CARD-03 | P1: Cards | onTap com chevron_right | Design | Pending |
| VS-TOKEN-01 | P2: Cores | Cores hardcoded → tokens Constants | Design | Pending |
| VS-TOKEN-02 | P2: Cores | Background → kSecondBackgroundColor | Design | Pending |
| VS-BG-01 | P2: Background | scaffoldBackgroundColor consistente | Design | Pending |
| VS-EDGE-01 | Edge | SliverList vs SliverToBoxAdapter | Design | Pending |
| VS-EDGE-02 | Edge | CardLote decomposição prévia | Design | Pending |
| VS-EDGE-03 | Edge | expandedHeight padronizado | Design | Pending |
| VS-EDGE-04 | Edge | _searchController local mantido | Design | Pending |

**Coverage**: 17 total, 0 mapped to tasks, 17 unmapped ⚠️

---

## Success Criteria

- [ ] Todos os 10 módulos operacionais usam `AppPageHeaderSliver` para o header
- [ ] Nenhum módulo de listagem usa `CircularProgressIndicator` solto como único estado de loading
- [ ] Nenhum módulo de listagem usa `Text` solto como estado vazio
- [ ] Módulos com busca usam `AppSearchBar`
- [ ] Módulos com cards de listagem usam `AppEntityCard` com `AppBadge`
- [ ] Todas as cores de badge usam `AppBadgeTone` em vez de valores literais
- [ ] Regras de negócio, stores, rotas e serviços permanecem inalterados
- [ ] Análise de diff confirma que mudanças são exclusivamente visuais/presenter
