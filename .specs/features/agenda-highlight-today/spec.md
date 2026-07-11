# Spec: Destaque e filtro para itens da agenda com realização hoje

Agent: spec-writer  
Rules: AGENTS.md

## Contexto

Usuários do produto, especialmente gestores e operadores de cultivo, precisam identificar rapidamente quais atividades da agenda exigem atenção no dia atual. A agenda já diferencia itens concluídos e itens atrasados/alerta, mas itens cuja data de realização é igual à data de hoje não possuem destaque e acesso direto suficientes.

Sequência da solicitação:

1. "analise a agenda, gostaria q o item q tivesse a data igual a data de hoje para ser realizada deveria ter mais destaque";
2. após avaliar que apenas o destaque não bastava, solicitação de uma aba/filtro apenas para itens de hoje;
3. "aplique o ajuste".

Estado atual identificado:

- `lib/features/presenter/views/agenda/components/agenda_item.dart` renderiza cada item e calcula `isDone` e `isOverdue`.
- `isOverdue` usa comparação por timestamp exato: `!isDone && (agenda.alerta == true || (agenda.data != null && agenda.data!.isBefore(DateTime.now())))`.
- `lib/features/presenter/views/agenda/agenda_page.dart` contém `TableCalendar`, chips/filtros e renderização de lista; arquivo já possui aproximadamente 536 linhas.
- `lib/features/presenter/viewmodels/agenda_store.dart` filtra dias selecionados e marcadores usando comparação por ano/mês/dia; arquivo já possui aproximadamente 443 linhas.
- A agenda possui filtros por enum/chip, com alvos prováveis em `agenda_page_enum.dart`, `agenda_store.dart` e `agenda_page.dart`.
- Princípios de produto aplicáveis: priorizar o trabalho de hoje, uso semântico de cor, UI previsível e acessibilidade WCAG AA.

## Problema

Itens com data no mesmo dia local atual podem ficar visualmente semelhantes a itens futuros e não há um caminho direto para ver somente as atividades de hoje, reduzindo a capacidade do operador de priorizar o trabalho do dia.

## Objetivos

- Destacar visualmente itens pendentes da agenda cuja `agenda.data` esteja no mesmo dia local de `DateTime.now()`.
- Exibir um badge textual compacto `Hoje` próximo à linha de data/horário do item.
- Adicionar um filtro/chip exclusivo `Hoje` para listar atividades com `agenda.data` no mesmo dia local de `DateTime.now()`.
- Incluir atividades concluídas no filtro `Hoje`, preservando o visual de concluído.
- Ao selecionar `Hoje`, limpar filtros de lote/responsável e sincronizar preferencialmente `selectedDay` com `DateTime.now()` para manter calendário e lista coerentes.
- Exibir estado vazio específico quando não houver atividades para hoje.
- Usar comparação por dia de calendário local, consistente com o padrão usado no store para filtros e marcadores.
- Manter a prioridade visual de itens concluídos: atividades concluídas devem continuar parecendo concluídas, sem destaque ativo de hoje.
- Manter itens atrasados ou com alerta com urgência visual maior que o destaque simples de hoje.
- Preservar acessibilidade: não depender apenas de cor para comunicar o estado.

## Não objetivos

- Não alterar API, contratos, modelos remotos, schema de banco ou persistência.
- Não alterar a regra de `isOverdue` nesta feature.
- Não alterar ordenação da lista de agenda.
- Não combinar o filtro `Hoje` com filtros de lote/responsável nesta entrega.
- Não transformar `Hoje` em filtro apenas de pendentes; atividades concluídas de hoje devem continuar aparecendo quando o filtro estiver ativo.
- Não fazer redesign amplo, refatoração arquitetural ou reestruturação não necessária de `agenda_page.dart` ou `agenda_store.dart`.
- Não criar nova infraestrutura de testes.
- Não introduzir side-stripe, texto com gradiente, sombra decorativa, animação ou redesign amplo do card.

## Abordagem técnica e decisões de design

- Escopo mínimo: manter o destaque visual local no item da agenda e adicionar o menor ajuste necessário no fluxo de filtros existente.
- A lógica de identificação de "hoje" deve ficar no componente de item ou helper local coeso, evitando tocar store/calendário quando não houver mudança de regra de dados.
- `isToday` deve ser verdadeiro apenas quando:
  - `agenda.data != null`;
  - o item não estiver concluído;
  - ano, mês e dia locais de `agenda.data` forem iguais aos de `DateTime.now()`.
- O filtro `Hoje` deve usar a mesma comparação de dia local, mas não deve excluir itens concluídos.
- Deve ser adicionado um valor exclusivo ao enum de filtros da agenda, preferencialmente `AgendaFilter.hoje`.
- A ordem alvo dos chips deve ser: `Hoje`, `Todos`, `Por Lote`, `Por Responsável`. Se a implementação atual exigir menor mudança visual, `Hoje` pode ficar próximo ao início, antes dos filtros segmentados por lote/responsável, desde que a decisão fique evidente no diff.
- Selecionar `Hoje` deve limpar seleção/filtro de lote e responsável para evitar combinação implícita de filtros.
- Selecionar `Hoje` deve preferencialmente sincronizar `selectedDay` com `DateTime.now()` para que calendário e lista representem o mesmo recorte temporal.
- Selecionar outro dia no calendário pode continuar resetando o filtro para `Todos`, se esse for o comportamento atual.
- O filtro `Hoje` não deve alterar a ordenação já aplicada à lista.
- O estado vazio do filtro `Hoje` deve exibir:
  - título: `Nenhuma atividade para hoje`;
  - descrição: `Não há atividades cadastradas para hoje.`
- O badge `Hoje` deve aparecer próximo à informação de data/horário, para reforçar o vínculo com a data de realização.
- Se for usada cor, ela deve ser semântica, discreta e acompanhada do texto `Hoje`; cor sozinha não é critério de sinalização.
- Um leve tint de fundo no card é aceitável somente se mantiver hierarquia previsível e contraste adequado; o badge textual é obrigatório e suficiente para cumprir o destaque mínimo.
- Itens concluídos devem preservar seu tratamento visual atual, mesmo quando a data for hoje.
- Itens atrasados ou com alerta devem manter maior urgência que itens apenas de hoje; o destaque de hoje não deve sobrescrever estilos de urgência.

## Estruturas de dados e interfaces envolvidas

Não há novas estruturas persistidas nem mudança de interface pública/API.

Conceitos locais previstos:

- `isDone: bool` — já existente no item.
- `isOverdue: bool` — já existente e sem mudança de regra.
- `isToday: bool` — estado derivado localmente para apresentação do badge, condicionado a item não concluído.
- `isTodayFilterMatch: bool` — estado derivado para filtro, verdadeiro quando `agenda.data` está no dia local atual, incluindo itens concluídos.
- `AgendaFilter.hoje` — novo valor previsto para o enum de filtros da agenda.

Comparação conceitual:

```text
sameLocalCalendarDay(a, b) =
  a.year == b.year &&
  a.month == b.month &&
  a.day == b.day
```

## Arquivos-alvo previstos

- `lib/features/presenter/views/agenda/components/agenda_item.dart`
  - adicionar cálculo de `isToday` por dia local;
  - renderizar badge `Hoje` próximo à linha de data/horário;
  - aplicar eventual tint discreto sem prejudicar estados existentes.
- `lib/features/presenter/states/agenda_page_enum.dart`
  - adicionar valor exclusivo `AgendaFilter.hoje`, ou equivalente conforme nomenclatura existente.
- `lib/features/presenter/viewmodels/agenda_store.dart`
  - aplicar filtro de hoje por ano/mês/dia local;
  - limpar filtros de lote/responsável ao selecionar `Hoje`;
  - preservar ordenação existente;
  - sincronizar preferencialmente `selectedDay` com `DateTime.now()` ao selecionar `Hoje`.
- `lib/features/presenter/views/agenda/agenda_page.dart`
  - incluir chip `Hoje` na ordem alvo;
  - renderizar estado vazio específico do filtro `Hoje`.

Arquivo que não deve crescer para esta entrega, salvo necessidade descoberta e justificada antes da implementação:

- `lib/features/presenter/views/agenda/components/agenda_item.dart` não deve receber responsabilidades de filtro; manter apenas apresentação do item.

## Critérios de aceitação

- **CA-01:** Dado um item pendente com `agenda.data` no mesmo ano/mês/dia local de `DateTime.now()`, o item exibe o badge textual `Hoje` junto à informação de data/horário.
- **CA-02:** Dado um item pendente com `agenda.data` em outro dia local, o badge `Hoje` não é exibido.
- **CA-03:** Dado um item concluído com `agenda.data` hoje, o item mantém a prioridade visual de concluído e não recebe destaque ativo de hoje que concorra com o estado concluído.
- **CA-04:** Dado um item atrasado ou com `agenda.alerta == true`, o estado de urgência existente continua visualmente mais forte que o destaque simples de hoje.
- **CA-05:** A regra de `isOverdue` permanece inalterada nesta feature.
- **CA-06:** O destaque de hoje não depende apenas de cor; há texto visível `Hoje`.
- **CA-07:** O contraste do badge e de qualquer tint aplicado atende WCAG AA para texto normal quando verificado manualmente ou por teste visual equivalente disponível no projeto.
- **CA-08:** A implementação não altera API, schema, persistência ou ordenação da agenda.
- **CA-09:** A implementação fica limitada ao menor escopo correto nos arquivos-alvo previstos.
- **CA-10:** A agenda exibe um chip/filtro `Hoje` junto aos filtros existentes, com ordem alvo `Hoje`, `Todos`, `Por Lote`, `Por Responsável`.
- **CA-11:** Dado o filtro `Hoje` selecionado, a lista mostra atividades cuja `agenda.data` está no mesmo ano/mês/dia local de `DateTime.now()`.
- **CA-12:** Dado o filtro `Hoje` selecionado, atividades concluídas de hoje aparecem na lista e mantêm o visual de concluído.
- **CA-13:** Dado o filtro `Hoje` selecionado, atividades de outros dias não aparecem.
- **CA-14:** Ao selecionar `Hoje`, filtros de lote e responsável são limpos e não são combinados com o filtro de hoje.
- **CA-15:** Ao selecionar `Hoje`, `selectedDay` é preferencialmente sincronizado com `DateTime.now()` para coerência entre calendário e lista.
- **CA-16:** Ao selecionar outro dia no calendário, o comportamento atual de resetar o filtro para `Todos` pode ser preservado.
- **CA-17:** Quando o filtro `Hoje` não tiver resultados, a UI exibe `Nenhuma atividade para hoje` e `Não há atividades cadastradas para hoje.`

## Tarefas de implementação

1. **Mapear estrutura atual da agenda** — revisar filtros, enum, store, calendário e item antes de alterar. Cobre CA-09, CA-10, CA-14 e CA-15.
2. **Adicionar derivação local de `isToday`** — comparar `agenda.data` com `DateTime.now()` por ano/mês/dia local e condicionar ao item não concluído. Cobre CA-01, CA-02, CA-03 e CA-08.
3. **Renderizar badge `Hoje`** — posicionar o badge próximo à linha de data/horário, com estilo compacto e acessível. Cobre CA-01, CA-06 e CA-07.
4. **Adicionar filtro `Hoje`** — criar valor no enum, chip na UI e regra de filtragem por dia local incluindo concluídos. Cobre CA-10, CA-11, CA-12 e CA-13.
5. **Sincronizar seleção e limpar filtros conflitantes** — ao selecionar `Hoje`, limpar lote/responsável e sincronizar preferencialmente `selectedDay` com hoje. Cobre CA-14, CA-15 e CA-16.
6. **Adicionar estado vazio específico** — renderizar mensagens de ausência de atividades para hoje. Cobre CA-17.
7. **Preservar hierarquia e ordenação** — garantir que concluído, atrasado e alerta não percam prioridade visual, que `isOverdue` não mude e que a lista mantenha ordenação atual. Cobre CA-03, CA-04, CA-05, CA-08 e CA-12.
8. **Validar escopo e comportamento** — executar análise estática/testes/build existentes que forem identificáveis e fazer verificação manual dos cenários hoje, futuro, concluído, alerta, filtro vazio e limpeza de filtros. Cobre CA-02, CA-05, CA-07, CA-08, CA-09, CA-14 e CA-17.

## Riscos

- Comparar timestamps exatos em vez de dia de calendário local pode marcar incorretamente itens de hoje; por isso a comparação deve usar ano/mês/dia.
- Adicionar cor sem texto pode falhar em acessibilidade; o badge textual é obrigatório.
- Aumentar arquivos grandes como `agenda_page.dart` ou `agenda_store.dart` para uma mudança local pode elevar acoplamento desnecessário.
- Um tint excessivo pode competir com estados de alerta/atraso; a hierarquia visual deve ser preservada.
- Tratar `Hoje` como pendente por engano excluiria atividades concluídas que o usuário espera ver no recorte do dia.
- Combinar implicitamente `Hoje` com lote/responsável pode gerar listas vazias difíceis de explicar; por isso a seleção deve limpar esses filtros nesta entrega.
- Alterar ordenação durante a filtragem pode introduzir mudança comportamental não solicitada.
- Não sincronizar calendário e filtro pode deixar a lista mostrando hoje enquanto o calendário indica outro dia.

## Validação

- Executar os comandos existentes de validação do projeto, se identificáveis, antes de finalizar a implementação: análise estática, typecheck, testes ou build disponíveis.
- Verificar manualmente pelo menos estes cenários:
  - item pendente com data hoje mostra `Hoje`;
  - item pendente com data futura não mostra `Hoje`;
  - item concluído com data hoje mantém visual de concluído;
  - item com alerta/atrasado mantém urgência maior que o destaque de hoje.
  - chip `Hoje` aparece junto aos filtros na ordem alvo;
  - filtro `Hoje` lista atividades de hoje, incluindo concluídas;
  - filtro `Hoje` não lista atividades de outros dias;
  - selecionar `Hoje` limpa lote/responsável;
  - lista filtrada por `Hoje` preserva ordenação existente;
  - ausência de atividades de hoje exibe `Nenhuma atividade para hoje` e `Não há atividades cadastradas para hoje.`
- Confirmar no diff que não houve alteração fora de `.specs/` durante esta etapa de especificação.

## Questões em aberto

- O destaque deve ser aplicado também em itens com `agenda.alerta == true` e data de hoje, ou o alerta deve permanecer como única sinalização visual dominante?
- O produto prefere apenas o badge `Hoje` ou badge + tint discreto de fundo quando o contraste estiver adequado?
- Existe paleta semântica já consolidada para estado "hoje" na agenda ou deve ser reutilizada a cor semântica mais próxima existente no tema?
- A ordem `Hoje`, `Todos`, `Por Lote`, `Por Responsável` deve ser obrigatória ou pode preservar a ordem visual atual com `Hoje` apenas próximo ao início para reduzir mudança de UI?
