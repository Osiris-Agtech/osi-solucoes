# Decisão: escopo localizado para lote pré-selecionado no cadastro do caderno de campo

Agent: spec-writer
Rules: AGENTS.md

## O que foi decidido

A melhoria de lote pré-marcado e layout mais claro deve focar no fluxo atual `DetalhesCadernoCampoPage -> CadastroCadernoCampoPage`, derivando o estado visual do grupo a partir dos `LoteSelection.selected` internos e mantendo o ajuste na camada presenter/viewmodel local.

`DetalhesLotePage`, API, schema, repositories e payload de cadastro ficam fora do escopo desta etapa.

## Por que

O problema relatado está na comunicação visual da seleção já existente: o lote interno pode estar selecionado, mas o grupo externo aparenta estar desmarcado e o resumo não identifica claramente o lote. Corrigir a derivação visual e o resumo resolve o risco operacional com menor mudança e menor acoplamento.

O fluxo do detalhe do caderno do lote já fornece o contexto necessário via `store.loteSelecionado`, então ampliar para outros pontos de entrada aumentaria risco sem ser necessário para esta entrega.

## O que foi descartado

- **Alterar API/schema/repository:** descartado porque a melhoria é de apresentação e estado local, sem necessidade de mudar persistência ou contrato.
- **Redesenhar o wizard inteiro:** descartado por aumentar escopo e risco sem relação direta com o problema.
- **Incluir `DetalhesLotePage` nesta etapa:** descartado para reduzir risco e manter validação concentrada no fluxo confirmado.
- **Usar `LoteByFilter.selected` como única fonte visual:** descartado porque não representa adequadamente seleção parcial de lotes internos.
- **Adicionar nova abstração global de seleção:** descartado porque o ajuste pode ser resolvido com derivação local a partir das estruturas existentes.
