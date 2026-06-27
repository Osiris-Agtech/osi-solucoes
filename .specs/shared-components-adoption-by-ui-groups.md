# Estratégia de adoção dos componentes compartilhados por grupos de telas

## Resumo

Esta spec define uma estratégia incremental para adoção dos componentes compartilhados presenter em grupos de telas com padrões de UI semelhantes, em vez de migrar módulos inteiros de uma vez. A abordagem usa Home/Login/Auth já implementados como referência visual e preserva a boundary definida em `.specs/shared-presenter-components-proposal.md` e `.specs/decisions/shared-presenter-components-boundary.md`.

A recomendação prática é começar pelo pacote **Reservatórios + Protocolos + Equipe**, validando listagens simples, busca, estados, cards de entidade, badges e tiles de ícone. **Solução** pode entrar apenas com a listagem principal se a tela estiver suficientemente próxima do padrão, sem arrastar formulários ou fluxos complexos para o primeiro pacote.

Esta especificação não inclui implementação de código de produção.

## Contexto

O produto registrado em `PRODUCT.md` é `product`. A personalidade do produto é clara, confiável e objetiva; a interface deve reduzir ruído visual, preservar familiaridade e apoiar decisões rápidas. As specs `.specs/home-daily-panel-redesign.md` e `.specs/auth-visual-standardization.md` consolidaram uma linguagem visual aplicada na Home/Login/Auth: cards brancos, raio amplo, sombra leve, tipografia compacta, cores semânticas, estados explícitos e composição responsiva.

A spec `.specs/shared-presenter-components-proposal.md` propõe uma camada pequena e incremental de componentes compartilhados em `lib/features/presenter/widgets/common/` ou boundary presenter equivalente. A decisão `.specs/decisions/shared-presenter-components-boundary.md` estabelece que esses componentes não devem importar Home/Auth diretamente nem acessar `Get`, `GetIt`, stores, services ou rotas.

Com Home e Auth já implementados como referência visual, o próximo risco não é mais definir a linguagem, mas escolher uma estratégia de adoção que evite acoplamento, migração em massa e componentes genéricos demais. A adoção por módulos inteiros tende a misturar listagens, formulários, hierarquias operacionais, navegação contextual e estados específicos no mesmo pacote de trabalho. A adoção por grupos de telas com padrões semelhantes reduz esse risco e permite validar componentes em cenários reais antes de expandir a API.

## Problema

É difícil usar os mesmos componentes em múltiplos lugares se a adoção for organizada por módulos inteiros. Um módulo costuma conter padrões diferentes: lista, cadastro, detalhe, seleção, bottom sheet, navegação contextual e estados de domínio. Migrar “Reservatórios” ou “Protocolos” por completo pode forçar componentes compartilhados a nascerem com props excessivas ou a absorverem responsabilidades que pertencem às telas.

A estratégia deve agrupar telas por padrão de UI, não por fronteira funcional. Assim, listagens simples são tratadas juntas; formulários com seleção são tratados em outro momento; hierarquias operacionais/contextuais entram depois; Relatórios e Ajustes ficam para uma fase cautelosa por terem maior risco de variação visual, métricas, configurações e decisões específicas.

## Objetivos

- Definir uma estratégia de adoção dos componentes compartilhados por grupos de telas com padrões de UI semelhantes.
- Preservar os princípios de design aplicados pela skill impeccable na Home/Login/Auth.
- Começar por um pacote de menor risco e maior repetição visual: Reservatórios + Protocolos + Equipe.
- Validar componentes comuns em uso real antes de expandir a API.
- Evitar importação direta de componentes Home/Auth em módulos operacionais.
- Manter componentes compartilhados puros, sem navegação, store, service, `Get` ou `GetIt`.
- Preservar regras de negócio, rotas, backend, stores e contratos existentes.
- Criar critérios verificáveis por grupo de adoção.

## Não objetivos

- Implementar código de produção nesta etapa.
- Migrar todos os módulos de uma vez.
- Criar design system global completo.
- Promover componentes para `core/widgets` sem evidência de estabilidade e reutilização real.
- Reescrever Home, Login, Auth ou os módulos existentes.
- Alterar regras de negócio, permissões, rotas, stores, services, contratos de API, schemas de banco ou backend.
- Criar infraestrutura nova de testes, analytics, logs, i18n, CI ou documentação interativa.

## Princípios de design aplicados na Home/Login/Auth

Estes princípios devem orientar os componentes compartilhados e as telas migradas:

1. **Design serve a tarefa**  
   Conforme o registro de produto, a interface deve apoiar a tarefa principal. Familiaridade e consistência são mais importantes que surpresa visual.

2. **Cards brancos, raio amplo e sombra leve**  
   Painéis e cards devem usar superfície branca, cantos amplos e sombra sutil. Evitar elevação forte, decoração gratuita e excesso de cards aninhados.

3. **Fundo neutro e superfície limpa**  
   Telas devem usar fundo neutro e reservar a superfície branca para conteúdo acionável ou informativo.

4. **Tipografia compacta e hierarquia objetiva**  
   Títulos curtos, textos auxiliares menores e hierarquia clara. Evitar textos longos, grandes blocos promocionais e densidade visual que esconda a tarefa.

5. **Cor semântica**  
   Cor deve comunicar função: primário, erro, atenção, sucesso ou neutro. Status não deve depender apenas de cor; texto, ícone ou rótulo devem reforçar o significado.

6. **Badges discretos e informativos**  
   Badges devem ser pequenos, arredondados, com baixa opacidade e texto curto. Devem informar status, categoria ou contexto, não decorar.

7. **Ícones em tiles com baixa opacidade**  
   Ícones devem aparecer em blocos compactos com fundo semântico suave, reforçando escaneabilidade sem competir com título e CTA.

8. **Estados explícitos inline/estruturais**  
   Loading, vazio, erro e busca sem resultado devem manter contexto e orientar próximo passo. Spinner genérico centralizado não deve ser a única resposta quando houver contexto suficiente para um estado estrutural.

9. **Mobile-first com adaptação para tablet/desktop**  
   Layouts devem partir de leitura vertical mobile e usar `ConstrainedBox`, `LayoutBuilder` e `Wrap` quando aplicável para limitar largura, quebrar linhas e evitar overflow em telas maiores.

10. **Componentes puros**  
    Componentes compartilhados recebem dados de apresentação, children e callbacks. Não navegam, não acessam store, não resolvem dependência, não chamam services.

11. **Copy objetiva**  
    Textos devem ser diretos, sem buzzwords. Labels devem ser acionáveis e deixar claro o próximo passo.

## Abordagem técnica e decisões de design

### Direção geral

A adoção deve acontecer por **pacotes de padrões de UI**, começando com telas que compartilham estrutura visual e interação semelhantes. Cada pacote valida um subconjunto pequeno de componentes. A API dos componentes só deve crescer quando um novo caso real exigir.

### Local e boundary

- Local recomendado permanece `lib/features/presenter/widgets/common/` ou boundary presenter equivalente.
- Home/Auth são referência visual, não dependência de importação.
- Componentes comuns devem ficar fora de `home/components` e fora de `login/components/auth`.
- `core/widgets` continua fora do escopo inicial até estabilização por uso real.

### Sequência recomendada

1. Criar/validar primitivas visuais de listagem em telas de baixa complexidade.
2. Aplicar em uma tela por vez dentro do pacote piloto.
3. Revisar se a API continuou pequena e pura após cada tela.
4. Só então avançar para formulários com seleção.
5. Adiar hierarquias contextuais e Relatórios/Ajustes até os componentes básicos estarem validados.

### Decisões de design

- Adoção por padrão de UI é preferível à adoção por módulo inteiro.
- O primeiro pacote deve validar componentes de listagem e estado, não formulários complexos.
- Componentes compartilhados devem aceitar dados já formatados para apresentação, não models de domínio obrigatórios.
- Navegação e chamadas de store continuam na tela ou em adapters/viewmodels existentes.
- Se uma tela estiver em arquivo grande, a implementação futura deve decompor subcomponentes locais antes de adicionar componentes compartilhados.

## Data structures ou interfaces envolvidas

As interfaces abaixo são conceituais para orientar adoção futura; não representam implementação nesta spec.

### Componentes esperados no primeiro pacote

#### `AppPageShell` ou `AppListScaffold`

- **Responsabilidade:** estrutura visual de página/listagem com fundo neutro, safe area, padding responsivo, largura máxima opcional, header/ações e slot para conteúdo.
- **Entradas:** `title`, `subtitle`, `actions`, `search`, `children` ou `body`, `maxWidth`, callbacks recebidos da tela.
- **Boundary:** não chama `Get`, não decide rota de voltar, não carrega dados, não conhece módulo.

#### `AppSearchBar`

- **Responsabilidade:** busca visual consistente com ícone, hint, clear opcional e estado disabled.
- **Entradas:** `hintText`, `value` ou controller conforme decisão futura, `onChanged`, `onSubmitted`, `onClear`, `enabled`, `trailing` opcional.
- **Boundary:** não filtra lista internamente e não acessa store.

#### `AppStatePanel`

- **Responsabilidade:** estado vazio, erro, loading estrutural ou busca sem resultado com título, descrição, ícone e ação opcional.
- **Entradas:** tipo de estado, `title`, `message`, `icon`, `actionLabel`, `onAction`, `secondaryActionLabel`, `onSecondaryAction`, `isCompact`.
- **Boundary:** não decide quando o estado acontece; apenas renderiza o estado recebido.

#### `AppEntityCard`

- **Responsabilidade:** card de entidade operacional com título, subtítulo, descrição opcional, leading, badges, metadados e ações.
- **Entradas:** `title`, `subtitle`, `description`, `leading`, `badges`, `metadata`, `onTap`, `actions`, flags visuais.
- **Boundary:** não recebe model de domínio obrigatório; Reservatório, Protocolo, Usuário ou Solução devem ser mapeados pela tela.

#### `AppBadge`

- **Responsabilidade:** badge discreto para status, categoria ou contexto.
- **Entradas:** `label`, `tone`, `icon`, `tooltip`, limites de largura.
- **Boundary:** não calcula status de domínio.

#### `AppIconTile`

- **Responsabilidade:** tile de ícone com fundo semântico em baixa opacidade para cards, headers e estados.
- **Entradas:** `icon` ou asset local, `tone`/cor, `size`, `semanticLabel`.
- **Boundary:** não carrega asset remoto, não navega, não decide ação.

### Tones conceituais

- `primary`: ação principal ou destaque de navegação.
- `success`: estado concluído, saudável ou positivo.
- `warning`: atenção, pendência, prazo próximo ou cuidado.
- `danger`: erro, crítico, falha ou bloqueio.
- `neutral`: informação secundária, metadados e estados sem severidade.

### Dados de apresentação comuns

- Badge: texto curto, tom semântico, ícone opcional.
- Metadado: label curto, valor curto, ícone opcional.
- Estado de ação: habilitado, loading, desabilitado, callback.
- Leading visual: ícone, tile, imagem local/fallback ou iniciais quando aplicável.

## Estratégia de agrupamento recomendada

## Grupo 1 — Listagens simples

### Escopo recomendado

- Reservatórios.
- Protocolos.
- Equipe.
- Solução: opcionalmente apenas a listagem principal.

### Por que agrupar

Essas telas tendem a compartilhar padrões de listagem: busca, card de entidade, estados vazios/loading/erro, badges ou metadados curtos e ação de item. O grupo permite validar a camada comum em cenários repetidos, mas com baixa necessidade de navegação contextual profunda ou formulário extenso.

### Componentes que devem nascer ou ser validados

- `AppPageShell` ou `AppListScaffold`.
- `AppSearchBar`.
- `AppStatePanel`.
- `AppEntityCard`.
- `AppBadge`.
- `AppIconTile`.

### Telas candidatas

- Lista de Reservatórios.
- Lista principal de Protocolos.
- Gestão/Listagem de Equipe.
- Listagem principal de Solução, apenas se puder ser isolada sem migrar cadastro/edição.

### Riscos

- Protocolos e Equipe podem ter estados e permissões específicas que não devem entrar no componente comum.
- Equipe pode exigir avatar/imagem/cargo/permissão; esses dados devem virar props de apresentação, não models obrigatórios.
- Solução pode puxar formulários ou regras de composição se a migração não for limitada à listagem principal.
- Se a busca atual estiver acoplada à store, `AppSearchBar` deve apenas emitir callbacks, não assumir filtragem.

### Critérios de aceite

- Cada tela migrada mantém suas regras de negócio, store, service, rotas e permissões existentes.
- Componentes comuns usados no grupo não importam Home/Auth.
- Componentes comuns usados no grupo não importam `get`, `get_it`, stores, services ou arquivos de rotas.
- Busca continua funcionando com o comportamento existente e sem lógica de filtragem dentro de `AppSearchBar`.
- Estados vazio/loading/erro/busca sem resultado aparecem de forma explícita e contextual quando o fluxo existente permite.
- Cards de entidade usam card branco, raio amplo, sombra leve, tipografia compacta e metadados escaneáveis.
- Badges comunicam status/categoria/contexto com tom semântico e texto curto.
- Layout não apresenta overflow em mobile estreito e mantém largura legível em tablet/desktop.

## Grupo 2 — Formulários com seleção

### Escopo recomendado

- Cadastrar Reservatório.
- Cadastrar Protocolo.
- Cadastrar Área de Cultivo.
- Cadastrar Caderno de Campo.

### Por que agrupar

Essas telas compartilham campos, seções, seleção de entidade, validação visual, CTA principal e estados de envio. O padrão dominante não é listagem, mas formulário com seleção e fluxo de preenchimento. Migrá-las depois do Grupo 1 evita que componentes de card/lista nasçam contaminados por necessidades de formulário.

### Componentes que devem nascer ou ser validados

- `AppFormSection`.
- `AppFormSelectionTile`.
- `AppPrimaryButton`, se ainda não existir no pacote comum.
- `AppStatePanel` para erros estruturais ou ausência de opções.
- `AppIconTile` para headers/seções.
- Possível `AppFeedbackMessage` se houver repetição real de mensagens inline fora de Auth.

### Telas candidatas

- Cadastro de Reservatório.
- Cadastro de Protocolo.
- Cadastro de Área de Cultivo.
- Cadastro de Caderno de Campo.

### Riscos

- Arquivos de cadastro tendem a ser grandes; adicionar componentes sem decomposição pode piorar acoplamento.
- Seleções podem envolver bottom sheets, stores e carregamento remoto; componentes comuns não devem abrir sheets nem buscar dados.
- Validação de formulário e regras de obrigatoriedade pertencem à tela/store, não ao componente visual.
- Há risco de generalizar demais se tentar cobrir todos os campos e seleções em um único widget.

### Critérios de aceite

- Formulários preservam validações, controllers, stores, services e contratos existentes.
- Seções visuais melhoram hierarquia sem alterar ordem funcional necessária.
- Tiles de seleção recebem título/subtítulo/status/callback já definidos pela tela.
- CTAs mostram estados habilitado/desabilitado/loading sem chamar store diretamente.
- Mensagens de erro ou ausência de opção aparecem próximas ao contexto afetado quando o fluxo existente expõe essa informação.
- Layout funciona com teclado aberto em mobile e sem campos cortados.
- `ConstrainedBox`, `LayoutBuilder` ou `Wrap` são usados quando necessários para evitar overflow em linhas com múltiplos campos.

## Grupo 3 — Hierarquia operacional/contextual

### Escopo recomendado

- Área de Cultivo.
- Setores.
- Lotes.
- Caderno de Campo.

### Por que agrupar

Essas telas dependem de contexto operacional e hierarquia: área, setor, lote, registros e navegação contextual. Elas podem reutilizar cards, badges e estados, mas têm maior risco porque itens frequentemente exigem contexto/id, breadcrumbs implícitos, filtros contextuais e ações dependentes do nível selecionado.

### Componentes que devem nascer ou ser validados

- `AppEntityCard` com metadados hierárquicos já mapeados pela tela.
- `AppBadge` para status operacional.
- `AppStatePanel` para ausência de itens no contexto atual.
- `AppPageShell`/`AppListScaffold` com header contextual, se o Grupo 1 provar a estrutura.
- Possível componente local de breadcrumb/header contextual antes de promover qualquer padrão comum.

### Telas candidatas

- Lista/visão de Área de Cultivo.
- Setores dentro de uma área.
- Lotes dentro de setor/área.
- Lista e registros de Caderno de Campo.

### Riscos

- Setores e Lotes exigem contexto/id e não devem ser tratados como módulos soltos.
- Componentes comuns não podem assumir a hierarquia do domínio.
- Misturar navegação contextual no componente compartilhado quebraria a boundary presenter.
- Caderno de Campo pode combinar lista, formulário, seleção e histórico no mesmo fluxo.

### Critérios de aceite

- Contexto operacional atual fica visível na tela sem ser calculado pelo componente comum.
- Cards recebem metadados e badges prontos, sem models obrigatórios de Área/Setor/Lote.
- Nenhum componente compartilhado monta rota com ids ou chama navegação direta.
- Estados vazios deixam claro se faltam setores, lotes ou registros dentro do contexto atual.
- Hierarquia visual preserva familiaridade e não esconde ações críticas.
- Migração ocorre por subfluxo, não pelo conjunto completo de Área/Setores/Lotes/Caderno de Campo de uma vez.

## Grupo 4 — Relatórios e Ajustes

### Escopo recomendado

- Relatórios.
- Ajustes.

### Por que agrupar

Relatórios e Ajustes devem ficar depois e com cautela porque têm padrões menos homogêneos: métricas, cards informacionais, configurações, ações administrativas, possíveis estados de disponibilidade e escolhas de conta/perfil. Parte de Relatórios pode já estar visualmente próxima da linguagem nova, enquanto Ajustes costuma concentrar muitas responsabilidades em uma tela grande.

### Componentes que devem nascer ou ser validados

- `AppPanelCard`, se ainda existir como base separada de `AppEntityCard`.
- `AppBadge` para disponibilidade/status.
- `AppIconTile` para categorias.
- `AppStatePanel` para indisponibilidade/erro.
- Possível `AppMetricCard` somente após evidência de repetição real entre Relatórios, Home e outros módulos.

### Telas candidatas

- Relatórios principais.
- Cards/atalhos de relatório.
- Seções específicas de Ajustes após decomposição local.

### Riscos

- Criar `AppMetricCard` cedo pode virar abstração prematura.
- Ajustes pode misturar perfil, conta, permissões, preferências e ações destrutivas.
- Relatórios pode ter estados próprios de disponibilidade que não devem virar regra global.
- Migração visual pode alterar percepção de ações sensíveis se não preservar hierarquia e confirmação existentes.

### Critérios de aceite

- Relatórios e Ajustes só entram após componentes do Grupo 1 estarem validados em pelo menos duas telas reais.
- Adoção em Ajustes exige decomposição prévia se a tela estiver grande ou misturar responsabilidades.
- Ações sensíveis preservam confirmação, permissões e hierarquia existentes.
- Componentes comuns não assumem cálculo de métricas, disponibilidade ou permissões.
- Qualquer componente de métrica só nasce se houver repetição real e API pequena.

## Recomendação prática inicial

Começar pelo pacote **Reservatórios + Protocolos + Equipe**.

Sequência recomendada:

1. Reservatórios como primeira tela piloto de listagem.
2. Protocolos como segunda tela para validar se `AppSearchBar`, `AppStatePanel` e `AppEntityCard` não ficaram específicos demais.
3. Equipe como terceira tela para validar avatar/cargo/permissão por dados de apresentação e badges.
4. Solução entra apenas com a listagem principal se a migração puder ser isolada sem tocar cadastro, edição ou regras de composição.

O primeiro pacote deve validar somente:

- `AppPageShell` ou `AppListScaffold`.
- `AppSearchBar`.
- `AppStatePanel`.
- `AppEntityCard`.
- `AppBadge`.
- `AppIconTile`.

Não incluir no primeiro pacote:

- shell de bottom sheet;
- componentes de formulário complexos;
- componentes de métricas;
- navegação contextual;
- promoção para `core/widgets`;
- refatoração ampla de stores ou rotas.

## Boundaries obrigatórias

- Não importar componentes da Home diretamente em módulos operacionais.
- Não importar componentes de Auth/Login diretamente em módulos operacionais.
- Não acessar `Get`, `GetIt`, stores, services, repositories, storage, clients HTTP ou rotas nos componentes compartilhados.
- Não alterar regras de negócio.
- Não alterar rotas.
- Não alterar backend, contratos de API ou schema de banco.
- Não mover lógica de filtro, permissão, carregamento, validação ou navegação para componentes comuns.
- Não tornar models de domínio obrigatórios nas props dos componentes comuns.
- Não criar design system global nesta fase.
- Não expandir arquivos grandes com nova responsabilidade sem decomposição ou plano explícito.

## Plano incremental

### Fase 0 — Confirmação de baseline

- Revisar Home/Login/Auth como referência visual implementada.
- Confirmar boundary em `lib/features/presenter/widgets/common/` ou equivalente.
- Listar telas exatas do Grupo 1 e arquivos envolvidos antes da implementação.
- Confirmar que a primeira entrega não toca regras de negócio, backend, rotas ou stores além de wiring visual mínimo.

### Fase 1 — Primeiro componente em Reservatórios

- Criar o menor conjunto necessário para a listagem piloto.
- Aplicar em Reservatórios sem alterar comportamento funcional.
- Validar estados de lista com dados, vazia, loading, erro e busca sem resultado quando existirem.

### Fase 2 — Segunda validação em Protocolos

- Reutilizar os mesmos componentes em Protocolos.
- Ajustar API apenas se a necessidade também fizer sentido para Reservatórios ou for claramente genérica de listagem.
- Impedir que regras específicas de Protocolo entrem nos componentes comuns.

### Fase 3 — Validação de variação em Equipe

- Aplicar cards, badges e icon/avatar tiles na listagem de Equipe.
- Validar cargos, permissões e estados visuais como dados de apresentação.
- Confirmar que o componente suporta variação sem receber model de usuário obrigatório.

### Fase 4 — Solução opcional limitada

- Avaliar apenas a listagem principal de Solução.
- Não migrar cadastro, edição, composição ou seleção nesta fase.
- Cancelar a inclusão de Solução se ela exigir tocar formulários ou regras complexas.

### Fase 5 — Revisão antes do Grupo 2

- Revisar imports e dependências dos componentes comuns.
- Registrar ajustes necessários para formulários sem alterar componentes de listagem indevidamente.
- Só avançar para Grupo 2 se os componentes do Grupo 1 estiverem pequenos, puros e usados por pelo menos duas telas reais.

## Validações

### Validações documentais desta spec

- A spec existe em `.specs/` e não contém implementação de produção.
- A spec considera `PRODUCT.md`, Home, Auth, proposta de componentes compartilhados e decisão de boundary.
- A estratégia recomenda grupos por padrão de UI, não por módulo inteiro.

### Validações futuras por implementação

- Rodar análise estática Flutter/Dart existente no projeto após cada pacote.
- Revisar imports dos componentes comuns para garantir ausência de Home/Auth, `get`, `get_it`, stores, services e rotas.
- Validar manualmente mobile estreito, tablet e desktop.
- Validar estados: carregando, vazio, erro, busca sem resultado, lista com dados e ações desabilitadas.
- Conferir contraste, legibilidade, overflow de texto, área de toque e comportamento com teclado aberto quando houver campo de busca.
- Confirmar que regras de negócio, rotas, permissões e chamadas de service continuam equivalentes ao fluxo anterior.
- Comparar visualmente com Home/Login/Auth para garantir consistência sem acoplamento direto.

## Critérios de aceite gerais

- Existe spec em `.specs/` descrevendo a estratégia de adoção por grupos de telas.
- A spec explicita o problema de migrar por módulos inteiros e recomenda agrupar por padrão de UI.
- A spec registra os princípios de design aplicados pela skill impeccable na Home/Login/Auth.
- A spec define os grupos 1, 2, 3 e 4 com motivo, componentes, telas candidatas, riscos e critérios de aceite.
- A spec recomenda começar por Reservatórios + Protocolos + Equipe, com Solução opcional apenas na listagem principal.
- A spec lista `AppPageShell` ou `AppListScaffold`, `AppSearchBar`, `AppStatePanel`, `AppEntityCard`, `AppBadge` e `AppIconTile` como componentes esperados no primeiro pacote.
- A spec reforça que Home/Auth são referência visual, não dependência direta.
- A spec define boundaries impedindo acesso a `Get`, `GetIt`, stores, services, rotas e backend nos componentes comuns.
- A spec inclui plano incremental e validações futuras.
- Nenhum código de produção é implementado nesta etapa.

## Perguntas abertas

- O nome preferido para o shell inicial deve ser `AppPageShell` ou `AppListScaffold`?
- A primeira tela piloto deve ser obrigatoriamente Reservatórios ou pode ser outra listagem se o código atual estiver mais simples no momento da implementação?
- `AppSearchBar` deve usar controller recebido ou API controlada por `value/onChanged` no primeiro pacote?
- Solução deve entrar no primeiro pacote apenas se a listagem principal estiver isolada, ou deve ficar totalmente para depois?
- Quais larguras de tablet/desktop devem ser usadas como baseline formal de validação visual?
