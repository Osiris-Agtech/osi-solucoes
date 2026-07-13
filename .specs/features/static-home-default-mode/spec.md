# Spec: Modo STATIC da Home como default determinístico

Agent: spec-writer
Rules: AGENTS.md

## Contexto

A Home possui modos adaptativos (`STATIC`, `GRADUAL`, `INSTANT`) usados para controlar recomendações de atalhos, dashboard e métricas de sessão.

Na exploração atual, o modo `STATIC` ainda entra no fluxo de `HomeStore.loadAdaptiveInterface()`, chama `AdaptiveInterfaceService.getAdaptiveInterface()`, consome `recommendedShortcuts` da resposta da Cloud Function/ML e pode propagar `adaptiveSource`, `adaptiveReason`, confiança, textos/badges ou outros indícios adaptativos para a UI. O `HomePanelMapper` bloqueia apenas o highlight visual de dashboard quando o modo resolvido é `STATIC`, mas isso não impede que recomendações adaptativas cheguem ao estado da Home.

Como `STATIC` representa grupo controle/default, ele deve ser realmente determinístico: sem chamada adaptativa, sem consumo de recomendações remotas e sem estado adaptativo aplicado. A lista canônica de atalhos padrão deve ser a retornada por `HomeStore._getDefaultShortcuts()`.

## Objetivos

- Fazer o modo `STATIC` da Home renderizar atalhos e estado adaptativo de forma determinística.
- Impedir que `STATIC` chame/consuma a Cloud Function/ML de interface adaptativa.
- Garantir que `STATIC` use sempre a lista padrão canônica de `HomeStore._getDefaultShortcuts()`.
- Sanear o estado adaptativo no store para evitar badges, textos, dashboard/card adaptativos e motivos vindos de respostas anteriores.
- Manter o comportamento atual quando não houver configuração adaptativa do usuário.
- Manter `trackSessionStart` registrando sessões `STATIC`.
- Evitar alterações em componentes de UI se o estado já vier saneado do store.

## Não objetivos

- Não alterar contrato, payload ou implementação da Cloud Function/ML.
- Não alterar schemas de Firestore, modelos remotos ou configuração adaptativa do usuário.
- Não transformar ausência de configuração adaptativa em modo `STATIC`.
- Não redesenhar a Home nem alterar componentes visuais sem necessidade.
- Não alterar o fluxo `INSTANT`, inclusive chamada com contexto operacional.
- Não alterar a lógica adaptativa `GRADUAL`, exceto para preservar o bypass explícito de `STATIC`.
- Não criar nova infraestrutura de teste.

## Requisitos funcionais

- **RF-01:** Quando `fetchUserAdaptiveConfig()` retornar `mode == 'STATIC'`, a Home deve tratar a sessão como `STATIC` antes de qualquer chamada adaptativa não-INSTANT.
- **RF-02:** Em modo `STATIC`, `HomeStore.loadAdaptiveInterface()` não deve chamar `AdaptiveInterfaceService.getAdaptiveInterface()`.
- **RF-03:** Em modo `STATIC`, `HomeStore.recommendedShortcuts` deve receber exatamente a lista retornada por `HomeStore._getDefaultShortcuts()`.
- **RF-04:** Em modo `STATIC`, o estado adaptativo residual deve ser limpo: `adaptiveDashboard`, `adaptiveCardType` e `adaptiveReason` nulos; `dashboardConfidence = 0.0`; `adaptiveSource`, `adaptiveDashboardSource` e `adaptiveVisualPriority` em valores não adaptativos compatíveis com o padrão atual.
- **RF-05:** Em modo `STATIC`, `instantViewData` deve permanecer nulo e estados de erro/loading INSTANT não devem produzir UI adaptativa.
- **RF-06:** Em modo `STATIC`, `HomeStore.hasAdaptiveDashboardRecommendation` deve resultar falso.
- **RF-07:** Em modo `STATIC`, `_applyAdaptiveDashboard()` não deve aplicar dashboard/card adaptativo; se o store estiver saneado, isso deve ocorrer naturalmente sem regra extra na UI.
- **RF-08:** Ausência de configuração adaptativa (`fetchUserAdaptiveConfig() == null`) deve manter o comportamento atual, sem passar a ser interpretada como `STATIC` determinístico.
- **RF-09:** `MetricsTrackingService.trackSessionStart()` deve continuar sendo chamado após o carregamento da Home e deve registrar `mode: 'STATIC'` quando a configuração ativa for `STATIC`.
- **RF-10:** Em modo `STATIC`, métricas de exposição/aplicação adaptativa não devem ser registradas como consequência de `loadAdaptiveInterface()`, porque não deve haver chamada adaptativa nem recomendação aplicada.

## Requisitos não funcionais

- **RNF-01:** A solução deve ter escopo mínimo e concentrar a regra no `HomeStore`.
- **RNF-02:** `HomePage` só deve ser alterada se necessário para impedir aplicação de dashboard adaptativo em `STATIC` ou para passar o modo de forma explícita ao store.
- **RNF-03:** Componentes de UI não devem ser alterados se o estado do store já impedir exposição adaptativa.
- **RNF-04:** A mudança não deve introduzir dependências novas.
- **RNF-05:** A implementação deve seguir os padrões Dart/Flutter existentes do projeto e preservar geração MobX já estabelecida.

## Abordagem técnica e decisões de design

### Diagnóstico técnico

Arquivos relevantes lidos:

- `lib/features/presenter/viewmodels/home_store.dart`
- `lib/features/presenter/views/home/home_page.dart`
- `lib/features/presenter/views/home/models/home_panel_mapper.dart`

Fluxo atual observado:

1. `HomePage.initState()` carrega dashboard base com `store.carregarHome()`.
2. `HomePage` lê `fetchUserAdaptiveConfig()`.
3. Apenas `INSTANT` com `sessionId` válido desvia para `loadInstantAdaptiveInterface()`.
4. Demais casos, incluindo `STATIC`, chamam `store.loadAdaptiveInterface()`.
5. `loadAdaptiveInterface()` busca novamente a config, chama `getAdaptiveInterface(mode, sessionId)` e aplica a resposta no store.
6. `HomePanelMapper` bloqueia highlight visual para `STATIC`, mas ainda recebe `recommendedShortcuts` e metadados adaptativos já aplicados ao estado.

### Design proposto

- Implementar bypass explícito no `HomeStore.loadAdaptiveInterface()` quando a configuração carregada indicar `mode == 'STATIC'`.
- O bypass deve ocorrer depois de ler `fetchUserAdaptiveConfig()` e antes de chamar `_adaptiveService.getAdaptiveInterface()`.
- No bypass, o store deve:
  - definir `adaptiveMode = 'STATIC'`;
  - preservar/atribuir `currentSessionId` se a configuração trouxer `sessionId`, para fins de métricas de sessão;
  - atribuir `recommendedShortcuts = _getDefaultShortcuts()`;
  - limpar campos adaptativos (`adaptiveDashboard`, `adaptiveCardType`, `adaptiveReason`, confiança, source/priority);
  - limpar dados INSTANT (`instantViewData`, `hasInstantError`, `isLoadingInstantAdaptation`);
  - inicializar `cardOrder` com a ordem estrutural padrão;
  - finalizar `hasResolvedAdaptiveInterface = true` e `isLoadingShortcuts = false` pelo fluxo normal/finally.
- Não usar fallback da Cloud Function ou defaults de `AdaptiveInterfaceService` como fonte canônica para `STATIC`; a fonte canônica é `HomeStore._getDefaultShortcuts()`.
- Não tratar `mode == null` como `STATIC`; nesses casos, manter chamada atual a `getAdaptiveInterface()` para preservar comportamento existente.
- `HomePage` deve permanecer sem regra visual extra sempre que possível. Alteração mínima é aceitável apenas se a implementação no store não for suficiente para impedir aplicação de dashboard/card adaptativo em `STATIC`.

### Decisão registrada

Foi registrada decisão em `.specs/decisions/static-home-store-bypass.md` para documentar a escolha por bypass explícito no `HomeStore`, em vez de bloquear apenas no mapper/UI ou depender de fallback remoto.

## Estruturas de dados e interfaces envolvidas

Não há novas estruturas de dados obrigatórias.

Estados e interfaces existentes envolvidos:

- `HomeStore.fetchUserAdaptiveConfig(): Future<Map<String, dynamic>?>`
- `HomeStore.loadAdaptiveInterface(): Future<void>`
- `HomeStore.recommendedShortcuts: List<ShortcutModel>`
- `HomeStore._getDefaultShortcuts(): List<ShortcutModel>`
- `HomeStore.adaptiveMode: String`
- `HomeStore.currentSessionId: String?`
- `HomeStore.adaptiveDashboard: String?`
- `HomeStore.adaptiveCardType: String?`
- `HomeStore.adaptiveSource: String`
- `HomeStore.adaptiveDashboardSource: String`
- `HomeStore.adaptiveVisualPriority: String`
- `HomeStore.adaptiveReason: String?`
- `HomeStore.dashboardConfidence: double`
- `HomeStore.instantViewData: InstantAdaptiveHomeViewData?`
- `HomeStore.hasAdaptiveDashboardRecommendation: bool`
- `AdaptiveInterfaceService.getAdaptiveInterface({String? mode, String? sessionId})`
- `MetricsTrackingService.trackSessionStart({required String mode, String? sessionId})`
- `HomePanelMapper.map(...)`

Comportamento esperado das interfaces:

- `HomeStore._getDefaultShortcuts()` é a fonte canônica para atalhos `STATIC`.
- `AdaptiveInterfaceService.getAdaptiveInterface()` não participa do fluxo `STATIC`.
- `HomePanelMapper` deve receber estado já não adaptativo para `STATIC` e, portanto, não deve precisar compensar recomendações remotas.
- `trackSessionStart` continua sendo chamado pela Home com o modo resolvido no store.

## Arquivos prováveis

- `lib/features/presenter/viewmodels/home_store.dart`
  - Adicionar bypass explícito para `mode == 'STATIC'` em `loadAdaptiveInterface()`.
  - Extrair helper privado pequeno para reset de estado adaptativo, se isso reduzir duplicação sem ampliar escopo.
- `lib/features/presenter/views/home/home_page.dart`
  - Alterar somente se necessário para não aplicar dashboard/card adaptativo em `STATIC` ou para evitar chamada redundante/configuração inconsistente.
- Arquivos gerados MobX (`home_store.g.dart`)
  - Atualizar apenas se a implementação alterar observables/actions de forma que exija regeneração.

## Critérios de aceitação

- **CA-01:** Com config adaptativa ativa `mode == 'STATIC'`, a inicialização da Home não executa `AdaptiveInterfaceService.getAdaptiveInterface()`.
- **CA-02:** Com config `STATIC`, `store.recommendedShortcuts` contém exatamente os atalhos de `HomeStore._getDefaultShortcuts()`, sem reordenação ou itens vindos da Cloud Function/ML.
- **CA-03:** Com config `STATIC`, `store.adaptiveMode == 'STATIC'` ao final do carregamento.
- **CA-04:** Com config `STATIC`, `store.hasAdaptiveDashboardRecommendation == false` ao final do carregamento.
- **CA-05:** Com config `STATIC`, `adaptiveDashboard`, `adaptiveCardType` e `adaptiveReason` ficam nulos, `dashboardConfidence == 0.0` e `adaptiveVisualPriority` não indica prioridade visual adaptativa.
- **CA-06:** Com config `STATIC`, `_applyAdaptiveDashboard()` não muda a ordem/seleção de dashboard por recomendação adaptativa.
- **CA-07:** Com config `STATIC`, a UI não exibe badge/texto/highlight adaptativo decorrente de resposta remota.
- **CA-08:** Com config `STATIC`, `MetricsTrackingService.trackSessionStart()` continua sendo chamado com `mode == 'STATIC'` e `sessionId` da config quando houver.
- **CA-09:** Com config `STATIC`, nenhuma métrica de exposição/aplicação adaptativa é disparada por `loadAdaptiveInterface()`.
- **CA-10:** Quando não houver config adaptativa, o fluxo existente permanece igual ao atual e pode continuar chamando `getAdaptiveInterface()` conforme comportamento vigente.
- **CA-11:** Modos `GRADUAL` e `INSTANT` mantêm os comportamentos atuais: `GRADUAL` usa `loadAdaptiveInterface()` com chamada adaptativa; `INSTANT` com `sessionId` usa `loadInstantAdaptiveInterface()`.
- **CA-12:** A implementação não altera contrato remoto, schema Firestore, payloads de Cloud Function ou componentes UI sem necessidade comprovada.

## Validações esperadas

Validações automatizadas, se disponíveis no ambiente de implementação:

- `flutter analyze`
- `flutter test` se houver suíte existente configurada e executável

Validações manuais recomendadas:

1. Configurar usuário com `userAdaptiveConfig.mode = 'STATIC'`.
2. Abrir a Home e confirmar que atalhos exibidos são os quatro padrões: Gerenciar Equipe, Histórico, Agenda e Protocolos.
3. Confirmar por log/mock/instrumentação local que `getAdaptiveInterface` não foi chamado no fluxo `STATIC`.
4. Confirmar que não aparecem badges, motivos, textos ou highlight adaptativos na Home `STATIC`.
5. Confirmar que `trackSessionStart` registra `STATIC`.
6. Remover config adaptativa e confirmar que o comportamento atual sem config permanece inalterado.
7. Testar um usuário `GRADUAL` e um `INSTANT` para confirmar ausência de regressão nos fluxos adaptativos.

## Questões em aberto

- Quais valores exatos devem representar estado não adaptativo nos campos `adaptiveSource` e `adaptiveDashboardSource`: manter `system` ou usar `fallback` para algum deles? A recomendação desta spec é usar valores não adaptativos já existentes e consistentes com a UI atual.
- Caso uma config `STATIC` venha com `sessionId`, ele deve ser preservado em `currentSessionId` para métricas de sessão ou descartado por não haver exposição adaptativa? Esta spec assume preservar para `trackSessionStart`, conforme decisão informada.
- Há testes automatizados existentes de Home/Store que permitam mockar `AdaptiveInterfaceService`? A implementação deve verificar antes de criar novos testes ou alterar infraestrutura.
