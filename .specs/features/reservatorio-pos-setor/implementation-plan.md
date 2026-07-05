# Implementation Plan — Reservatório Logo Após Setor

## Overview
Reordenar o stepper de cadastro de lote para colocar o step de Reservatório imediatamente após Setor, com auto-preset do reservatório do setor selecionado.

## Target Files

| # | Arquivo | Mudança | Linhas Afetadas | Risco |
|---|---------|---------|-----------------|-------|
| 1 | `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` | Reordenar `stepLabels`, switch `_buildStepContent`, switch `_canGoForward` | 34-40, 115-130, 133-147 | Baixo — só reordenação |
| 2 | `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/setor_step.dart` | Adicionar auto-preset no onChanged do setor; limpar reservatório no onChanged da área | 35-41, 56-59 | Médio — nova chamada de store action |
| 3 | `lib/features/presenter/viewmodels/lote_store.dart` | Adicionar action `autoPreencherReservatorioDoSetor()` | ~após linha 448 | Baixo — action isolada sem efeitos colaterais |

## Workstreams e Dependências

```
WS-A (store): lote_store.dart → adicionar action
  └── sem dependências externas

WS-B (setor_step): setor_step.dart → chamar action
  └── depende de WS-A (action precisa existir)

WS-C (page): cadastrar_lote_page.dart → reordenar
  └── não depende de WS-A ou WS-B (só reordena referências existentes)

Execução: WS-A → WS-B e WS-C podem rodar em paralelo após WS-A.
```

## Decomposition

Dado que as mudanças são pequenas e em arquivos distintos, um único implementer pode executar todas as 3 mudanças sequencialmente sem risco de conflito.

**Ordem de execução no implementer:**
1. `lote_store.dart` — adicionar `autoPreencherReservatorioDoSetor()`
2. `setor_step.dart` — adicionar chamada nos dois `onChanged`
3. `cadastrar_lote_page.dart` — reordenar steps

## File Boundaries

- Nenhum arquivo pode ser criado ou removido.
- `reservatorio_step.dart` não deve ser alterado (já funciona corretamente).
- `reservatorio_detalhes_page.dart` não deve ser alterado.
- `lote_store.dart` só deve ganhar a nova action — nenhum observable existente deve ser removido ou renomeado.
- `cadastrar_lote_page.dart` só deve ter a ordem alterada — nenhuma lógica de step deve mudar.

## Coupling Risks

- Nenhum risco de acoplamento identificado. As mudanças são puramente de reordenação e propagação de dados dentro do mesmo fluxo.
- `autoPreencherReservatorioDoSetor` acessa apenas `novoLoteSetor` e `novoLoteReservatorio`, ambos já observables do mesmo store.
- Não há dependência circular entre os 3 arquivos.

## Validation Commands

```bash
cd /home/joao/Documentos/personal/mestras/osi-solucoes
flutter analyze --no-fatal-infos --no-fatal-warnings
dart format lib/features/presenter/views/area_cultivo/N3/ --set-exit-if-changed
```
