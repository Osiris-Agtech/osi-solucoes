# Spec: OperationalOnboardingCard no fluxo INSTANT da Home

Agent: spec-writer
Rules: AGENTS.md

## Contexto

A Home já possui o componente apresentacional `OperationalOnboardingCard` em `lib/features/presenter/views/home/components/adaptive/operational_onboarding_card.dart`, com entradas locais `title`, `message`, `steps`, `ctaLabel` e `onCtaTap`.

A primeira fase desta feature tratou o card como componente isolado e deixou a integração funcional fora do escopo. Esta spec agora adiciona uma **Fase 2** para integrar o card ao fluxo da API de adaptação **INSTANT**, seguindo o mesmo padrão dos demais componentes renderizados por resposta adaptativa.

Uma etapa posterior adiciona a **Fase 3**, em que o conteúdo de `operationalOnboarding` deixa de ser renderizado como card independente na Home e passa a ocupar o slot informativo (`HomeInfoCard`) com prioridade sobre `infoRecommendation`.

Fluxo atual identificado:

- `HomeStore.loadInstantAdaptiveInterface`
- `AdaptiveInterfaceService.getInstantAdaptiveInterface`
- `InstantAdaptiveHomeMapper.parse`
- `InstantAdaptiveHomeViewData`
- `HomeDailyPanelContent`

Estado atual relevante:

- `client_capabilities_mapper.dart` ainda não declara suporte a `OperationalOnboardingCard`.
- `instant_adaptive_home_view_data.dart` ainda não possui dado de view para `operationalOnboarding`.
- `instant_adaptive_home_mapper.dart` lê `nextStepPrediction`, `focus`, `sectionAdaptations`, `shortcuts`, `activityFeedItems` e `infoRecommendation`, mas não `operationalOnboarding`.
- `HomeDailyPanelContent` não renderiza `OperationalOnboardingCard` a partir do payload INSTANT.
- `HomeStore._getRenderedComponents` centraliza a lista de componentes efetivamente renderizados para métricas.

## Objetivos

- Permitir que a API INSTANT solicite a renderização de `OperationalOnboardingCard` na seção INSTANT da Home.
- Declarar `OperationalOnboardingCard` nas `clientCapabilities` enviadas ao serviço adaptativo.
- Mapear o campo `operationalOnboarding` da resposta INSTANT para view data local validada.
- Renderizar o card quando o payload for válido, sem acoplar o widget à API, a rotas ou a serviços.
- Navegar pelo CTA por callback externo ao widget, mantendo o padrão atual de tracking/navegação da Home.
- Incluir o componente em `renderedComponents` quando ele for efetivamente renderizado.

## Não objetivos

- Não alterar Cloud Function, backend, prompt server-side ou schema remoto nesta tarefa; a spec define o contrato esperado pelo app.
- Não criar nova infraestrutura de testes.
- Não modificar layout global da Home nem reposicionar seções não relacionadas.
- Não acoplar `OperationalOnboardingCard` à API INSTANT, a rotas, stores, serviços ou analytics.
- Não adicionar lógica de fallback total da tela por erro isolado no campo `operationalOnboarding`.
- Não criar sistema novo de analytics; se houver métricas específicas, manter simples e não bloquear a renderização.

## Fases

### Fase 1 — Componente isolado

Fase já especificada originalmente: criação do widget apresentacional puro, sem integração funcional. As restrições originais continuam válidas para o widget em si: ele recebe dados por construtor, renderiza UI e dispara apenas `onCtaTap`.

### Fase 2 — Integração INSTANT

Nova fase desta spec: integrar o componente ao fluxo adaptativo INSTANT da Home por mapper, view data, capabilities, renderização e métricas de componentes renderizados.

### Fase 3 — OperationalOnboarding como Info Card

O conteúdo de `operationalOnboarding` deve ser renderizado no mesmo slot visual usado por `HomeInfoCard`, seguindo a prioridade:

```text
info slot = operationalOnboarding ?? infoRecommendation ?? fallback
```

Regras desta fase:

- Se `operationalOnboarding` válido existir em modo INSTANT, ele deve ser convertido para `HomeInfoViewData` e renderizado como `HomeInfoCard`.
- `operationalOnboarding` tem prioridade sobre `infoRecommendation` apenas no slot informativo; os demais componentes INSTANT continuam seguindo o fluxo atual.
- Se `operationalOnboarding` estiver ausente ou inválido, o fluxo atual com `infoRecommendation` deve permanecer.
- A renderização independente de `OperationalOnboardingCard` na Home deve ser removida para evitar duplicidade.
- O CTA do info card deve usar `ctaLabel` e `targetRoute` do `operationalOnboarding`.
- O toque no card não deve criar navegação implícita para onboarding; a navegação deve ocorrer pelo CTA.
- O tracking existente de info card deve registrar o novo tipo de informação de onboarding quando renderizado.

## Contrato de resposta esperado da API

A resposta INSTANT pode incluir o campo opcional `operationalOnboarding`:

```json
{
  "operationalOnboarding": {
    "title": "Configure sua operação",
    "message": "Complete os passos para melhorar a execução diária.",
    "steps": [
      "Revise os talhões ativos",
      "Confirme os protocolos operacionais",
      "Acompanhe as próximas atividades"
    ],
    "ctaLabel": "Continuar configuração",
    "targetRoute": "/algumaRotaInterna",
    "reason": "Usuário ainda não concluiu o onboarding operacional",
    "priority": 20
  }
}
```

Campos:

- `title` — string obrigatória, não vazia.
- `message` — string obrigatória, não vazia.
- `steps` — lista obrigatória de strings não vazias, com limite definido no app para evitar payloads excessivos.
- `ctaLabel` — string obrigatória, não vazia.
- `targetRoute` — string obrigatória representando rota interna, deve começar com `/`.
- `reason` — string opcional, usada apenas como metadado se o fluxo atual já suportar esse tipo de informação.
- `priority` — número opcional, usado apenas para ordenação/priorização se o padrão atual de componentes adaptativos já suportar prioridade.

## Regras de validação

- O mapper deve aceitar ausência de `operationalOnboarding` como estado válido: nenhum card é renderizado.
- `title`, `message`, `ctaLabel` e `targetRoute` devem ser strings após trim e não podem ficar vazias.
- `steps` deve ser uma lista de strings; cada item deve ser não vazio após trim.
- `steps` deve ter limite máximo no app para proteger a UI contra payload excessivo; sugestão: renderizar no máximo 5 passos válidos.
- `targetRoute` deve representar rota interna e começar com `/`.
- Se `operationalOnboarding` existir mas for inválido, somente esse componente deve ser ignorado.
- Erro isolado em `operationalOnboarding` não deve invalidar o restante da interface INSTANT nem acionar fallback total da Home.
- Dados inválidos não devem ser passados para `OperationalOnboardingCard`.

## Abordagem técnica e decisões de design

- Manter `OperationalOnboardingCard` como widget apresentacional puro; ele não conhece API, JSON, rotas, stores nem analytics.
- Criar/adicionar view data específica para `operationalOnboarding` em `InstantAdaptiveHomeViewData`, contendo apenas dados já validados para renderização e navegação externa.
- Estender `InstantAdaptiveHomeMapper.parse` para ler `operationalOnboarding` de forma defensiva e independente dos demais componentes.
- Estender `client_capabilities_mapper.dart` para declarar suporte a `OperationalOnboardingCard`, permitindo que a API saiba que o cliente consegue renderizá-lo.
- Renderizar o card em `HomeDailyPanelContent` na seção INSTANT da Home, respeitando a estrutura visual atual e sem alterar layout global.
- O CTA deve chamar callback externo criado no nível da Home/conteúdo, que executa navegação para `targetRoute` e preserva o tracking existente do fluxo.
- Atualizar `HomeStore._getRenderedComponents` para incluir `OperationalOnboardingCard` apenas quando o view data válido existir e for renderizado.
- Métricas específicas, se necessárias, devem permanecer simples e aderentes ao padrão existente; a ausência de métrica específica não deve bloquear a entrega se `renderedComponents` estiver correto.
- Na Fase 3, `HomeInfoMapper.resolve` deve aceitar `operationalOnboarding` como entrada prioritária em modo INSTANT e mapear esse conteúdo para `HomeInfoViewData`.
- Na Fase 3, `HomeStore._getRenderedComponents` deve refletir o componente visual realmente renderizado; `OperationalOnboardingCard` não deve ser reportado se o conteúdo for exibido dentro de `HomeInfoCard`.

## Estruturas de dados e interfaces envolvidas

### Widget existente

- `OperationalOnboardingCard`
  - `title: String`
  - `message: String`
  - `steps: List<String>`
  - `ctaLabel: String`
  - `onCtaTap: VoidCallback`

### View data conceitual

Nome exato deve seguir o padrão existente do arquivo `instant_adaptive_home_view_data.dart`.

- `OperationalOnboardingViewData`
  - `title: String`
  - `message: String`
  - `steps: List<String>`
  - `ctaLabel: String`
  - `targetRoute: String`
  - `reason: String?`
  - `priority: num?` ou tipo numérico compatível com o padrão atual

### View data da Home INSTANT

- `InstantAdaptiveHomeViewData`
  - adicionar campo opcional `operationalOnboarding` com o tipo de view data definido acima.

### Capabilities

- `client_capabilities_mapper.dart`
  - incluir `OperationalOnboardingCard` na lista/estrutura de componentes suportados pelo cliente.

### Métricas de renderização

- `HomeStore._getRenderedComponents`
  - incluir identificador do componente quando `operationalOnboarding` válido estiver presente na view data renderizada.

## Arquivos-alvo previstos

- `lib/features/presenter/views/home/adaptive/client_capabilities_mapper.dart`
- `lib/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart`
- `lib/features/presenter/views/home/adaptive/instant_adaptive_home_mapper.dart`
- `lib/features/presenter/views/home/components/adaptive/operational_onboarding_card.dart` apenas como consumidor existente, sem acoplamento novo.
- Arquivo que define/renderiza `HomeDailyPanelContent`.
- Arquivo de store onde está `HomeStore._getRenderedComponents`.

## Critérios de aceitação

- **CA-01:** `clientCapabilities` declara suporte a `OperationalOnboardingCard` no fluxo INSTANT.
- **CA-02:** quando a resposta INSTANT contém `operationalOnboarding` válido, o mapper popula view data específica com `title`, `message`, `steps`, `ctaLabel`, `targetRoute`, `reason` opcional e `priority` opcional.
- **CA-03:** quando `operationalOnboarding` está ausente, inválido ou parcialmente inválido, o card não é renderizado e os demais componentes INSTANT continuam disponíveis.
- **CA-04:** `title`, `message`, `ctaLabel` e cada item de `steps` são tratados como inválidos se forem vazios após trim.
- **CA-05:** `steps` é limitado pelo app antes de chegar ao widget, evitando lista excessiva.
- **CA-06:** `targetRoute` inválido ou sem prefixo `/` impede a renderização do card.
- **CA-07:** `OperationalOnboardingCard` aparece na seção INSTANT da Home quando há view data válida.
- **CA-08:** o widget continua sem conhecer API, rotas, stores, serviços ou analytics; navegação ocorre via callback externo.
- **CA-09:** ao renderizar o card, `HomeStore._getRenderedComponents` inclui o identificador de `OperationalOnboardingCard`.
- **CA-10:** a integração não altera Cloud Function/backend, não cria infraestrutura nova de testes e não modifica layout global da Home.
- **CA-11:** análise estática/testes existentes do projeto são executados na implementação, se comandos estiverem disponíveis.
- **CA-12:** em modo INSTANT, `operationalOnboarding` válido ocupa o slot do `HomeInfoCard` antes de `infoRecommendation`.
- **CA-13:** quando `operationalOnboarding` é renderizado como info card, a Home não renderiza também `OperationalOnboardingCard` separado.
- **CA-14:** o CTA do onboarding renderizado como info card navega para `targetRoute` preservando o tracking de clique do info card.
- **CA-15:** ausência de `operationalOnboarding` mantém o comportamento atual de `infoRecommendation` e fallback.

## Tarefas resumidas

1. Atualizar `clientCapabilities` para incluir `OperationalOnboardingCard`.
2. Adicionar view data opcional para `operationalOnboarding` em `InstantAdaptiveHomeViewData`.
3. Estender `InstantAdaptiveHomeMapper.parse` com validação defensiva do contrato definido nesta spec.
4. Renderizar `OperationalOnboardingCard` em `HomeDailyPanelContent` quando houver view data válida.
5. Implementar callback externo para navegação por `targetRoute`, preservando tracking existente.
6. Atualizar `HomeStore._getRenderedComponents` para reportar o componente renderizado.
7. Validar cenários de payload válido, ausente e inválido, além de análise estática/testes existentes.
8. Mapear `operationalOnboarding` para `HomeInfoViewData` com prioridade sobre `infoRecommendation`.
9. Remover renderização independente do `OperationalOnboardingCard` na Home.
10. Atualizar métricas/listas de componentes renderizados para refletir que o visual final é `HomeInfoCard`.

## Questões em aberto

- Qual deve ser o limite final de `steps`? Recomendação inicial: 5 passos.
- Qual identificador exato deve ser enviado em `clientCapabilities` e `renderedComponents`: `OperationalOnboardingCard`, `operationalOnboardingCard` ou outro padrão já usado pelo backend?
- Quais `targetRoute` internas são permitidas para esse card? A regra mínima desta spec exige apenas prefixo `/`, mas allowlist pode ser considerada se já existir padrão no app.
- `priority` deve influenciar posição do card nesta fase ou apenas ser preservado como metadado para evolução posterior?
