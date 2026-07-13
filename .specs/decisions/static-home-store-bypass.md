# Decisão: bypass explícito de modo STATIC no HomeStore

Agent: spec-writer
Rules: AGENTS.md

## O que foi decidido

O modo `STATIC` da Home deve ser tratado por bypass explícito em `HomeStore.loadAdaptiveInterface()`, antes de chamar `AdaptiveInterfaceService.getAdaptiveInterface()`.

Quando a config adaptativa ativa indicar `mode == 'STATIC'`, o store deve usar `HomeStore._getDefaultShortcuts()` como lista canônica, limpar estado adaptativo residual e finalizar a resolução da interface sem consumir recomendações da Cloud Function/ML.

## Por quê

`STATIC` é o grupo controle/default e precisa ser determinístico. Bloquear apenas highlights no mapper/UI não impede que recomendações remotas alterem atalhos, textos, motivos, confiança ou badges adaptativos.

Centralizar o saneamento no `HomeStore` evita espalhar exceções nos componentes visuais e garante que a UI receba um estado coerente: `STATIC` sem exposição adaptativa.

## O que foi descartado

- **Bloquear apenas em `HomePanelMapper` ou componentes UI:** insuficiente, porque os atalhos e metadados adaptativos já teriam sido aplicados ao estado.
- **Depender da Cloud Function retornar defaults para `STATIC`:** mantém chamada adaptativa e não garante determinismo local.
- **Tratar ausência de config como `STATIC`:** mudaria comportamento vigente e poderia remover adaptação/fallback atualmente aplicada a usuários sem config.
