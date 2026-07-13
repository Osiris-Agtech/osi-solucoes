# Spec: Lote pré-marcado e layout mais claro no cadastro de atividade do caderno de campo

Agent: spec-writer  
Rules: AGENTS.md

## Contexto

O produto busca uma interface clara, confiável e objetiva para apoiar a operação de cultivo, conforme o direcionamento de `PRODUCT.md`. No cadastro de atividades do caderno de campo, o operador pode partir do detalhe do caderno de um lote e iniciar uma nova atividade. Nesse cenário, o lote de origem já é conhecido e deve aparecer pré-marcado de forma inequívoca no passo de seleção de lotes.

Estado técnico resumido identificado:

- `CadernoCampoPage` define `store.loteSelecionado` e abre `DetalhesCadernoCampoPage`.
- Em `DetalhesCadernoCampoPage`, o FAB navega para `Routes.cadastroCadernoCampoPage`.
- `CadastroCadernoCampoPage.initState` chama `store.groupLotesBy()`.
- `groupLotesBy()` marca `LoteSelection(selected: true)` quando `loteSelecionado.id == e.id`.
- O problema provável é que o grupo externo `LoteByFilter.selected` permanece `false`, então o card fechado pode parecer desmarcado mesmo quando há lote interno selecionado.
- Hoje o usuário tende a ver apenas um resumo genérico como `1 lote selecionado`, sem nome claro do lote pré-selecionado.

Não existe spec específica para caderno de campo/cadastro/lote pré-selecionado antes desta entrega.

## Problema

Ao cadastrar uma atividade a partir do detalhe do caderno de campo de um lote, o lote interno pode estar tecnicamente selecionado, mas o estado visual do grupo e o resumo fechado não comunicam isso com clareza. Isso gera dúvida operacional: o usuário não sabe rapidamente se o lote correto já está marcado, se precisa expandir o card ou se a seleção foi perdida.

## Objetivos

- Garantir que, no fluxo `DetalhesCadernoCampoPage -> CadastroCadernoCampoPage`, o lote de origem apareça pré-selecionado de forma visualmente clara no passo de lotes.
- Fazer com que o card/grupo fechado reflita estado parcial ou total de seleção quando houver lotes internos selecionados.
- Exibir resumo textual mais explícito dos lotes selecionados, preferencialmente incluindo o nome do lote quando houver poucos selecionados.
- Melhorar a legibilidade da etapa de lotes sem redesenhar o wizard inteiro.
- Preservar contratos existentes de API, schema, repository e persistência.
- Manter o escopo pequeno e localizado nos arquivos já responsáveis pelo cadastro e seleção de lotes.

## Não objetivos

- Não alterar API, schema de banco, repositories, DTOs remotos ou contratos de persistência.
- Não redesenhar o wizard inteiro de cadastro do caderno de campo.
- Não alterar a regra de negócio de quais lotes podem ser selecionados.
- Não alterar o fluxo geral de navegação do caderno de campo fora do necessário para refletir o lote já selecionado.
- Não tratar `DetalhesLotePage` nesta etapa; esse fluxo fica fora de escopo para reduzir risco e manter a entrega focada no caminho atual do detalhe do caderno do lote.
- Não expandir responsabilidades de arquivos grandes como `caderno_campo_store.dart` e `detalhes_caderno_campo_page.dart` além do mínimo necessário.
- Não criar nova infraestrutura de testes.

## Suposições

- `store.loteSelecionado` está corretamente preenchido antes da navegação de `DetalhesCadernoCampoPage` para `CadastroCadernoCampoPage` no fluxo-alvo.
- `groupLotesBy()` já recebe dados suficientes para identificar o lote pré-selecionado por `id`.
- O modelo local de seleção permite derivar estado de grupo a partir dos itens internos, sem alterar modelos persistidos.
- Os componentes atuais de seleção de lotes aceitam ajustes visuais e textuais sem mudança de contrato externo.
- A nomenclatura exibida para lote já está disponível nos objetos usados em `LoteSelection` ou estruturas relacionadas.

## Requisitos funcionais

- **RF-01:** Ao abrir `CadastroCadernoCampoPage` a partir de `DetalhesCadernoCampoPage`, o lote correspondente a `store.loteSelecionado` deve estar marcado na lista interna de lotes.
- **RF-02:** Quando um grupo contiver pelo menos um lote interno selecionado, o card/grupo fechado deve indicar seleção ativa ou parcial, mesmo que nem todos os lotes do grupo estejam selecionados.
- **RF-03:** Quando todos os lotes selecionáveis de um grupo estiverem selecionados, o card/grupo deve indicar estado total selecionado.
- **RF-04:** Quando apenas parte dos lotes de um grupo estiver selecionada, o card/grupo deve indicar estado parcial de forma distinguível do estado desmarcado e do estado total.
- **RF-05:** O resumo do passo de lotes deve mostrar quantidade de lotes selecionados e, quando houver um único lote selecionado, o nome desse lote.
- **RF-06:** Quando houver múltiplos lotes selecionados, o resumo deve ser mais informativo que apenas a contagem, usando nomes quando couber no layout ou uma composição como primeiro(s) nome(s) + contagem restante.
- **RF-07:** A lista expandida deve deixar claro quais lotes estão marcados, mantendo affordance consistente para marcar/desmarcar.
- **RF-08:** Desmarcar manualmente o lote pré-selecionado deve ser permitido se o comportamento atual já permite desmarcar lotes; a pré-seleção não deve bloquear a edição.
- **RF-09:** Alternar seleção de itens internos deve atualizar imediatamente o estado visual do grupo e o resumo de selecionados.
- **RF-10:** A implementação não deve alterar payload de cadastro, repository, API, schema ou persistência.
- **RF-11:** A melhoria deve ficar limitada ao fluxo atual de cadastro aberto a partir de `DetalhesCadernoCampoPage`; outros pontos de entrada devem manter comportamento compatível e não quebrar.

## Abordagem técnica e decisões de design

- O estado visual do grupo deve ser derivado da coleção interna de `LoteSelection`, evitando nova fonte de verdade paralela.
- `LoteByFilter.selected` não deve ser tratado como único indicador quando há seleções parciais; o componente deve considerar contagem interna selecionada versus total selecionável.
- A UI deve representar três estados conceituais do grupo:
  - `none`: nenhum lote interno selecionado;
  - `partial`: pelo menos um lote interno selecionado, mas não todos;
  - `all`: todos os lotes internos selecionáveis selecionados.
- O resumo textual deve ser gerado a partir dos lotes atualmente selecionados, não apenas do número armazenado em um campo de grupo.
- O ajuste deve priorizar componentes de apresentação e helpers locais, evitando crescer `caderno_campo_store.dart` salvo para corrigir a derivação inicial de estado se for indispensável.
- A navegação em `DetalhesCadernoCampoPage` não deve ganhar nova responsabilidade de composição visual; ela deve continuar apenas conduzindo ao cadastro.
- A seleção prévia continua baseada em `loteSelecionado.id == lote.id`.
- Não devem ser introduzidos novos padrões de arquitetura, nova biblioteca de estado ou nova abstração global para resolver esta melhoria.

## Boundaries e arquivos alvo

Arquivos-alvo previstos:

- `lib/features/presenter/views/caderno_campo/components/caderno_lote_step.dart`
  - melhorar resumo dos lotes selecionados;
  - refletir estado claro no passo de lotes;
  - manter a lógica de apresentação coesa no componente da etapa.
- `lib/features/presenter/views/caderno_campo/components/expandedCard.dart`
  - representar estado nenhum/parcial/total no card fechado ou cabeçalho expansível;
  - evitar aparência de desmarcado quando há seleção interna.
- `lib/features/presenter/viewmodels/caderno_campo_store.dart`
  - somente se necessário, ajustar derivação em `groupLotesBy()` para que o estado externo seja compatível com seleções internas;
  - evitar adicionar responsabilidades novas, pois o arquivo já possui aproximadamente 585 linhas.
- `lib/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart`
  - manter inicialização existente com `store.groupLotesBy()`;
  - alterar apenas se necessário para garantir que o passo de lotes receba estado atualizado.

Arquivos a evitar crescer nesta entrega:

- `lib/features/presenter/viewmodels/caderno_campo_store.dart` — arquivo grande, deve receber apenas ajuste mínimo se indispensável.
- `lib/features/presenter/views/caderno_campo/detalhes_caderno_campo_page.dart` — arquivo grande, não deve receber lógica de seleção/layout.

Boundary de domínio/dados:

- Sem mudança em camada de API, repository, datasource, schema, entidades persistidas ou payload final de cadastro.
- A melhoria é de derivação local de estado de seleção e apresentação no wizard existente.

## Estruturas de dados e interfaces envolvidas

Não há novas estruturas persistidas nem mudança de interface pública/API.

Conceitos locais envolvidos:

- `loteSelecionado`: lote de contexto já mantido no store e usado para pré-seleção.
- `LoteSelection`:
  - `selected: bool` indica seleção individual do lote.
  - deve continuar sendo a fonte para determinar quais lotes entrarão no cadastro.
- `LoteByFilter`:
  - agrupa lotes para apresentação na etapa de lotes.
  - `selected` existente pode continuar representando seleção total do grupo, mas não deve esconder estado parcial.
- Estado derivado sugerido para apresentação:

```text
selectedCount = lotes.where(selected == true).length
selectableCount = lotes.length

groupSelectionState =
  selectedCount == 0 -> none
  selectedCount == selectableCount -> all
  otherwise -> partial
```

Resumo conceitual sugerido:

```text
0 selecionados -> "Nenhum lote selecionado"
1 selecionado  -> "1 lote selecionado: {nomeDoLote}"
2+ selecionados -> "{n} lotes selecionados: {nome1}, {nome2} ..."
```

A forma exata pode se adaptar ao espaço do layout, desde que preserve clareza e não volte ao resumo genérico quando houver lote único.

## Critérios de aceitação

- **CA-01:** Dado que o usuário está em `DetalhesCadernoCampoPage` de um lote e toca no FAB para cadastrar atividade, ao abrir `CadastroCadernoCampoPage`, o lote de origem aparece selecionado no passo de lotes.
- **CA-02:** Dado que o lote de origem está selecionado dentro de um grupo, o card fechado desse grupo não aparece como totalmente desmarcado.
- **CA-03:** Dado que apenas parte dos lotes de um grupo está selecionada, o card/grupo indica estado parcial de seleção.
- **CA-04:** Dado que todos os lotes selecionáveis de um grupo estão selecionados, o card/grupo indica estado total selecionado.
- **CA-05:** Dado que nenhum lote de um grupo está selecionado, o card/grupo indica estado não selecionado.
- **CA-06:** Dado que há exatamente um lote selecionado, o resumo visível informa `1 lote selecionado` e exibe o nome do lote.
- **CA-07:** Dado que há mais de um lote selecionado, o resumo visível informa a quantidade e apresenta nomes ou indicação textual suficiente para identificar a seleção sem depender de abrir todos os grupos.
- **CA-08:** Ao marcar ou desmarcar um lote na lista expandida, o resumo e o estado do grupo são atualizados sem exigir sair e voltar da tela.
- **CA-09:** A pré-seleção não impede o usuário de alterar manualmente os lotes, respeitando o comportamento de edição já existente.
- **CA-10:** O cadastro continua enviando os mesmos dados esperados atualmente; não há alteração de contrato de API, schema, repository ou payload persistido.
- **CA-11:** O fluxo `DetalhesLotePage` não é alterado nesta etapa.
- **CA-12:** `detalhes_caderno_campo_page.dart` não recebe lógica de layout ou derivação de seleção de lotes.
- **CA-13:** `caderno_campo_store.dart` recebe no máximo ajuste localizado de derivação/estado inicial, se necessário, sem refatoração ampla.
- **CA-14:** O layout do passo de lotes fica mais claro sem introduzir novo wizard, nova navegação ou nova biblioteca.

## Riscos e mitigação

- **Risco:** Corrigir apenas o texto do resumo e manter o grupo fechado parecendo desmarcado.  
  **Mitigação:** Validar explicitamente estado visual nenhum/parcial/total no card fechado.
- **Risco:** Usar `LoteByFilter.selected` como fonte única e perder seleções parciais.  
  **Mitigação:** Derivar estado de apresentação a partir dos `LoteSelection.selected` internos.
- **Risco:** Crescer `caderno_campo_store.dart` com lógica de UI.  
  **Mitigação:** Manter formatação de resumo e estado visual em componentes/helpers de apresentação; tocar store só se a derivação inicial estiver incorreta.
- **Risco:** Alterar sem querer payload ou regra de cadastro.  
  **Mitigação:** Limitar mudanças à camada presenter/viewmodel local e validar diff sem alterações em API/repository/schema.
- **Risco:** Incluir `DetalhesLotePage` e ampliar pontos de entrada sem teste suficiente.  
  **Mitigação:** Declarar `DetalhesLotePage` fora de escopo e validar apenas compatibilidade básica de outros pontos de entrada.
- **Risco:** Resumo com muitos nomes quebrar layout em telas menores.  
  **Mitigação:** Usar truncamento/limite de nomes conforme padrão visual existente, preservando contagem total.

## Plano de validação

- Executar `flutter analyze` após implementação.
- Executar `flutter test` se houver suíte/configuração disponível no projeto.
- Inspeção manual do fluxo principal:
  - abrir caderno de campo de um lote;
  - tocar no FAB em `DetalhesCadernoCampoPage`;
  - confirmar que `CadastroCadernoCampoPage` abre com o lote de origem pré-selecionado;
  - confirmar que o grupo fechado indica seleção parcial ou total corretamente;
  - confirmar que o resumo mostra quantidade e nome do lote quando houver um selecionado;
  - marcar e desmarcar lotes e verificar atualização imediata do resumo e estado do grupo.
- Inspeção manual de não regressão:
  - abrir cadastro por outro ponto de entrada existente, se acessível, e confirmar que a etapa de lotes continua funcional;
  - confirmar que não houve alteração de API/schema/repository/payload persistido.
- Confirmar no diff que esta etapa de especificação alterou apenas arquivos em `.specs/`.

## Questões em aberto

- Qual campo deve ser priorizado como nome exibível do lote quando houver mais de uma nomenclatura disponível?
- Para múltiplos lotes selecionados, o produto prefere listar até quantos nomes antes de usar `+N`?
- O estado parcial deve usar checkbox indeterminado, badge textual ou outro padrão visual já existente no projeto?
- Deve haver uma mensagem explícita como `Lote pré-selecionado a partir do caderno de campo` ou o resumo com nome do lote é suficiente?
