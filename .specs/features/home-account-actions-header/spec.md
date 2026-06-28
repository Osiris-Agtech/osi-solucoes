# Especificação SDD — Header discreto da Home e card com ações de conta

## Contexto

A Home já está sendo redesenhada para priorizar o trabalho diário de cultivo, conforme `.specs/home-daily-panel-redesign.md`, `.specs/home-daily-panel-implementation-plan.md` e `.specs/features/home-adaptacao-visual/`. Nesse redesenho, a saudação aparece no topo do conteúdo e o header fixo da tela também pode exibir informações de usuário/cargo, gerando duplicação visual e competição de hierarquia.

Esta especificação existe para consolidar a saudação e ações úteis de usuário/conta em um card compacto dentro de `HomeDayHeader`, preservando o header fixo apenas como estrutura discreta de navegação global com botão de menu acessível e baixo ruído visual.

## Problema e objetivo

### Problema

- A Home pode repetir saudação, nome, cargo ou contexto entre o header fixo e o card inicial.
- Ações de conta úteis, como trocar conta e sair, não estão especificadas como parte do topo contextual da Home.
- Expor ações de conta diretamente em componentes visuais pode acoplar UI a `AuthController`, stores, rotas ou modelos completos de usuário.
- Incluir ações sem destino real, como “Sobre o App” sem tela definida, cria CTA morto ou navegação falsa.

### Objetivo

Implementar, em especificação futura de código, a **Opção A**: ações compactas dentro de `HomeDayHeader`, com callbacks vindos da Home, `MyHeaderDelegate` sem saudação/cargo/conta/título e header fixo preservando apenas um botão de menu acessível de forma sutil.

## Goals e non-goals

### Goals

- Combinar saudação, contexto de conta e ações úteis em um card compacto no topo do conteúdo da Home.
- Remover duplicação de saudação/cargo do header fixo.
- Preservar o header fixo como navegação global discreta: sem título, sem saudação/cargo/conta, sem barra verde evidente, mantendo apenas botão de menu acessível e comportamento estrutural existente.
- Exibir ações de conta somente quando houver destino/condição real.
- Manter componentes visuais desacoplados de controllers, stores, services, rotas diretas e modelos completos.
- Exigir confirmação antes de logout iniciado pelo card para evitar toque acidental.

### Non-goals

- Não implementar código de app nesta etapa.
- Não alterar backend, schema de banco, contratos GraphQL, Cloud Functions ou models gerados.
- Não criar tela “Sobre o App” nem exibir essa ação enquanto não houver destino real.
- Não redesenhar o drawer, autenticação, seleção de contas ou fluxo global de logout.
- Não criar nova infraestrutura de analytics, logs, testes, i18n ou design system.
- Não substituir a arquitetura da Home definida nas specs já existentes.

## Escopo e fora de escopo

### Escopo

- Refinar a UI conceitual do topo da Home.
- Definir comportamento esperado de `HomeDayHeader` para saudação + ações de conta.
- Definir comportamento esperado de `MyHeaderDelegate` na Home.
- Definir contratos de view data e callbacks em alto nível.
- Definir responsabilidades por arquivo para implementação futura.
- Definir critérios de aceite e validações sugeridas.

### Fora de escopo

- Implementação Flutter/Dart.
- Alterações em autenticação, permissões ou gerenciamento de sessão.
- Criação de novas rotas.
- Exposição de ações sem destino validado.
- Uso direto de `Usuario` inteiro em widgets de apresentação.

## Requisitos funcionais e de UX

### RF-001 — Saudação única no card da Home

`HomeDayHeader` deve concentrar a saudação curta, o nome de exibição do usuário quando disponível e o contexto de conta atual. O header fixo não deve repetir saudação, nome, cargo ou contexto detalhado.

### RF-002 — Header fixo discreto

Na Home, `MyHeaderDelegate` deve preservar apenas o botão de menu acessível em uma apresentação sutil e de baixo ruído visual. Ele não deve exibir título “Home”, saudação, cargo, conta ou metadados de conta, nem usar uma barra verde evidente que dispute atenção com o card inicial.

### RF-003 — Ações compactas no card

`HomeDayHeader` deve aceitar ações compactas de usuário/conta, renderizadas de forma secundária em relação ao conteúdo operacional da Home. As ações não devem competir com o CTA primário “Ver tarefas de hoje”.

### RF-004 — Troca de conta condicional

A ação de troca de conta deve aparecer somente quando houver múltiplas contas disponíveis para o usuário ou quando a view data indicar explicitamente que troca de conta é possível.

### RF-005 — Logout com confirmação

A ação de logout exibida no card deve abrir confirmação antes de encerrar sessão. O logout não deve ocorrer em um único toque direto no card.

### RF-006 — Sem “Sobre o App” sem destino real

A ação “Sobre o App” não deve aparecer no card enquanto não existir destino real e validado para ela.

### RF-007 — Callbacks vindos da Home

As ações devem ser recebidas como callbacks ou descriptors de ação já validados pela Home. `HomeDayHeader` não deve decidir rotas, acessar controllers, stores ou services.

### RF-008 — Dados mínimos de apresentação

Componentes visuais devem receber view data mínima: saudação pronta ou dados simples para renderizá-la, nome de exibição, rótulo da conta, indicação de múltiplas contas e ações habilitadas. Não devem receber `Usuario` inteiro.

### RF-009 — Prioridade visual preservada

O card deve continuar compacto e não deslocar o bloco “Hoje no cultivo” de forma excessiva. Ações de conta devem ser secundárias e de baixo ruído.

### RF-010 — Estados ausentes

Quando nome, cargo ou conta estiverem ausentes, o card deve usar fallback textual seguro e não exibir placeholders, `null`, TODOs ou textos técnicos.

## Technical approach and design decisions

- Adotar a **Opção A** como direção: ações compactas dentro de `HomeDayHeader`.
- Tratar `HomeDayHeader` como componente visual puro: dados mínimos entram por view data; interações saem por callbacks.
- Centralizar callbacks na Home ou boundary equivalente, onde já existe acesso permitido a stores, controllers, navegação e fluxo de confirmação.
- Manter `MyHeaderDelegate` na Home como estrutura de navegação fixa e discreta, sem título e sem duplicar identidade do usuário.
- Não introduzir action sheet genérica, novo menu global ou nova tela de configurações nesta feature.
- Preferir descriptors simples de ação para habilitar/ocultar ações sem espalhar regra de negócio no widget.

## Contratos de dados/callbacks em alto nível

### View data conceitual

`HomeDayHeaderViewData` deve representar, em alto nível:

- `greetingText`: saudação curta pronta para exibição ou derivável por mapper.
- `displayName`: nome curto do usuário, opcional.
- `accountLabel`: nome/contexto da conta atual, opcional.
- `roleLabel`: cargo/função, opcional, somente no card se necessário para contexto; nunca duplicado no header fixo.
- `canSwitchAccount`: indica se a ação de troca de conta pode aparecer.
- `primaryTaskActionEnabled`: indica se o CTA “Ver tarefas de hoje” possui destino validado.
- `accountActions`: lista pequena de ações validadas, por exemplo trocar conta e logout.

### Ações conceituais

`HomeAccountActionViewData` deve representar:

- `id`: identificador estável da ação de UI.
- `label`: texto curto.
- `icon`: referência visual compatível com o padrão do projeto.
- `emphasis`: normal ou destrutiva; logout deve ser destrutiva/alerta.
- `isEnabled`: habilitação já decidida fora do widget.

### Callbacks conceituais

`HomeDayHeader` deve receber callbacks em alto nível, como:

- `onTodayTasksTap`: acionado pelo CTA “Ver tarefas de hoje”.
- `onSwitchAccountTap`: acionado somente quando `canSwitchAccount` for verdadeiro.
- `onLogoutTap`: deve iniciar fluxo de confirmação fora do componente visual puro ou via callback já encapsulado pela Home.
- `onAccountActionTap(actionId)`: alternativa aceitável se o padrão do projeto preferir callback único por ação.

### Boundaries obrigatórias

- Componentes visuais não acessam `AuthController`, `HomeStore`, `GetIt`, `Get`, services, rotas ou `Usuario` inteiro.
- `HomeDayHeader` não chama logout diretamente.
- `HomeDayHeader` não decide se existem múltiplas contas; recebe `canSwitchAccount` ou ação já filtrada.
- `HomeDayHeader` não exibe “Sobre o App” sem descriptor de ação com destino real.

## Responsabilidades por arquivo

### `lib/features/presenter/views/home/home_page.dart`

- Orquestrar dados existentes e callbacks.
- Montar view data mínima para o header ou chamar mapper existente.
- Definir callbacks de ações de conta, incluindo confirmação de logout.
- Preservar lifecycle, tracking existente e composição da Home.
- Não renderizar detalhes visuais do card inline.

### `lib/features/presenter/views/home/components/home_day_header.dart`

- Renderizar saudação, contexto de conta e CTA principal.
- Renderizar ações compactas recebidas por dados/callbacks.
- Não acessar stores, controllers, services, rotas ou modelos completos.
- Não conter lógica de autenticação, troca de conta ou logout.

### `lib/features/presenter/views/home/components/home_daily_panel_content.dart`

- Posicionar `HomeDayHeader` como primeiro bloco do conteúdo.
- Encaminhar view data e callbacks recebidos da Home.
- Preservar ordem visual definida para a Home: header do conteúdo, “Hoje no cultivo”, ações recomendadas, produção e módulos.

### `MyHeaderDelegate` ou arquivo equivalente do header fixo

- Na Home, exibir apenas o botão de menu acessível, com baixo ruído visual.
- Não exibir título “Home”, saudação, cargo, conta detalhada ou metadados de conta quando esses dados estiverem no card.
- Não usar barra verde evidente no header fixo; o card deve permanecer como ponto principal de saudação e contexto.
- Preservar comportamento estrutural existente do app bar/header.

### Mapper/view data da Home, se existente

- Derivar textos seguros e flags simples para o header.
- Filtrar ações sem destino/condição real.
- Não navegar, não fazer logout, não acessar services e não buscar dados remotos.

## Critérios de aceite verificáveis

- CA-001: A Home exibe saudação e contexto de conta em `HomeDayHeader`.
- CA-002: O header fixo da Home exibe apenas botão de menu acessível e discreto, sem título “Home”, saudação, cargo, conta ou contexto detalhado duplicado.
- CA-003: O header fixo da Home não apresenta barra verde evidente nem outro tratamento visual que dispute atenção com o card de saudação/contexto.
- CA-004: `HomeDayHeader` recebe dados mínimos de apresentação e não recebe `Usuario` inteiro.
- CA-005: `HomeDayHeader` não importa nem acessa `AuthController`, `HomeStore`, `GetIt`, `Get`, services ou rotas.
- CA-006: A ação “Trocar conta” aparece somente quando a view data indicar múltiplas contas/troca disponível.
- CA-007: A ação “Logout” exige confirmação antes de encerrar sessão.
- CA-008: “Sobre o App” não aparece no card sem destino real validado.
- CA-009: Nenhuma ação do card aponta para callback vazio, TODO ou rota inexistente.
- CA-010: O CTA “Ver tarefas de hoje” continua visualmente mais importante que ações de conta.
- CA-011: O card permanece compacto em mobile e não causa overflow com nome/conta longos.
- CA-012: Estados com nome, conta ou cargo ausentes exibem fallback seguro, sem `null`, placeholder técnico ou TODO visível.
- CA-013: A implementação futura não altera backend, schema, contratos de API, queries GraphQL ou models gerados.

## Validações sugeridas

- Revisar imports de `home_day_header.dart` para confirmar ausência de `AuthController`, stores, `GetIt`, `Get`, services e rotas.
- Revisar `MyHeaderDelegate` na Home para confirmar ausência de título “Home”, saudação, cargo, conta e barra verde evidente, mantendo apenas botão de menu acessível e discreto.
- Validar manualmente a Home com:
  - usuário com uma conta;
  - usuário com múltiplas contas;
  - conta/nome longos;
  - dados de usuário ou conta ausentes;
  - tentativa de logout cancelada;
  - tentativa de logout confirmada.
- Validar responsividade em mobile estreito, tablet e desktop/web.
- Executar validações automatizadas existentes do projeto após implementação futura, se disponíveis: `flutter analyze`, `flutter test`, `flutter build apk --debug`.

## Riscos e mitigação de acoplamento

- Risco: `HomeDayHeader` acessar autenticação diretamente para executar logout.
  - Mitigação: exigir callback vindo da Home e confirmação fora do componente visual puro.
- Risco: passar `Usuario` inteiro para o componente e espalhar regras de apresentação.
  - Mitigação: usar view data mínima com strings e flags simples.
- Risco: duplicar novamente nome/cargo/conta ou criar competição visual entre header fixo e card.
  - Mitigação: `MyHeaderDelegate` da Home fica limitado a botão de menu acessível e discreto, sem título e sem barra verde evidente.
- Risco: ação de troca de conta aparecer sem alternativa real.
  - Mitigação: exibir apenas com `canSwitchAccount` verdadeiro ou descriptor validado.
- Risco: logout por toque acidental.
  - Mitigação: confirmação obrigatória antes de encerrar sessão.
- Risco: card crescer demais e prejudicar “Hoje no cultivo”.
  - Mitigação: ações compactas, truncamento seguro e prioridade visual secundária.

## Open questions que precisam de clarificação

- Qual componente/arquivo exato implementa `MyHeaderDelegate` no branch final de implementação?
- O fluxo de troca de conta existente usa modal, rota ou drawer, e qual callback deve ser chamado pela Home?
- O diálogo de confirmação de logout já possui padrão compartilhado no projeto ou deve usar o padrão local existente da Home/autenticação?
- O cargo/função deve permanecer visível no card quando houver conta selecionada, ou deve ser omitido para reduzir ruído?
