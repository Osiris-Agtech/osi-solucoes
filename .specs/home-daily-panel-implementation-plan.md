# Plano de implementação: Home como painel do dia

## Base aprovada

- Spec: `.specs/home-daily-panel-redesign.md`
- Decisão arquitetural: `.specs/decisions/home-daily-panel-architecture.md`
- Contexto de produto: `PRODUCT.md`

## Objetivo do plano

Orientar a implementação futura sem adicionar novas responsabilidades grandes a `home_page.dart`. A primeira entrega deve reorganizar dados já disponíveis em `HomeDashboard`, preservar regras de negócio existentes e tornar a Home mais útil para o trabalho diário.

O plano não autoriza remover atalhos ou dashboards adaptativos existentes. A refatoração deve preservar o sistema adaptativo e alterar apenas sua hierarquia visual: informações críticas não ficam exclusivamente em carousel, e recomendações adaptativas aparecem como ações recomendadas discretas, limitadas e validadas.

## Arquivos-alvo e responsabilidades

### Arquivos existentes que podem ser tocados

- `lib/features/presenter/views/home/home_page.dart`
   - Responsabilidade final: orquestrar lifecycle, stores existentes, layout shell e composição das seções.
   - Mudança esperada: remover ou reduzir blocos inline de header, dashboard principal, módulos, estados e loading, delegando para componentes.
   - Limite: não adicionar novos blocos grandes, novos painters ou regras extensas de apresentação; não remover chamadas existentes de carga adaptativa ou tracking sem decisão específica.

- `lib/features/presenter/views/home/components/home_page_header.dart`
  - Responsabilidade atual: header legado com placeholder.
  - Mudança esperada: substituir por componente real ou deixar de usar se um novo `home_day_header.dart` for criado.
  - Limite: não manter `Lorem ipsum` ou imagem placeholder em fluxo principal.

- `lib/features/presenter/views/home/components/daily_tasks_widget.dart`
  - Responsabilidade atual: lista/card de tarefas diárias, já acima de 300 linhas.
  - Mudança esperada: reutilizar padrões visuais apenas se não exigir crescimento relevante; caso contrário, criar seção nova menor.
  - Limite: evitar expandir este arquivo sem decomposição.

- `lib/features/presenter/views/home/components/mini_charts.dart`
  - Responsabilidade atual: gráficos pequenos e gauges.
  - Mudança esperada: reaproveitar para tendência curta ou produção, se o contrato visual couber.
  - Limite: não transformar em componente de seção.

- `lib/core/constants/constants.dart`
  - Responsabilidade atual: tokens básicos de cor.
  - Mudança esperada: somente adicionar tokens semânticos se necessário e consistente com o app.
  - Limite: não redesenhar a paleta global nesta feature.

- `lib/core/theme/theme.dart`
  - Responsabilidade atual: tema claro básico.
  - Mudança esperada: evitar mudanças globais; só ajustar se a implementação provar necessidade para consistência da Home.
  - Limite: não introduzir tema completo novo nesta feature.

- `lib/features/presenter/viewmodels/home_store.dart`
  - Responsabilidade atual: carregamento, dashboard, UI e interface adaptativa.
  - Mudança esperada: manter `HomeStore.loadAdaptiveInterface()` e os dados adaptativos como fonte de entrada para atalhos/recomendações/dashboard quando já usados.
  - Limite: não remover `store.shortcuts`/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType` ou `cardOrder`; evitar expandir responsabilidades do store.

### Novos módulos/componentes sugeridos

Criar em `lib/features/presenter/views/home/components/`, mantendo o padrão de pasta existente:

- `home_daily_panel_content.dart`
  - Composição vertical/responsiva das seções principais da Home.
  - Recebe dados prontos e callbacks de navegação.

- `home_day_header.dart`
  - Saudação compacta, contexto da conta/usuário e CTA “Ver tarefas de hoje”.
  - Não busca dados diretamente em stores.

- `today_cultivation_panel.dart`
  - Bloco principal “Hoje no cultivo”.
  - Renderiza tarefas de hoje, lotes ativos, próximas colheitas e alertas críticos a partir de view data.

- `recommended_actions_section.dart`
  - Lista até 4 ações recomendadas.
  - Exibe indicação adaptativa discreta somente quando houver recomendação real.
  - Pode receber atalhos/recomendações adaptativas já existentes, desde que mapeados para ações com destino validado.

- `home_production_summary.dart`
  - Métrica principal de produção, tendência curta e link para relatórios quando válido.

- `home_modules_section.dart`
   - Card “Módulos principais” com 6 itens no estado compacto e 10 itens no estado expandido.
   - Botão “Ver todos”/“Ver menos” alterna expansão inline do próprio card, sem navegar para `Routes.modulosPage`.
   - Lista permitida: Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos, Histórico.
   - Exclui Setores e Lotes somente desta seção porque exigem contexto/id de área; ações recomendadas adaptativas permanecem fora desse filtro.

- `home_skeletons.dart`
  - Skeletons locais para topo, Hoje no cultivo, ações, produção e módulos.
  - Deve preservar a geometria dos blocos finais.

- `home_empty_state.dart`
  - Estados vazios acionáveis por bloco, sem TODOs e sem callbacks vazios.

- `home_error_state.dart`
  - Erro com ação segura de tentar novamente quando `store.carregarHome()` estiver disponível.

### Mapper/modelos de apresentação sugeridos

Criar em `lib/features/presenter/views/home/models/` ou `lib/features/presenter/views/home/` se o projeto preferir menos subpastas:

- `home_panel_view_data.dart`
  - `HomePanelViewData`: contexto, métricas do dia, alertas, produção, módulos e ações já prontos para UI.
  - `TodayCultivationViewData`: tarefas hoje, lotes ativos, próximas colheitas, alertas críticos.
  - `RecommendedActionViewData`: label, descrição curta, ícone, severidade/ênfase, callback key ou rota validada.
  - `ProductionSummaryViewData`: métrica principal, tendência e destino opcional.
   - `HomeModuleShortcutViewData`: nome, ícone/asset, rota, prioridade e elegibilidade para exibição na seção de módulos.

- `home_panel_mapper.dart`
  - Converte `HomeDashboard`, shortcuts adaptativos e dados de usuário/conta em view data.
  - Centraliza limites, fallbacks, severidades visuais e decisões de exibição.
  - Não deve buscar rede, acessar `GetIt` ou navegar.
  - Não deve sobrescrever a semântica de `adaptiveDashboard`, `adaptiveCardType` ou `cardOrder`; esses campos devem ser preservados quando usados pelo fluxo atual.

## Módulos reutilizados

- `HomeStore`: carregamento, erro, refresh, dashboard e dados adaptativos existentes.
- `HomeStore.loadAdaptiveInterface()`: fluxo existente de carga adaptativa que deve continuar preservado.
- Atalhos/recomendações adaptativas do store: fonte existente para ações recomendadas quando aplicável.
- `adaptiveDashboard`, `adaptiveCardType` e `cardOrder`: dados existentes de dashboard recomendado/tipo de card/ordem que não devem ser removidos ou quebrados.
- `HomeDashboard`: fonte principal para resumo, tarefas, produção, lotes e alertas.
- `MetricsTrackingService`: tracking existente a preservar em fluxos equivalentes, incluindo `trackSessionStart()` e `trackDashboardShown()`; `trackDashboardNavigation()` deve ser preservado somente se existir na implementação-alvo.
- `Routes`: destinos existentes, incluindo `agendaPage`, `lotePage`, `cadastrarLotePage`, `relatoriosPage`, `relatorioProducaoPage`, `relatorioAgendaTarefasPage` quando aplicável. `Routes.modulosPage` não deve ser usado pelo botão “Ver todos” do card de módulos.
- `ResponsiveBreakpoints`: breakpoints e helpers já usados no app.
- `Constants`: cores base existentes, com semântica aplicada no nível da Home.
- Componentes de `home/components`: reaproveitar apenas quando coesos e sem crescimento excessivo.

## Boundaries que não devem ser cruzadas

- Widgets de seção não devem acessar `GetIt`, `HomeStore`, `ModulosStore`, `LoteStore` ou `AuthController` diretamente.
- Widgets de seção não devem chamar `Get.toNamed` diretamente, salvo se o padrão atual exigir e o callback já vier da página orquestradora.
- Mapper não deve navegar, logar analytics, buscar dados remotos ou alterar stores.
- Mapper não deve remover, filtrar definitivamente ou invalidar atalhos adaptativos; deve apenas limitar a apresentação visível da seção de ações recomendadas a no máximo 4 itens.
- O filtro que remove Setores e Lotes vale apenas para a seção “Módulos principais”; não deve alterar atalhos/recomendações adaptativas.
- A feature não deve alterar query GraphQL, schema de banco ou modelos gerados sem decisão nova.
- Lógica de negócio de tarefas, lotes, produção e alertas deve permanecer nos stores/repositórios existentes.
- `home_page.dart` deve coordenar dependências e callbacks, não renderizar internamente todos os detalhes.
- `HomeStore.loadAdaptiveInterface()` deve continuar no fluxo de inicialização/carga equivalente da Home.
- `store.shortcuts`/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` não devem ser removidos, renomeados ou substituídos por constantes locais da nova UI.
- Métricas existentes não devem ser removidas: preservar `trackSessionStart()` e `trackDashboardShown()` quando aplicáveis; preservar tracking de exposição/interação de atalhos; preservar `trackDashboardNavigation()` apenas se esse método/evento existir no branch em implementação.
- Dashboards adaptativos e carousels podem continuar existindo como apoio, mas dados críticos devem aparecer também fora deles.

## Arquivos que não devem crescer sem decomposição

- `lib/features/presenter/views/home/home_page.dart`, já tem aproximadamente 3571 linhas.
- `lib/features/presenter/viewmodels/home_store.dart`, já mistura dashboard, UI e interface adaptativa.
- `lib/features/presenter/models/homeDashboard/home_dashboard_model.dart`, evitar alteração de contrato.
- `lib/features/presenter/views/home/components/daily_tasks_widget.dart`, já passa de 300 linhas.
- `lib/features/presenter/views/home/components/productivity_chart_widget.dart`, já é grande.

## Riscos de acoplamento

- Ações recomendadas podem acoplar a Home a rotas de módulos sem checagem de permissão.
- Manter navegação diretamente em componentes dificulta validar CTAs e remover TODOs.
- Reaproveitar componentes grandes pode apenas deslocar complexidade em vez de reduzi-la.
- Skeletons divergentes do layout final podem causar saltos visuais e falsa sensação de loading resolvido.
- Dados adaptativos atuais podem competir com a nova hierarquia se a Home continuar priorizando recomendações acima do painel do dia.
- Reduzir recomendações adaptativas para uma seção discreta pode quebrar personalização se a implementação remover dados em vez de apenas remapear apresentação.
- Remover eventos de tracking existentes durante a extração de componentes pode quebrar métricas históricas da Home.

## Etapas de implementação recomendadas

### Etapa 1: Preparar boundaries antes do visual

- Criar view data e mapper de apresentação.
- Mapear `HomeDashboard` atual para os blocos da nova Home.
- Mapear atalhos/recomendações adaptativas existentes para ações recomendadas discretas, sem remover a fonte adaptativa.
- Registrar no mapper quais campos adaptativos são apenas consumidos (`adaptiveDashboard`, `adaptiveCardType`, `cardOrder`) e quais são limitados visualmente.
- Definir a lista fixa permitida da seção “Módulos principais”, com 6 itens compactos e 10 itens no estado expandido.
- Validar rotas existentes antes de expor CTAs.

Critério de conclusão:
- A Home consegue montar dados de apresentação sem alterar backend.
- CTAs sem rota validada são omitidos ou substituídos por ação segura existente.
- Atalhos/recomendações adaptativas continuam disponíveis mesmo quando a seção visual exibe no máximo 4 itens.

### Etapa 2: Extrair shell e estados

- Criar componente de composição principal.
- Criar skeletons, empty states e error state locais.
- Substituir spinners dos blocos principais por skeletons.

Critério de conclusão:
- Loading, erro, vazio e dados parciais têm componentes próprios.
- Não há TODO visível nem callback vazio em estados principais.

### Etapa 3: Implementar seções da nova hierarquia

- Implementar topo compacto.
- Implementar “Hoje no cultivo” antes de ações, produção e módulos.
- Implementar ações recomendadas limitadas a 4.
- Implementar produção resumida.
- Implementar módulos reduzidos com expansão inline.

Critério de conclusão:
- A ordem visual segue a spec.
- Informações críticas não dependem de carousel.
- Recomendações adaptativas aparecem de forma discreta e não competem com o CTA principal.
- “Módulos principais” exibe 6 itens no estado compacto, 10 no expandido, alterna botão “Ver todos”/“Ver menos” e não navega para `Routes.modulosPage` no clique do botão.

### Etapa 4: Integrar navegação e analytics existentes

- Centralizar callbacks em `home_page.dart` ou em boundary equivalente.
- Preservar tracking existente quando aplicável, sem criar eventos novos.
- Preservar `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` nos fluxos equivalentes já existentes.
- Preservar tracking relacionado a atalhos adaptativos/exposição/interação quando já existir no fluxo atual.
- Preservar `trackDashboardNavigation()` somente se o método/evento existir no branch alvo; não criar evento novo apenas por esta spec.
- Garantir que todos os destinos usam `Routes` existentes.
- Garantir que o botão “Ver todos” de módulos apenas altera estado local/controlado da seção, sem `Get.toNamed`.

Critério de conclusão:
- Todos os CTAs executam ação real e validável.
- Nenhum TODO de navegação permanece na Home redesenhada.
- O clique em “Ver todos”/“Ver menos” não executa navegação.
- Métricas existentes de sessão, dashboard e atalhos continuam sendo disparadas quando aplicável.

### Etapa 5: Responsividade e acabamento visual

- Validar mobile `<600`, tablet `600–1024` e desktop `>=1024`.
- Remover dependência de `FittedBox` para textos críticos.
- Evitar alturas proporcionais frágeis em conteúdo dinâmico.
- Checar contraste de textos, badges e botões.

Critério de conclusão:
- Sem overflow, clipping ou textos ilegíveis nos blocos principais.
- Cores fortes são reservadas para semântica clara.

## Validações automatizadas recomendadas

Executar a partir da raiz do projeto:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Se a implementação alterar modelos gerados, executar antes das validações:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Validações manuais obrigatórias

- Home carregada com dashboard completo.
- Loading inicial com skeletons.
- Erro de dashboard com retry.
- Sem tarefas hoje.
- Sem alertas críticos.
- Sem produção.
- Sem conta/contexto selecionado, se reproduzível.
- Mobile estreito.
- Tablet.
- Desktop/web.
- Todos os CTAs acionáveis levando para rotas existentes.
- Atalhos/recomendações adaptativas carregados por `HomeStore.loadAdaptiveInterface()` continuam disponíveis e funcionais.
- `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` continuam preservados quando usados pelo fluxo atual.
- Tracking existente de sessão, dashboard e atalhos continua sendo disparado nos pontos equivalentes.
- Nenhum texto TODO visível.

## Execução paralela segura

Pode ser paralelizado somente depois do mapper e contratos de view data estarem estáveis.

- Workstream A: skeletons e estados vazios.
  - Permitido: `home_skeletons.dart`, `home_empty_state.dart`, `home_error_state.dart`.
  - Proibido: `home_page.dart`, mapper, stores.

- Workstream B: componentes visuais puros.
  - Permitido: `home_day_header.dart`, `today_cultivation_panel.dart`, `home_production_summary.dart`.
  - Proibido: navegação, stores, models GraphQL.

- Workstream C: mapper e view data.
  - Permitido: `home_panel_view_data.dart`, `home_panel_mapper.dart`.
  - Proibido: componentes visuais e navegação direta.

Integração em `home_page.dart` deve ser sequencial após os três workstreams para evitar contratos divergentes.
