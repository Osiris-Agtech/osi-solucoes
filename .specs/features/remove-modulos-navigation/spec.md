# Especificação SDD — Remoção da navegação por `ModulosPage`

## Contexto

A Home adaptativa já é o hub principal do app Flutter. Manter `ModulosPage` como container interno de navegação cria uma segunda camada de hub, desloca o usuário para um `IndexedStack` com abas estáticas e prejudica a experiência adaptativa de recomendações/dashboard.

Hoje, `ModulosPage` agrega páginas por índice: `0` Área, `1` Reservatórios, `2` Caderno, `3` Solução, `4` Relatórios e `5` Ajustes. O `ModulosStore` mantém estado/preloads desse container e aparece acoplado à Home e a telas internas. A decisão de produto é remover esse container e direcionar entradas para rotas finais explícitas.

## Goals

- Remover `Routes.modulosPage` como destino navegável do app.
- Remover `ModulosPage` e `ModulosStore` quando não restarem referências necessárias.
- Substituir navegações para o container por rotas finais explícitas já existentes.
- Preservar a Home adaptativa como hub de módulos, recomendações e dashboard.
- Garantir que `ReservatoriosPage` carregue seus próprios dados no `initState` quando deixar de depender de preload do `ModulosStore`.
- Corrigir o destino do label “Ajuste” em `DetalhesReservatorio`: deve navegar para `Routes.ajustesPage`, não para índice/id `4` do container.

## Non-goals

- Não criar novos middlewares, guards ou interceptadores de rota nesta feature.
- Não alterar contratos de backend, GraphQL, Cloud Functions ou schemas.
- Não redesenhar a Home adaptativa nem alterar a regra de recomendação/dashboard.
- Não criar novo hub de navegação substituto para `ModulosPage`.
- Não introduzir nova infraestrutura de testes, analytics, logs ou telemetria.
- Não reestruturar rotas fora do necessário para remover o container.

## Technical approach and design decisions

### Abordagem

1. Tratar `ModulosPage` como container legado e remover seu uso como destino de navegação.
2. Mapear cada chamada a `Routes.modulosPage` e substituir por rota final do módulo correspondente.
3. Remover `Routes.modulosPage` de `routes.dart` e `app_pages.dart` após todos os chamadores serem atualizados.
4. Remover `ModulosPage`, `ModulosStore`, arquivo gerado associado e registro de injeção quando o grafo de referências estiver zerado.
5. Transferir para a própria tela apenas carregamentos indispensáveis que eram implicitamente garantidos pelo container/store, especialmente em `ReservatoriosPage`.

### Decisões

- A Home adaptativa é o hub canônico; `ModulosPage` não deve ser mantida como fallback.
- Navegação deve ser explícita por rota final, não por índice de `IndexedStack`.
- O label “Ajuste” em `DetalhesReservatorio` deve apontar para `Routes.ajustesPage`; o id `4` era acoplamento ao índice antigo e conflita com a semântica de Ajustes.
- Nenhum middleware novo deve ser usado para redirecionar `Routes.modulosPage`; remoção direta reduz acoplamento e evita esconder usos legados.

## Data structures or interfaces involved

- `Routes.modulosPage`: constante de rota a remover.
- `AppPages`/lista de páginas GetX: entrada de rota de `ModulosPage` a remover.
- `ModulosPage`: widget/container legado baseado em `IndexedStack`.
- `ModulosStore`: store de apoio ao container, seus preloads e registro em `GetIt`.
- `ReservatoriosPage`: deve assumir carregamento próprio no ciclo de vida se dependia de preload externo.
- `DetalhesReservatorio`: navegação do label “Ajuste” deve usar `Routes.ajustesPage`.
- Chamadores conhecidos a revisar: Home, mapper de módulos/atalhos, detalhes de reservatório, lista horizontal de área/cultivo, detalhes de protocolo e registro de injeção.

## Acceptance criteria

- CA-001: Não existe referência ativa a `Routes.modulosPage` em código Dart de produção.
- CA-002: `Routes.modulosPage` não existe mais em `routes.dart`.
- CA-003: `app_pages.dart` não registra `ModulosPage`.
- CA-004: `ModulosPage` e `ModulosStore` são removidos se não houver referências restantes.
- CA-005: A Home continua oferecendo acesso aos módulos por seus cards/atalhos adaptativos, sem navegar para o container legado.
- CA-006: Navegações anteriormente baseadas em índice do container apontam para rotas finais equivalentes.
- CA-007: `ReservatoriosPage` busca seus dados no `initState` quando acessada diretamente por rota final.
- CA-008: Em `DetalhesReservatorio`, a ação com label “Ajuste” navega para `Routes.ajustesPage`.
- CA-009: Nenhum middleware, guard ou redirecionador novo é criado para esta remoção.
- CA-010: Validação automatizada disponível no projeto passa, ou a limitação é documentada se não houver comando identificável.

## Open questions que precisam de clarificação

1. Quais rotas finais devem substituir todos os usos genéricos de `Routes.modulosPage` na Home antiga que não carregam contexto explícito?
2. `ModulosStore` contém algum preload ainda necessário fora do container, além de Reservatórios?
3. Arquivos gerados de MobX devem ser removidos junto com o store ou o projeto espera regeneração por `build_runner` após remoção?
4. Há deep links externos ou notificações que ainda apontam para `/modulosPage` e precisam de migração fora do app?
