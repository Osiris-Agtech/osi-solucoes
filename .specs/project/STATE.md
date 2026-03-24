# Project State

**Last updated:** 2026-03-20
**Current branch:** feat/new-home-layout

## Active Work

- Feature: Correção de navegação direta via atalhos inteligentes para lotes
  - Spec: `.specs/features/smart-shortcut-navigation/spec.md`
  - Status: Implementado ✅

## Decisions

### 2026-03-20 — Abordagem de fix para atalhos de lote
**Decision:** Implementar `buscarDetalhesLotePorId(int id)` no `LoteStore` + preparar estado dos stores antes de navegar em `_navigateWithResource()`.
**Rationale:** Reutiliza infraestrutura existente (`buscarDetalhesLote`) sem quebrar fluxo normal. Alternativa de criar nova rota foi descartada por overhead desnecessário.
**Trade-offs:** Adiciona uma chamada de API no momento do clique no atalho, mas já seria necessária ao entrar na DetalhesLotePage de qualquer forma.

### 2026-03-20 — Mapeamento brownfield concluído
**Decision:** Toda documentação criada em `.specs/codebase/`
**Status:** STACK, ARCHITECTURE, CONVENTIONS, STRUCTURE, TESTING, INTEGRATIONS, CONCERNS — todos criados.

## Todos

- [ ] Implementar fix da feature smart-shortcut-navigation (ver spec.md)
- [ ] Remover `print()` statements de produção (substituir por `kDebugMode`)
- [ ] Centralizar `_getDefaultShortcuts()` duplicado
- [ ] Adicionar testes unitários para `LoteStore` e `HomeStore`

## Lessons Learned

- A hierarquia de navegação Área→Setor→Lote cria acoplamento implícito via estado dos stores MobX
- `buscarDetalhesLote()` no `LoteStore` usa `loteSelecionado.id!` — qualquer navegação direta sem preparar o store causa crash null-check
- O `Lote` model já possui referência ao `Setor` — ao buscar detalhes do lote por ID, o setor fica disponível no objeto retornado

## Preferences

- Confirmação automática autorizada para escrita de arquivos de documentação e spec
