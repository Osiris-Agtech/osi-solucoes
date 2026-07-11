# Spec: Correção do skeleton da Home em modo INSTANT ao retornar de outra tela

Agent: spec-writer
Rules: AGENTS.md

## Contexto

A Home em modo `INSTANT` recarrega a adaptação ao retornar de outra tela por meio de `RouteAware.didPopNext`, chamando `_refreshInstantOnReturn()` em `HomePage`.

O fluxo atual observado é:

1. usuário está na Home com dashboard base e conteúdo INSTANT renderizados;
2. usuário navega para outra tela;
3. ao voltar, `HomePage.didPopNext()` chama `_refreshInstantOnReturn()`;
4. `HomeStore.prepareInstantRefresh()` marca `isLoadingInstantAdaptation = true`, limpa `instantViewData` e mantém o dashboard base;
5. `_refreshInstantOnReturn()` chama `store.carregarHome()` e depois `store.loadInstantAdaptiveInterface()`;
6. `_buildDailyPanelSliver()` calcula `shouldShowSkeleton = !hasBaseDashboard || !store.hasResolvedAdaptiveInterface` e passa `data: null` quando `hasResolvedAdaptiveInterface` fica falso durante o refresh;
7. `HomeDailyPanelContent` renderiza `HomeDailyPanelSkeleton` full-page quando `isLoading && data == null`.

Isso gera uma transição visual indesejada no retorno para Home INSTANT: conteúdo parcial/antigo → skeleton full-page → conteúdo atualizado. Como já existe dashboard base, a atualização INSTANT deve preservar o conteúdo estrutural da Home e mostrar apenas o loading parcial da seção INSTANT.

## Objetivos

- Corrigir a experiência de loading no retorno para Home em modo `INSTANT`.
- Evitar a transição visual `conteúdo parcial -> skeleton full-page -> conteúdo` quando já houver dashboard base carregado.
- Usar `InstantSectionSkeleton` como loading parcial da seção INSTANT durante refresh pós-retorno quando `dashboard` já existir.
- Preservar o skeleton full-page apenas para carregamento inicial ou ausência real de dados base.
- Manter o escopo pequeno, sem refatoração ampla e sem crescimento relevante em arquivos grandes.

## Não objetivos

- Não alterar contrato da Cloud Function ou payload da API adaptativa.
- Não alterar schema, Firestore, GraphQL ou modelos de domínio.
- Não redesenhar a Home, componentes INSTANT ou layout global.
- Não criar nova infraestrutura de testes.
- Não mexer em métricas, exceto se necessário para preservar comportamento existente.
- Não reestruturar navegação, `RouteObserver` ou arquitetura do store.

## Requisitos funcionais

- **RF-01:** Ao retornar para Home em modo `INSTANT` com `dashboard` já carregado, a Home deve manter cabeçalho, módulos e dados base visíveis.
- **RF-02:** Durante o refresh INSTANT pós-retorno, a área adaptativa INSTANT deve exibir `InstantSectionSkeleton` enquanto `instantViewData` não estiver disponível e não houver erro INSTANT.
- **RF-03:** O skeleton full-page (`HomeDailyPanelSkeleton`) deve aparecer apenas quando não houver `dashboard` base ou em carregamento inicial sem dados suficientes para montar `HomePanelViewData`.
- **RF-04:** Erro no refresh INSTANT pós-retorno não deve limpar o dashboard base nem forçar skeleton full-page.
- **RF-05:** O fluxo não-INSTANT (`GRADUAL`/`STATIC`) deve manter o comportamento atual.
- **RF-06:** O primeiro carregamento em modo `INSTANT`, quando ainda não há dashboard base, pode continuar usando skeleton full-page até existir dado base para renderização.

## Requisitos não funcionais

- **RNF-01:** A correção deve tocar o menor número possível de arquivos.
- **RNF-02:** Arquivos grandes, especialmente `home_page.dart`, não devem receber nova responsabilidade; se alguma lógica crescer, ela deve ser extraída para helper pequeno ou mantida no store/componente apropriado.
- **RNF-03:** A solução deve manter tipagem Dart estrita e padrões existentes do projeto.
- **RNF-04:** A mudança não deve introduzir novas dependências.
- **RNF-05:** A renderização deve evitar flicker perceptível de tela inteira no retorno para Home.

## Abordagem técnica e decisões de design

### Diagnóstico técnico

Arquivos relevantes lidos:

- `lib/features/presenter/viewmodels/home_store.dart`
- `lib/features/presenter/views/home/home_page.dart`
- `lib/features/presenter/views/home/components/home_daily_panel_content.dart`
- `lib/features/presenter/views/home/components/instant_section_skeleton.dart`
- `lib/features/presenter/views/home/components/home_skeletons.dart`

O problema está na distinção insuficiente entre dois tipos de loading:

- **loading bloqueante de base:** não há dashboard suficiente para renderizar a Home;
- **loading incremental INSTANT:** já há dashboard base, mas a seção adaptativa INSTANT está sendo recalculada.

Hoje, `hasResolvedAdaptiveInterface = false` durante `loadInstantAdaptiveInterface()` faz `_buildDailyPanelSliver()` tratar o refresh como bloqueante, mesmo com `store.dashboard != null`.

### Design proposto

- Separar a decisão de skeleton full-page da decisão de skeleton INSTANT parcial.
- Em `_buildDailyPanelSliver()`, considerar `dashboard` existente como suficiente para manter `HomePanelViewData` durante refresh INSTANT.
- Em modo `INSTANT`, quando `store.dashboard != null` e `store.isLoadingInstantAdaptation == true`, passar `data: panelData` para `HomeDailyPanelContent` e deixar `showInstantSkeleton` renderizar `InstantSectionSkeleton`.
- Ajustar `showInstantSkeleton` para depender explicitamente do loading INSTANT quando já houver conteúdo base, evitando mostrar skeleton parcial indefinidamente em estados INSTANT sem dados e sem loading.
- Manter `HomeDailyPanelSkeleton` para `data == null` e loading bloqueante real.
- Evitar adicionar nova responsabilidade ao `home_page.dart`; se necessário, concentrar a regra em variáveis locais pequenas ou helper privado coeso apenas para cálculo de estado visual.

### Decisão registrada

Foi registrada uma decisão em `.specs/decisions/home-instant-return-partial-loading.md` para documentar a escolha por loading parcial da seção INSTANT em vez de skeleton full-page quando já existe dashboard base.

## Estruturas de dados e interfaces envolvidas

Não há novas estruturas de dados obrigatórias.

Interfaces/estados existentes envolvidos:

- `HomeStore.dashboard: HomeDashboard?`
- `HomeStore.hasResolvedAdaptiveInterface: bool`
- `HomeStore.isLoading: bool`
- `HomeStore.isLoadingShortcuts: bool`
- `HomeStore.isLoadingInstantAdaptation: bool`
- `HomeStore.instantViewData: InstantAdaptiveHomeViewData?`
- `HomeStore.hasInstantError: bool`
- `HomeStore.adaptiveMode: String`
- `HomeDailyPanelContent.data: HomePanelViewData?`
- `HomeDailyPanelContent.isLoading: bool`
- `HomeDailyPanelContent.isLoadingInstantAdaptation: bool`
- `HomeDailyPanelContent.instantViewData: InstantAdaptiveHomeViewData?`

Comportamento esperado das interfaces:

- `data == null` continua representando ausência de base suficiente para renderizar a Home.
- `isLoadingInstantAdaptation == true` representa refresh parcial da seção adaptativa INSTANT.
- `instantViewData == null` em conjunto com loading INSTANT deve renderizar skeleton parcial, não skeleton full-page, quando `data != null`.

## Arquivos prováveis

- `lib/features/presenter/views/home/home_page.dart`
  - Ajustar cálculo de `shouldShowSkeleton`, `isPanelLoading` e `data` em `_buildDailyPanelSliver()`.
  - Não adicionar novas responsabilidades além da decisão de estado visual já existente nesse método.
- `lib/features/presenter/views/home/components/home_daily_panel_content.dart`
  - Ajustar regra de `showInstantSkeleton` para loading parcial INSTANT com base em `isLoadingInstantAdaptation`, `adaptiveMode`, `instantViewData` e `hasInstantError`.
- `lib/features/presenter/viewmodels/home_store.dart`
  - Provável revisão pontual de `prepareInstantRefresh()` e `loadInstantAdaptiveInterface()` apenas se necessário para preservar `dashboard`/estado base; evitar mudanças amplas.

## Critérios de aceitação

- **CA-01:** Em modo `INSTANT`, ao retornar de outra tela com `store.dashboard != null`, a Home não renderiza `HomeDailyPanelSkeleton` full-page durante o refresh.
- **CA-02:** No mesmo cenário, `HomeDailyPanelContent` recebe `data` não nulo e mantém seções base visíveis.
- **CA-03:** No mesmo cenário, enquanto `store.isLoadingInstantAdaptation == true` e `store.instantViewData == null`, a seção INSTANT exibe `InstantSectionSkeleton`.
- **CA-04:** Quando o refresh INSTANT conclui com sucesso, `InstantSectionSkeleton` desaparece e os componentes de `instantViewData` são renderizados.
- **CA-05:** Quando o refresh INSTANT falha, a Home mantém dados base visíveis, não entra em skeleton full-page e não exibe skeleton INSTANT infinito.
- **CA-06:** No carregamento inicial sem `dashboard`, o skeleton full-page continua aparecendo durante loading bloqueante.
- **CA-07:** Em modos `GRADUAL` e `STATIC`, a mudança não altera a decisão atual de loading/skeleton.
- **CA-08:** A implementação não altera payloads, contratos remotos, models de API ou schemas.
- **CA-09:** A correção não adiciona dependências e não cria nova infraestrutura de teste.
- **CA-10:** Arquivos grandes não recebem lógica extensa; qualquer lógica nova deve ser pequena, localizada e coesa.

## Validações esperadas

Validações automatizadas, se disponíveis no ambiente de implementação:

- `flutter analyze`
- `flutter test` se a suíte existente estiver configurada e executável

Validações manuais recomendadas:

1. Entrar com usuário/configuração em modo `INSTANT` e `sessionId` válido.
2. Abrir Home e aguardar dashboard + conteúdo INSTANT carregarem.
3. Navegar para outra tela, por exemplo Agenda ou módulo acionado pela Home.
4. Retornar para Home.
5. Confirmar visualmente que não ocorre skeleton full-page.
6. Confirmar que a seção INSTANT mostra skeleton parcial enquanto atualiza.
7. Confirmar que o conteúdo INSTANT atualizado substitui o skeleton parcial ao finalizar.
8. Simular falha/timeout da chamada INSTANT, quando possível, e confirmar que a Home base permanece visível.

## Questões em aberto

- O refresh pós-retorno deve manter os componentes INSTANT antigos visíveis até a nova resposta chegar, ou substituí-los imediatamente por `InstantSectionSkeleton`? A direção desta spec assume substituir por skeleton parcial, conforme escopo informado.
- Existe cenário em que `hasResolvedAdaptiveInterface == false` em modo `INSTANT` deve continuar bloqueando a Home mesmo com `dashboard` presente? Não identificado nos arquivos lidos.
- Há testes widget existentes para Home que devam ser atualizados? A glob inicial não identificou arquivos de teste, mas a implementação deve confirmar antes de validar.
