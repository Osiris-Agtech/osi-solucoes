# Decisão: integrar OperationalOnboardingCard ao INSTANT sem acoplar widget ao contrato remoto

Agent: spec-writer
Rules: AGENTS.md

## O que foi decidido

`OperationalOnboardingCard` será integrado ao fluxo adaptativo INSTANT por meio de `clientCapabilities`, mapper defensivo, view data local, renderização na Home e métricas de componentes renderizados.

O widget continuará sendo apenas apresentacional: ele receberá `title`, `message`, `steps`, `ctaLabel` e `onCtaTap`, sem conhecer JSON da API, rotas, stores, serviços ou analytics.

## Por que

O fluxo INSTANT já centraliza adaptação em service, mapper, view data e renderização da Home. Manter a integração nessas camadas preserva o padrão existente, reduz acoplamento e permite ignorar payload inválido do componente sem derrubar o restante da interface adaptativa.

## O que foi descartado

- Acoplar `OperationalOnboardingCard` diretamente ao payload da API.
- Fazer o widget conhecer `targetRoute` e executar navegação internamente.
- Tratar erro em `operationalOnboarding` como falha total da interface INSTANT.
- Alterar Cloud Function/backend nesta tarefa.
