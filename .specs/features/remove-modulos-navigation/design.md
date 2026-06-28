# Design SDD — Remoção da navegação por `ModulosPage`

## Contexto

`ModulosPage` centraliza módulos em um `IndexedStack`, mas a Home adaptativa já cumpre o papel de hub. A remoção deve ser direta, com navegação por rotas finais explícitas, sem camada intermediária e sem middleware de compatibilidade.

## Goals and non-goals

### Goals

- Reduzir acoplamento entre Home, telas internas e `ModulosStore`.
- Eliminar navegação por índice implícito.
- Preservar comportamento funcional dos destinos finais.
- Tornar páginas acessíveis diretamente responsáveis por seus carregamentos essenciais.

### Non-goals

- Não substituir GetX/GetIt/MobX nesta feature.
- Não redesenhar telas de módulos.
- Não revisar toda a arquitetura de rotas.
- Não criar abstração nova de roteamento.

## Technical approach and design decisions

### Fluxo de remoção

1. Atualizar chamadores de `Routes.modulosPage` para rotas finais.
2. Corrigir navegações acopladas a índices do container.
3. Garantir carregamento próprio em páginas que dependiam de preload do `ModulosStore`.
4. Remover rota, widget, store e injeção quando referências forem zeradas.
5. Rodar análise estática/build/teste disponível.

### Mapeamento inicial de destinos

| Índice antigo | Módulo | Destino esperado |
| --- | --- | --- |
| 0 | Área | rota final de Área/Cultivo existente |
| 1 | Reservatórios | rota final de Reservatórios existente |
| 2 | Caderno | rota final de Caderno existente |
| 3 | Solução | rota final de Solução Nutritiva existente |
| 4 | Relatórios | rota final de Relatórios existente |
| 5 | Ajustes | `Routes.ajustesPage` |

Observação: em `DetalhesReservatorio`, o label “Ajuste” deve usar `Routes.ajustesPage`, não o índice `4`, porque `4` representava Relatórios no container legado informado e não Ajustes.

### Responsabilidades por componente

- Home: manter cards/atalhos como entrada principal e navegar diretamente para destinos finais.
- Rotas: declarar apenas páginas finais navegáveis.
- `ReservatoriosPage`: iniciar seus próprios dados quando aberta diretamente.
- Injeção: registrar apenas stores ainda usados após a remoção.

## Data structures or interfaces involved

- `Routes`: remoção de constante e uso de rotas finais existentes.
- `AppPages`: remoção do `GetPage` de `ModulosPage`.
- `ModulosStore`: possível remoção do tipo, mixin gerado e registro em `inject.dart`.
- `ReservatoriosPageState.initState`: ponto provável para carregamento independente.
- Chamadas `Get.toNamed(...)`: devem receber rotas finais, não container.

## Acceptance criteria

- O app não compila com dependência remanescente de `ModulosPage`/`ModulosStore` removidos.
- Busca textual por `Routes.modulosPage`, `ModulosPage` e `ModulosStore` retorna zero ocorrências em código Dart de produção após remoção, exceto histórico/specs.
- Abrir Reservatórios por rota final carrega dados sem precisar visitar Home ou container antes.
- A ação “Ajuste” de `DetalhesReservatorio` abre Ajustes.

## Open questions que precisam de clarificação

1. Qual é o nome real da rota final de Área/Cultivo que deve substituir índice `0`?
2. Qual é o nome real da rota final de Caderno que deve substituir índice `2`?
3. Qual é o nome real da rota final de Solução Nutritiva que deve substituir índice `3`?
4. A rota de Relatórios atual deve ser genérica ou uma tela específica de relatório?
