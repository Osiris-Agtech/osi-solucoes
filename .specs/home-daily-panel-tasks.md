# Tasks de implementação: Home como painel do dia

## Contexto

A Home deve passar a priorizar o trabalho diário de cultivo, conforme `PRODUCT.md` e `.specs/home-daily-panel-redesign.md`: o usuário precisa abrir a tela e entender rapidamente contexto da conta, tarefas urgentes, alertas críticos, produção e caminhos de ação.

Este arquivo transforma o plano aprovado em `.specs/home-daily-panel-implementation-plan.md` e a decisão `.specs/decisions/home-daily-panel-architecture.md` em tarefas atômicas, sequenciais e verificáveis para uma implementação staged.

A implementação deve alterar apenas apresentação e composição da Home. O sistema adaptativo existente é obrigatório e deve ser preservado explicitamente: `HomeStore.loadAdaptiveInterface()`, `store.shortcuts`/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType`, `cardOrder` e tracking existente relacionado à Home/adaptação.

## Goals e non-goals

### Goals

- Reorganizar a Home em seções coesas, com “Hoje no cultivo” como bloco prioritário.
- Criar tasks pequenas, verificáveis e com arquivos permitidos por etapa.
- Permitir implementação staged com pontos de validação intermediários.
- Preservar regras de negócio, navegação existente, tracking existente e sistema adaptativo.
- Definir a seção “Módulos principais” com expansão inline: 6 módulos no compacto, 10 no expandido, sem navegação para `Routes.modulosPage` pelo botão “Ver todos”.
- Evitar crescimento de `home_page.dart`, `home_store.dart` e componentes já grandes.
- Definir validações por task e validação final.

### Non-goals

- Não alterar backend, schema de banco, queries GraphQL ou modelos gerados.
- Não criar novas regras de negócio para tarefas, lotes, alertas, produção, favoritos ou recentes.
- Não remover nem substituir o sistema adaptativo existente.
- Não criar nova camada arquitetural, pacote, design system, analytics, logs, i18n ou infraestrutura de testes.
- Não apontar CTAs para TODOs, callbacks vazios ou rotas inexistentes.

## Technical approach e decisões de design

- Implementar por composição de componentes em `lib/features/presenter/views/home/components/`.
- Usar `HomeDashboard` como fonte principal dos dados já existentes.
- Usar mapper/modelos de apresentação simples para transformar dados existentes em view data, sem buscar rede, navegar ou acessar stores diretamente.
- Manter `home_page.dart` como orquestrador de lifecycle, stores, callbacks e composição.
- Widgets de seção devem receber dados prontos e callbacks, sem acessar `GetIt`, stores ou services diretamente.
- A navegação deve ficar centralizada em `home_page.dart` ou boundary equivalente já existente.
- Dados críticos não podem depender exclusivamente de carousel; carousels/dashboards adaptativos podem continuar como apoio.
- Recomendações adaptativas devem aparecer, quando aplicável, como ações recomendadas discretas, limitadas a 4 e com destino validado.
- A lista de módulos permitida na seção “Módulos principais” é: Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos, Histórico.
- Setores e Lotes ficam fora da seção “Módulos principais” porque exigem contexto/id de área; essa exclusão não modifica ações recomendadas adaptativas.
- Tracking existente deve ser preservado nos pontos equivalentes; não criar eventos novos nesta feature.

### Critério de parada obrigatório

Pare a implementação e apresente novo plano antes de codar se qualquer task exigir:

- tocar mais de 5 arquivos no total da etapa corrente;
- tocar mais de 2 camadas na mesma etapa;
- acoplar componente de UI diretamente a `HomeStore`, `ModulosStore`, `LoteStore`, `AuthController`, services ou `GetIt`;
- alterar backend, schema, queries GraphQL, modelos gerados ou contratos de API;
- remover/renomear `HomeStore.loadAdaptiveInterface()`, `store.shortcuts`, `adaptiveDashboard`, `adaptiveCardType`, `cardOrder` ou tracking existente.

## Data structures ou interfaces envolvidas

### Entradas existentes a preservar

- `HomeDashboard`: resumo, tarefas, produção, lotes e alertas.
- `HomeStore.loadAdaptiveInterface()`: carregamento adaptativo existente.
- `store.shortcuts`/recomendações adaptativas: fonte para ações recomendadas quando aplicável.
- `adaptiveDashboard`, `adaptiveCardType`, `cardOrder`: dados adaptativos existentes que não podem ser removidos ou sobrescritos por constantes locais.
- `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()`: tracking existente a preservar quando aplicável.
- Tracking de atalhos/adaptação já existente: preservar se estiver presente no fluxo alvo.
- `Routes`: somente destinos existentes e validados.
- `Routes.modulosPage`: não deve ser usado pelo botão “Ver todos” da seção “Módulos principais”.

### View data sugerida

- `HomePanelViewData`: contexto, blocos do dia, produção, módulos e ações recomendadas.
- `TodayCultivationViewData`: tarefas de hoje, lotes ativos, próximas colheitas e alertas críticos.
- `RecommendedActionViewData`: label, descrição curta, ícone, indicação adaptativa opcional e destino/callback validado.
- `ProductionSummaryViewData`: métrica principal, tendência opcional e destino opcional para relatórios.
- `HomeModuleShortcutViewData`: nome, ícone/asset, rota, prioridade e elegibilidade para a seção “Módulos principais”.

## Tasks atômicas staged

### Stage 0 — Pré-checagem obrigatória

#### Task 0.1 — Mapear arquivos atuais e rotas disponíveis

- Dependência: nenhuma.
- Paralelismo: não paralelizável; bloqueia todas as demais tasks.
- Arquivos permitidos: nenhum arquivo deve ser alterado.
- Ações:
  - Ler `home_page.dart`, `home_store.dart`, componentes de `home/components`, `Routes` e models usados pela Home.
  - Identificar rotas reais para tarefas, lotes, relatórios e módulos.
  - Identificar chamadas atuais de `loadAdaptiveInterface`, atalhos/recomendações, `adaptiveDashboard`, `adaptiveCardType`, `cardOrder` e tracking.
- Validação:
  - Lista de arquivos e responsabilidades confirmada antes da primeira alteração.
  - Nenhuma alteração de código realizada.
  - Critério de parada avaliado.

### Stage 1 — Contratos de apresentação

#### Task 1.1 — Criar modelos de view data da Home

- Dependência: Task 0.1.
- Paralelismo: sequencial; desbloqueia Task 1.2.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/models/home_panel_view_data.dart`
- Ações:
  - Definir modelos imutáveis de apresentação para header, “Hoje no cultivo”, ações recomendadas, produção e módulos.
  - Incluir campos opcionais para indicação adaptativa sem obrigar exibição visual.
  - Representar destino validado como rota/callback key ou interface equivalente já usada no projeto.
- Validação:
  - Arquivo não importa stores, services, `GetIt` ou backend.
  - Não usa `any`, casts inseguros ou dados externos sem validação na boundary existente.
  - Não altera models gerados nem schema.

#### Task 1.2 — Criar mapper de `HomeDashboard` para view data

- Dependência: Task 1.1.
- Paralelismo: sequencial; desbloqueia componentes visuais.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/models/home_panel_view_data.dart`
  - `lib/features/presenter/views/home/models/home_panel_mapper.dart`
- Ações:
  - Mapear dados existentes de `HomeDashboard` para blocos da Home.
  - Limitar ações recomendadas visíveis a no máximo 4.
  - Consumir atalhos/recomendações adaptativas como entrada preservada, sem remover fonte original.
  - Preservar semanticamente `adaptiveDashboard`, `adaptiveCardType` e `cardOrder`; não sobrescrever ordem adaptativa global com regra local incompatível.
  - Omitir CTAs sem rota válida ou substituir por ação segura existente.
  - Usar lista permitida de módulos principais com 6 itens no estado compacto e 10 no expandido.
  - Excluir Setores e Lotes somente da seção de módulos, sem filtrar recomendações adaptativas.
- Validação:
  - Mapper não navega, não acessa stores/services, não faz tracking e não busca rede.
  - Nenhuma alteração em backend/schema/queries/models gerados.
  - Recomendações adaptativas continuam disponíveis na fonte original mesmo se só 4 forem exibidas.

### Stage 2 — Estados estruturais

#### Task 2.1 — Criar skeletons locais dos blocos principais

- Dependência: Task 1.1.
- Paralelismo: pode rodar em paralelo com Tasks 2.2, 3.1, 3.2, 3.3 e 3.4 após contratos de view data estáveis.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/home_skeletons.dart`
- Ações:
  - Criar skeletons para topo, “Hoje no cultivo”, ações recomendadas, produção e módulos.
  - Preservar geometria aproximada do layout final.
- Validação:
  - Não usar `CircularProgressIndicator` como único loading dos blocos principais.
  - Componente não acessa stores, services, rotas ou tracking.

#### Task 2.2 — Criar estados vazio e erro locais

- Dependência: Task 1.1.
- Paralelismo: pode rodar em paralelo com Task 2.1 e tasks visuais puras.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/home_empty_state.dart`
  - `lib/features/presenter/views/home/components/home_error_state.dart`
- Ações:
  - Criar empty state acionável por bloco, sem TODO visível.
  - Criar error state com retry via callback recebido por parâmetro.
- Validação:
  - Nenhum callback vazio embutido.
  - Nenhuma navegação direta dentro dos componentes.
  - Textos orientam próximo passo real e existente.

### Stage 3 — Componentes visuais puros

#### Task 3.1 — Criar header compacto do dia

- Dependência: Task 1.1.
- Paralelismo: pode rodar em paralelo com Tasks 2.1, 2.2, 3.2, 3.3 e 3.4.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/home_day_header.dart`
- Ações:
  - Renderizar saudação curta, contexto da conta/usuário e CTA “Ver tarefas de hoje”.
  - Receber dados e callback por parâmetro.
- Validação:
  - Sem placeholder `Lorem ipsum` ou imagem decorativa obrigatória.
  - Sem acesso direto a store/service/rota.
  - CTA só é exibido/habilitado quando callback validado existir.

#### Task 3.2 — Criar painel “Hoje no cultivo”

- Dependência: Task 1.1.
- Paralelismo: pode rodar em paralelo com Tasks 2.1, 2.2, 3.1, 3.3 e 3.4.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/today_cultivation_panel.dart`
- Ações:
  - Exibir tarefas de hoje, lotes ativos, próximas colheitas e alertas críticos quando disponíveis.
  - Exibir fallbacks independentes para dados ausentes.
  - Comunicar prioridade por texto/ícone/rótulo, não apenas por cor.
- Validação:
  - Alertas críticos e tarefas urgentes aparecem fora de carousel.
  - Dados parciais não apagam blocos não relacionados.
  - Componente não acessa store/service/rota.

#### Task 3.3 — Criar seção de ações recomendadas

- Dependência: Task 1.2.
- Paralelismo: pode rodar em paralelo com Tasks 2.1, 2.2, 3.1, 3.2 e 3.4 após mapper pronto.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/recommended_actions_section.dart`
- Ações:
  - Renderizar até 4 ações recomendadas.
  - Mostrar indicação adaptativa discreta somente quando ação vier de recomendação adaptativa real.
  - Receber callbacks/destinos já validados.
- Validação:
  - Nunca exibe mais de 4 ações.
  - Não remove nem altera `store.shortcuts`/recomendações adaptativas originais.
  - Sem TODO, callback vazio ou navegação direta.

#### Task 3.4 — Criar produção resumida e módulos com expansão inline

- Dependência: Task 1.2.
- Paralelismo: pode rodar em paralelo com Tasks 2.1, 2.2, 3.1, 3.2 e 3.3 após mapper pronto.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/home_production_summary.dart`
  - `lib/features/presenter/views/home/components/home_modules_section.dart`
- Ações:
  - Produção: exibir métrica principal, tendência curta quando existir e link de relatórios somente com destino válido.
   - Módulos: exibir 6 itens no estado compacto e 10 itens no expandido.
   - Botão “Ver todos” deve expandir inline o próprio card; no estado expandido, deve alternar para “Ver menos”.
   - Não chamar `Get.toNamed` nem navegar para `Routes.modulosPage` no clique do botão.
   - Exibir somente Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos e Histórico.
   - Não exibir Setores e Lotes na lista de módulos.
- Validação:
  - Nenhum link aponta para rota inexistente.
   - Módulos exibem exatamente 6 itens no estado compacto quando a lista permitida estiver completa.
   - Módulos exibem exatamente 10 itens no estado expandido quando a lista permitida estiver completa.
   - Botão alterna “Ver todos”/“Ver menos”.
   - Não há `Get.toNamed` no clique do botão “Ver todos”/“Ver menos”.
   - Sem Setores/Lotes na seção de módulos.
  - Componentes não acessam stores/services/rotas diretamente.

### Stage 4 — Composição da Home

#### Task 4.1 — Criar componente de composição principal

- Dependência: Tasks 2.1, 2.2, 3.1, 3.2, 3.3 e 3.4.
- Paralelismo: não paralelizável; integra componentes.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/components/home_daily_panel_content.dart`
- Ações:
  - Compor ordem visual: header, “Hoje no cultivo”, ações recomendadas, produção e módulos.
  - Receber view data, estado de loading/erro/vazio e callbacks.
  - Adaptar layout para mobile/tablet/desktop com breakpoints existentes.
- Validação:
  - Ordem visual segue a spec.
  - “Hoje no cultivo” aparece antes de módulos.
  - Componente não acessa stores/services/rotas/tracking.
  - Sem overflow evidente em layout responsivo por inspeção/manual.

#### Task 4.2 — Integrar mapper e composição em `home_page.dart`

- Dependência: Task 4.1.
- Paralelismo: não paralelizável.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/home_page.dart`
  - `lib/features/presenter/views/home/models/home_panel_mapper.dart`
  - imports necessários dos novos componentes/modelos.
- Ações:
  - Substituir blocos inline equivalentes pela composição nova, sem remover lifecycle existente.
  - Manter `HomeStore.loadAdaptiveInterface()` no fluxo equivalente atual.
  - Manter uso/fonte de `store.shortcuts`, `adaptiveDashboard`, `adaptiveCardType` e `cardOrder`.
  - Centralizar callbacks de navegação em `home_page.dart` ou boundary equivalente.
  - Garantir que carousels/dashboards adaptativos remanescentes não sejam o único local de dados críticos.
- Validação:
  - `loadAdaptiveInterface()` continua sendo chamado no fluxo esperado.
  - Nenhum campo adaptativo obrigatório foi removido, renomeado ou substituído por constante local.
  - `home_page.dart` não recebe novos blocos grandes de UI; detalhes ficam nos componentes.
  - Nenhuma alteração em `home_store.dart` salvo se indispensável e dentro do critério de parada.

### Stage 5 — Navegação e tracking existentes

#### Task 5.1 — Validar e conectar CTAs a rotas existentes

- Dependência: Task 4.2.
- Paralelismo: sequencial antes de validação final.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/home_page.dart`
  - `lib/features/presenter/views/home/models/home_panel_mapper.dart`
- Ações:
  - Conectar “Ver tarefas de hoje” à rota/filtro existente; se filtro hoje não existir, usar lista geral de tarefas e registrar limitação no resumo da implementação.
   - Conectar relatórios, módulos individuais, lotes e alertas apenas quando rota real existir.
   - Manter “Ver todos”/“Ver menos” dos módulos como alternância inline sem navegação.
  - Omitir ações sem destino seguro.
- Validação:
  - Nenhum CTA chama função vazia.
  - Nenhum CTA aponta para TODO ou rota inexistente.
  - Navegação preserva permissões/regras existentes.

#### Task 5.2 — Preservar tracking existente nos pontos equivalentes

- Dependência: Task 4.2.
- Paralelismo: pode rodar em paralelo com Task 5.1 se não houver conflito em `home_page.dart`; caso ambos editem o mesmo trecho, executar sequencialmente.
- Arquivos permitidos:
  - `lib/features/presenter/views/home/home_page.dart`
  - arquivos atuais de tracking somente se já forem usados pela Home e sem criar evento novo.
- Ações:
  - Preservar `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` quando aplicáveis ao fluxo atual.
  - Preservar tracking existente de exposição/interação de atalhos adaptativos.
  - Preservar `trackDashboardNavigation()` somente se existir na implementação-alvo.
- Validação:
  - Nenhuma métrica existente é removida sem decisão nova.
  - Nenhum evento novo é criado para compensar a refatoração.
  - Tracking continua fora de componentes visuais puros.

### Stage 6 — Acabamento responsivo e limpeza de escopo

#### Task 6.1 — Ajustar responsividade e acessibilidade visual

- Dependência: Tasks 5.1 e 5.2.
- Paralelismo: sequencial.
- Arquivos permitidos:
  - componentes criados em `lib/features/presenter/views/home/components/`
  - `lib/features/presenter/views/home/home_page.dart` somente para composição/responsividade
  - `lib/core/constants/constants.dart` somente se token semântico for indispensável
- Ações:
  - Validar mobile `<600`, tablet `600–1024` e desktop `>=1024`.
  - Evitar clipping, overflow, textos comprimidos e dependência de `FittedBox` em textos críticos.
  - Garantir cor semântica com texto/ícone/rótulo.
- Validação:
  - Sem overflow nos blocos principais.
  - Prioridade/status não dependem apenas de cor.
  - Nenhuma mudança global de tema/design system.

#### Task 6.2 — Revisar diff contra boundaries

- Dependência: Task 6.1.
- Paralelismo: não paralelizável; gate final antes da validação completa.
- Arquivos permitidos: nenhum arquivo novo deve ser alterado nesta task, salvo correção mínima descoberta na revisão.
- Ações:
  - Conferir arquivos tocados e responsabilidades.
  - Confirmar ausência de alteração em backend/schema/queries/models gerados.
  - Confirmar que `home_store.dart` não cresceu em responsabilidade.
  - Confirmar preservação do sistema adaptativo e tracking existente.
- Validação:
  - Se a implementação tocou mais de 5 arquivos em uma etapa ou acoplou UI a stores/services, parar e apresentar plano de correção antes de seguir.
  - Nenhuma boundary proibida foi cruzada.

## Acceptance criteria

- A Home abre com topo compacto, contexto da conta/usuário e CTA “Ver tarefas de hoje”.
- “Hoje no cultivo” aparece antes de módulos e mostra tarefas de hoje, lotes ativos, próximas colheitas e alertas críticos quando disponíveis.
- Alertas críticos e tarefas urgentes não ficam exclusivamente em carousel.
- Ações recomendadas exibem no máximo 4 itens.
- Recomendações adaptativas, quando exibidas, são discretas, validadas e não competem com o CTA principal.
- `HomeStore.loadAdaptiveInterface()` continua no fluxo de carga adaptativa existente.
- `store.shortcuts`/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` não são removidos, renomeados ou quebrados.
- Tracking existente de sessão, dashboard e atalhos/adaptação é preservado nos pontos equivalentes.
- Produção exibe métrica principal e link de relatório apenas quando houver destino válido.
- Módulos mostram favoritos/recentes existentes ou fallback de até 6 acessos principais.
- Card “Módulos principais” mostra 6 módulos no estado compacto e 10 módulos no estado expandido.
- Botão do card alterna entre “Ver todos” e “Ver menos”.
- Clique em “Ver todos”/“Ver menos” não chama `Get.toNamed` e não navega para `Routes.modulosPage`.
- A seção “Módulos principais” não exibe Setores nem Lotes.
- A exclusão de Setores e Lotes não altera ações recomendadas adaptativas.
- Card “Módulos principais” não apresenta overflow em mobile, tablet ou desktop/web.
- Loading dos blocos principais usa skeleton/estrutura, não spinner centralizado como única experiência.
- Estados vazios e erro são acionáveis, sem TODOs visíveis e sem callbacks vazios.
- Nenhuma alteração de backend, schema de banco, contrato de API, query GraphQL ou model gerado.
- Widgets de seção não acessam stores, services, `GetIt`, tracking ou navegação direta.
- `home_page.dart` atua como orquestrador e não recebe novos blocos grandes de UI.

## Validação final

Executar, se disponíveis no projeto:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Validação manual obrigatória:

- Home com dashboard completo.
- Loading inicial com skeletons.
- Erro de dashboard com retry.
- Sem tarefas hoje.
- Sem alertas críticos.
- Sem produção.
- Sem conta/contexto selecionado, se reproduzível.
- Mobile estreito, tablet e desktop/web.
- Todos os CTAs levam a rotas existentes ou são omitidos.
- Atalhos/recomendações adaptativas continuam carregados por `HomeStore.loadAdaptiveInterface()` e funcionais.
- `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` continuam preservados quando usados pelo fluxo atual.
- Tracking existente de sessão, dashboard e atalhos/adaptação continua disparando nos pontos equivalentes.
- Nenhum texto TODO visível.

## Open questions

- Existe rota/filtro específico para “tarefas de hoje” ou a primeira entrega deve abrir a lista geral de tarefas?
- Existe tela de relatórios adequada para a seção Produção nesta versão?
- Quais rotas existentes devem ser usadas para cada módulo individual da lista permitida?
- Quais severidades de alerta existentes devem mapear para crítico, atenção e informativo?
- Há tracking de navegação de dashboard no branch final além de `trackSessionStart()` e `trackDashboardShown()`?
