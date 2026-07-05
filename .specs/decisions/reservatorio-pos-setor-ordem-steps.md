# Decisão: Ordem dos Steps no Cadastro de Lote

**Data:** 2026-07-05
**Feature:** `reservatorio-pos-setor`
**Arquivos afetados:** `cadastrar_lote_page.dart`, `setor_step.dart`, `lote_store.dart`

## O que foi decidido

A ordem dos steps no wizard de cadastro de lote foi alterada de:

```
Setor → Lote → Cultura → Reservatório → Protocolo
```

para:

```
Setor → Reservatório → Lote → Cultura → Protocolo
```

E o reservatório do setor é auto-presetado no `novoLoteReservatorio` quando o setor é selecionado.

## Por quê

- `Setor` já possui um campo `reservatorio` vinculado
- Na prática, o lote quase sempre usa o mesmo reservatório do setor
- Colocar o step de reservatório logo após setor permite que o usuário confirme ou ajuste o preset imediatamente, antes de preencher os dados específicos do lote (nome, cultura)
- Reduz o retrabalho de ter que lembrar de vincular o reservatório no final

## O que foi descartado

- **Manter a ordem original e apenas pré-selecionar no step 3:** não resolve o problema de fluidez — o usuário ainda precisaria avançar por 2 steps antes de ver o reservatório
- **Ocultar o step de reservatório quando o setor já tem um:** perde a oportunidade de o usuário trocar para um reservatório diferente (caso de uso real)

## Trade-offs

- O auto-preset **sempre sobrescreve** o reservatório ao trocar de setor, mesmo que o usuário tenha alterado manualmente antes. Justificativa: o step de reservatório vem imediatamente após, então o usuário pode trocar de volta.
- A validação por etapa (`_canGoForward`) existente na spec original do `cadastrar-lote-refactor` não foi implementada porque o `AppStepWizard` já havia sido introduzido com `canGoForward: true` fixo. Isso é um problema pré-existente, não introduzido por esta feature.
