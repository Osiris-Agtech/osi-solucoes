Agent: architect
Rules: AGENTS.md

# Tasks SDD — Adaptação visual dos cards da nova Home

## Contexto

Esta lista quebra a feature em tarefas atômicas e verificáveis para adaptar visualmente os cards da nova Home usando dados já recebidos do backend, sem implementar mudanças de API. A execução futura deve seguir o escopo mínimo e preservar a responsabilidade da lógica adaptativa na camada de apresentação.

## Goals

- Criar uma implementação incremental, validável por etapa.
- Evitar espalhar regra adaptativa em widgets, página ou serviços.
- Proteger `home_page.dart` de crescimento indevido.
- Manter GraphQL e Cloud Function inalterados.

## Non-goals

- Não implementar esta feature neste documento.
- Não alterar backend.
- Não criar nova infraestrutura de testes sem instrução explícita.

## Dependências gerais

- Ler os arquivos reais antes de alterar qualquer código.
- Confirmar nomes e tipos existentes de `HomePanelMapper`, `HomePanelViewData`, `HomeDailyPanelContent`, `TodayCultivationPanel`, `HomeProductionSummary`, `RecommendedActionsSection`, `HomeModulesSection`, `home_page.dart`, `home_store.dart` e `adaptive_interface_service.dart`.
- Verificar comandos existentes de lint, análise estática, teste ou build antes da validação final.

## Observação sobre arquivo grande

`home_page.dart` é arquivo grande e não deve crescer. Se a implementação exigir tocar nele, limitar a mudança à passagem mínima de dados já existente. Nenhuma regra de adaptação visual deve ser adicionada nele.

## Tarefas atômicas

### T01 — Mapear estrutura atual da Home

- Dependências: nenhuma.
- Pode rodar em paralelo: sim, com T02 e T03.
- Arquivos-alvo: leitura de arquivos da Home, principalmente `HomeDailyPanelContent` e componentes filhos.
- Ação: identificar como `HomePanelViewData` é consumido e quais campos já chegam aos componentes.
- Validação: registrar lista de componentes tocáveis e confirmar onde cada dado necessário já existe.

### T02 — Mapear `HomePanelMapper` e `HomePanelViewData`

- Dependências: nenhuma.
- Pode rodar em paralelo: sim, com T01 e T03.
- Arquivos-alvo: arquivos que definem `HomePanelMapper` e `HomePanelViewData`.
- Ação: identificar pontos de extensão para foco visual, nível de adaptação e destaques derivados.
- Validação: confirmar que a lógica adaptativa pode ser centralizada sem alterar serviços ou store.

### T03 — Confirmar contratos locais dos dados carregados

- Dependências: nenhuma.
- Pode rodar em paralelo: sim, com T01 e T02.
- Arquivos-alvo: modelos locais de `homeDashboard`, estado da Home e resposta adaptativa.
- Ação: verificar nomes reais e nulabilidade de campos de resumo, tarefas, produção, culturas, equipe e alertas críticos.
- Validação: checklist dos campos disponíveis para cada foco sem exigir API nova.

### T04 — Definir normalização de foco visual

- Dependências: T02, T03.
- Pode rodar em paralelo: não.
- Arquivos-alvo: `HomePanelMapper` e/ou módulo coeso existente da camada de apresentação.
- Ação: modelar foco interno para `default`, `tasks`, `cultivation`, `production` e `health`, mapeando valores reais de `adaptiveCardType`.
- Validação: casos de tipo conhecido, nulo, vazio e desconhecido geram foco esperado.

### T05 — Definir avaliação de intensidade adaptativa

- Dependências: T02, T03.
- Pode rodar em paralelo: sim, com T04 se os contratos já estiverem confirmados.
- Arquivos-alvo: `HomePanelMapper` e `HomePanelViewData`.
- Ação: representar aplicação `none`, `soft` ou `strong` com base em `dashboardConfidence` e `dashboardSource`.
- Validação: baixa confiança e source não adaptativo caem em fallback conservador.

### T06 — Normalizar `cardOrder` como prioridade visual

- Dependências: T04.
- Pode rodar em paralelo: sim, com T07 a T10 após definição do foco.
- Arquivos-alvo: `HomePanelMapper` e `HomePanelViewData`.
- Ação: transformar `cardOrder` em lista limpa de prioridades, ignorando duplicatas e itens desconhecidos.
- Validação: `cardOrder` vazio, duplicado ou inconsistente não quebra a Home.

### T07 — Preparar view data para foco em tarefas

- Dependências: T04, T05.
- Pode rodar em paralelo: sim, com T08, T09 e T10.
- Arquivos-alvo: `HomePanelMapper`, `HomePanelViewData` e, se necessário, componentes que exibem tarefas/agenda.
- Ação: derivar destaque de tarefas com `pendentesHoje`, `atrasadas`, `pendentesSemana`, `porVencimento`, `porPrioridade` e `ultimasTarefas`.
- Validação: com foco em tarefas e dados disponíveis, o destaque principal representa pendências/agenda; sem dados, aplica fallback.

### T08 — Preparar view data para foco em lotes/cultivo

- Dependências: T04, T05.
- Pode rodar em paralelo: sim, com T07, T09 e T10.
- Arquivos-alvo: `HomePanelMapper`, `HomePanelViewData`, `TodayCultivationPanel` se necessário.
- Ação: derivar destaque de cultivo com `lotesAtivos`, `lotesFinalizados`, `taxaConclusao`, `lotesPorStatus`, `lotesComColheitaProxima`, culturas e espécies em andamento quando deriváveis.
- Validação: com foco em lotes e dados disponíveis, o destaque prioriza cultivo/lotes; sem dados, aplica fallback.

### T09 — Preparar view data para foco em produção

- Dependências: T04, T05.
- Pode rodar em paralelo: sim, com T07, T08 e T10.
- Arquivos-alvo: `HomePanelMapper`, `HomePanelViewData`, `HomeProductionSummary` se necessário.
- Ação: derivar destaque de produção com totais, produção mensal, taxas médias, comparativo de período e cultura com maior produção.
- Validação: com foco em produção e dados disponíveis, o destaque prioriza métricas produtivas; sem dados, aplica fallback.

### T10 — Preparar view data para foco em saúde/risco

- Dependências: T04, T05.
- Pode rodar em paralelo: sim, com T07, T08 e T09.
- Arquivos-alvo: `HomePanelMapper`, `HomePanelViewData` e componentes que exibam alerta/risco se existirem.
- Ação: derivar destaque de saúde com `alertasCritico`, `equipe.atividadesVencidas`, `equipe.taxaConclusaoMedia`, `equipe.atividadesNoPrazo`, `producao.taxasMedia` e `tarefas.atrasadas`.
- Validação: com foco em saúde e dados disponíveis, alertas e atrasos têm prioridade; sem dados, aplica fallback.

### T11 — Ajustar componentes para consumir view data pronta

- Dependências: T07, T08, T09, T10.
- Pode rodar em paralelo: não.
- Arquivos-alvo: `HomeDailyPanelContent`, `TodayCultivationPanel`, `HomeProductionSummary`, se necessário `RecommendedActionsSection` e `HomeModulesSection`.
- Ação: passar e renderizar os campos preparados, sem interpretar `adaptiveCardType` cru nos widgets.
- Validação: componentes continuam renderizando com dados padrão e exibem destaques quando a view data indica foco.

### T12 — Preservar shortcuts adaptativos existentes

- Dependências: T11.
- Pode rodar em paralelo: não.
- Arquivos-alvo: `RecommendedActionsSection` e passagem atual de `recommendedShortcuts`.
- Ação: garantir que a mudança de foco visual não remova nem duplique a lógica atual de shortcuts.
- Validação: shortcuts adaptativos continuam aparecendo como antes.

### T13 — Revisar acoplamento e tamanho de arquivos

- Dependências: T11, T12.
- Pode rodar em paralelo: não.
- Arquivos-alvo: todos os arquivos alterados.
- Ação: confirmar que regras adaptativas ficaram no mapper/view data e que `home_page.dart`, `home_store.dart` e `adaptive_interface_service.dart` não receberam lógica visual.
- Validação: diff mostra responsabilidade concentrada e sem crescimento indevido de arquivo grande.

### T14 — Validar comportamento por cenários

- Dependências: T13.
- Pode rodar em paralelo: não.
- Arquivos-alvo: testes existentes se houver, ou validação manual/estática documentada.
- Ação: validar cenários de foco `tarefas`, `lotes`, `producao`, `saude`, tipo desconhecido, baixa confiança, source não adaptativo e dados ausentes.
- Validação: cada critério de aceite do `spec.md` tem evidência de verificação.

### T15 — Rodar validações automatizadas existentes

- Dependências: T14.
- Pode rodar em paralelo: não.
- Arquivos-alvo: comandos do projeto.
- Ação: executar comandos existentes de lint/análise estática/test/build identificáveis no repositório.
- Validação: comandos passam ou falhas são registradas com causa e escopo.

## Plano de paralelização

- Paralelo inicial: T01, T02 e T03.
- Após contratos confirmados: T04 e T05 podem avançar com coordenação.
- Após foco/intensidade definidos: T07, T08, T09 e T10 podem ser implementadas em paralelo se os arquivos-alvo não conflitarem.
- Sequenciais obrigatórias: T11, T12, T13, T14 e T15.

## Acceptance criteria

- Cada tarefa tem dependência, alvo e validação explícitos.
- As tarefas evitam mudança em API e backend.
- A lógica adaptativa fica planejada para mapper/view data.
- `home_page.dart` é tratado como arquivo grande e protegido contra crescimento de responsabilidade.

## Open questions que precisam de clarificação

1. Quais comandos oficiais do projeto devem ser usados para validação final em Flutter/Dart?
2. Existem testes de widget ou golden tests já aceitos para a Home?
3. O threshold de confiança será definido pelo produto ou inferido temporariamente pela implementação?
