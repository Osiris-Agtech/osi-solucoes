# Especificação SDD — Adaptação visual dos cards da nova Home

## Contexto

A nova Home do app Flutter/Dart renderiza `HomeDailyPanelContent` em ordem fixa: `header`, `TodayCultivationPanel`, `HomeProductionSummary`, `RecommendedActionsSection` e `HomeModulesSection`. Ao mesmo tempo, a aplicação já carrega recomendações adaptativas por meio de `HomeStore.loadAdaptiveInterface()`, incluindo `adaptiveCardType`, `adaptiveDashboard`, `dashboardConfidence`, `dashboardSource`, `recommendedShortcuts` e `cardOrder`.

Hoje, `RecommendedActionsSection` já usa atalhos adaptativos, mas os cards principais da Home ainda não refletem de forma suficiente a recomendação adaptativa. `HomePanelMapper.map()` já recebe `adaptiveCardType` e `cardOrder`, porém usa esses sinais quase apenas para `hasDashboardSupport`.

Esta feature existe para adaptar visualmente o destaque e a prioridade dos cards da nova Home usando dados que já chegam do backend, sem alterar API, Cloud Function ou GraphQL nesta etapa.

## Problema

Os dados adaptativos já existem, mas a Home não transforma `adaptiveCardType` e `cardOrder` em uma experiência visual realmente personalizada. O usuário recebe a mesma hierarquia principal de cards, mesmo quando o backend recomenda foco em tarefas, lotes/cultivo, produção ou saúde/risco.

## Objetivo

Usar a recomendação adaptativa como sinal de foco de interface, mantendo `homeDashboard` como fonte dos dados reais dos cards. A recomendação deve decidir qual recorte desses dados aparece primeiro, recebe mais destaque ou ganha tratamento visual prioritário.

## Fora de escopo

- Alterar a API GraphQL `homeDashboard`.
- Alterar a Cloud Function `getAdaptiveInterface`.
- Alterar contratos de backend, nomes de campos ou schemas.
- Reintroduzir ou depender de carousel legado.
- Mover lógica adaptativa para `home_page.dart`, `home_store.dart` ou `adaptive_interface_service.dart`.
- Criar nova infraestrutura de testes, analytics, logs ou telemetria sem pedido explícito.
- Reescrever a Home completa ou trocar a ordem estrutural fixa do `HomeDailyPanelContent` sem necessidade mínima.

## Dados disponíveis

### Dados reais da Home — GraphQL `homeDashboard`

- `resumo`
  - `lotesAtivos`
  - `lotesFinalizados`
  - `taxaConclusao`
  - `lotesPorStatus`
  - `lotesComColheitaProxima`
- `tarefas`
  - `pendentesHoje`
  - `atrasadas`
  - `pendentesSemana`
  - `porVencimento`
  - `porPrioridade`
  - `ultimasTarefas`
- `producao`
  - `totalPlantasColhidas`
  - `totalEmbalagensProduzidas`
  - `producaoMensal`
  - `taxasMedia`
  - `comparativoPeriodo`
  - `culturaMaisProducao`
- `culturas`
- `equipe`
  - `atividadesVencidas`
  - `taxaConclusaoMedia`
  - `atividadesNoPrazo`
- `alertasCritico`

### Recomendação adaptativa — Cloud Function `getAdaptiveInterface`

- `dashboard`
- `dashboardId`
- `cardType`
- `confidence`
- `dashboardSource`
- `shortcuts`
- `mode`

### Estado carregado na apresentação

- `adaptiveCardType`
- `adaptiveDashboard`
- `dashboardConfidence`
- `dashboardSource`
- `recommendedShortcuts`
- `cardOrder`

## Requisitos funcionais

### RF-001 — Foco visual por recomendação adaptativa

Quando `adaptiveCardType` indicar um foco conhecido, a Home deve destacar o recorte correspondente de `homeDashboard`, sem buscar novos dados e sem alterar contratos de backend.

### RF-002 — Uso de `cardOrder` como sinal de interface

Quando `cardOrder` estiver disponível e confiável, a camada de apresentação deve usá-lo como orientação de prioridade visual dos cards/recortes, sem tratar o valor como contrato de carousel legado.

### RF-003 — Fonte única dos dados reais dos cards

Os cards devem continuar usando `homeDashboard` como fonte dos dados exibidos. A recomendação adaptativa só decide foco, ordem relativa, destaque e seleção de recortes.

### RF-004 — Foco em tarefas

Para foco `tarefas`, a Home deve priorizar tarefas e agenda usando, conforme disponibilidade, `tarefas.pendentesHoje`, `tarefas.atrasadas`, `tarefas.pendentesSemana`, `tarefas.porVencimento`, `tarefas.porPrioridade` e `tarefas.ultimasTarefas`.

### RF-005 — Foco em lotes/cultivo

Para foco `lotes`, a Home deve priorizar lotes e cultivo usando, conforme disponibilidade, `resumo.lotesAtivos`, `resumo.lotesFinalizados`, `resumo.taxaConclusao`, `resumo.lotesPorStatus`, `resumo.lotesComColheitaProxima`, `culturas` e espécies/culturas em andamento quando representadas nos dados existentes.

### RF-006 — Foco em produção

Para foco `producao`, a Home deve priorizar produção usando, conforme disponibilidade, `producao.totalPlantasColhidas`, `producao.totalEmbalagensProduzidas`, `producao.producaoMensal`, `producao.taxasMedia`, `producao.comparativoPeriodo` e `producao.culturaMaisProducao`.

### RF-007 — Foco em saúde/risco

Para foco `saude`, a Home deve priorizar atenção e risco usando, conforme disponibilidade, `alertasCritico`, `equipe.atividadesVencidas`, `equipe.taxaConclusaoMedia`, `equipe.atividadesNoPrazo`, `producao.taxasMedia` e `tarefas.atrasadas`.

### RF-008 — Fallback seguro para baixa confiança

Quando `dashboardConfidence` for baixo, ausente ou inválido, a Home deve manter comportamento visual conservador, próximo ao layout atual, evitando destaque excessivo de uma recomendação incerta.

### RF-009 — Fallback para origem não adaptativa

Quando `dashboardSource` não indicar origem adaptativa, a Home deve tratar a recomendação como sugestão fraca e preservar hierarquia padrão, salvo dados críticos que já sejam relevantes pela própria Home.

### RF-010 — Fallback para `cardType` desconhecido

Quando `adaptiveCardType` for desconhecido, nulo ou não mapeado, a Home deve ignorar o foco específico e manter o layout padrão sem erro visual.

### RF-011 — Fallback para dados ausentes

Quando o foco recomendado não tiver dados suficientes em `homeDashboard`, a Home deve escolher o próximo recorte disponível ou voltar ao destaque padrão, sem exibir cards vazios ou métricas enganosas.

### RF-012 — Lógica na camada de apresentação

A transformação dos dados adaptativos em view data deve ficar preferencialmente em `HomePanelMapper` e `HomePanelViewData`. Componentes visuais devem receber dados prontos e evitar calcular regra adaptativa.

## Requisitos não funcionais

### RNF-001 — Sem mudança de contrato externo

A feature não deve exigir alteração em GraphQL, Cloud Function, DTOs externos ou resposta do backend.

### RNF-002 — Baixo acoplamento

`home_page.dart`, `home_store.dart` e `adaptive_interface_service.dart` não devem receber nova lógica de decisão visual. Se precisarem ser tocados, o escopo deve ser limitado a passagem mínima de dados já existentes.

### RNF-003 — Componentes simples

Componentes da Home devem consumir view data pronta, com responsabilidade visual clara e pouca regra de negócio.

### RNF-004 — Compatibilidade com dados parciais

A Home deve permanecer estável com respostas parciais, listas vazias e campos nulos já possíveis na boundary atual.

### RNF-005 — Clareza visual

A adaptação deve melhorar hierarquia e relevância percebida sem ocultar informações essenciais da Home.

## Critérios de aceite

- CA-001: Com `adaptiveCardType = tarefas` e dados de tarefas disponíveis, o primeiro destaque relevante da Home prioriza tarefas/agenda.
- CA-002: Com `adaptiveCardType = lotes` e dados de cultivo disponíveis, o destaque visual prioriza lotes/cultivo.
- CA-003: Com `adaptiveCardType = producao` e dados de produção disponíveis, o destaque visual prioriza métricas e evolução de produção.
- CA-004: Com `adaptiveCardType = saude` e dados de risco disponíveis, o destaque visual prioriza alertas, atraso e saúde operacional.
- CA-005: Com `adaptiveCardType` desconhecido, a Home renderiza sem erro e mantém hierarquia padrão.
- CA-006: Com baixa confiança ou `dashboardSource` não adaptativo, a Home não aplica destaque agressivo e preserva experiência conservadora.
- CA-007: Com dados ausentes para o foco recomendado, nenhum card vazio ou métrica falsa é exibido; há fallback para dados disponíveis ou padrão.
- CA-008: Não há mudança em API GraphQL, Cloud Function ou contrato externo.
- CA-009: A lógica adaptativa fica concentrada em mapper/view data, não nos widgets de página ou serviços.
- CA-010: `RecommendedActionsSection` continua recebendo e exibindo atalhos adaptativos como já ocorre.

## Edge cases

- `adaptiveCardType` nulo, vazio, com casing inesperado ou valor legado.
- `cardOrder` vazio, duplicado, com itens desconhecidos ou inconsistente com `adaptiveCardType`.
- `dashboardConfidence` ausente, fora de faixa esperada ou serializado em tipo inesperado já normalizado pelo estado atual.
- `dashboardSource` ausente ou diferente de fonte adaptativa.
- `homeDashboard` carrega parcialmente enquanto a recomendação adaptativa já está disponível.
- Recomendação aponta para produção, mas `producao` está vazio.
- Recomendação aponta para tarefas, mas não há pendências hoje nem atrasadas.
- Alertas críticos existem mesmo quando foco recomendado é outro; risco crítico não deve ficar invisível.
- Dados numéricos zerados devem ser diferenciados de dados ausentes quando a modelagem atual permitir.

## Open questions que precisam de clarificação

1. Qual limiar exato define `dashboardConfidence` baixa, média e alta no produto?
2. Quais valores canônicos de `adaptiveCardType` podem chegar hoje além de `tarefas`, `lotes`, `producao` e `saude`?
3. `dashboardSource` tem enum documentado para distinguir recomendação adaptativa de fallback/default?
4. A adaptação deve apenas destacar visualmente dentro da ordem estrutural atual ou pode reordenar seções internas dos componentes?
5. Alertas críticos devem sempre sobrepor o foco adaptativo quando existirem?
