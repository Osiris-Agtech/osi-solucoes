Agent: architect
Rules: AGENTS.md

# Tasks SDD — Remoção da navegação por `ModulosPage`

## Contexto

Esta lista orienta a implementação futura da remoção do container legado `ModulosPage`, mantendo a Home adaptativa como hub e evitando middlewares novos.

## Goals and non-goals

### Goals

- Remover rota, widget e store legados com segurança.
- Substituir navegações por destinos finais explícitos.
- Garantir que telas finais carreguem dados necessários sem preload do container.

### Non-goals

- Não implementar código neste documento.
- Não criar middleware de redirecionamento.
- Não redesenhar telas.

## Technical approach and design decisions

- Executar em ordem para evitar remoção antes de zerar referências.
- Tarefas de mapeamento podem rodar em paralelo.
- Remoções só devem ocorrer depois de validação por busca textual e análise estática.

## Data structures or interfaces involved

- `Routes.modulosPage`
- `AppPages`
- `ModulosPage`
- `ModulosStore`
- `ReservatoriosPage`
- `DetalhesReservatorio`
- chamadas `Get.toNamed`

## Tarefas atômicas

### T01 — Inventariar referências ao container

- Dependências: nenhuma.
- Pode rodar em paralelo: sim, com T02.
- Ação: buscar `Routes.modulosPage`, `ModulosPage` e `ModulosStore` em código Dart.
- Validação: lista de arquivos e motivo de cada referência registrada antes de alterar.

### T02 — Confirmar rotas finais existentes

- Dependências: nenhuma.
- Pode rodar em paralelo: sim, com T01.
- Ação: verificar em `routes.dart` e `app_pages.dart` os nomes reais para Área, Reservatórios, Caderno, Solução, Relatórios e Ajustes.
- Validação: tabela de substituição sem destinos ambíguos; se houver ambiguidade, pausar e perguntar.

### T03 — Substituir navegações para destinos finais

- Dependências: T01, T02.
- Pode rodar em paralelo: não.
- Ação: trocar chamadas `Get.toNamed(Routes.modulosPage)` por rotas finais equivalentes, sem criar middleware.
- Validação: nenhuma chamada funcional para `Routes.modulosPage` permanece.

### T04 — Corrigir “Ajuste” em `DetalhesReservatorio`

- Dependências: T02.
- Pode rodar em paralelo: sim, com T03 se o destino `Routes.ajustesPage` estiver confirmado.
- Ação: trocar navegação do label “Ajuste” para `Routes.ajustesPage`.
- Validação: o destino não usa id/índice do container.

### T05 — Tornar `ReservatoriosPage` independente de preload do container

- Dependências: T01.
- Pode rodar em paralelo: após T01, sim com T03/T04 se não tocar nos mesmos arquivos.
- Ação: garantir busca de dados no `initState` quando a página é aberta diretamente.
- Validação: abrir a rota final de Reservatórios não depende de `ModulosStore`.

### T06 — Remover registro e uso de `ModulosStore`

- Dependências: T03, T05.
- Pode rodar em paralelo: não.
- Ação: remover injeção e imports do store quando não houver referências necessárias.
- Validação: busca por `ModulosStore` em código Dart de produção retorna zero ocorrências antes da remoção do arquivo.

### T07 — Remover rota e página legadas

- Dependências: T03, T06.
- Pode rodar em paralelo: não.
- Ação: remover constante `Routes.modulosPage`, `GetPage` correspondente e arquivos `modulos_page.dart`, `modulos_store.dart` e gerado associado se sem referências.
- Validação: busca por `Routes.modulosPage` e `ModulosPage` retorna zero ocorrências em código Dart de produção.

### T08 — Validar build/análise

- Dependências: T07.
- Pode rodar em paralelo: não.
- Ação: executar comandos existentes de análise estática, teste ou build identificáveis no projeto.
- Validação: comandos passam; se não houver comando disponível, registrar limitação explicitamente.

## Acceptance criteria

- Todas as tarefas T01–T08 concluídas ou bloqueios documentados.
- Nenhum middleware novo criado.
- Nenhuma referência produtiva a `Routes.modulosPage`, `ModulosPage` ou `ModulosStore` permanece se os arquivos forem removidos.
- `ReservatoriosPage` carrega dados sem o container.
- “Ajuste” navega para `Routes.ajustesPage`.

## Open questions que precisam de clarificação

1. Quais destinos finais devem substituir usos genéricos que não informam o módulo pretendido?
2. A validação manual de navegação em dispositivo/emulador será exigida além de análise/build?
