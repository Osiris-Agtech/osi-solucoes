# Proposta: camada incremental de componentes compartilhados presenter

## Contexto

O produto prioriza consistência, familiaridade e clareza operacional. A Home redesenhada e a proposta de padronização de Auth/Login já consolidam uma linguagem visual mais clara: painéis brancos, raio amplo, sombra leve, tipografia compacta, cores semânticas, estados explícitos e hierarquia orientada à tarefa.

A exploração dos módulos principais em `lib/features/presenter/views/` indica que essa linguagem pode ser distribuída para Reservatórios, Protocolos, Solução, Área Cultivo, Caderno Campo, Equipe, Ajustes e Relatórios. Porém, a adoção deve ser incremental: componentes da Home/Auth são referência visual, não dependências diretas dos módulos.

Esta revisão habilita a primeira padronização estética implementável de imediato. A primeira onda deve priorizar Reservatórios e Relatórios por terem padrões visuais claros e risco menor: Reservatórios já concentra busca, loading, empty e lista; Relatórios já possui cards e badges locais, mas o arquivo tem 314 linhas e deve receber apenas substituições seguras e pequenas.

Hoje há padrões visuais semelhantes repetidos ou divergentes entre telas: barras de busca locais, cards de entidade, estados vazios/loading com `CircularProgressIndicator`, app bars locais e componentes de formulário espalhados por subpastas de módulo. Algumas telas também já importam componentes da Home, como `top_app_bar.dart`, o que reforça a necessidade de uma boundary presenter compartilhada mais neutra.

## Resumo e problema

Criar uma proposta para uma camada pequena e incremental de componentes compartilhados presenter, com foco em reutilizar padrões visuais já aprovados sem introduzir um design system global grande neste momento.

Problemas observados:

- Linguagem visual da Home/Auth ainda não está disponível para módulos principais de forma neutra.
- Importar componentes de `home/components` ou `login/components/auth` em módulos operacionais acopla telas com responsabilidades específicas.
- Componentes atuais misturam frequentemente visual, navegação, stores, Get/GetIt e regras locais.
- Estados vazios/loading e cards/listas variam bastante entre módulos, reduzindo familiaridade.
- Arquivos grandes tendem a concentrar UI, estado e navegação, dificultando adoção segura sem decomposição prévia.

## Objetivos

- Definir uma camada presenter compartilhada, incremental e visualmente alinhada à Home/Auth.
- Permitir reutilização por módulos principais sem importar widgets específicos de Home/Auth.
- Padronizar cards, estados, botões, busca, tiles de seleção, headers, badges e seções de formulário no menor escopo útil.
- Manter componentes puros: dados entram por props/callbacks; stores, rotas, services e Get/GetIt ficam fora.
- Orientar adoção por fases, começando por componentes com maior repetição e baixo risco.
- Preservar familiaridade das telas atuais durante a migração.
- Melhorar clareza operacional com estados explícitos e hierarquia visual consistente.
- Habilitar implementação imediata da primeira onda estética sem alterar regras de negócio, stores, navegação ou contratos.
- Aplicar primeiro onde houver baixo risco, evitando expandir arquivos grandes de cadastro nesta rodada.

## Fora de escopo

- Implementar código de produção nesta etapa.
- Criar um design system global completo com tokens, tema, documentação interativa ou catálogo.
- Alterar regras de negócio, stores, rotas, services, contratos de API ou schemas.
- Reescrever Home, Auth/Login ou módulos principais.
- Migrar todos os módulos de uma vez.
- Criar nova infraestrutura de testes, analytics, logs, i18n ou CI.
- Substituir `Constants` ou reformular a arquitetura global do Flutter.
- Importar componentes específicos de Home/Auth diretamente em módulos operacionais.
- Refatorar arquivos grandes de cadastro como parte da primeira onda estética.
- Criar barrel export inicial para os componentes comuns.

## Princípios de design

1. **Home/Auth como referência, não dependência**  
   A camada deve replicar padrões visuais aprovados, mas não importar `HomePanelCard`, `HomeBadge`, componentes de Login/Auth ou helpers privados desses fluxos.

2. **Componentes puros**  
   Widgets compartilhados recebem dados simples, widgets filhos e callbacks. Não acessam stores, `Get`, `GetIt`, services, rotas, controllers globais ou models específicos de domínio.

3. **Boundary presenter**  
   A camada deve ficar dentro da área presenter e resolver composição visual reutilizável, não regras de domínio, persistência, navegação ou orquestração.

4. **Adoção incremental**  
   Cada componente deve nascer quando houver pelo menos uma tela candidata real e deve ser migrado em pequenos passos verificáveis.

5. **Mobile-first com tablet/desktop**  
   A largura, espaçamento e densidade partem do uso mobile, com limites de largura (`ConstrainedBox`), grids/`Wrap` e adaptação progressiva para telas maiores.

6. **API pequena e estável por uso real**  
   Evitar props antecipadas. Começar com os casos reais de Reservatórios/Protocolos/Solução/Área Cultivo e expandir apenas quando outro módulo exigir.

7. **Estados explícitos**  
   Loading, vazio, erro e busca sem resultados devem ter apresentação consistente e acionável, sem depender apenas de spinner centralizado.

## Local recomendado

Local recomendado inicial:

```text
lib/features/presenter/widgets/common/
```

Para a primeira implementação, este local deixa de ser apenas recomendado e passa a ser obrigatório para os componentes comuns listados nesta spec.

Justificativa:

- Já existe `lib/features/presenter/widgets/`, que é uma boundary presenter compartilhada e não pertence a uma feature específica.
- `common/` deixa explícito que os widgets são reutilizáveis entre telas presenter, mas ainda não são um design system global.
- Mantém proximidade com os módulos Flutter/Dart atuais sem mover a responsabilidade para `core` prematuramente.
- Permite evoluir a API por adoção real antes de promover algo para camada mais central.

Alternativas descartadas inicialmente:

- `lib/features/presenter/views/home/components/`: componentes de Home são referência visual, mas têm contexto, helpers e modelos específicos do dashboard. Usá-los como fonte compartilhada acopla módulos à Home.
- `lib/features/presenter/views/login/components/` ou `login/components/auth`: Auth/Login tem responsabilidades e estados de autenticação próprios. Módulos operacionais não devem depender do fluxo de autenticação.
- `lib/core/widgets/`: descartado no primeiro momento porque sugere API global e estável. A proposta ainda precisa maturar com uso real e evitar design system amplo antes da estabilização.

## Abordagem técnica e decisões de design

- Criar componentes `StatelessWidget` sempre que possível.
- Preferir composição via `child`, `leading`, `trailing`, `actions`, `onPressed` e dados primitivos.
- Usar `Constants` existentes para cor base enquanto não houver tokens formais.
- Manter nomes prefixados com `App` para indicar padrão compartilhado do app sem prometer design system completo.
- Não depender de models como `Reservatorio`, `Protocolo`, `Area`, `Usuario` ou DTOs de relatório.
- Não chamar `Get.toNamed`, `Get.close`, `GetIt.I`, métodos de store ou services dentro dos widgets comuns.
- Não criar barrel export obrigatório no primeiro momento; avaliar após os primeiros usos para evitar superfície pública artificial.
- Adotar componentes em telas já decompostas ou extrair subcomponentes locais antes de aplicar em arquivos grandes.
- `AppSearchBar` deve aceitar `TextEditingController?` opcional e callbacks (`onChanged`, `onSubmitted`, `onClear`), sem criar ou exigir controller interno obrigatório.
- `AppPageHeaderSliver` deve ser criado para estabilizar a API, mas aplicado apenas onde não houver risco de quebrar navegação, gesto de voltar, scroll existente ou composição de `CustomScrollView`.
- A primeira onda deve evitar mudanças em arquivos grandes de cadastro; quando um arquivo grande for tocado, limitar a alteração a substituições visuais locais e verificáveis.

## Primeira padronização estética implementável

### Escopo da primeira onda

Criar os componentes comuns de prioridade alta e média em `lib/features/presenter/widgets/common/`, mantendo cada arquivo independente e sem barrel export inicial.

Aplicar na primeira onda apenas em telas com benefício direto e baixo risco:

1. **Reservatórios — tela de lista**
   - Aplicar `AppSearchBar` na busca existente, preservando o controller/callbacks atuais da tela.
   - Aplicar `AppStatePanel` para loading, vazio e busca sem resultado quando a tela já expuser essas condições.
   - Aplicar `AppPanelCard` e/ou `AppEntityCard` nos itens da lista quando a substituição não exigir mudar model, store, rota ou lógica de seleção.
   - Aplicar `AppPrimaryButton` apenas em CTAs já existentes e sem mexer no fluxo de cadastro.
   - Avaliar `AppPageHeaderSliver` somente se a tela já usa sliver/header compatível; caso contrário, criar o componente sem aplicá-lo aqui.

2. **Relatórios — tela principal**
   - Aplicar `AppPanelCard`, `AppBadge` e `AppIconTile` nos cards/badges locais quando a mudança couber em substituição visual controlada.
   - Avaliar `AppEntityCard` para `_RelatorioCard` se reduzir repetição sem aumentar acoplamento nem inflar a API.
   - Não reestruturar a navegação, grid, app bar ou fluxo da tela nesta rodada.
   - Como `relatorios_page.dart` tem 314 linhas, evitar adicionar nova responsabilidade; preferir extração local pequena apenas se necessária para manter legibilidade.

### Telas-alvo desta rodada

- `lib/features/presenter/views/reservatorio/...` — tela de listagem/consulta de Reservatórios, incluindo busca, estados e lista. A implementação deve identificar o arquivo exato antes de alterar.
- `lib/features/presenter/views/relatorios/relatorios_page.dart` — apenas cards/badges/ícones locais, com cautela por tamanho do arquivo.

### Telas explicitamente adiadas

- `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart` — arquivo grande de cadastro; adiar `AppFormSection` e `AppFormSelectionTile` salvo extração específica aprovada depois.
- `lib/features/presenter/views/protocolo/cadastrar_protocolo_page.dart` — cadastro grande; adiar.
- `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart` — cadastro grande; adiar.
- `lib/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart` — cadastro grande; adiar.
- `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart` — cadastro grande; adiar.
- `lib/features/presenter/views/area_cultivo/N1/area_cultivo_page.dart` — alto potencial, mas arquivo grande; exige decomposição/plano próprio.
- `lib/features/presenter/views/gerenciar_equipe/gerenciar_equipe_page.dart` — alto potencial, mas arquivo grande; exige decomposição/plano próprio.
- `lib/features/presenter/views/ajuste/ajustes_page.dart` — arquivo grande; fora da primeira onda.
- Home e Auth/Login — permanecem referências visuais, não alvos de migração nesta spec.

## Interfaces e dados envolvidos

As interfaces abaixo são propostas conceituais para orientar implementação futura. Não representam código implementado nesta etapa.

### Tipos conceituais compartilhados

- `AppTone`: `primary`, `success`, `warning`, `danger`, `neutral`.
- `AppBadgeData`: texto curto, tom/cor, ícone opcional.
- `AppStateAction`: rótulo, callback opcional, estilo primário/secundário.
- `AppEntityMeta`: rótulo curto, valor curto, ícone opcional.
- `AppSelectionState`: selecionado, desabilitado, loading opcional.

### Boundaries obrigatórias

- Entrada permitida: strings, ícones, cores/tokens existentes, callbacks, children/widgets, flags de estado, dados de apresentação já formatados.
- Entrada não permitida: stores MobX, instâncias GetIt, rotas, services, repositories, clients HTTP, models de domínio como fonte obrigatória.
- Saída permitida: callbacks de interação (`onTap`, `onChanged`, `onPressed`, `onSubmitted`).
- Saída não permitida: navegação direta, mutação de store, chamada de serviço, leitura de storage.

## Componentes candidatos por prioridade

### Prioridade alta

#### `AppPanelCard`

- **Responsabilidade:** card/painel base branco com raio amplo, sombra leve, padding previsível e largura responsiva.
- **Props/dados esperados:** `child`, `padding`, `margin`, `backgroundColor`, `borderRadius`, `maxWidth`, `onTap` opcional, `semanticLabel` opcional.
- **Boundaries:** não conhece entidade, rota, store ou estado de carregamento. Não deve encapsular lógica de navegação; apenas expõe callback.
- **Primeiras telas candidatas:** Reservatórios (`reservatorioItem`/lista), Relatórios (`_RelatorioCard`), Área Cultivo (`CardArea` após decomposição), Equipe (`CardUsuario` após decomposição), Solução e Protocolos em cards de lista/detalhe.

#### `AppStatePanel`

- **Responsabilidade:** apresentação consistente para estados vazio, erro, loading leve e busca sem resultados, com ícone, título, descrição e ação opcional.
- **Props/dados esperados:** `stateKind`, `icon`, `title`, `message`, `actionLabel`, `onAction`, `secondaryActionLabel`, `onSecondaryAction`, `isCompact`.
- **Boundaries:** não decide quando a lista está vazia; a tela/store decide e passa os dados. Não chama reload por conta própria; apenas executa callback recebido.
- **Primeiras telas candidatas:** Reservatórios (`emptyList`, `loadingList`), Área Cultivo, Equipe, Caderno Campo, Protocolos, Solução, Ajustes; Relatórios apenas para estados futuros de erro/indisponível.

#### `AppPrimaryButton`

- **Responsabilidade:** CTA primário visualmente consistente com Home/Auth, com suporte a loading/desabilitado sem espalhar estilo de botão.
- **Props/dados esperados:** `label`, `onPressed`, `icon`, `isLoading`, `isEnabled`, `isFullWidth`, `size/density`, `tone`.
- **Boundaries:** não valida formulário nem chama store/service. A tela decide se botão está habilitado e o que acontece no callback.
- **Primeiras telas candidatas:** formulários de cadastro/edição em Reservatórios, Protocolos, Solução, Área Cultivo, Caderno Campo, Equipe; botões de ação em estados vazios.

#### `AppSearchBar`

- **Responsabilidade:** busca visualmente consistente com ícone, placeholder, clear opcional e ação/filtro opcional.
- **Props/dados esperados:** `TextEditingController? controller`, `initialValue` opcional apenas quando não houver controller externo, `hintText`, `onChanged`, `onSubmitted`, `onClear`, `trailing`, `autofocus`, `enabled`.
- **Boundaries:** não acessa stores nem filtra listas internamente. Não conhece campos pesquisáveis; apenas emite texto.
- **Decisão:** controller externo é opcional e não há controller interno obrigatório. Se a tela já possuir controller, ele deve ser preservado. Se a tela controlar busca por estado simples, callbacks continuam suficientes.
- **Primeiras telas candidatas:** Reservatórios (`filterWidget`), Protocolos, Área Cultivo, Equipe, Caderno Campo, Solução; Relatórios com cautela se houver busca/filtro real.

#### `AppFormSelectionTile`

- **Responsabilidade:** tile de seleção para formulários e bottom sheets, com título, subtítulo, estado selecionado e metadados curtos.
- **Props/dados esperados:** `title`, `subtitle`, `leading`, `trailing`, `isSelected`, `isEnabled`, `onTap`, `badge`, `metadata`, `errorText` opcional.
- **Boundaries:** não abre bottom sheet, não busca opções e não mantém seleção global. O estado selecionado vem da tela/store.
- **Primeiras telas candidatas:** Reservatório (`receitaPage`, seleção de receita), Protocolo (cultura/fase/atividade), Solução (fertilizante/nutriente), Área Cultivo (localização/reservatório), Caderno Campo (autor/atividade/lote).

### Prioridade média

#### `AppPageHeaderSliver`

- **Responsabilidade:** header sliver reutilizável com título, subtítulo, ação de voltar opcional, slot de busca/filtro e comportamento responsivo.
- **Props/dados esperados:** `title`, `subtitle`, `leading`, `onBack`, `actions`, `bottom`, `backgroundColor`, `expandedHeight`, `pinned/floating`.
- **Boundaries:** não chama `Get.close`, `Get.offNamedUntil` ou rotas diretamente. A ação de voltar é callback da tela.
- **Decisão de aplicação:** deve ser implementado na camada comum, mas a primeira onda só deve aplicá-lo se a tela já tiver estrutura sliver compatível e a substituição não alterar comportamento de navegação/scroll. Caso contrário, fica criado sem uso inicial.
- **Primeiras telas candidatas:** Reservatórios, Protocolos, Área Cultivo, Equipe, Caderno Campo, Solução; Relatórios com cautela porque já tem app bar local alinhada parcialmente.

#### `AppEntityCard`

- **Responsabilidade:** card de entidade operacional com título, subtítulo, ícone/imagem, badges, metadados e CTA/área clicável.
- **Props/dados esperados:** `title`, `subtitle`, `description`, `leading`, `image`, `badges`, `metadata`, `onTap`, `actions`, `isDisabled`.
- **Boundaries:** não recebe model de domínio obrigatório. A tela transforma `Reservatorio`, `Area`, `Usuario`, etc. em dados de apresentação.
- **Primeiras telas candidatas:** Reservatórios, Área Cultivo, Equipe, Relatórios (`_RelatorioCard`), Protocolos, Solução.

#### `AppBadge`

- **Responsabilidade:** badge discreto semântico para status, categoria ou contexto complementar.
- **Props/dados esperados:** `label`, `tone`, `icon`, `color`, `maxWidth`, `tooltip` opcional.
- **Boundaries:** não calcula status de domínio. Recebe texto/status já definido pela tela.
- **Primeiras telas candidatas:** Relatórios (`Disponível`), Home-like modules, Equipe (permissão/cargo), Protocolos (status/tipo), Área Cultivo, Solução.

#### `AppIconTile`

- **Responsabilidade:** bloco compacto de ícone com fundo semântico em baixa opacidade para headers, cards e seções.
- **Props/dados esperados:** `icon` ou `asset`, `color/tone`, `size`, `backgroundColor`, `semanticLabel`.
- **Boundaries:** não carrega asset remoto, não decide rota/ação. Pode receber `IconData` ou asset local como dado visual.
- **Primeiras telas candidatas:** Relatórios, módulos principais, headers de formulário, cards de entidades, estados vazios.

#### `AppFormSection`

- **Responsabilidade:** seção visual de formulário com título, descrição opcional, conteúdo e espaçamento consistente.
- **Props/dados esperados:** `title`, `description`, `children` ou `child`, `actions`, `isRequired` opcional, `footer` opcional.
- **Boundaries:** não contém `Form` global nem validações de domínio. Recebe campos/children já montados pela tela.
- **Primeiras telas candidatas:** Cadastro de Reservatório, Protocolo, Solução, Área Cultivo, Caderno Campo, Equipe; pode se inspirar em `cadastro_form_section.dart` sem depender dele.

### Prioridade baixa/futura

- `AppSkeletonList`: útil para substituir spinners, mas deve aguardar definição mínima de densidade/card em telas reais.
- `AppBottomSheetPickerShell`: recorrente em módulos, mas tem alto risco de acoplar seleção, busca e navegação; só depois de estabilizar `AppFormSelectionTile`.
- `AppNavigationShell`: envolve rotas e estrutura ampla; fora do escopo inicial.
- `AppMetricCard`: útil para Home/Relatórios/Ajustes, mas deve esperar estabilização de métricas e relatórios para evitar abstração prematura.

## Módulos e telas candidatas para adoção incremental

- **Reservatórios:** bom primeiro candidato para `AppSearchBar`, `AppStatePanel`, `AppPanelCard` e depois `AppEntityCard`. Arquivo de lista é menor, mas componentes de cadastro exigem cuidado.
- **Protocolos:** candidato forte para `AppFormSelectionTile`, `AppFormSection`, estados e cards, mas telas de cadastro/edição são grandes e devem ser decompostas antes.
- **Solução:** candidato para seleção/formulário e botões; telas de cadastro são grandes e devem ser migradas por subcomponentes.
- **Área Cultivo:** alto potencial para `AppEntityCard`, `AppSearchBar`, `AppStatePanel` e `AppPageHeaderSliver`; exige decomposição de `area_cultivo_page.dart` e componentes N1/N2/N3.
- **Caderno Campo:** candidato para seções de formulário, seleção e estados; telas grandes e bottom sheets requerem fases menores.
- **Equipe:** candidato para cards de usuário, busca e estados; `gerenciar_equipe_page.dart` concentra grid, agrupamento e card.
- **Ajustes:** candidato para `AppPanelCard`, `AppPrimaryButton`, `AppFormSection` e estados, mas `ajustes_page.dart` é grande e deve ser decomposto.
- **Relatórios com cautela:** já possui uma organização visual mais recente e cards locais. Pode validar `AppBadge`, `AppIconTile`, `AppPanelCard` e depois `AppEntityCard`, evitando quebra de fluxo ou generalização excessiva.

## Lista de telas faltantes após a primeira onda

Após aplicar somente Reservatórios e Relatórios, ainda ficam faltantes para ondas futuras:

- Protocolos: listagem, detalhes e cadastro/edição.
- Solução: listagem, detalhes e cadastro/edição.
- Área Cultivo: N1/N2/N3, listagens, detalhes e cadastro.
- Caderno Campo: listagem, detalhes, cadastro e bottom sheets.
- Equipe/Gerenciar Equipe: busca, agrupamento, cards de usuário e estados.
- Ajustes: painéis, formulários e CTAs.
- Formulários de cadastro de Reservatórios: seções, seleção e botões com decomposição prévia.
- Home/Auth/Login: continuam fora da migração; apenas referência visual.

## Arquivos grandes que exigem decomposição antes da adoção

Com base na exploração, estes arquivos estão próximos ou acima de ~300 linhas e não devem receber nova responsabilidade diretamente:

- `lib/features/presenter/views/home/home_page.dart` — 3291 linhas; referência visual, não alvo de importação direta.
- `lib/features/presenter/viewmodels/home_store.dart` — 424 linhas; fora do escopo da camada visual.
- `lib/features/presenter/views/ajuste/ajustes_page.dart` — 722 linhas.
- `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart` — 715 linhas.
- `lib/features/presenter/views/protocolo/cadastrar_protocolo_page.dart` — 648 linhas.
- `lib/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart` — 618 linhas.
- `lib/features/presenter/views/area_cultivo/N1/area_cultivo_page.dart` — 516 linhas.
- `lib/features/presenter/views/caderno_campo/caderno_campo_page.dart` — 496 linhas.
- `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart` — 396 linhas.
- `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart` — 387 linhas.
- `lib/features/presenter/views/gerenciar_equipe/gerenciar_equipe_page.dart` — 359 linhas.
- `lib/features/presenter/views/relatorios/relatorios_page.dart` — 314 linhas.

Critério recomendado: antes de aplicar componentes compartilhados nesses arquivos, extrair subcomponentes locais coesos quando a alteração tocar lógica de lista, formulário, card e navegação ao mesmo tempo.

## Riscos de acoplamento e over-engineering

- **Acoplamento à Home/Auth:** importar widgets ou helpers específicos desses fluxos faria módulos dependerem de decisões locais de dashboard/login.
- **Acoplamento a Get/GetIt/stores:** colocar navegação, resolução de dependência ou mutação de store em widget comum tornaria a camada difícil de reutilizar e testar visualmente.
- **Design system prematuro:** mover para `core/widgets` ou criar tokens amplos agora pode congelar uma API antes de validar os casos reais.
- **Props genéricas demais:** tentar cobrir todos os módulos desde o início pode gerar widgets com muitos parâmetros e baixa clareza.
- **Migração em massa:** trocar muitas telas de uma vez aumenta risco de regressão visual e funcional.
- **Quebra de familiaridade:** padronização excessiva pode remover pistas específicas úteis de cada módulo.
- **Responsividade superficial:** usar apenas dimensões fixas ou proporções de tela pode manter overflows em tablet/desktop.

## Plano incremental de adoção por fases

### Fase 0 — Preparação e validação de boundary

- Confirmar diretório `lib/features/presenter/widgets/common/`.
- Definir naming inicial e limites de importação.
- Escolher uma tela piloto pequena ou moderada.
- Não migrar Home/Auth; usá-las apenas como referência visual.

### Fase 1 — Primitivos de baixo risco

- Criar `AppPanelCard`, `AppStatePanel`, `AppPrimaryButton` e `AppSearchBar`.
- Aplicar primeiro em Reservatórios ou outra tela de lista com menor área de alteração.
- Validar loading/vazio/busca sem mudar store, rota ou regra de negócio.

### Fase 2 — Seleção e formulários

- Criar `AppFormSelectionTile` e, se necessário, `AppFormSection`.
- Aplicar em um fluxo de cadastro com componentes já isolados, preferencialmente em uma etapa específica.
- Evitar criar shell de bottom sheet nesta fase.

### Fase 3 — Cards e badges de entidade

- Criar `AppBadge`, `AppIconTile` e `AppEntityCard` quando houver dois usos reais semelhantes.
- Migrar cards de Reservatórios/Relatórios/Equipe/Área Cultivo progressivamente.
- Garantir que os dados de domínio sejam mapeados na tela/adapters locais para props de apresentação.

### Fase 4 — Headers e refinamento responsivo

- Avaliar `AppPageHeaderSliver` após entender variações reais de header, busca e ações.
- Aplicar em uma tela por vez, evitando substituir navegação sem necessidade.
- Validar mobile, tablet e desktop.

### Fase 5 — Componentes futuros

- Avaliar `AppSkeletonList`, `AppBottomSheetPickerShell`, `AppNavigationShell` e `AppMetricCard` apenas após estabilização dos componentes alta/média prioridade.
- Promover para `core/widgets` somente se a API estiver estável, genérica e usada fora de presenter por necessidade real.

## Critérios de aceite

- A spec existe em `.specs/` e descreve a proposta sem implementar código de produção.
- A decisão arquitetural existe em `.specs/decisions/` registrando a boundary fora de Home/Auth e fora de `core/widgets` inicialmente.
- Cada componente de prioridade alta e média tem responsabilidade, props/dados esperados, boundaries e primeiras telas candidatas documentadas.
- A proposta recomenda `lib/features/presenter/widgets/common/` e justifica alternativas descartadas.
- A proposta explicita que componentes compartilhados não acessam `Get`, `GetIt`, stores, services ou rotas.
- O plano de adoção é incremental e evita migração em massa.
- Arquivos grandes candidatos à decomposição estão listados com risco associado.
- Adoção futura preserva regras de negócio, contratos, stores e navegação existente, salvo decisões explícitas posteriores.
- Validação futura mínima por componente inclui análise visual em mobile e pelo menos uma largura maior, além dos comandos existentes de lint/typecheck/build quando identificáveis.

### Critérios de aceite da implementação da primeira onda

- Todos os componentes comuns criados nesta rodada ficam em `lib/features/presenter/widgets/common/`.
- Nenhum componente comum importa `Get`, `GetIt`, stores, routes, services, models de Home, models de Auth ou models de domínio como `Reservatorio`/relatório.
- Não é criado barrel export inicial para `common/`; os usos importam arquivos específicos.
- `AppSearchBar` aceita `TextEditingController?` externo e callbacks; não exige controller interno obrigatório para funcionar.
- `AppPageHeaderSliver` existe, mas só é aplicado se a tela-alvo já suportar o padrão sem mudar navegação, voltar ou scroll. Se não houver aplicação segura, o componente permanece não aplicado nesta rodada.
- Reservatórios preserva comportamento atual de busca, loading, empty, lista, callbacks, navegação e store; a mudança é apenas de apresentação/composição visual.
- Relatórios preserva comportamento atual dos cards, badges, navegação e ações; a mudança é apenas de apresentação/composição visual.
- Arquivos grandes de cadastro não são alterados nesta rodada.
- `relatorios_page.dart` não recebe nova responsabilidade; se a alteração aumentar complexidade, deve ser limitada por extração local coesa ou adiada.
- A implementação roda a validação estática/build/test já disponível no projeto, ou registra explicitamente a limitação se não houver comando identificável.

## Validações recomendadas para implementação futura

- Revisar imports dos novos componentes para garantir ausência de `get`, `get_it`, stores, services e rotas.
- Rodar análise estática do Flutter/Dart disponível no projeto após cada fase.
- Comparar telas piloto antes/depois em mobile e tablet/desktop.
- Validar estados: carregando, vazio, erro/busca sem resultado, lista com dados e ação desabilitada.
- Verificar contraste, overflow de texto, área mínima de toque e comportamento com teclado aberto nos formulários.

## Perguntas abertas do diagnóstico

- Qual é o arquivo exato da listagem de Reservatórios que deve receber a primeira aplicação após a implementação localizar a tela?
- Qual nível de compatibilidade visual com telas antigas deve ser preservado em cada módulo: atualização discreta ou alinhamento forte com Home/Auth?
- Em quais breakpoints tablet/desktop o app deve ser validado formalmente?
- Quando, e com quais critérios objetivos, um componente presenter comum poderia ser promovido para `core/widgets`?
