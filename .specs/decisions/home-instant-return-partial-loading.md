# Decisão: loading parcial da seção INSTANT no retorno para Home

Agent: spec-writer
Rules: AGENTS.md

## O que foi decidido

Quando a Home está em modo `INSTANT` e o usuário retorna de outra tela com `dashboard` base já carregado, o refresh adaptativo deve preservar a Home base visível e usar `InstantSectionSkeleton` apenas na seção INSTANT.

O skeleton full-page (`HomeDailyPanelSkeleton`) fica reservado para carregamento inicial ou ausência de dados base suficientes para renderizar a Home.

## Por que

O retorno para Home já possui contexto visual suficiente para manter cabeçalho, módulos e dados base. Trocar a tela inteira por skeleton durante um refresh incremental cria flicker e uma transição visual regressiva: conteúdo parcial/antigo → skeleton full-page → conteúdo atualizado.

A seção INSTANT é a parte que está sendo recalculada. Portanto, o feedback de loading deve ficar localizado nessa seção.

## O que foi descartado

- **Manter skeleton full-page em todo refresh INSTANT:** descartado por causar flicker e esconder dados base válidos.
- **Manter componentes INSTANT antigos até a nova resposta:** descartado neste ajuste porque o escopo esperado pede loading parcial da seção INSTANT durante o refresh.
- **Refatorar a arquitetura de loading da Home inteira:** descartado por aumentar escopo e risco em arquivos grandes para uma correção localizada de comportamento.
